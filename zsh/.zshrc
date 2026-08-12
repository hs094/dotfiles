# Ensure Homebrew is available
if [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

eval "$(starship init zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# Custom zsh
[ -f "$HOME/.config/zsh/export.zsh" ] && source "$HOME/.config/zsh/export.zsh"
# Custom zsh
[ -f "$HOME/.config/zsh/custom.zsh" ] && source "$HOME/.config/zsh/custom.zsh"
# Bindkeys
[ -f "$HOME/.config/zsh/bindkeys.zsh" ] && source "$HOME/.config/zsh/bindkeys.zsh"
# Hooks
[ -f "$HOME/.config/zsh/hooks.zsh" ] && source "$HOME/.config/zsh/hooks.zsh"
# Utils
[ -f "$HOME/.config/zsh/utils.zsh" ] && source "$HOME/.config/zsh/utils.zsh"
# Aliases
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"
# Cleanup
[ -f "$HOME/.config/zsh/cleanup.zsh" ] && source "$HOME/.config/zsh/cleanup.zsh"
# Plugins
[ -f "$HOME/.config/zsh/plugins.zsh" ] && source "$HOME/.config/zsh/plugins.zsh"
# Work
# [ -f "$HOME/.config/zsh/git-completion.zsh" ] && source "$HOME/.config/zsh/git-completion.zsh"

export STARSHIP_CONFIG="~/.config/starship/starship.toml"
export FUNCNEST=1000
autoload -Uz compinit
compinit

# Ghost shell completions
command -v /Users/hardik.soni/.local/bin/ghost >/dev/null 2>&1 && source <(/Users/hardik.soni/.local/bin/ghost completion zsh)

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
