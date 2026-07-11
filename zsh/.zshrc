unsetopt login
MAILCHECK=0

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Ensure Homebrew is available
if [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Add completion directories to fpath BEFORE compinit
fpath=($HOME/.config/zsh $fpath)

# Initialize completion system once, after fpath is set
autoload -Uz compinit
compinit

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Custom Exports to Load
[ -f "$HOME/.config/zsh/export.zsh" ] && source "$HOME/.config/zsh/export.zsh"
# Custom Functions for Productivity
[ -f "$HOME/.config/zsh/custom.zsh" ] && source "$HOME/.config/zsh/custom.zsh"
# Bindkeys
[ -f "$HOME/.config/zsh/bindkeys.zsh" ] && source "$HOME/.config/zsh/bindkeys.zsh"
# Hooks
[ -f "$HOME/.config/zsh/hooks.zsh" ] && source "$HOME/.config/zsh/hooks.zsh"
# Utility functions (backing aliases)
[ -f "$HOME/.config/zsh/utils.zsh" ] && source "$HOME/.config/zsh/utils.zsh"
# Aliases
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"
# Plugins
[ -f "$HOME/.config/zsh/plugins.zsh" ] && source "$HOME/.config/zsh/plugins.zsh"
# Cleanup
[ -f "$HOME/.config/zsh/cleanup.zsh" ] && source "$HOME/.config/zsh/cleanup.zsh"

# IntelliShell
alias is="intelli-shell"
eval "$(intelli-shell init zsh)"


if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
