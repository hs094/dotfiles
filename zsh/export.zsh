export LANG=en_US.UTF-8
export INPUTRC="$HOME/.config/readline/inputrc"

# VS Code
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin$PATH"

# uv
export PATH="/Users/hs094/.local/bin:$PATH"

# Set DOCKER_HOST to lima docker socket if lima is running
# if command -v limactl >/dev/null 2>&1 && limactl list docker --format '{{.Status}}' 2>/dev/null | grep -q "Running"; then
#  export DOCKER_HOST=$(limactl list docker --format 'unix://{{.Dir}}/sock/docker.sock')
# fi

# Docker
# export DOCKER_HOST=$(limactl list docker --format 'unix://{{.Dir}}/sock/docker.sock')
fpath=(/Users/hardiksoni/.docker/completions $fpath)

# Add local ~/scripts to the PATH
export PATH="$HOME/.config/scripts:$PATH"
export ZSH="$HOME/.oh-my-zsh"
# Python
export PATH="/opt/homebrew/opt/python@3.10/libexec/bin:$PATH"
# Add Homebrew binaries to PATH
export PATH="/opt/homebrew/bin:$PATH"
export HOMEBREW_NO_AUTO_UPDATE=1
# Add GCC binaries
export PATH="/opt/homebrew/Cellar/gcc/14.2.0_1/bin:$PATH"
# Pipenv
export PIPENV_VENV_IN_PROJECT=1

# Configure Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export EDITOR="nvim"

# TMUX
export TMUX_CONF="~/.config/tmux/tmux.conf"
# FZF
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"

# Setup fzf previews
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# fzf preview for tmux
export FZF_TMUX_OPTS=" -p90%,70% "  

# Go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export PATH=$PATH:$(go env GOPATH)/bin

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Meteor
export PATH="/Users/hardiksoni/.meteor:$PATH"

# Function to count files up to a specified depth level
countfiles() {
  local depth=${1:-100}
  find . -maxdepth "$depth" -type f | wc -l
}
