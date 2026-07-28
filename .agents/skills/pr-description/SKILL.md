---
name: pr-description
description: >
  Generate a PR description from the project's `.github/PULL_REQUEST_TEMPLATE.md`,
  filled with content inferred from the branch name and diff against main,
  then copy the markdown to clipboard. Never loses a single section from the
  template — every heading, checkbox, and placeholder is preserved.
---

# PR Description Generator

Generate a complete PR description from the project's pull request template.
Every section of the template is preserved exactly — nothing is deleted or
summarized away.

## Workflow — exactly three commands

1. **Read the template.** Find and read the PR template (checks repo root
   `.github/PULL_REQUEST_TEMPLATE.md`, then
   `.github/PULL_REQUEST_TEMPLATE/`, then the git worktree root).

2. **Fetch git context.** Run a single command to capture branch name and diff:
   ```sh
   git branch --show-current && echo "---BRANCH---" && git log --oneline -10 && echo "---DIFF---" && git diff main...HEAD
   ```

3. **Generate and copy.** Fill every template section based on the git
   context, write the result to a temp file, and copy to clipboard with
   `pbcopy`. Report success and the temp file path.

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

- **Checklist** — Preserve all checkboxes exactly. Leave them unchecked
  (the author should self-verify).

- **Deployment Notes** — Fill if config files, env vars, or migrations
  changed. Otherwise leave blank.

- **Additional Context** — Note if new dependencies were added/removed, or
  if the diff hints at breaking changes. Otherwise leave blank.

## References

- `pbcopy` on macOS copies stdin to the system clipboard.
- The temp file lives under `/tmp/pr-description-*.md`.

## Hard rules

- Never delete, reorder, or rewrite any template section.
- Never ask for confirmation — generate, copy, report.
- Always copy to clipboard with `pbcopy`.
- Always print the temp file path so the user can review/edit the raw file.
