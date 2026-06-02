autoload -Uz add-zsh-hook

# chpwd hook for python
# On cd: activate a virtualenv (.venv or venv) in the current directory. If
# there's none here, look one level down in the immediate children — activate
# the sole match, or pop an fzf chooser when there are several. With nothing
# nearby, drop the env we activated. Only this hook's env is auto-deactivated,
# so a manually `source`d or conda env is left alone. $_AUTO_VENV holds the
# path we sourced (compared instead of $VIRTUAL_ENV, which activate bakes as
# the symlink-resolved path, so it may not match $PWD).
_chpwd_python_venv() {
  local venv
  local -a found

  # 1. venv in the current directory
  for venv in "$PWD/.venv" "$PWD/venv"; do
    if [[ -f "$venv/bin/activate" ]]; then
      [[ "$_AUTO_VENV" == "$venv" ]] && return  # already activated by us
      source "$venv/bin/activate"
      _AUTO_VENV="$venv"
      return
    fi
  done

  # 2. venvs in immediate children
  found=( $PWD/*/.venv/bin/activate(N) $PWD/*/venv/bin/activate(N) )
  found=( ${found%/bin/activate} )

  # keep our selection if it's still one of the children here
  [[ -n "$_AUTO_VENV" ]] && (( ${found[(Ie)$_AUTO_VENV]} )) && return

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

  if [[ -n "$venv" ]]; then
    source "$venv/bin/activate"
    _AUTO_VENV="$venv"
    return
  fi

  # 3. nothing nearby — drop the env we activated
  if [[ -n "$_AUTO_VENV" ]]; then
    deactivate 2>/dev/null
    unset _AUTO_VENV
  fi
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
