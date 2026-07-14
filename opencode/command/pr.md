---
description: Create PR from current branch using PULL_REQUEST_TEMPLATE
allowed-tools: Bash(git:*), Bash(gh:*), Bash(ls:*), Bash(cat:*)
---

**Tools restricted:** Bash only (git/gh/cat/ls). No Read, No Glob, no other tools. Use bash commands for everything.

Get current branch: !`git rev-parse --abbrev-ref HEAD`

Detect default base branch (try origin/main then origin/master): !`git rev-parse --verify origin/main 2>/dev/null && echo "main" || (git rev-parse --verify origin/master 2>/dev/null && echo "master" || echo "unknown")`

Find template: !`ls "$(git rev-parse --show-toplevel)/.github/PULL_REQUEST_TEMPLATE.md" 2>/dev/null`

If no template: report "No `.github/PULL_REQUEST_TEMPLATE.md` found at repo root" and stop.

Read template: !`cat "$(git rev-parse --show-toplevel)/.github/PULL_REQUEST_TEMPLATE.md"`

Check if branch is pushed: !`git rev-parse --abbrev-ref HEAD@{upstream} 2>/dev/null || echo "not-pushed"`

If not pushed, push it: !`git push -u origin $(git rev-parse --abbrev-ref HEAD)`

Get diff from base: use the detected base name (no "origin/") and run all three:
!`git log origin/{base}..HEAD --oneline --no-decorate`
!`git diff origin/{base}...HEAD --stat`
!`git diff origin/{base}...HEAD`

Now compose the PR. Use the base name (just "main" or "master", no "origin/") as the target.

**Title:** First commit subject from the log. If not already conventional, prefix with type inferred from changes.

**Body:** Fill every section in the template using real diff info. Never leave a section blank. Mark checkboxes `[x]` accurately. Strip HTML comments and instructional hints from the template.

Create PR: !`gh pr create --title "$title" --body "$body" --base {base}`

Show result: !`gh pr view --web`
