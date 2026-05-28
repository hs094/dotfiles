bindkey '^B' beginning-of-line
bindkey '^E' end-of-line
bindkey '^[^?' backward-delete-word
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

## DO NOT TOUCH

# bindkey '^R' history-search
# bindkey '⌥C' folder-search
# bindkey '**tab' start-fuzzy-search
