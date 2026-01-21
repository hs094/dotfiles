autoload -Uz compinit
compinit
unsetopt login

# Set the dorectory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

export INTELLI_BOOKMARK_HOTKEY=\C-o

# Ensure Homebrew is available
if [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Add to ~/.zshrc
export PATH="$HOME/.local/bin:$PATH"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(register-python-argcomplete --shell zsh eval-main)"
eval "$(atuin init zsh)"

export PATH="$PATH:/Users/hs094/.cargo/bin"

# Add completion directories to fpath BEFORE compinit
fpath=($HOME/.config/zsh $fpath)

# Initialize completion system after fpath is set
autoload -Uz compinit
compinit

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export FUNCNEST=1000
export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:/usr/local/bin
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Custom Exports to Load
[ -f "$HOME/.config/zsh/export.zsh" ] && source "$HOME/.config/zsh/export.zsh"
# Custom Functions for Productivity
[ -f "$HOME/.config/zsh/custom.zsh" ] && source "$HOME/.config/zsh/custom.zsh"
# Bindkeys
[ -f "$HOME/.config/zsh/bindkeys.zsh" ] && source "$HOME/.config/zsh/bindkeys.zsh"
# Aliases
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"
# Plugins
[ -f "$HOME/.config/zsh/plugins.zsh" ] && source "$HOME/.config/zsh/plugins.zsh"
# Cleanup
[ -f "$HOME/.config/zsh/cleanup.zsh" ] && source "$HOME/.config/zsh/cleanup.zsh"

# IntelliShell
export INTELLI_HOME="/Users/hs094/Library/Application Support/org.IntelliShell.Intelli-Shell"
# export INTELLI_SEARCH_HOTKEY='^@'
# export INTELLI_VARIABLE_HOTKEY='^l'
# export INTELLI_BOOKMARK_HOTKEY='^b'
# export INTELLI_FIX_HOTKEY='^x'
# export INTELLI_SKIP_ESC_BIND=0
alias is="intelli-shell"
export PATH="$INTELLI_HOME/bin:$PATH"
eval "$(intelli-shell init zsh)"

# Added by Antigravity
export PATH="/Users/hs094/.antigravity/antigravity/bin:$PATH"

# Added by Antigravity
export PATH="/Users/hs094/.antigravity/antigravity/bin:$PATH"
