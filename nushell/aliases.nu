# aliases.nu — aliases & short commands (translated from zsh/aliases.zsh)
#
# Nushell `alias` only supports `alias name = command [static-args...]`. Anything
# with pipes, `;`-chains, command substitution, or positional args becomes a
# `def`. Nushell lets aliases shadow builtins (cd, ls, rm) — used below.
#
# NOT ported (no nushell equivalent):
#   - suffix aliases  `alias -s {py,...}=$EDITOR`  (nushell can't run `file.py`)

# ── Make / web ───────────────────────────────────────────────────────────────
def mformat [] {
    let dirs = (^git diff main...HEAD --name-only -- "*.py"
        | ^sed -n 's#^python/security_assistant/##p'
        | ^sort -u
        | ^tr "\n" " "
        | str trim)
    ^make format-dirs dirs=$dirs
}

def web [] { ^docker compose down web; ^docker compose up -d web }

# ── Editors / viewers ────────────────────────────────────────────────────────
alias n = nvim
alias vim = nvim
alias jl = jless
alias lc = nvim leetcode.nvim

# ── Trash / files ────────────────────────────────────────────────────────────
alias rm = trash            # shadows nushell `rm` builtin
alias cat = bat             # nushell has no `cat` builtin

# eza is available as `eza`; `ls` stays the nushell builtin so table output and
# `ls | where ...` pipelines keep working.

# ── Modern replacements ──────────────────────────────────────────────────────
alias cd = z                # zoxide `z` (vendor/zoxide.nu); parse-time safe, no recursion
alias diff = difft
alias htop = btop

# ── Weather (delegates to custom.nu `weather`) ───────────────────────────────
alias pnq = weather Pune
alias blr = weather Bengaluru

# ── CLI AI editors ───────────────────────────────────────────────────────────
alias a = agent
alias co = codex
alias oc = opencode
alias cc = claude
alias cl = cline
alias ge = goose
alias cpl = copilot
alias kil = kilocode
alias qw = qwen
alias ag = auggie
alias fb = freebuff
alias hm = hunk diff main
alias bai = npx @langwatch/better-agents init
alias skill-add = npx skills add

# ── GitHub ───────────────────────────────────────────────────────────────────
alias ghopen = gh repo view --web
def ghb [] { ^gh browse --branch (^git rev-parse --abbrev-ref HEAD) }

# ghbranches — local branches with behind/ahead vs main
def ghbranches [] {
    ^git fetch --quiet
    print "BRANCH                               UPDATED              BEHIND|AHEAD"
    let refs = (^git for-each-ref --sort=-committerdate --format='%(refname:short)|%(committerdate:relative)' refs/heads/ | lines)
    for line in $refs {
        let parts = ($line | split row '|')
        let branch = $parts.0
        let date = $parts.1
        if $branch != 'main' {
            let counts = (^git rev-list --left-right --count $"main...($branch)" | str trim | split row -r '\s+')
            let behind = ($counts.0 | into int)
            let ahead = ($counts.1 | into int)
            let color = if $behind == 0 and $ahead == 0 { 'green' }
                else if $behind > 0 and $ahead == 0 { 'red' }
                else if $behind == 0 and $ahead > 0 { 'cyan' }
                else { 'yellow' }
            print $"(ansi $color)($branch)(ansi reset)   ($date)   ($behind)|($ahead)"
        }
    }
}

# ── uv ───────────────────────────────────────────────────────────────────────
alias uvt = uv tree
alias uva = uv add --active
alias uvr = uv remove --active

# ── Edit config files (shifted to nushell config; zsh files kept) ────────────
alias nhelp = help                                      # keep access to nushell `help` builtin
alias help = bat ~/.config/README.md                    # shadows nushell `help` → use `nhelp`
alias ezshrc = nvim ~/.zshrc
alias zshconfig = bat ~/.zshrc
alias ealias = nvim ~/.config/nushell/aliases.nu
alias eexport = nvim ~/.config/nushell/env.nu
alias ecustom = nvim ~/.config/nushell/custom.nu
alias econfig = nvim ~/.config/nushell/config.nu
alias ekey = nvim ~/.config/nushell/keybindings.nu
alias eghost = nvim ~/.config/ghostty/config

# ── Reload / regenerate ──────────────────────────────────────────────────────
# NOTE: nushell can't `source` config.nu from within its own parse chain
# (circular import), so there's no `source ~/.zshrc`-style reload —
# restart the shell (`exec nu`) to apply config changes.
def nu-vendor-regen [] {
    ^starship init nu | save -f ~/.config/nushell/vendor/starship.nu
    ^zoxide init nushell | save -f ~/.config/nushell/vendor/zoxide.nu
    ^wt config shell init nu | save -f ~/.config/nushell/vendor/wt.nu
    print "Regenerated nushell vendor scripts — restart the shell to pick them up."
}

# ── Folders ──────────────────────────────────────────────────────────────────
alias doc = cd ~/Documents
alias dow = cd ~/Downloads
alias dev = cd ~/Dev.hs
alias ss = cd ~/Screenshot
alias sshconf = bat ~/.ssh/config

# ── System ───────────────────────────────────────────────────────────────────
alias shutdown = sudo shutdown now
alias restart = sudo reboot
alias suspend = sudo pm-suspend
alias sleep = pmset sleepnow
alias c = clear
alias e = exit

# ── fetch ────────────────────────────────────────────────────────────────────
alias ff = fastfetch

# ── Secret generators ────────────────────────────────────────────────────────
alias genpass = openssl rand -base64 12
alias sshpass = ssh-keygen -t ed25519 -C                # Usage: sshpass "your@email.com"

# ── Disk ─────────────────────────────────────────────────────────────────────
alias duai = dua interactive

# ── Brew ─────────────────────────────────────────────────────────────────────
def brewup [] { ^brew update; ^brew upgrade; ^brew cleanup; ^brew doctor }

# ── fzf helpers ──────────────────────────────────────────────────────────────
alias fzfb = fzf --preview "bat --color=always {}"

def fzlof [...a] { ^bash ~/.config/scripts/fzf_listoldfiles.sh ...$a }
def fzo   [...a] { ^bash ~/.config/scripts/zoxide_openfiles_nvim.sh ...$a }

def fzfd [] { ^docker ps -a | ^fzf --preview 'docker inspect {1}' }

def fzman [] {
    let cmds = ($env.PATH
        | each {|d| if ($d | path exists) { glob ($d | path join "*") | where ($it | path type) == 'file' } else { [] } }
        | flatten
        | each { path basename }
        | sort
        | uniq)
    let c = ($cmds | ^fzf | str trim)
    if ($c | is-not-empty) { ^man $c }
}

def fzbat [] { $in | ^bat --color=always --paging=never | ^fzf --ansi }

def gafzf [] {
    ^git ls-files -m -o --exclude-standard
        | lines
        | where $it != '__pycache__'
        | ^fzf -m --print0
        | split row (char null)
        | where $it != ''
        | each {|f| print $"git add ($f)"; ^git add $f }
}
def grmfzf [] {
    ^git ls-files -m -o --exclude-standard
        | ^fzf -m --print0
        | split row (char null)
        | where $it != ''
        | each {|f| print $"git rm ($f)"; ^git rm $f }
}
def grfzf [] {
    ^git diff --name-only
        | ^fzf -m --print0
        | split row (char null)
        | where $it != ''
        | each {|f| print $"git restore ($f)"; ^git restore $f }
}
def grsfzf [] {
    ^git diff --name-only
        | ^fzf -m --print0
        | split row (char null)
        | where $it != ''
        | each {|f| print $"git restore --staged ($f)"; ^git restore --staged $f }
}

