---
name: pr-description
description: >
  Generate a PR description from the project's `.github/PULL_REQUEST_TEMPLATE.md`,
  filled with content inferred from the branch name and diff against main,
  optionally including verified before/after UI screenshots captured with the
  native `agent_browser` tool, then open the PR with `gh`. Assigns the
  authenticated user, applies inferred labels, and preserves any existing
  screenshots/custom text when updating. Never loses a single section from
  the template — every heading, checkbox, and placeholder is preserved.
---

# PR Description Generator

## Workflow — exactly five phases

1. **Read the template.** Find and read the PR template (checks repo root
   `.github/PULL_REQUEST_TEMPLATE.md`, then
   `.github/PULL_REQUEST_TEMPLATE/`, then the git worktree root).

2. **Fetch git context.** Run a single command to capture branch name and diff:
   ```sh
   git branch --show-current && echo "---BRANCH---" && git log --oneline -10 && echo "---DIFF---" && git diff main...HEAD
   ```

3. **Fetch existing PR body (if any).** Check whether a PR already exists for
   this branch and, if so, save its current body for preservation (see
   "Preserving existing description content" below):
   ```sh
   gh pr view --json body,number --jq .body > /tmp/pr-description-existing.md 2>/dev/null || echo "" > /tmp/pr-description-existing.md
   ```

4. **Generate.** If the diff contains UI changes, follow **UI screenshot
   capture** below before filling the template. Fill every template section
   based on the git context, **merging in any preserved content** from step 3,
   and write the result to a temp file. Report success, the temp file path, and
   any screenshot artifact paths.

5. **Open the PR.** Create or update the PR from the same temp file (see
   "Opening the PR" below). Assign the authenticated user and apply inferred
   labels (see "Assignee and Labels"). If screenshots were captured, finish the
   optional GitHub upload step there and report whether they were actually attached.

## Opening the PR

Use the GitHub CLI (`gh`) with the temp file from step 4 as the body. The
PR title comes from the branch name converted to a readable description —
replace hyphens/underscores with spaces, capitalize, **keep the ticket
prefix** (e.g. `PP-337: Fix session timeout bug`).

