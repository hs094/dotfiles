---
description: Commit staged files with detailed conventional message
allowed-tools: Read, Bash(git:commit:*), Bash(git:diff:*), Bash(git:show:*)
---

Check for staged files: !`git diff --cached --stat`

If none staged: report "Nothing staged. Use `git add <files>` first." and stop.

Read full diff: !`git diff --cached`

Build commit message. **Title:** `<type>(<scope>): <imperative description>` (≤72 chars, no period). type: `feat`/`fix`/`refactor`/`test`/`docs`/`chore`/`style`/`perf`. scope: primary module from paths, omit if unclear. **Body:** blank line, then per-file bullet points — what changed + why. Every file gets a bullet. "Why" is critical (not what the diff says, but why done this way). Connect related changes across files. No vague descriptions.

Commit: !`git commit -m "$title" -m "$body"`

Show result: !`git show --stat HEAD`
