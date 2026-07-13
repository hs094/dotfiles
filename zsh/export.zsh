# Locale and input
export LANG=en_US.UTF-8
export INPUTRC="$HOME/.config/readline/inputrc"

# Shell behavior
export FUNCNEST=1000
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export ZSH="$HOME/.config/.oh-my-zsh"

# Editor
export EDITOR="nvim"
export GIT_EDITOR="nvim"

# PATH — user bins first, system foundation, tool bins appended
export PATH="$HOME/.local/bin"
export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$PATH:/opt/homebrew/bin"
export PATH="$PATH:/opt/homebrew/opt/python@3.10/libexec/bin"
export PATH="$PATH:/opt/homebrew/opt/llvm/bin"
export PATH="$PATH:/opt/homebrew/opt/postgresql@16/bin"
export PATH="$PATH:/opt/homebrew/Cellar/gcc/14.2.0_1/bin"   # ponytail: version pin
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$PATH:$HOME/.config/scripts"
export PATH="$PATH:$HOME/.antigravity/antigravity/bin"
export PATH="$PATH:$HOME/.meteor"
export PATH="$PATH:$HOME/Library/pnpm"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$PATH:$BUN_INSTALL/bin"

# Homebrew
export HOMEBREW_NO_AUTO_UPDATE=1

# Git
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"

# Node
export NVM_DIR="$HOME/.nvm"

# Go
export GOPATH=$HOME/go

# Python
export PIPENV_VENV_IN_PROJECT=1

# Bun
export BUN_INSTALL="$HOME/.bun"

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"

# FZF
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"
export FZF_TMUX_OPTS=" -p90%,70% "

# AWS
export AWS_CLI_AUTO_PROMPT=on-partial

# App paths
export obsidian="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents"
export rcscriptcmd="$HOME/.config/raycast/commands"

# IntelliShell
export INTELLI_BOOKMARK_HOTKEY=\C-o
export INTELLI_HOME="$HOME/Library/Application Support/org.IntelliShell.Intelli-Shell"
export INTELLI_FIX_HOTKEY='^xf'

# ponytail: belongs in a function file, kept here to avoid breaking source
countfiles() {
  local depth=${1:-100}
  find . -maxdepth "$depth" -type f | wc -l
}