Resolve the assignee and labels first (see "Assignee and Labels"), then
create the PR, falling back to an edit if one already exists for the branch.
Always preserve existing screenshots/custom text (see "Preserving existing
description content") — the temp file from step 4 must already contain it.

```sh
# Resolve labels (comma-separated, may be empty) — see "Assignee and Labels" for inference
LABELS="bug"  # example; use inferred value

if gh pr view --json number -q .number >/dev/null 2>&1; then
  gh pr edit --title "TITLE" --body-file /tmp/pr-description-*.md
  # Assignee + labels on existing PR (separate calls — edit doesn't accept them atomically in all gh versions)
  gh pr edit --add-assignee "@me" 2>/dev/null || true
  [ -n "$LABELS" ] && gh pr edit --add-label "$LABELS" 2>/dev/null || true
else
  if [ -n "$LABELS" ]; then
    gh pr create --title "TITLE" --body-file /tmp/pr-description-*.md --assignee "@me" --label "$LABELS"
  else
    gh pr create --title "TITLE" --body-file /tmp/pr-description-*.md --assignee "@me"
  fi
fi
```

Notes:

- Run from the repo root; `gh` requires the current branch to be pushed
  already, otherwise push it first. `gh` requires `gh auth login`.
- `gh pr create` auto-copies the PR URL to the clipboard and prints it —
  report that URL to the user.
- If `gh pr edit --add-assignee` / `--add-label` fails (e.g. label doesn't
  exist in repo), log the warning but don't fail the PR creation.

## UI screenshot capture

Use the native `agent_browser` tool, never a shell `agent-browser` command. Only
capture screenshots for UI changes, and only after identifying the affected
screen or flow from the diff.

1. Start a fresh browser session and open `http://app.localhost:8000`.
2. Use `snapshot -i`, then current refs or semantic locators to log in:
   username `user@simbian.com`, password `pwd`. Re-snapshot after navigation or
   rerenders; never put these credentials in the PR body or screenshot.
3. Navigate to the affected screen. Capture a true pre-change state to
   `/tmp/pr-description-<slug>-before.png`, then perform the relevant safe,
   non-destructive clicks or input and capture the resulting state to
   `/tmp/pr-description-<slug>-after.png`.
4. Verify both screenshot calls report a saved/verified artifact (including
   `details.artifactVerification`) before using either file. Close the browser
   only after verification.
5. If a genuine before state or a reproducible after state cannot be established,
   leave that marker empty and report why; never manufacture a comparison.

Local screenshot paths do not render in a GitHub PR. When an authenticated
GitHub browser session is available after `gh pr create`/`gh pr edit`, open the
PR with `agent_browser`, edit its body, upload the two PNGs into the existing
Before/After markers, save, and verify the images appear. Otherwise keep an
HTML comment with each local path next to its marker for manual upload and say
that the screenshots were not attached.

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
  For verified UI artifacts, place the uploaded image under the matching
  marker. Before upload, add only an HTML comment with the local artifact path;
  leave a marker empty when no genuine comparison exists.

- **Checklist** — Preserve all checkboxes exactly. Always mark every box
  as checked (`[x]`).

- **Deployment Notes** — Fill if config files, env vars, or migrations
  changed. Otherwise leave blank.

- **Additional Context** — Note if new dependencies were added/removed, or
  if the diff hints at breaking changes. Otherwise leave blank.

## Preserving existing description content

When a PR already exists for the branch, **never delete** what the user has
already written — especially screenshots, embedded images, and custom notes.

1. **Fetch** the current body before generating (workflow step 3):
   `gh pr view --json body -q .body > /tmp/pr-description-existing.md`.
2. **Extract preservable content** from that file:
   - Markdown images: `![...](...)` (including GitHub-uploaded screenshots)
   - HTML `<img ...>` tags
   - Any `<!-- screenshot ... -->` or `<!-- preserved ... -->` comments
   - Any paragraphs/sections the user added outside the template (e.g. extra
     "Screenshots", "Demo", "Notes" content not in template)
3. **Merge** into the generated body:
   - If the template has a `Screenshots` / `Screencast` / `Demo` section, append
     preserved images there (deduplicate by URL) rather than replacing the section.
   - If preserved content doesn't map to a template section, append it under
     `## Additional Context` or at the very end under `<!-- preserved-content -->`
     so it stays visible.
   - Never duplicate the same image URL twice; never drop an image that was
     already in the PR.
4. **Report** what was preserved (e.g. "preserved 2 screenshot(s) from existing PR body").

If `gh pr view` returns empty / no PR exists, skip preservation entirely.

## Assignee and Labels

### Assignee

- Always assign the authenticated GitHub user as the PR assignee via `@me`
  (no need to resolve login — `gh` maps `@me` to the authenticated user).
- On `gh pr create`: pass `--assignee "@me"`.
- On `gh pr edit` (PR already exists): run `gh pr edit --add-assignee "@me"` after the body/title update.
- If assignment fails (e.g. repo disallows self-assign), log the warning but don't fail the PR.

### Labels

Apply labels both when creating and when updating an existing PR.

1. **Discover available labels** in the repo:
   ```sh
   gh label list --limit 100 --json name -q '.[].name' 2>/dev/null
   ```
2. **Infer labels** from branch name + diff, then intersect with available labels
   (only apply labels that actually exist — never create new labels):
   | Signal | Label to try (in priority order) |
   |--------|-----------------------------------|
   | `fix`/`bug`/`hotfix` in branch, or small diff touching error paths | `bug`, `bugfix`, `fix` |
   | `feat`/`feature`/`add` in branch, or new files added | `enhancement`, `feature`, `feat` |
   | `react/` or `.tsx`/`.jsx` / CSS changed | `frontend`, `ui`, `ui/ux` |
   | `perf`/`optimize` in branch | `performance`, `perf` |
   | `.env`/`docker`/`deploy`/CI touched | `chore`, `config`, `devops` |
   | Only `.md`/`.rst` changed | `documentation`, `docs` |
   | Any other | `enhancement` as fallback if it exists |
3. **Also** try ticket-derived labels if the branch contains `PP-337` style
   prefixes and a matching label exists.
4. **Apply**:
   - On create: `--label "$LABELS"` (comma-separated).
   - On edit: `gh pr edit --add-label "$LABELS"`.
   - If no inferred label matches an available label, skip labeling and report why.
5. **Report** which labels were applied (or why none were).

## Hard rules

- Never ask for confirmation — generate, open, report.
- Always open the PR with `gh` (create, or edit if it already exists).
- Always print the temp file path so the user can review/edit the raw file.
- Always report the PR URL after opening it.
- Never claim screenshots are attached unless the GitHub browser upload and
  rendered-image verification succeeded.
