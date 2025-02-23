# Folders
alias doc="$HOME/Documents"
alias dow="$HOME/Downloads"
alias dev="$HOME/Dev.hs"

# Add personal aliases and configurations
alias vim="nvim"
alias python="python3.10"
alias python3="python3.13" 
alias zshconfig="bat ~/.zshrc"
alias zshreload="source ~/.config/.zshrc"
alias ls="eza --no-filesize --icons=always --color=always --ignore-glob=.git --no-user"
alias lsh="eza -a --no-filesize --icons=always --color=always --ignore-glob=.git --no-user"
alias ll="eza -al --no-filesize  --icons=always --color=always --ignore-glob=.git --no-user"
alias lt="eza -aT --no-filesize --icons --color=always --ignore-glob=.git --no-user"

# System
alias shutdown='sudo shutdown now'
alias restart='sudo reboot'
alias suspend='sudo pm-suspend'
alias sleep='pmset sleepnow'
alias c='clear'
alias e='exit'
alias cat='bat'
alias cd='z'
alias diff='difft'
alias mem='ncdu .'
alias htop='btop'
alias y='yazi'

# fzf
alias fzf='fzf --preview "bat --color=always {}"'
alias flof="~/.config/scripts/fzf_listoldfiles.sh"
alias fzfd="docker ps -a | fzf --preview 'docker inspect {1}'" # Docker
alias fman="command -v | fzf | xargs man" # opens documentation through fzf (eg: git,zsh etc.)
alias fzo="~/.config/scripts/zoxide_openfiles_nvim.sh"

# Tmux 
alias tmux="tmux -f ~/.config/tmux/tmux.conf"
alias a="attach"
alias tns="~/.config/scripts/tmux_sessionizer"

# Git
alias g='git'
alias gc='git commit -m'
alias gs="git status -s"
alias glog='git log --oneline --graph --all'
alias lg="lazygit"
alias ga='git add .'
alias gafzf='git ls-files -m -o --exclude-standard | grep -v "__pycache__" | fzf -m --print0 | xargs -0 -o -t git add' # Git add with fzf
alias grmfzf='git ls-files -m -o --exclude-standard | fzf -m --print0 | xargs -0 -o -t git rm' # Git rm with fzf
alias grfzf='git diff --name-only | fzf -m --print0 | xargs -0 -o -t git restore' # Git restore with fzf
alias grsfzf='git diff --name-only | fzf -m --print0 | xargs -0 -o -t git restore --staged' # Git restore --staged with fzf
alias gf='git fetch'
alias gs='git status -s'
alias gss='git status -s'
alias gup='git fetch && git rebase'
alias gtd='git tag --delete'
alias gtdr='git tag --delete origin'
alias glo='git pull origin'
alias gl='git pull'
alias gb='git branch '
alias gbr='git branch -r'
alias gd='git diff'
alias gco='git checkout '
alias gcob='git checkout -b '
alias gcofzf='git branch | fzf | xargs git checkout' # Select branch with fzf
alias gre='git remote'
alias gres='git remote show'
alias glgg='git log --graph --max-count=5 --decorate --pretty="oneline"'
alias gm='git merge'
alias gp='git push'
alias gpo='git push origin'
alias ggpush='git push origin $(current_branch)'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gcmnv='git commit --no-verify -m'
alias gcanenv='git commit --amend --no-edit --no-verify'

# Function to commit with ticket ID from current branch, with optional push
quick_commit() {
  local branch_name ticket_id commit_message push_flag
  branch_name=$(git branch --show-current)
  ticket_id=$(echo "$branch_name" | awk -F '-' '{print toupper($1"-"$2)}')
  commit_message="$ticket_id: $*"
  push_flag=$1

  if [[ "$push_flag" == "push" ]]; then
    # Remove 'push' from the commit message
    commit_message="$ticket_id: ${*:2}" # take all positional parameters starting from the second one
    git commit --no-verify -m "$commit_message" && git push
  else
    git commit --no-verify -m "$commit_message"
  fi
}

alias gqc='quick_commit'
alias gqcp='quick_commit push'

# Neovim
# If poetry is installed and an environment exists, run "poetry run nvim"
poetry_run_nvim() {
  if command -v poetry >/dev/null 2>&1 && [ -f "poetry.lock" ]; then
    poetry run nvim "$@"
  else
    nvim "$@"
  fi
}
alias vi='poetry_run_nvim'
alias v='poetry_run_nvim'

# Poetry
alias poetry_shell='. "$(dirname $(poetry run which python))/activate"'

# Go
  # These alias need to have the same exact space as written here
  # HACK: For Running Go Server using Air
alias air='$(go env GOPATH)/bin/air'
