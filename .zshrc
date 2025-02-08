# Set the dorectory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Custom zsh
[ -f "$HOME/.config/zsh/export.zsh" ] && source "$HOME/.config/zsh/export.zsh"
# Custom zsh
[ -f "$HOME/.config/zsh/custom.zsh" ] && source "$HOME/.config/zsh/custom.zsh"
# Bindkeys
[ -f "$HOME/.config/zsh/bindkeys.zsh" ] && source "$HOME/.config/zsh/bindkeys.zsh"
# Aliases
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"
# Work
# [ -f "$HOME/.config/zsh/git-completion.zsh" ] && source "$HOME/.config/zsh/git-completion.zsh"

eval "$(starship init zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval $(thefuck --alias)
eval "$(brew shellenv)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# plugins = ( git zsh-autosuggestions zsh-syntax-highlighting web-search)

export STARSHIP_CONFIG="~/.config/starship/starship.toml"
export FUNCNEST=1000
. "/Users/hardiksoni/.deno/env"
# bun completions
[ -s "/Users/hardiksoni/.bun/_bun" ] && source "/Users/hardiksoni/.bun/_bun"
