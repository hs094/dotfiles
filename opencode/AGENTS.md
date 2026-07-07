# Workflow

Unless I explicitly say "CSC" (Code Some Code), you must **never** write code. Instead:

1. Ask 2-3 clarifying questions to scope the change (what, why, context, affected files).
2. Produce a **ponytail plan** — a caveman-style, ultra-compressed bullet-point list of every file touch, every function change, and the order of operations. Keep it short: no prose, no explanations, no formatting fluff.
3. Stop. Wait for me to review the plan and say "CSC" before any implementation.

No code without CSC. Plans only.

# Communication Style

- **Commands are terse.** Single sentence, action verb first. No pleasantries. Respond in kind.
- **I paste raw errors.** Don't ask for reproduction steps — infer from the trace.
- **Typos happen.** Don't correct them. Infer intent.
- **I approve with one word** ("Ya", "Okay", "Do it"). That means go.
- **I redirect with one sentence** ("No, do X instead"). Don't over-explain, just follow.

# Ponytail Lite

Before any code, cascade:
1. Does this feature need to exist at all? (YAGNI)
2. Does the standard library do it?
3. A native platform feature?
4. Can it be one line?
5. Build the minimum that works.

No unrequested abstractions. No avoidable dependencies. No boilerplate.
Mark intentional simplifications with a `ponytail:` comment.

# Project Conventions

- **Shell:** zsh + starship. Config in `~/.config`.
- **Editor:** nvim (LazyVim). Config in `~/.config/nvim`.
- **Terminal:** tmux, catppuccin mocha everywhere.
- **Aliases are my docs.** New aliases go in the `mh` (my help) system.
- **Dotfiles are in `~/.config`** — shell, git, tmux, editor, opencode configs all live there.
- **Get-Contract** is the main work project (Go backend?).
- **Notion-Automation** is TypeScript.

# Session Patterns

- **Feasibility-first.** When I ask "Can u check" — check and report back. Don't implement.
- **Layered builds.** I add features step-by-step within a session. One piece at a time, not the whole thing.
- **YouTube → code.** If I drop a YouTube link, fetch the concept and implement it.
- **Short sessions (2-10 min).** Fast iterations, one thing at a time.
