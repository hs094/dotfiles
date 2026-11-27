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
# Secrets
[ -f "$HOME/.config/zsh/secrets.zsh" ] && source "$HOME/.config/zsh/secrets.zsh"

export STARSHIP_CONFIG="~/.config/starship/starship.toml"
export FUNCNEST=1000
autoload -Uz compinit
compinit

# Ghost shell completions
command -v /Users/hardik.soni/.local/bin/ghost >/dev/null 2>&1 && source <(/Users/hardik.soni/.local/bin/ghost completion zsh)

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
if (( $+functions[compdef] && $+functions[_wt_lazy_complete] )); then
  compdef _ws_complete ws
  compdef _wsc_complete wsc
  compdef _wsx_complete wsx
  compdef _wscp_complete wscp
  compdef _wr_complete wr
fi
export PATH="$HOME/.config/herdr/plugins/github/dnzzl.automations-c6e92c72ec60/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.11/libexec/bin:$PATH"

# opencode
export PATH=/Users/hardik.soni/.opencode/bin:$PATH
export PATH="$HOME/.opencode/bin:$PATH"

# added by dbx installer
export PATH="$HOME/.dbx/bin:$PATH"
# bun completions
[ -s "/Users/hs094/.bun/_bun" ] && source "/Users/hs094/.bun/_bun"

# Added by Kiri: its docker and kiri commands (kiri setup --uninstall removes this)
case ":$PATH:" in *":$HOME/.kiri/bin:"*) ;; *) export PATH="$PATH:$HOME/.kiri/bin" ;; esac

# Keep Rex CLI available inside Rex terminals
if [[ -n "$REX_BIN_DIR" ]]; then
    export PATH="$REX_BIN_DIR:$PATH"
fi
# Keep Rex CLI available inside Rex terminals
if [[ -n "$REX_BIN_DIR" ]]; then
    export PATH="$REX_BIN_DIR:$PATH"
fi

# Added by Kiri: its docker and kiri commands (kiri setup --uninstall removes this)
case ":$PATH:" in *":$HOME/.kiri/bin:"*) ;; *) export PATH="$PATH:$HOME/.kiri/bin" ;; esac
