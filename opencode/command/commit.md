---
description: Commit staged files with Profressional message
allowed-tools: Read, Bash(git:commit:*), Bash(git:diff:*), Bash(git:show:*)
---

Check for staged files: !`git diff --cached --stat`

If none staged: report "Nothing staged. Use `git add <files>` first." and stop.

Read full diff: !`git diff --cached`

Extract ticket from branch name (e.g. `PP-337`, `PROJ-123`). If none, skip.

Build commit message.
**Title:** `<ticket> | <imperative description>` (≤72 chars, no period). If no ticket, use plain `<imperative description>`.
**Body:** blank line, then bullet points — `* <what changed>. <why>.`. Every file gets covered. "Why" is critical (not what the diff says, but why done this way). Connect related changes across files. No vague descriptions.

Example:

```
PP-337 | Add agent spec push-down to child tenants

* Add ConfigType.PLAYBOOK and ConfigType.AGENT_SPEC to push-down registry so playbooks and agent specs inherit alongside integrations/skills.
* Copy agent spec into child schema on push (same UUID) since Trigger.harness_spec is a hard FK requiring same-schema rows.
```

Commit: !`git commit -m "$title" -m "$body"`
