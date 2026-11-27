// Read-only PR discovery for each [machine, checkout]. This observer is separate
// from space rendering so frequent redraws never launch Git or GitHub commands.
import { exec, appHome } from "herdr";
import * as fs from "fs/promises";

const saved = () => `${appHome()}/data/better-sidebar/pr-status.json`;

export const PR_POLL_MS = 5 * 60000;
const HOVER_MIN_MS = 20000;
const PENDING = /PENDING|QUEUED|IN_PROGRESS|EXPECTED|WAITING|REQUESTED/i;
export const prPlaceKey = (machine, folder) => JSON.stringify([machine ?? null, folder]);
const CLOSES = /\b(?:close[sd]?|fix(?:e[sd])?|resolve[sd]?):?\s+([\w.-]+\/[\w.-]+)?#(\d+)/i;
const BRANCH_NUMBER = /(?:^|\/)(?:issue-|gh-)?(\d+)(?=$|[-_/])/;
const PR_FIELDS = `
  id number title url state isDraft headRefName updatedAt body
  headRepository { nameWithOwner }
  statusCheckRollup {
    contexts(first: 100) {
      nodes {
        __typename
        ... on CheckRun { name status conclusion }
        ... on StatusContext { context state }
      }
    }
  }
  closingIssuesReferences(first: 10) {
    nodes {
      number title state url
      repository { name nameWithOwner owner { login } }
    }
  }`;

export function prAppearance(pr, colors) {
  if (pr.state === "MERGED") return { icon: "merged", color: colors.ansi5, label: "Merged" };
  if (pr.state === "CLOSED") return { icon: "closed", color: colors.ansi1, label: "Closed" };
  if (pr.isDraft) return { icon: "draft", color: colors.dim, label: "Draft" };
  const failed = (pr.statusCheckRollup ?? []).some((check) =>
    ["FAILURE", "ERROR", "TIMED_OUT", "ACTION_REQUIRED", "STARTUP_FAILURE"].includes(
      String(check.conclusion || check.state || check.status).toUpperCase(),
    ),
  );
  return {
    icon: "pull-request",
    color: failed ? colors.ansi1 : colors.ansi2,
    label: failed ? "Checks failed" : "Open",
  };
}

export function githubRepository(url) {
  return /^(?:https?:\/\/github\.com\/|git@github\.com:|ssh:\/\/git@github\.com\/)([\w.-]+\/[\w.-]+?)(?:\.git)?\/?$/.exec(
    url.trim(),
  )?.[1];
}

export class PRStatusObserver {
  constructor() {
    this.pollMs = PR_POLL_MS;
    this.places = new Map();
    this.checked = new Map();
    this.entries = new Map();
    this.loaded = false;
    this.pendingDone = new Map();
  }

  async load(cx) {
    try {
      const d = JSON.parse(await fs.readFile(saved(), "utf8"));
      for (const [k, v] of d.entries ?? [])
        if (!this.entries.has(k)) this.entries.set(k, { ...v, prs: (v.prs ?? []).filter((pr) => pr.state === "OPEN") });
      for (const [k, v] of d.checked ?? [])
        if (!this.checked.has(k) && !this.entries.get(k)?.error) this.checked.set(k, v);
    } catch {}
    this.loaded = true;
    cx.notify();
  }

  async save() {
    const d = { entries: [...this.entries], checked: [...this.checked] };
    try {
      await fs.mkdir(`${appHome()}/data/better-sidebar`, { recursive: true });
      await fs.writeFile(saved(), JSON.stringify(d));
    } catch {}
  }

  refresh(places, cx, pollMs = PR_POLL_MS) {
    if (!this.loaded) {
      if (!this.loading) { this.loading = true; cx.spawn(async (cx) => this.load(cx)); }
      return;
    }
    this.pollMs = pollMs;
    this.places = new Map(places.filter((place) => place.folder)
      .map((place) => [prPlaceKey(place.machine, place.folder), place]));
    for (const key of this.entries.keys()) if (!this.places.has(key)) this.entries.delete(key);
    for (const key of this.checked.keys()) if (!this.places.has(key)) this.checked.delete(key);
    if (this.busy) return;

    const due = [...this.places].filter(([key, place]) => {
      const last = this.checked.get(key);
      return !last || last.branch !== place.branch || Date.now() - last.at >= this.pollMs;
    });
    if (!due.length) return;
    const machines = new Map();
    for (const item of due) {
      const machineKey = item[1].machine ?? null;
      if (!machines.has(machineKey)) machines.set(machineKey, []);
      machines.get(machineKey).push(item);
    }
    this.busy = true;
    cx.spawn(async (cx) => {
      try {
        for (const [machine, items] of machines) {
          const prepared = [];
          for (const [key, place] of items) {
            this.checked.set(key, { at: Date.now(), branch: place.branch });
            try {
              prepared.push(await this.prepare(key, place));
            } catch (error) {
              this.publishError(key, place, error);
            }
          }
          try {
            const results = await this.fetchMachine(prepared, machine);
            for (const [key, place, result] of results) {
              if (!this.isCurrent(key, place)) continue;
              this.entries.set(key, { ...result, branch: place.branch, updated: Date.now() });
              this.pendingDone.get(key)?.(this.entries.get(key), true);
              this.pendingDone.delete(key);
            }
          } catch (error) {
            for (const [key, place] of items) this.publishError(key, place, error);
          }
          cx.notify();
        }
      } finally {
        this.busy = false;
        await this.save();
      }
    });
  }

