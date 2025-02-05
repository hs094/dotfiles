# Set the dorectory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Custom zsh
[ -f "$HOME/.config/zsh/custom.zsh" ] && source "$HOME/.config/zsh/custom.zsh"

# Bindkeys
[ -f "$HOME/.config/zsh/bindkeys.zsh" ] && source "$HOME/.config/zsh/bindkeys.zsh"

# Aliases
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"

# Work
# [ -f "$HOME/.config/zsh/git-completion.zsh" ] && source "$HOME/.config/zsh/git-completion.zsh"

export STARSHIP_CONFIG="~/.config/starship/starship.toml"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
