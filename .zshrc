# Set the dorectory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

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
# Aliases
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"
# Plugins
[ -f "$HOME/.config/zsh/plugins.zsh" ] && source "$HOME/.config/zsh/plugins.zsh"
# Work
# [ -f "$HOME/.config/zsh/git-completion.zsh" ] && source "$HOME/.config/zsh/git-completion.zsh"

export STARSHIP_CONFIG="~/.config/starship/starship.toml"
export FUNCNEST=1000
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/hardiksoni/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
