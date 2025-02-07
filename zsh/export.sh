# Add local ~/scripts to the PATH
export PATH="$HOME/.config/scripts:$PATH"

export ZSH="$HOME/.oh-my-zsh"
# Poetry
export PATH="$HOME/.local/bin:$PATH"
# Add Homebrew binaries to PATH
export PATH="/opt/homebrew/bin:$PATH"
# Add GCC binaries
export PATH="/opt/homebrew/Cellar/gcc/14.2.0_1/bin:$PATH"
export HOMEBREW_NO_AUTO_UPDATE=1
# Pipenv
export PIPENV_VENV_IN_PROJECT=1

# Configure Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

export EDITOR="nvim"


export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"

# Setup fzf previews
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# fzf preview for tmux
export FZF_TMUX_OPTS=" -p90%,70% "  