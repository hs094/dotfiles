clip() {
  if [[ -f "$1" ]]; then
    pbcopy < "$1"
    echo "✅ Copied to clipboard: $1"
  else
    echo "❌ File not found: $1"
  fi
}

clipl() {
  if [[ $# -ne 3 ]]; then
    echo "Usage: clipl <file_path> <start_line> <end_line>" >&2
    return 1
  fi

  local file_path="$1"
  local start_line="$2"
  local end_line="$3"

  if [[ ! -f "$file_path" ]]; then
    echo "Error: File '$file_path' not found." >&2
    return 1
  fi

  # Extract lines from start_line to end_line (inclusive), preserving indentation
  # Output to stdout; pipe to pbcopy (macOS), xclip -sel clip (Linux), or similar for clipboard
  sed -n "${start_line},${end_line}p" "$file_path"
}

# Copy file content + metadata to clipboard
clipd() {
  if [[ -z "$1" ]]; then
    echo "Usage: clipd <file>"
    return 1
  fi

  local file="$1"
  if [[ ! -f "$file" ]]; then
    echo "Error: $file is not a file"
    return 1
  fi

  {
    echo "### FILE METADATA"
    echo "Name: $(basename "$file")"
    echo "Path: $(realpath "$file")"
    echo "Size: $(stat -f%z "$file") bytes"
    echo "Permissions: $(stat -f%Sp "$file")"
    echo "Owner: $(stat -f%Su "$file")"
    echo
    echo "### FILE CONTENT"
    cat "$file"
  } | pbcopy
  echo "File + metadata copied to clipboard."
}

# Copy a clean, LLM-safe directory tree to clipboard 📂✨
clipsd() {
  if [ -z "$1" ]; then
    echo "❌ Usage: clipsd <directory-path>"
    return 1
  fi

  local dir="$1"

  # Check directory exists
  if [ ! -d "$dir" ]; then
    echo "❌ Error: '$dir' is not a valid directory."
    return 1
  fi

  # Ensure 'tree' is installed
  if ! command -v tree >/dev/null 2>&1; then
    echo "🌳 Installing 'tree' utility..."
    brew install tree || return 1
  fi

  echo "📋 Copying LLM-safe directory structure for '$dir'..."

  # Ignore hidden files, build, cache, and env folders/files
  tree -a -I '.*|node_modules|__pycache__|.venv|.env|dist|build|target|bin|pkg|.pytest_cache|.mypy_cache|.ruff_cache|*.log|*.lock|.DS_Store' "$dir" | pbcopy

  echo "✅ Directory structure copied to clipboard!"
}


# Copy directory structure (depth=1) + metadata to clipboard
clipfd() {
  if [[ -z "$1" ]]; then
    echo "Usage: clipfd <directory>"
    return 1
  fi

  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    echo "Error: $dir is not a directory"
    return 1
  fi

  {
    echo "### DIRECTORY METADATA"
    echo "Name: $(basename "$dir")"
    echo "Path: $(realpath "$dir")"
    echo "Permissions: $(stat -f%Sp "$dir")"
    echo "Owner: $(stat -f%Su "$dir")"
    echo
    echo "### DIRECTORY CONTENTS (depth=1)"
    find "$dir" -maxdepth 1 -mindepth 1 -exec stat -f "%HT %N (size=%z bytes perms=%Sp owner=%Su group=%Sg mod=%Sm)" {} \;
    echo
    echo "### FILE PREVIEWS (first 20 lines per file)"
    for f in "$dir"/*; do
      if [[ -f "$f" ]]; then
        echo "--- $(basename "$f") ---"
        head -n 20 "$f"
        echo
      fi
    done
  } | pbcopy
  echo "Directory structure + metadata copied to clipboard."
}

weather() {
  if [ -z "$1" ]; then
    curl wttr.in
  else
    curl "wttr.in/$1"
  fi
}

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then 
  mkdir -p "$(dirname $ZINIT_HOME)" 
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" 
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# source "${HOME}/.nvm/nvm.sh"
# FZF with Git right in the shell by Junegunn : check out his github below
# Keymaps for this is available at https://github.com/junegunn/fzf-git.sh
source ~/.config/scripts/fzf_git.sh
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Activate syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Disable underline
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
# Change colors
# export ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=blue
# export ZSH_HIGHLIGHT_STYLES[precommand]=fg=blue
# export ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue


# . "/Users/hardiksoni/.deno/env"
[ -s "/Users/hardiksoni/.bun/_bun" ] && source "/Users/hardiksoni/.bun/_bun"

# Forgit
[ -f $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh ] && source $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh

# pnpm
export PNPM_HOME="/Users/hardiksoni/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Load zsh-autosuggestions only if Atuin is not available
if ! command -v atuin >/dev/null 2>&1; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Yazi
# function y() {
#     local tmp cwd
#     tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
#     command yazi "$@" --cwd-file="$tmp"  # Ensure it calls 'yazi' and not 'y' again
#     if [[ -f "$tmp" ]]; then
#         cwd="$(<"$tmp")"
#         rm -f "$tmp"

#         if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
#             cd "$cwd" || return
#         fi
#     fi
# }

# NOTE: FZF
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

# bun completions
[ -s "/Users/personal/.bun/_bun" ] && source "/Users/personal/.bun/_bun"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
# . "/Users/personal/.deno/env"´

# History 
HISTSIZE=5000 
HISTFILE=~/.zsh_history 
SAVEHIST=$HISTSIZE 
HISTDUP=erase 
setopt appendhistory 
setopt sharehistory 
setopt hist_ignore_space 
setopt hist_ignore_all_dups 
setopt hist_save_no_dups 
setopt hist_ignore_dups 
setopt hist_find_no_dups

# Completion styling 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Redshift
# export ODBCINI="$HOME/.odbc.ini"
# export ODBCSYSINI="/opt/amazon/redshift/Setup"
# export AMAZONREDSHIFTODBCINI="/opt/amazon/redshift/lib/amazon.redshiftodbc.ini"
# export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:/usr/local/lib"

# export FZF_CTRL_T_OPTS="
#   --preview 'bat -n --color=always {}'
#   --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# export FZF_DEFAULT_COMMAND='rg --hidden -l ""' # Include hidden files

# # fd - cd to selected directory
# fd() {
#   local dir
#   dir=$(find ${1:-.} -path '*/\.*' -prune \
#                   -o -type d -print 2> /dev/null | fzf +m) &&
#   cd "$dir"
# }

# fh - search in your command history and execute selected command
h() {
   eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# Vi mode
# ANSI cursor escape codes:
# \e[0 q: Reset to the default cursor style.
# \e[1 q: Blinking block cursor.
# \e[2 q: Steady block cursor (non-blinking).
# \e[3 q: Blinking underline cursor.
# \e[4 q: Steady underline cursor (non-blinking).
# \e[5 q: Blinking bar cursor.
# \e[6 q: Steady bar cursor (non-blinking).
# bindkey -v
# export KEYTIMEOUT=1 # Makes switching modes quicker
# export VI_MODE_SET_CURSOR=true 

# function zle-keymap-select {
#   if [[ ${KEYMAP} == vicmd ]]; then
#     echo -ne '\e[1 q' # block
#   else
#     echo -ne '\e[5 q' # beam
#   fi
# }

# zle -N zle-keymap-select
# zle-line-init() {
#   zle -K viins # initiate 'vi insert' as keymap (can be removed if 'binkey -V has been set elsewhere')
#   echo -ne '\e[5 q'
# }
# zle -N zle-line-init
# echo -ne '\e[5 q' # Use beam shape cursor on startup

# Yank to the system clipboard
function vi-yank-xclip {
  zle vi-yank
  echo "$CUTBUFFER" | pbcopy -i
}

# zle -N vi-yank-xclip
# bindkey -M vicmd 'y' vi-yank-xclip