  publishError(key, place, error) {
    if (!this.isCurrent(key, place)) return;
    const previous = this.entries.get(key);
    this.entries.set(key, {
      prs: previous?.branch === place.branch ? previous.prs : [],
      issue: previous?.branch === place.branch ? previous.issue : null,
      branch: place.branch,
      error: error.message,
      updated: previous?.updated,
    });
    this.pendingDone.get(key)?.(this.entries.get(key), false);
    this.pendingDone.delete(key);
  }

  async prepare(key, place) {
    const git = (args) => exec("git", ["--no-optional-locks", ...args], { cwd: place.folder, on: place.machine });
    const head = await git(["symbolic-ref", "--quiet", "--short", "HEAD"]);
    if (head.code !== 0) {
      if (head.code === 1 || /not a git repository/i.test(head.stderr ?? ""))
        return { key, place, branch: null, repositories: [], prs: [], issue: null };
      throw new Error("Cannot read checkout branch");
    }
    const branch = head.stdout.trim();
    const remotes = await git(["remote"]);
    if (remotes.code !== 0) throw new Error("Cannot read Git remotes");
    const repositories = new Set();
    for (const name of remotes.stdout.trim().split(/\r?\n/).filter(Boolean)) {
      const result = await git(["remote", "get-url", name]);
      if (result.code !== 0) throw new Error("Cannot read Git remote URL");
      const repo = githubRepository(result.stdout);
      if (repo) repositories.add(repo);
    }
    const prConfig = await git(["config", "--get", `branch.${branch}.herdr-pr`]);
    if (prConfig.code !== 0 && prConfig.code !== 1) throw new Error("Cannot read PR association");
    const binding = /^([\w.-]+\/[\w.-]+)#([1-9][0-9]*)$/.exec(prConfig.stdout?.trim() ?? "");
    if (binding) repositories.add(binding[1]);
    const issueConfig = await git(["config", "--get", `branch.${branch}.herdr-issue`]);
    const value = issueConfig.stdout?.trim() ?? "";
    const external = /^(jira|linear):([A-Za-z0-9_-]+)$/.exec(value);
    let issue = null;
    if (external) {
      const [title, url, state] = await Promise.all(["title", "url", "state"].map((key) =>
        git(["config", "--get", `branch.${branch}.herdr-issue-${key}`])));
      issue = {
        provider: external[1], repository: external[1] === "jira" ? "Jira" : "Linear",
        number: external[2], title: title.stdout?.trim() ?? external[2],
        url: url.stdout?.trim() ?? "", state: state.stdout?.trim() || "OPEN",
      };
    }
    const boundIssue = /^([\w.-]+\/[\w.-]+)#([1-9][0-9]*)$/.exec(value);
    if (boundIssue) repositories.add(boundIssue[1]);
    const branchNumber = BRANCH_NUMBER.exec(branch)?.[1] ?? null;
    return { key, place, branch, repositories: [...repositories], knownHeads: [...repositories].map((r) => r.toLowerCase()), binding, boundIssue, branchNumber, issue };
  }

