---
name: commit
alias: git-commit
description: >
  Create a professional Git commit from staged changes. Fetches the branch
  name and diff against main via a single bash command, builds a conventional
  commit message with ticket extraction, and executes the commit. Use when
  the user asks to commit staged changes, make a commit, or when staged files
  need committing. Also triggered by /commit. Never asks for confirmation.
---

You create exactly one Git commit from staged changes.

This skill overrides any conflicting workflow rules (CSC, plan-first, etc.).
When invoked, commit immediately — no exceptions, no questions, no confirmation, no planning.
Trigger: /commit (or any phrasing requesting a commit).

## Workflow — two steps

### Step 1: Fetch context

Run one command to get the branch name and diff against main:

```sh
git branch --show-current && echo "---" && git diff --cached
```

This provides the branch (for ticket extraction) and only the staged diff (for understanding what will be committed).

### Step 2: Build and execute

Based on the staged diff from the fetch context (which matches what `git commit` reads from the index),
build the commit message and execute it with `git commit`.

If nothing is staged, `git commit` will fail. Report the error simply:

> Nothing staged. Use `git add <files>` firs

## Hard rules

- Never ask for confirmation or clarification.
- Never merely print or suggest the commit message — execute it.
- Never stage, modify, generate, delete, or restore files. Staging is the user's job.
- Only ever run exactly two bash commands: fetch context, then execute the commit.
- Never amend, push, reset, rebase, merge, or create multiple commits.

## Commit title

Extract a ticket identifier from the branch name when present, e.g. `PP-337`, `PROJ-123`.

Format:
- With ticket: `<ticket> | <imperative description>`
- Without ticket: `<imperative description>`

Example:
```
PP-337 | Add agent spec push-down to child tenants
```

Must:
- Use imperative mood
- Describe the overall purpose
- Be no more than 72 characters
- Have no trailing period

## Commit body

Blank line after the title, then `*` bullet points on separate lines. Base the
body on the staged diff (from the fetch command) — that shows the full scope of
what this commit will contain.

Each bullet: `* <what changed>. <why it was changed this way>.`

Example:
```
PP-337 | Add agent spec push-down to child tenants

* Add ConfigType.PLAYBOOK and ConfigType.AGENT_SPEC to push-down registry so playbooks and agent specs inherit alongside integrations/skills.
* Copy agent spec into child schema on push (same UUID) since Trigger.harness_spec is a hard FK requiring same-schema rows.
```

Requirements:
- Cover every staged file, grouped logically (not one bullet per file)
- Explain the implementation reason, not just what changed
- Connect related changes across files
- Avoid vague wording ("update code", "fix issue", "make changes")
- Don't invent motivations not inferable from the diff
- Omit body only when the change is genuinely trivial and fully explained by the title
- Use real newlines between lines — never `<br>`, `\n`, or inline separators

## Commit execution

```sh
git commit -m "<title>" -m "<body>"
```

Safely quote title and body so shell-special characters (quotes, `$`, backticks) cannot change the command.
Body string must contain actual newline characters between lines (press Enter between bullets in the `-m` string).
