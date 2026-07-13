autoload -Uz add-zsh-hook

# chpwd hook for python
# On cd into a dir with .venv/ or venv/, activate it. If one is already active
# (auto-activated here, manual `source`, or conda), leave it alone. Only
# considers the current directory — no child search.
# HOOKS_FLAG=1: also prompt to create .venv if missing (creates + activates,
#               then installs deps in background with tmux notification).
_chpwd_python_venv() {
  local venv flag=${HOOKS_FLAG:-0}

  [[ -n "$VIRTUAL_ENV" ]] && return

  for venv in "$PWD/.venv" "$PWD/venv"; do
    if [[ -f "$venv/bin/activate" ]]; then
      source "$venv/bin/activate"
      return
    fi
  done

  # No venv found — prompt to create one if HOOKS_FLAG=1 and this looks like a
  # Python project.
  if (( flag )) && [[ -f $PWD/requirements.txt || -f $PWD/pyproject.toml || -f $PWD/setup.py || -f $PWD/Pipfile ]]; then
    echo -n "🐍 No venv found — create .venv? [y/N] "
    read -q || return
    echo
    if (( $+commands[uv] )); then
      uv venv "$PWD/.venv" || return
    else
      python3 -m venv "$PWD/.venv" || return
    fi
    source "$PWD/.venv/bin/activate"
    if [[ -f requirements.txt ]]; then
      if (( $+commands[uv] )); then
        (uv pip install -r requirements.txt; tmux display-message "🐍 uv done: ${PWD:t}") &!
      else
        (pip install -r requirements.txt; tmux display-message "🐍 pip done: ${PWD:t}") &!
      fi
    fi
  fi
}
# chpwd hook for node
# On entering a folder with a package.json but no node_modules, install deps.
# HOOKS_FLAG=0 (default): no prompt, install silently.
# HOOKS_FLAG=1:          ask y/n before installing.
_chpwd_node_install() {
  local flag=${HOOKS_FLAG:-0}
  if [[ -f package.json && ! -d node_modules ]]; then
    if (( flag )); then
      echo -n "📦 package.json found, no node_modules — install? [y/N] "
      read -q || return
      echo
    fi
    (npm i; tmux display-message "📦 npm done: ${PWD:t}") &!
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
