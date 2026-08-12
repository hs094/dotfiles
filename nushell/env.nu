# env.nu — environment variables (translated from zsh/export.zsh)
# Loaded by nushell *before* config.nu.
#
# NOTE: Homebrew shellenv vars are set explicitly here because nushell cannot
# `eval` the sh-style `export` output of `brew shellenv` (no sh `eval`).

# ── Locale & input ───────────────────────────────────────────────────────────
$env.LANG = "en_US.UTF-8"
# INPUTRC is readline-specific (bash/zsh); nushell has its own line editor.
# Kept for subprocesses (e.g. `bash`) that still use readline.
$env.INPUTRC = ($env.HOME | path join ".config" "readline" "inputrc")

# ── Shell behaviour ──────────────────────────────────────────────────────────
$env.FUNCNEST = "1000"
# Clear vi-mode prompt indicators (": " by default) — cursor shape shows mode.
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.STARSHIP_CONFIG = ($env.HOME | path join ".config" "starship" "starship.toml")
# $env.ZSH was zsh-only; omitted for nushell.

# ── Editor ───────────────────────────────────────────────────────────────────
$env.EDITOR = "nvim"
$env.GIT_EDITOR = "nvim"

# ── Homebrew (Apple Silicon) ─────────────────────────────────────────────────
$env.HOMEBREW_PREFIX = "/opt/homebrew"
$env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
$env.HOMEBREW_REPOSITORY = "/opt/homebrew"
$env.HOMEBREW_NO_AUTO_UPDATE = "1"
$env.MANPATH = $":($env.HOMEBREW_PREFIX)/share/man:($env.MANPATH? | default '')"
$env.INFOPATH = $":($env.HOMEBREW_PREFIX)/share/info:($env.INFOPATH? | default '')"

# ── PATH ─────────────────────────────────────────────────────────────────────
# Replicates zsh/export.zsh: user bins first, system foundation, tool bins appended.
$env.PATH = [
    ($env.HOME | path join ".local/bin")
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
    "/opt/homebrew/bin"
    "/opt/homebrew/opt/python@3.10/libexec/bin"
    "/opt/homebrew/opt/llvm/bin"
    "/opt/homebrew/opt/postgresql@16/bin"
    "/opt/homebrew/Cellar/gcc/14.2.0_1/bin"              # ponytail: version pin
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    ($env.HOME | path join ".config" "scripts")
    ($env.HOME | path join ".antigravity" "antigravity" "bin")
    ($env.HOME | path join ".meteor")
    ($env.HOME | path join "Library" "pnpm")
    ($env.HOME | path join ".cargo" "bin")
    ($env.GOPATH? | default ($env.HOME | path join "go") | path join "bin")  # GOPATH/bin
    ($env.BUN_INSTALL? | default ($env.HOME | path join ".bun") | path join "bin") # BUN_INSTALL/bin
]

# ── Git ──────────────────────────────────────────────────────────────────────
$env.LG_CONFIG_FILE = ($env.HOME | path join ".config" "lazygit" "config.yml")

# ── Node ─────────────────────────────────────────────────────────────────────
$env.NVM_DIR = ($env.HOME | path join ".nvm")

# ── Go ───────────────────────────────────────────────────────────────────────
$env.GOPATH = ($env.HOME | path join "go")

# ── Python ───────────────────────────────────────────────────────────────────
$env.PIPENV_VENV_IN_PROJECT = "1"

# ── Bun ──────────────────────────────────────────────────────────────────────
$env.BUN_INSTALL = ($env.HOME | path join ".bun")

# ── PNPM ─────────────────────────────────────────────────────────────────────
$env.PNPM_HOME = ($env.HOME | path join "Library" "pnpm")

# ── FZF ──────────────────────────────────────────────────────────────────────
$env.FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git"
$env.FZF_CTRL_T_COMMAND = $env.FZF_DEFAULT_COMMAND
$env.FZF_ALT_C_COMMAND = "fd --type=d --hidden --strip-cwd-prefix --exclude .git"
$env.FZF_DEFAULT_OPTS = "--height 50% --layout=default --border --color=hl:#2dd4bf"
$env.FZF_CTRL_T_OPTS = "--preview 'bat --color=always -n --line-range :500 {}'"
$env.FZF_ALT_C_OPTS = "--preview 'eza --icons=always --tree --color=always {} | head -200'"
$env.FZF_TMUX_OPTS = " -p90%,70% "

# ── AWS ──────────────────────────────────────────────────────────────────────
$env.AWS_CLI_AUTO_PROMPT = "on-partial"

# ── App paths ────────────────────────────────────────────────────────────────
$env.obsidian = ($env.HOME | path join "Library" "Mobile Documents" "iCloud~md~obsidian" "Documents")
$env.rcscriptcmd = ($env.HOME | path join ".config" "raycast" "commands")

# ── IntelliShell (hotkeys are readline-only; kept for the env var) ────────────
$env.INTELLI_BOOKMARK_HOTKEY = '\C-o'
$env.INTELLI_HOME = ($env.HOME | path join "Library" "Application Support" "org.IntelliShell.Intelli-Shell")
$env.INTELLI_FIX_HOTKEY = '^xf'

# ── Functions ────────────────────────────────────────────────────────────────
# countfiles — count files under cwd up to a depth (from zsh/export.zsh)
def countfiles [depth: int = 100] {
    ^find . -maxdepth $depth -type f | lines | length
}
