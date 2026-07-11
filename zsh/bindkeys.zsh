bindkey '^B' beginning-of-line
bindkey '^E' end-of-line
bindkey '^[^?' backward-delete-word
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^U' undo
bindkey ' ' magic-space

# Backspace in insert mode (ensure autosuggestions wraps the right widget)
bindkey '^?' backward-delete-char

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Clear screen, keep buffer
clear-keep-buffer() {
  zle clear-screen
}
zle -N clear-keep-buffer
bindkey '^Xl' clear-keep-buffer

# Copy current command to clipboard
copy-command() {
  echo -n $BUFFER | pbcopy  # or xclip
  zle -M "Copied to clipboard"
}
zle -N copy-command
bindkey '^Xc' copy-command

# Type a git commit skeleton with the cursor between the quotes
bindkey -s '^Xgc' 'git commit -m ""\C-b'
# Diff current branch against main
bindkey -s '^Xgd' 'git diff main...HEAD\n'
# Diff the last commit
bindkey -s '^Xgl' 'git diff HEAD~1 HEAD\n'
# Diff all current changes (staged + unstaged) against HEAD
bindkey -s '^Xga' 'git diff HEAD\n'
