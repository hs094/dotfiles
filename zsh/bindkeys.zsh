# Fuzzy search history with fzf
function fzf-history() {
    history | fzf --tac --preview "echo {} | cut -c 8- | head -n 10" --preview-window=up:10
}

# Convert function to a Zsh widget
zle -N fzf-history

bindkey -e
bindkey '^h' fzf-history
bindkey -r "^G"
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward