alias n="nvim"

alias ghbranches='git fetch --quiet 2>/dev/null; printf "\033[1;37m%-35s %-15s %10s\033[0m\n" "BRANCH" "UPDATED" "BEHIND|AHEAD"; printf "\033[2m%s\033[0m\n" "$(printf "%.80s" "────────────────────────────────────────────────────────────────────────────────")"; git for-each-ref --sort=-committerdate --format="%(refname:short)|%(committerdate:relative)" refs/heads/ | while IFS="|" read branch date; do
  if [ "$branch" != "main" ]; then
    counts=$(git rev-list --left-right --count main...${branch} 2>/dev/null)
    if [ -n "$counts" ]; then
      behind=$(echo $counts | awk '\''{print $1}'\'')
      ahead=$(echo $counts | awk '\''{print $2}'\'')
      if [ $behind -eq 0 ] && [ $ahead -eq 0 ]; then
        color="\033[0;32m"
      elif [ $behind -gt 0 ] && [ $ahead -eq 0 ]; then
        color="\033[0;31m"
      elif [ $behind -eq 0 ] && [ $ahead -gt 0 ]; then
        color="\033[0;36m"
      else
        color="\033[0;33m"
      fi
      printf "${color}%-35s\033[0m \033[2m%-15s\033[0m %2d\033[2m|\033[0m%2d\n" "$branch" "$date" "$behind" "$ahead"
    fi
  fi
done'

alias rm='trash'
alias ghopen='gh repo view --web'
alias bai='npx @langwatch/better-agents init'
alias skill-add='npx skills add'
alias rm="trash"
alias jl='jless'

# Suffix aliases — run `file.ext` directly to open it
alias -s json='jless'
alias -s {py,java,cpp,c,go,js,ts}="$EDITOR"
alias -s {mov,mp4,png}='open'
# md/yaml: cmux preview when inside cmux, else $EDITOR / bat (see utils.zsh)
alias -s {md,yaml,yml}='_open_cmux'

# Brew Upgrade and Update
alias brewup="brew update && brew upgrade && brew cleanup && brew doctor"

# Secret Generators
alias genpass="openssl rand -base64 12" 

# Generating a Public SSH Key
alias sshpass="ssh-keygen -t ed25519 -C" # Usage type sshpass <"YOUR_EMAIL@DOMAIN.COM">

# Disk Utility Manger
alias duai="dua interactive"

# Vim -> Neovim
alias vim="nvim"

# Weathers
alias pnq="weather Pune"
alias blr="weather Bengaluru"

# CLI AI Editors
alias a="agent"
alias co="codex"
alias oc="opencode"
alias cc="claude"
alias cl="cline"
alias ge="goose"
alias cpl="copilot"
alias kil="kilocode"
alias qw="qwen"
alias ag="auggie"
alias fb="freebuff"
# alias cf=

# Hunk Aliases
alias hm="hunk diff main"

alias lc="nvim leetcode.nvim"

# Help 
alias help="bat ~/.config/README.md"
alias ff="fastfetch"

# uv Aliases
alias uvt="uv tree"
alias uva="uv add --active"
alias uvr="uv remove --active"


# Edit Important Files
alias ezshrc="nvim ~/.zshrc"
alias ealias="nvim ~/.config/zsh/aliases.zsh"
alias eexport="nvim ~/.config/zsh/export.zsh"
alias ecustom="nvim ~/.config/zsh/custom.zsh"
alias eghost="nvim ~/.config/ghostty/config"


# Folders
alias doc="cd $HOME/Documents"
alias dow="cd $HOME/Downloads"
alias dev="cd $HOME/Dev.hs"
alias ss="cd $HOME/Screenshot/"

# Add personal aliases and configurations
alias zshreload="source ~/.zshrc"
alias zshr="source ~/.zshrc"
alias sshconf='bat ~/.ssh/config'
alias zshconfig="bat ~/.zshrc"
# eza bug: v0.23.0+ silently produces no output when called without a path
# See https://github.com/eza-community/eza/issues/1568
ls() {
  if [ $# -eq 0 ]; then
    eza --no-filesize --icons=always --color=always --ignore-glob=.git --no-user .
  else
    eza --no-filesize --icons=always --color=always --ignore-glob=.git --no-user "$@"
  fi
}
ll() {
  if [ $# -eq 0 ]; then
    eza -al --no-filesize --icons=always --color=always --ignore-glob=.git --no-user .
  else
    eza -al --no-filesize --icons=always --color=always --ignore-glob=.git --no-user "$@"
  fi
}

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
alias gcl='git clone git@github.com:' # Usage: gcl <username/repo.git>

alias gs="git status --short"
alias gf='git fetch'
alias gpu='git push origin'
alias gpuf='git push --force-with-lease'
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
alias gco='git switch'
alias gcob='git switch -c'

alias gcofzf='git branch | fzf | xargs git checkout' # Select branch with fzf
alias gre='git remote'

alias gres='git remote show'
alias glgg='git log --graph --max-count=5 --decorate --pretty="oneline"'
alias gm='git merge'

alias gph='git push'
alias gpo='git push origin'
alias gcph='git push origin $1'

# Git Worktree
alias gwl='git worktree list'

# Worktrunk (wt) — git worktree management (brew install worktrunk)
alias ws='wt switch'
alias wsc='wt switch -c'           # post-start hook auto-copies hidden files (.env, .envrc, etc.)
alias wsx='wt switch -c -x'        # Usage: wsx <cmd> <branch>, e.g. wsx claude feat-a
alias wl='wt list'
alias wlf='wt list --full'
alias wm='wt merge'
alias wr='wt remove'
alias wch='wt copy-hidden'         # Manually copy hidden files from primary worktree
wscp() { wt switch -c "$@" && echo "✓ Hidden files copied (via post-start hook)"; }

# Git Stash Alias Shortcuts
alias gsl='git stash list'
alias gsu='git stash -u'

# Docker 
alias d='docker'
alias di='docker images --tree'
alias ddf='docker system df'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dstop='docker stop $(docker ps -q)'        # Stop all Containers 
alias drmf='docker rm $(docker ps -aq)'          # Remove all Containers 
alias drm='docker container prune -f'            # Only Remove Stopped Containers
alias drmi='docker image prune -a -f'            # Remove all Images that are not associated with a container
alias dlog='docker logs -f'
alias dinspect='docker inspect'

# Docker Compose
alias dc='docker compose'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias dcu='docker compose up'
alias dcud='docker compose up -d'
alias dcub='docker compose up --build'
alias dcudb='docker compose up -d --build'
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
alias lg="lazygit"
alias ld="lazydocker"
alias lssh="lazyssh"
alias lsql="lazysql"
alias lenv="lazyenv"
alias lnpm="lazynpm"
alias lact="lazyactions"

alias mmdc="mmdc -p $HOME/.config/mermaid/puppeteer-config.json"
