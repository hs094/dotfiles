---
name: pr-description
description: >
  Generate a PR description from the project's `.github/PULL_REQUEST_TEMPLATE.md`,
  filled with content inferred from the branch name and diff against main,
  then open the PR with `gh`. Never loses a single section from the template —
  every heading, checkbox, and placeholder is preserved.
---

# PR Description Generator

## Workflow — exactly four commands

1. **Read the template.** Find and read the PR template (checks repo root
   `.github/PULL_REQUEST_TEMPLATE.md`, then
   `.github/PULL_REQUEST_TEMPLATE/`, then the git worktree root).

2. **Fetch git context.** Run a single command to capture branch name and diff:
   ```sh
   git branch --show-current && echo "---BRANCH---" && git log --oneline -10 && echo "---DIFF---" && git diff main...HEAD
   ```

3. **Generate.** Fill every template section based on the git
   context and write the result to a temp file. Report success and the
   temp file path.

4. **Open the PR.** Create the PR from the same temp file (see
   "Opening the PR" below). Report the PR URL.

## Opening the PR

Use the GitHub CLI (`gh`) with the temp file from step 3 as the body. The
PR title comes from the branch name converted to a readable description —
replace hyphens/underscores with spaces, capitalize, **keep the ticket
prefix** (e.g. `PP-337: Fix session timeout bug`).

Create the PR, falling back to an edit if one already exists for the branch:

```sh
if gh pr view --json number -q .number >/dev/null 2>&1; then
  gh pr edit --title "TITLE" --body-file /tmp/pr-description-*.md
else
  gh pr create --title "TITLE" --body-file /tmp/pr-description-*.md
fi
```

Notes:

- Run from the repo root; `gh` requires the current branch to be pushed
  already, otherwise push it first. `gh` requires `gh auth login`.
- `gh pr create` auto-copies the PR URL to the clipboard and prints it —
  report that URL to the user.

## Template filling rules

Preserve **every** section heading, instruction comment, checkbox, and
placeholder from the template. The filled output must have exactly the same
structure — only empty/example values get replaced.

- **Summary** — Use the branch name converted to a readable description (strip
  ticket prefix, replace hyphens/underscores with spaces, capitalize). Add
  more detail from the diff if possible.

- **Type of Change** — Check the appropriate box(es) based on diff content:
  - `🐛 Bug fix` if diff is small, touches error paths, or branch says
    "fix"/"bug"/"hotfix"
  - `✨ New feature` if diff adds significant new files or branch says
    "feat"/"feature"/"add"
  - `🎨 UI/UX improvement` if `react/` or `.tsx`/`.jsx` files changed
  - `⚡ Performance improvement` if branch says "perf"/"performance"/"optimize"
  - `🔧 Config/deployment` if `.env`, `docker`, `deploy`, CI configs touched
  - `📝 Documentation` if only `.md`/`.rst` files changed
  - Default: `🐛 Bug fix` (most common)

- **What Changed?** — Derive bullet points from `git diff main...HEAD`.
  Group related file changes into logical bullets. Cover every meaningful
  change area. Use present tense, imperative mood.

- **Why?** — Infer from the diff purpose. Link issues if branch contains
  ticket numbers (e.g. `PP-337`, `PROJ-123`, `#42`). Fill `Fixes #` if
  ticket found.

- **Screenshots** — Keep the "Before:" / "After:" markers exactly as-is.
  Leave them empty (they're blank in the template too).

- **Checklist** — Preserve all checkboxes exactly. Always mark every box
  as checked (`[x]`).

- **Deployment Notes** — Fill if config files, env vars, or migrations
  changed. Otherwise leave blank.

- **Additional Context** — Note if new dependencies were added/removed, or
  if the diff hints at breaking changes. Otherwise leave blank.

## Hard rules

- Never ask for confirmation — generate, open, report.
- Always open the PR with `gh` (create, or edit if it already exists).
- Always print the temp file path so the user can review/edit the raw file.
- Always report the PR URL after opening it.
