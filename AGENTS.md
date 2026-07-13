# Dotfiles

macOS dev environment configs. Every tool in its own dir under `~/.config/`.

## Shell stack

`.zshrc` sources zsh/*.zsh in order: `export.zsh → custom.zsh → bindkeys.zsh → hooks.zsh → utils.zsh → aliases.zsh → plugins.zsh → cleanup.zsh`.
Vi mode (`bindkey -v`, KEYTIMEOUT=10). No oh-my-zsh — zinit for plugin management.

## Package management

Brewfile at `homebrew/Brewfile` is single source of truth:
```
brew bundle --file=homebrew/Brewfile
brew bundle cleanup --file=homebrew/Brewfile   # remove unlisted
```
Adding a tool → add to Brewfile, period.

## Key aliases (the self-docs pattern)

`aliases.zsh` IS documentation. New aliases go in the `mh` (my help) system:

- `mh` — top-level menu
- `mh docker` / `dsvc` — Docker service wrappers (dozzle, n8n, metabase, infisical, …)
- `mh lazy` / `lsvc` — lazy-toolkit TUIs (lg, ld, lssh, lsql, ...)
- `mh wt` / `wth` — worktrunk aliases (ws, wsc, wsx, wl, wm, wr)
- `mh agent` / `codh` — coding agent aliases (oc=opencode, co=codex, cc=claude, ...)

Quick use: `mh` to browse, then `mh <submenu>` for details.

## Git conventions

- URL shortcuts: `gh:` → `git@github.com:`, `hs:` → `git@github.com:hs094/`, `tai:` → `git@github.com:Tailored-AI-Hub/`
- `push.autoSetupRemote=true`, `pull.rebase=true`, `fetch.prune=true`, `rerere.enabled=true`
- `merge.conflictStyle=zdiff3`, `diff.algorithm=histogram`, pager = delta
- `commit-at <date> <msg>` — amend author/committer dates
- `prune-gone` — delete branches whose upstream is gone

## Worktrunk (git worktree management)

Primary worktree workflow: `wsc <branch>` → work → `wm`.
Post-start hook auto-copies `.env*` and `.python-version` to new worktrees.
`wsx claude <branch>` — create worktree + launch Claude Code inside it.

## tmux

Prefix: `C-a` (not C-b). `C-a C-a` sends literal `C-a`.
- `C-a |` / `C-a -` — horizontal / vertical split
- `C-a hjkl` — resize pane (repeatable)
- `M-h`/`M-l` — prev/next window (no prefix)
- `C-a p` — floating window (floax), `C-a o` — session manager (sessionx)
- `C-a [`, vi copy mode: `v` visual, `y` yank
- Plugins via TPM: yank, resurrect, continuum, thumbs, sessionx, floax, vim-tmux-navigator

## Ghostty

- Theme: Catppuccin Mocha, 90% opacity
- Font: JetBrains Mono Nerd Font 15pt, `macos-option-as-alt=true`
- Split navigation: `cmd+s+j/k/h/l`
- Window: 180x45, `window-decoration=none`, `macos-titlebar-style=hidden`

## nvim

LazyVim distro. Entry: `nvim/init.lua` → `require("config.lazy")`.
Config under `nvim/lua/config/`, plugins under `nvim/lua/plugins/`.

## OpenCode

Config at `~/.config/opencode/opencode.json`. Agent workflows in `opencode/agent/`.
Plugins: `@dietrichgebert/ponytail`, `@omniroute/opencode-provider`.
Workflow: CSC-only (plan first, ask for "CSC" before code).

## Config load order pitfall

`.zshrc` references `export.zsh` (no s). The alias `eexport` points to `exports.zsh` (with s) which does not exist — it's `export.zsh` (no s). Aliases for editing configs: `ealias`, `eexport`(broken), `ecustom`, `ezshrc`, `eghost`.

## Key zsh features

- `cd` → `z` (zoxide). `ls` → `eza --no-filesize --icons`.
- `cat` → `bat`. `diff` → `difft`. `htop` → `btop`. `rm` → `trash`.
- Auto-python-venv activation on `cd` if `.venv` or `venv` exists (hooks.zsh). Auto `nvm use` on `.nvmrc`.
- FZF: piped into everything. See `bindkeys.zsh` for `^X*` shortcuts (`^Xgc` → git commit skeleton, `^Xgd` → diff vs main, etc.).