# ── Git ──────────────────────────────────────────────────────────────────────
alias ga = git add
alias gc = git commit
alias gcm = git commit -m
alias gcmnv = git commit --no-verify -m
alias gcanenv = git commit --amend --no-edit --no-verify
alias gd = git diff
alias gl = git log --oneline --graph --all
alias gb = git branch
alias gbd = git branch -d
alias gbD = git branch -D
alias gi = git init
alias gcl = git clone git@github.com:
alias gs = git status --short
alias gf = git fetch
alias gpu = git push origin
alias gpuf = git push --force-with-lease
alias gfo = git fetch origin
alias gfp = git fetch --prune
alias gtd = git tag --delete
alias gtdr = git tag --delete origin
alias gpl = git pull origin --rebase
alias gbr = git branch -r
alias gba = git branch -a
alias gco = git switch
alias gcob = git switch -c
alias gre = git remote
alias gres = git remote show
alias glgg = git log --graph --max-count=5 --decorate --pretty=oneline
alias gm = git merge
alias gph = git push
alias gpo = git push origin
alias gwl = git worktree list
alias gsl = git stash list
alias gsu = git stash -u

def gup [] { ^git fetch; ^git rebase }
def gcph [branch] { ^git push origin $branch }
def gcofzf [] {
    let b = (^git branch --format='%(refname:short)' | ^fzf | str trim)
    if ($b | is-not-empty) { ^git switch $b }
}

# ── Worktrunk (wt) — git worktree management ─────────────────────────────────
# `wt` itself is the wrapped command from vendor/wt.nu (with completions).
alias ws = wt switch
alias wsc = wt switch -c          # post-start hook auto-copies .env*, .python-version
alias wsx = wt switch -c -x       # Usage: wsx <cmd> <branch>, e.g. wsx claude feat-a
alias wl = wt list
alias wlf = wt list --full
alias wm = wt merge
alias wr = wt remove
alias wch = wt copy-hidden        # manually copy hidden files from primary worktree
def wscp [...a] { ^wt switch -c ...$a; print "✓ Hidden files copied (via post-start hook)" }

# ── Docker ───────────────────────────────────────────────────────────────────
alias d = docker
alias di = docker images --tree
alias ddf = docker system df
alias dps = docker ps
alias dpsa = docker ps -a
alias drm = docker container prune -f
alias drmi = docker image prune -a -f
alias dlog = docker logs -f
alias dinspect = docker inspect

def dstop [] { ^docker stop (^docker ps -q | lines) }
def drmf [] { ^docker rm (^docker ps -aq | lines) }

# Docker Compose
alias dc = docker compose
alias dcd = docker compose down
alias dcr = docker compose restart
alias dcu = docker compose up
alias dcud = docker compose up -d
alias dcub = docker compose up --build
alias dcudb = docker compose up -d --build
alias dcb = docker compose build
alias dcl = docker compose logs
alias dclf = docker compose logs -f

# ── Python venv (nushell-style; bash `activate` can't be sourced) ────────────
def --env aenv [venv: string = ".venv"] {
    let venv_path = ($venv | path expand)
    $env.VIRTUAL_ENV = $venv_path
    $env.PATH = ($env.PATH | prepend ($venv_path | path join "bin"))
    print $"🐍 Activated ($venv_path)"
}
def --env denv [] {
    if ($env.VIRTUAL_ENV? | is-not-empty) {
        let bin = ($env.VIRTUAL_ENV | path join "bin")
        $env.PATH = ($env.PATH | where $it != $bin)
        hide-env VIRTUAL_ENV
        print "🐍 Deactivated venv"
    }
}

# ── Go ───────────────────────────────────────────────────────────────────────
def air [...a] { ^($env.GOPATH | path join "bin" "air") ...$a }

# ── Lazy-toolkit ─────────────────────────────────────────────────────────────
alias lg = lazygit
alias ld = lazydocker
alias lssh = lazyssh
alias lsql = lazysql
alias lenv = lazyenv
alias lnpm = lazynpm
alias lact = lazyactions

# ── Mermaid ──────────────────────────────────────────────────────────────────
def mmdc [...a] { ^mmdc -p ($env.HOME | path join ".config" "mermaid" "puppeteer-config.json") ...$a }
