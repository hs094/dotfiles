autoload -Uz add-zsh-hook

# chpwd hook for python
# Look for a virtualenv in the current dir first, then one level deep.
# Activate the first one found; deactivate when none exists nearby.
_chpwd_python_venv() {
  local venv

  for venv in .venv venv */.venv(N) */venv(N); do
    if [[ -f "$venv/bin/activate" ]]; then
      [[ "$VIRTUAL_ENV" == "$PWD/$venv" ]] && return  # already active
      source "$venv/bin/activate"
      return
    fi
  done

  [[ -n "$VIRTUAL_ENV" ]] && deactivate
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
