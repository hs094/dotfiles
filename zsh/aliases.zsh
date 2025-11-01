# Secret Generators
alias genpass="openssl rand -base64 12" 

# Weathers
alias pnq="weather Pune"
alias blr="weather Bengaluru"

# CLI AI Editors
alias ca="cursor-agent"
alias co="codex"
alias cc="claude code"


# Help 
alias help="bat ~/.config/README.md"
alias ff="fastfetch"

# Edit Important Files
alias ezshrc="nvim ~/.zshrc"
alias ealias="nvim ~/.config/zsh/aliases.zsh"
alias ecustom="nvim ~/.config/zsh/custom.zsh"
alias eghost="nvim '/Users/hs094/Library/Application Support/com.mitchellh.ghostty/config'"
export obsidian="/Users/hs094/Library/Mobile Documents/iCloud~md~obsidian/Documents"
export rcscriptcmd="~/.config/raycast/commands"

# Folders
alias doc="cd $HOME/Documents"
alias dow="cd $HOME/Downloads"
alias dev="cd $HOME/Dev.hs"
alias ss="cd $HOME/Screenshot/"

# Add personal aliases and configurations
alias zshreload="source ~/.zshrc"
alias sshconf='bat ~/.ssh/config'
alias zshconfig="bat ~/.zshrc"
alias ls="eza --no-filesize --icons=always --color=always --ignore-glob=.git --no-user"
alias lsa="eza -a --no-filesize --icons=always --color=always --ignore-glob=.git --no-user"
alias ll="eza -al --no-filesize  --icons=always --color=always --ignore-glob=.git --no-user"
alias lt="eza -aT --no-filesize --icons --color=always --ignore-glob=.git --no-user"

# System
alias shutdown='sudo shutdown now'
alias restart='sudo reboot'
alias suspend='sudo pm-suspend'
alias sleep='pmset sleepnow'
alias c='clear'
alias e='exit'

# Modern Replacements to Linux Distros
alias cat='bat'
alias cd='z'
alias diff='difft'
alias htop='btop'
alias y='yazi'

# fzf
alias fzfb='fzf --preview "bat --color=always {}"'
alias fzlof="~/.config/scripts/fzf_listoldfiles.sh"
alias fzfd="docker ps -a | fzf --preview 'docker inspect {1}'" # Docker
alias fzman="command -v | fzf | xargs man" # opens documentation through fzf (eg: git,zsh etc.)
alias fzbat='bat --color=always --paging=never | fzf --ansi'
alias fzo="~/.config/scripts/zoxide_openfiles_nvim.sh"
alias gafzf='git ls-files -m -o --exclude-standard | grep -v "__pycache__" | fzf -m --print0 | xargs -0 -o -t git add' # Git add with fzf
alias grmfzf='git ls-files -m -o --exclude-standard | fzf -m --print0 | xargs -0 -o -t git rm' # Git rm with fzf
alias grfzf='git diff --name-only | fzf -m --print0 | xargs -0 -o -t git restore' # Git restore with fzf
alias grsfzf='git diff --name-only | fzf -m --print0 | xargs -0 -o -t git restore --staged' # Git restore --staged with fzf

# Git
alias ghps='git@ghp:hs094'
alias ghws='git@ghp:hardik0942'

alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gcmnv='git commit --no-verify -m'
alias gcanenv='git commit --amend --no-edit --no-verify'

alias gd='git diff'
alias gl='git log --oneline --graph --all'
alias gb='git branch'
alias gbd='git branch -d'
alias gbD='git branch -D'

alias gi='git init'
alias gcl='git clone'

alias gs="git status"
alias gss="git status --short"

alias gf='git fetch'
alias gfo='git fetch origin'
alias gfp='git fetch --prune'
alias gup='git fetch && git rebase'
alias gtd='git tag --delete'
alias gtdr='git tag --delete origin'
alias gpl='git pull origin --rebase'

alias gb='git branch '
alias gbr='git branch -r'
alias gba='git branch -a'
alias gd="git diff --output-indicator-new=' ' --output-indicator-old=' '"
alias gco='git checkout'
alias gcob='git checkout -b'

alias gcofzf='git branch | fzf | xargs git checkout' # Select branch with fzf
alias gre='git remote'

alias gres='git remote show'
alias glgg='git log --graph --max-count=5 --decorate --pretty="oneline"'
alias gm='git merge'

alias gpsh='git push'
alias gpo='git push origin'
alias ggpush='git push origin $(current_branch)'

# Git Stash Alias Shortcuts
alias gsl='git stash list' 
alias gsu='git stash -u'

# Docker 
alias d='docker'
alias di='docker images'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dstop='docker stop $(docker ps -q)'
alias drmf='docker rm $(docker ps -aq)'          # Remove all Containers 
alias drm='docker container prune -f'            # Only Remove Stopped Containers
alias drmi='docker image prune -a -f'            # Remove all Images that are not associated with a container
alias dlog='docker logs -f'
alias dinspect='docker inspect'

# Docker Compose
alias dc='docker compose'
alias dcd='docker compose down'
alias dcu='docker compose up -d'
alias dcb='docker compose build'
alias dcl='docker compose logs'
alias dclf='docker compose logs -f'

# Python
alias aenv='source .venv/bin/activate'
alias denv='deactivate'

# Go
  # These alias need to have the same exact space as written here
  # HACK: For Running Go Server using Air
alias air='$(go env GOPATH)/bin/air'



################################################################################
####################              Lazy-Tookit             ######################
################################################################################
alias lgit="lazygit"
alias ldock="lazydocker"
alias lssh="lazyssh"
alias lsql="lazysql"
