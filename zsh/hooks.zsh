autoload -Uz add-zsh-hook

# chpwd hook for python
# On cd: if a venv is already active (auto-activated here, a manual `source`,
# or conda), leave it alone. Otherwise activate a virtualenv (.venv or venv) in
# the current directory; failing that, look one level down in the immediate
# children — activate the sole match, or pop an fzf chooser when there are
# several. Never auto-deactivates: once an env is on, it stays until you leave
# it yourself.
_chpwd_python_venv() {
  local venv
  local -a found

  # 0. a venv is already active — leave it
  [[ -n "$VIRTUAL_ENV" ]] && return

  # 1. venv in the current directory
  for venv in "$PWD/.venv" "$PWD/venv"; do
    if [[ -f "$venv/bin/activate" ]]; then
      source "$venv/bin/activate"
      return
    fi
  done

  # 2. venvs in immediate children
  found=( $PWD/*/.venv/bin/activate(N) $PWD/*/venv/bin/activate(N) )
  found=( ${found%/bin/activate} )

  venv=""
  if (( ${#found} == 1 )); then
    venv=$found[1]
  elif (( ${#found} > 1 )); then
    if (( $+commands[fzf] )); then
      venv=$(print -rl -- $found | fzf --prompt='venv> ' --height=40% --reverse) || return
    else
      venv=$found[1]
    fi
  fi

  [[ -n "$venv" ]] && source "$venv/bin/activate"
}

# chpwd hook for node
# On entering a folder with a package.json but no node_modules, install deps.
_chpwd_node_install() {
  if [[ -f package.json && ! -d node_modules ]]; then
    echo "📦 package.json found, no node_modules — running npm i…"
    npm i
  fi
}

# chpwd hook for nvm
# Switch to the node version pinned in .nvmrc when present.
_chpwd_nvm_use() {
  if [[ -f .nvmrc ]]; then
    nvm use
  fi
}

add-zsh-hook chpwd _chpwd_python_venv
add-zsh-hook chpwd _chpwd_node_install
add-zsh-hook chpwd _chpwd_nvm_use