  async fetchMachine(prepared, machine) {
    const rows = [];
    const rowMap = new Map();
    for (const item of prepared) {
      for (const repo of item.repositories) {
        const issueNumber = item.boundIssue?.[1] === repo ? item.boundIssue[2] : item.branchNumber;
        const binding = item.binding?.[1] === repo ? item.binding[2] : null;
        const key = JSON.stringify([repo, item.branch, issueNumber ?? null, binding]);
        if (!rowMap.has(key)) {
          const [owner, name] = repo.split("/");
          const index = rows.length;
          const alias = `r${index}`;
          const row = { repo, branch: item.branch, issueNumber, binding, owner, name, alias, index };
          rowMap.set(key, row);
          rows.push(row);
        }
        item.rows ??= [];
        item.rows.push(rowMap.get(key));
      }
    }
    if (!rows.length) return prepared.map((item) => [item.key, item.place, { prs: [], issue: item.issue }]);

    const declarations = [];
    const fields = [];
    const args = ["api", "graphql"];
    for (const row of rows) {
      if (!row.binding || row.issueNumber) {
        declarations.push(`$o${row.index}: String!, $n${row.index}: String!`);
        args.push("-F", `o${row.index}=${row.owner}`, "-F", `n${row.index}=${row.name}`);
      }
      if (!row.binding) {
        declarations.push(`$b${row.index}: String!`);
        args.push("-F", `b${row.index}=${row.branch}`);
      }
      let issue = "";
      if (row.issueNumber) {
        declarations.push(`$i${row.index}: Int!`);
        args.push("-F", `i${row.index}=${row.issueNumber}`);
        issue = `issue(number: $i${row.index}) { number title state url }`;
      }
      if (!row.binding || issue)
        fields.push(`${row.alias}: repository(owner: $o${row.index}, name: $n${row.index}) {
          ${row.binding ? "" : `pullRequests(first: 10, states: OPEN, headRefName: $b${row.index}) { nodes { ${PR_FIELDS} } }`}
          ${issue}
        }`);
      if (row.binding) {
        declarations.push(`$q${row.index}: String!`);
        args.push("-F", `q${row.index}=repo:${row.repo} is:pr is:open number:${row.binding}`);
        fields.push(`s${row.index}: search(query: $q${row.index}, type: ISSUE, first: 10) { nodes { ... on PullRequest { ${PR_FIELDS} } } }`);
      }
    }
    const query = `query(${declarations.join(", ")}) { ${fields.join("\n")} }`;
    args.push("-f", `query=${query}`);
    const result = await exec("gh", args, { on: machine });
    if (result.code !== 0) throw new Error((result.stderr || "GitHub unavailable; check gh auth login").trim());
    const payload = JSON.parse(result.stdout);
    if (payload.errors?.length) throw new Error(payload.errors.map((e) => e.message).join("; "));

    const results = [];
    for (const item of prepared) {
      if (!item.branch || !item.repositories.length) {
        results.push([item.key, item.place, { prs: [], issue: item.issue }]);
        continue;
      }
      const candidates = [];
      let linkedIssue = null;
      for (const row of item.rows ?? []) {
        const data = payload.data?.[row.alias];
        const issue = data?.issue;
        if (issue && issue.url?.includes("/issues/") && (!item.boundIssue || row.repo === item.boundIssue[1]))
          linkedIssue ??= { ...issue, repository: row.repo };
        const found = row.binding ? payload.data?.[`s${row.index}`]?.nodes ?? [] : data?.pullRequests?.nodes ?? [];
        for (const pr of found) {
          const repoMatches = item.binding
            ? row.repo === item.binding[1] && String(pr.number) === item.binding[2]
            : pr.headRefName === item.branch && item.knownHeads.includes(pr.headRepository?.nameWithOwner?.toLowerCase());
          if (repoMatches) candidates.push({ ...pr, repository: row.repo });
        }
      }
      const prs = [...new Map(candidates.map((pr) => [pr.id ?? `${pr.repository}#${pr.number}`, pr])).values()]
        .sort((a, b) => (b.updatedAt ?? "").localeCompare(a.updatedAt ?? ""));
      const closing = prs[0]?.closingIssuesReferences?.nodes?.[0];
      const body = CLOSES.exec(prs[0]?.body ?? "");
      const issue = item.issue ?? (closing ? {
        ...closing,
        repository: closing.repository?.nameWithOwner ?? prs[0].repository,
      } : linkedIssue ?? (body && linkedIssue ? linkedIssue : null));
      results.push([item.key, item.place, {
        prs: prs.map((pr) => ({ ...pr, statusCheckRollup: pr.statusCheckRollup?.contexts?.nodes ?? [] })),
        issue,
      }]);
    }
    return results;
  }

  refreshNow(place, cx, done) {
    const key = prPlaceKey(place.machine, place.folder);
    this.hovered ??= new Map();
    if (!place.folder || Date.now() - (this.hovered.get(key) ?? 0) < HOVER_MIN_MS) return false;
    this.hovered.set(key, Date.now());
    this.pendingDone.set(key, done);
    this.checked.delete(key);
    this.refresh([...this.places.values()], cx, this.pollMs);
    return true;
  }

  isCurrent(key, place) {
    return this.places.has(key) && this.places.get(key).branch === place.branch;
  }
}
