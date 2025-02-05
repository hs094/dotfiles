# Fuzzy search history with fzf
function fzf-history() {
    history | fzf --tac --preview "echo {} | cut -c 8- | head -n 10" --preview-window=up:10
}

bindkey -e
bindkey '^h' fzf-history
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward