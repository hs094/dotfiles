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

# Kill process(es) listening on a given TCP port
killp() {
  if [[ -z "$1" ]]; then
    echo "Usage: killp <port> [-9]" >&2
    return 1
  fi

  local port="$1"
  local sig="${2:-TERM}"
  sig="${sig#-}"

  local pids
  pids=$(lsof -ti tcp:"$port")

  if [[ -z "$pids" ]]; then
    echo "No process listening on port $port"
    return 0
  fi

  echo "Killing PID(s) on port $port: ${pids//$'\n'/ } (SIG$sig)"
  echo "$pids" | xargs kill -"$sig"
}

drmpat() {
  local pattern="${1:?Provide a regex pattern}"
  docker volume ls -q | grep -E "$pattern" | xargs docker volume rm
}

# Generic docker-service lifecycle: start | stop | status | rm
# Usage: _docker_svc <action> <name> <url> <image> [docker-run-args...]
_docker_svc() {
  local action="$1" name="$2" url="$3" image="$4"
  shift 4

  local state
  state=$(docker inspect -f '{{.State.Status}}' "$name" 2>/dev/null)

  case "${action:-start}" in
    start)
      case "$state" in
        running)
          echo "$name is already running at $url"
          ;;
        exited|created|paused)
          echo "Starting existing $name container..."
          docker start "$name" >/dev/null && echo "$name running at $url"
          ;;
        "")
          echo "Creating and starting $name container..."
          docker run -d --name "$name" "$@" "$image" >/dev/null \
            && echo "$name running at $url"
          ;;
        *)
          echo "$name in unexpected state: $state" >&2
          return 1
          ;;
      esac
      ;;
    stop)
      if [[ "$state" == "running" ]]; then
        docker stop "$name" >/dev/null && echo "$name stopped"
      elif [[ -z "$state" ]]; then
        echo "$name container does not exist"
      else
        echo "$name is not running (state: $state)"
      fi
      ;;
    status)
      if [[ -z "$state" ]]; then
        echo "$name: not created"
      else
        echo "$name: $state"
      fi
      ;;
    rm)
      [[ "$state" == "running" ]] && docker stop "$name" >/dev/null
      if [[ -n "$state" ]]; then
        docker rm "$name" >/dev/null && echo "$name container removed"
      else
        echo "$name container does not exist"
      fi
      ;;
    *)
      echo "Usage: $name [start|stop|status|rm]" >&2
      return 1
      ;;
  esac
}

dozzle() {
  _docker_svc "${1:-start}" dozzle http://localhost:8080 amir20/dozzle:latest \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v dozzle_data:/data \
    -p 8080:8080
}

floci() {
  _docker_svc "${1:-start}" floci http://localhost:4566 floci/floci:latest \
    -p 4566:4566 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -u root
}

n8n() {
  local tz="${GENERIC_TIMEZONE:-Asia/Mumbai}"
  _docker_svc "${1:-start}" n8n http://localhost:5678 docker.n8n.io/n8nio/n8n \
    --restart always \
    -p 5678:5678 \
    -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
    -e N8N_HOST=localhost \
    -e N8N_PORT=5678 \
    -e N8N_PROTOCOL=http \
    -e N8N_RUNNERS_ENABLED=true \
    -e N8N_SECURE_COOKIE=false \
    -e NODE_ENV=production \
    -e GENERIC_TIMEZONE="$tz" \
    -e TZ="$tz" \
    -v n8n_data:/home/node/.n8n \
    -v n8n_files:/files
}

metabase() {
  _docker_svc "${1:-start}" metabase http://localhost:3000 metabase/metabase \
    --restart unless-stopped \
    -p 3000:3000 \
    -v metabase_data:/metabase-data
}

jackett() {
  _docker_svc "${1:-start}" jackett http://localhost:9117 lscr.io/linuxserver/jackett:latest \
    --restart unless-stopped \
    -p 9117:9117 \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ="${GENERIC_TIMEZONE:-Etc/UTC}" \
    -e AUTO_UPDATE=true \
    -v jackett_config:/config \
    -v jackett_downloads:/downloads
}

lobechat() {
  local envfile="$HOME/.config/images/lobechat/.env"
  local args=(--restart always -p 3210:3210 -e ACCESS_CODE=lobe66)
  [[ -f "$envfile" ]] && args+=(--env-file "$envfile")
  _docker_svc "${1:-start}" lobechat http://localhost:3210 lobehub/lobe-chat "${args[@]}"
}

# Set INFISICAL_DB_URI, INFISICAL_REDIS_URL, INFISICAL_SITE_URL before `infisical start`
infisical() {
  local version="${INFISICAL_VERSION:-latest}"
  _docker_svc "${1:-start}" infisical http://localhost:80 "infisical/infisical:${version}" \
    --restart unless-stopped \
    -p 80:8080 \
    -e ENCRYPTION_KEY="${INFISICAL_ENCRYPTION_KEY:-f40c9178624764ad85a6830b37ce239a}" \
    -e AUTH_SECRET="${INFISICAL_AUTH_SECRET:-q6LRi7c717a3DQ8JUxlWYkZpMhG4+RHLoFUVt3Bvo2U=}" \
    -e DB_CONNECTION_URI="${INFISICAL_DB_URI:?set INFISICAL_DB_URI}" \
    -e REDIS_URL="${INFISICAL_REDIS_URL:?set INFISICAL_REDIS_URL}" \
    -e SITE_URL="${INFISICAL_SITE_URL:?set INFISICAL_SITE_URL}"
}

# Registry: container-name -> "url|description"
# (lobechat's docker container is named lobe-chat to match the original compose)
typeset -gA DSVC_REGISTRY=(
  dozzle    "http://localhost:8080|Live docker container log viewer"
  floci     "http://localhost:4566|Floci docker UI"
  n8n       "http://localhost:5678|Workflow automation / low-code"
  metabase  "http://localhost:3000|Open-source BI dashboards"
  lobechat  "http://localhost:3210|Multi-LLM chat UI"
  infisical "http://localhost:80|Self-hosted secrets manager"
  jackett  "http://localhost:9117|Torrent indexer / proxy"
)

# Pretty-print all docker service wrappers with current state
dsvc() {
  local hdr=$'\e[1;36m' name_c=$'\e[1;35m' url_c=$'\e[36m'
  local dim=$'\e[2m' rst=$'\e[0m' green=$'\e[32m' yellow=$'\e[33m'

  printf "\n  ${hdr}%-12s %-26s %-10s %s${rst}\n" "SERVICE" "URL" "STATE" "DESCRIPTION"
  printf "  ${dim}%s${rst}\n" "──────────────────────────────────────────────────────────────────────────────"

  local name entry url desc state sc
  for name in ${(ko)DSVC_REGISTRY}; do
    entry="${DSVC_REGISTRY[$name]}"
    url="${entry%%|*}"
    desc="${entry#*|}"
    state=$(docker inspect -f '{{.State.Status}}' "$name" 2>/dev/null)
    [[ -z "$state" ]] && state="—"
    case "$state" in
      running)               sc=$green ;;
      exited|created|paused) sc=$yellow ;;
      *)                     sc=$dim ;;
    esac
    printf "  ${name_c}%-12s${rst} ${url_c}%-26s${rst} ${sc}%-10s${rst} %s\n" \
      "$name" "$url" "$state" "$desc"
  done

  printf "\n  ${dim}Use${rst} ${name_c}<service>${rst} ${dim}[start|stop|status|rm]${rst} ${dim}to control.${rst}\n\n"
}

# Registry: alias -> "binary|description"
typeset -gA LSVC_REGISTRY=(
  lg   "lazygit|Terminal UI for git"
  ld   "lazydocker|Terminal UI for Docker"
  lssh "lazyssh|TUI for SSH connection management"
  lsql "lazysql|TUI for SQL databases"
  lenv "lazyenv|TUI for .env files"
  lnpm "lazynpm|TUI for npm"
  lact "lazyactions|TUI for GitHub Actions workflows"
)

# Pretty-print all lazy-toolkit aliases with installed state
lsvc() {
  local hdr=$'\e[1;36m' name_c=$'\e[1;35m' bin_c=$'\e[36m'
  local dim=$'\e[2m' rst=$'\e[0m' green=$'\e[32m' yellow=$'\e[33m'

  printf "\n  ${hdr}%-8s %-14s %-12s %s${rst}\n" "ALIAS" "COMMAND" "STATE" "DESCRIPTION"
  printf "  ${dim}%s${rst}\n" "──────────────────────────────────────────────────────────────────────────────"

  local alias_name entry bin desc state sc
  for alias_name in ${(ko)LSVC_REGISTRY}; do
    entry="${LSVC_REGISTRY[$alias_name]}"
    bin="${entry%%|*}"
    desc="${entry#*|}"
    if command -v "$bin" >/dev/null 2>&1; then
      state="installed"; sc=$green
    else
      state="missing";   sc=$yellow
    fi
    printf "  ${name_c}%-8s${rst} ${bin_c}%-14s${rst} ${sc}%-12s${rst} %s\n" \
      "$alias_name" "$bin" "$state" "$desc"
  done

  printf "\n  ${dim}Run${rst} ${name_c}<alias>${rst} ${dim}to launch the TUI.${rst}\n\n"
}

# Registry: submenu -> "command|description"
typeset -gA MH_REGISTRY=(
  docker "dsvc|Docker service wrappers (start/stop/status/rm)"
  lazy   "lsvc|Lazy-toolkit TUIs (lazygit, lazydocker, lazysql, ...)"
)

# mh = my help. Top-level menu, dispatches to submenu commands.
# Usage: mh                 -> list submenus
#        mh <submenu>       -> run the submenu's command (e.g. mh docker -> dsvc)
mh() {
  local hdr=$'\e[1;36m' name_c=$'\e[1;35m' cmd_c=$'\e[36m'
  local dim=$'\e[2m' rst=$'\e[0m'

  if [[ -n "$1" ]]; then
    local entry="${MH_REGISTRY[$1]}"
    if [[ -z "$entry" ]]; then
      echo "mh: unknown submenu '$1'" >&2
      echo "Available: ${(ko)MH_REGISTRY}" >&2
      return 1
    fi
    "${entry%%|*}"
    return
  fi

  printf "\n  ${hdr}%-10s %-10s %s${rst}\n" "SUBMENU" "COMMAND" "DESCRIPTION"
  printf "  ${dim}%s${rst}\n" "──────────────────────────────────────────────────────────────────────────────"

  local key entry cmd desc
  for key in ${(ko)MH_REGISTRY}; do
    entry="${MH_REGISTRY[$key]}"
    cmd="${entry%%|*}"
    desc="${entry#*|}"
    printf "  ${name_c}%-10s${rst} ${cmd_c}%-10s${rst} %s\n" "$key" "$cmd" "$desc"
  done

  printf "\n  ${dim}Run${rst} ${name_c}mh <submenu>${rst} ${dim}or the command directly.${rst}\n\n"
}

# Tab-complete `mh` with its registered submenus
_mh_complete() { compadd -- ${(ko)MH_REGISTRY}; }
(( $+functions[compdef] )) && compdef _mh_complete mh

# Git Sparse Clone and Checkout
gcls() {
  if [ "$#" -lt 2 ]; then
    echo "Usage: gcls <org/repo> <path>"
    return 1
  fi
  repo="$1"
  path="$2"
  git clone --filter=blob:none --sparse "git@github.com:${repo}" &&
  cd "$dir" &&
  git sparse-checkout set "$path"
}

gitfco() {
  local path="$1"

  if [[ -z "$path" ]]; then
    echo "Usage: gitfco <file-or-directory-path>"
    return 1
  fi

  local selected
  selected=$(git log --all --reverse \
    --pretty=format:'%C(yellow)%h%Creset %C(white)%<(50,trunc)%s%Creset %C(cyan)%an%Creset %C(green)%ad%Creset' \
    --date=relative \
    -- "$path" |
    fzf --ansi \
        --no-sort \
        --reverse \
        --height=80% \
        --preview 'git show --color=always {1}' \
        --preview-window=right:60% )

  if [[ -n "$selected" ]]; then
    local commit
    commit=$(echo "$selected" | awk '{print $1}')
    echo "🔁 Checking out commit $commit"
    git checkout "$commit"
  else
    echo "❌ No commit selected"
  fi
}

# source "${HOME}/.nvm/nvm.sh"
# FZF with Git right in the shell by Junegunn : check out his github below
# Keymaps for this is available at https://github.com/junegunn/fzf-git.sh
source ~/.config/scripts/fzf_git.sh
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Activate syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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


# Yazi
function y() {
     local tmp cwd
     tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
     command yazi "$@" --cwd-file="$tmp"  # Ensure it calls 'yazi' and not 'y' again
     if [[ -f "$tmp" ]]; then
         cwd="$(<"$tmp")"
         rm -f "$tmp"

         if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
             cd "$cwd" || return
         fi
     fi 
}

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
