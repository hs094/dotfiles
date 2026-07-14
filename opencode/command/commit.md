---
description: Commit staged files with detailed conventional message
allowed-tools: Read, Bash(git:commit:*), Bash(git:diff:*), Bash(git:show:*)
---

Check for staged files: !`git diff --cached --stat`

If none staged: report "Nothing staged. Use `git add <files>` first." and stop.

Read full diff: !`git diff --cached`

Extract ticket from branch name (e.g. `PP-337`, `PROJ-123`). If none, skip.

Build commit message. **Title:** `<ticket> | <imperative description>` (≤72 chars, no period). If no ticket, use plain `<imperative description>`. **Body:** blank line, then bullet points — `* <what changed>. <why>. (<ticket>)`. Every file gets covered. "Why" is critical (not what the diff says, but why done this way). Connect related changes across files. No vague descriptions.

**Examples:**

```
PP-337 | Add agent spec push-down to child tenants

* Add ConfigType.PLAYBOOK and ConfigType.AGENT_SPEC to push-down registry so playbooks and agent specs inherit alongside integrations/skills. (PP-337)
* Copy agent spec into child schema on push (same UUID) since Trigger.harness_spec is a hard FK requiring same-schema rows. (PP-337)
* Fix artifact delete signal to route playbooks to ConfigType.PLAYBOOK instead of SKILL, preventing type mismatch errors. (PP-337)
```

```
PP-337 | Fix false conflict on controls field

* Normalize controls through AgentControls.model_validate before comparison in _spec_field_eq so sparse vs full-default dict representations don't produce spurious conflict badges. (PP-337)
```

```
fix: handle empty worktree list during cleanup

* Skip prune-gone when `git worktree list` returns empty — avoids traceback in cron job. (no ticket)
```

Commit: !`git commit -m "$title" -m "$body"`

Show result: !`git show --stat HEAD`
