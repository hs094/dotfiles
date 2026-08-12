# custom.nu — custom commands (translated from zsh/custom.zsh)
#
# NOT ported (zsh-plugin / bash-only, no nushell equivalent):
#   - fzf-git.sh (junegunn) ctrl-g* keybindings & fbr/fco/… commands
#   - fzf shell keybindings (ctrl-t / ctrl-r / alt-c) — use nushell's ctrl-r
#     history menu; fzf is still usable inline (fzfb, gcofzf, gitfco, …)
#   - forgit (zsh plugin), vi-yank-xclip, suffix aliases

# ── Clipboard helpers ────────────────────────────────────────────────────────
def clip [file: path] {
    if ($file | path exists) {
        open --raw $file | ^pbcopy
        print $"✅ Copied to clipboard: ($file)"
    } else {
        print $"❌ File not found: ($file)"
    }
}

def clipl [file: path, start: int, end: int] {
    if not ($file | path exists) {
        print $"Error: File '($file)' not found."
        return
    }
    ^sed -n $"($start),($end)p" $file
}

def clipd [file: path] {
    if not ($file | path exists) {
        print $"Error: ($file) is not a file"
        return
    }
    let out = $"### FILE METADATA\nName: ($file | path basename)\nPath: ($file | path expand)\nSize: (^stat -f%z $file | str trim) bytes\nPermissions: (^stat -f%Sp $file | str trim)\nOwner: (^stat -f%Su $file | str trim)\n\n### FILE CONTENT\n(open --raw $file)"
    $out | ^pbcopy
    print "File + metadata copied to clipboard."
}

def clipsd [dir: path] {
    if not ($dir | path exists) or (($dir | path type) != 'dir') {
        print "❌ Usage: clipsd <directory-path>  (not a valid directory)"
        return
    }
    if (which tree | is-empty) {
        print "🌳 Installing 'tree' utility..."
        ^brew install tree
    }
    print $"📋 Copying LLM-safe directory structure for '($dir)'..."
    ^tree -a -I '.*|node_modules|__pycache__|.venv|.env|dist|build|target|bin|pkg|.pytest_cache|.mypy_cache|.ruff_cache|*.log|*.lock|.DS_Store' $dir | ^pbcopy
    print "✅ Directory structure copied to clipboard!"
}

def clipfd [dir: path] {
    if not ($dir | path exists) or (($dir | path type) != 'dir') {
        print $"Error: ($dir) is not a directory"
        return
    }
    let contents = (^find $dir -maxdepth 1 -mindepth 1 -exec stat -f "%HT %N (size=%z bytes perms=%Sp owner=%Su group=%Sg mod=%Sm)" {} ';' | str trim)
    let previews = (glob ($dir | path join "*") | where ($it | path type) == 'file' | each {|f|
        $"--- ($f | path basename) ---\n(^head -n 20 $f)\n"
    } | str join "\n")
    let out = $"### DIRECTORY METADATA\nName: ($dir | path basename)\nPath: ($dir | path expand)\nPermissions: (^stat -f%Sp $dir | str trim)\nOwner: (^stat -f%Su $dir | str trim)\n\n### DIRECTORY CONTENTS [depth=1]\n($contents)\n\n### FILE PREVIEWS [first 20 lines per file]\n($previews)"
    $out | ^pbcopy
    print "Directory structure + metadata copied to clipboard."
}

# ── Misc ─────────────────────────────────────────────────────────────────────
def weather [city?: string] {
    if $city == null { ^curl wttr.in } else { ^curl $"wttr.in/($city)" }
}

def killp [port: int, sig: string = "TERM"] {
    let s = ($sig | str replace -r '^-' '')
    let pids = (^lsof -ti $"tcp:($port)" | lines | where $it != '')
    if ($pids | is-empty) {
        print $"No process listening on port ($port)"
        return
    }
    print $"Killing PID(s) on port ($port): ($pids | str join ' ') (SIG($s))"
    $pids | each {|p| ^kill $"-($s)" $p }
}

def bashly [...a] {
    let uid = (^id -u | str trim)
    let gid = (^id -g | str trim)
    ^docker run --rm -it --user $"($uid):($gid)" --volume $"($env.PWD):/app" dannyben/bashly ...$a
}

def drmpat [pattern: string] {
    ^docker volume ls -q | ^grep -E $pattern | lines | each {|v| ^docker volume rm $v }
}

# ── Docker service wrappers ──────────────────────────────────────────────────
# Generic lifecycle: start | stop | status | rm
# Usage: _docker_svc <action> <name> <url> <image> [docker-run-args...] [-- cmd...]
def --wrapped _docker_svc [
    action: string
    name: string
    url: string
    image: string
    ...rest
] {
    # Split rest into docker-run opts and CMD (everything after a bare --)
    let seps = ($rest | enumerate | where $it.item == '--' | get index)
    let sep_idx = if ($seps | is-empty) { null } else { $seps | first }
    let opts = if $sep_idx == null { $rest } else { $rest | take $sep_idx }
    let cmd = if $sep_idx == null { [] } else { $rest | skip ($sep_idx + 1) }

    let state = (try { ^docker inspect -f '{{.State.Status}}' $name err> /dev/null | str trim } catch { '' })

    match $action {
        "start" => {
            match $state {
                "running" => { print $"($name) is already running at ($url)" }
                "exited" | "created" | "paused" => {
                    ^docker start $name
                    print $"($name) running at ($url)"
                }
                "" => {
                    let run_args = if ($cmd | is-empty) { $opts ++ [$image] } else { $opts ++ [$image] ++ $cmd }
                    ^docker run -d --name $name ...$run_args
                    print $"($name) running at ($url)"
                }
                _ => { print $"($name) in unexpected state: ($state)" }
            }
        }
        "stop" => {
            if $state == "running" {
                ^docker stop $name
                print $"($name) stopped"
            } else if $state == '' {
                print $"($name) container does not exist"
            } else {
                print $"($name) is not running (state: ($state))"
            }
        }
        "status" => {
            match $state {
                "" => { print $"($name): not created" }
                _ => { print $"($name): ($state)" }
            }
        }
        "rm" => {
            if $state == "running" { ^docker stop $name }
            if $state != '' {
                ^docker rm $name
                print $"($name) container removed"
            } else {
                print $"($name) container does not exist"
            }
        }
        _ => { print $"Usage: ($name) [start|stop|status|rm]" }
    }
}

def dozzle [action: string = "start"] {
    let opts = [
        "-v" "/var/run/docker.sock:/var/run/docker.sock"
        "-v" "dozzle_data:/data"
        "-p" "8080:8080"
    ]
    _docker_svc $action "dozzle" "http://localhost:8080" "amir20/dozzle:latest" ...$opts
}

def floci [action: string = "start"] {
    let opts = [
        "-p" "4566:4566"
        "-v" "/var/run/docker.sock:/var/run/docker.sock"
        "-u" "root"
    ]
    _docker_svc $action "floci" "http://localhost:4566" "floci/floci:latest" ...$opts
}

def n8n [action: string = "start"] {
    let tz = ($env.GENERIC_TIMEZONE? | default "Asia/Mumbai")
    let opts = [
        "--restart" "always"
        "-p" "5678:5678"
        "-e" "N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true"
        "-e" "N8N_HOST=localhost"
        "-e" "N8N_PORT=5678"
        "-e" "N8N_PROTOCOL=http"
        "-e" "N8N_RUNNERS_ENABLED=true"
        "-e" "N8N_SECURE_COOKIE=false"
        "-e" "NODE_ENV=production"
        "-e" $"GENERIC_TIMEZONE=($tz)"
        "-e" $"TZ=($tz)"
        "-v" "n8n_data:/home/node/.n8n"
        "-v" "n8n_files:/files"
    ]
    _docker_svc $action "n8n" "http://localhost:5678" "docker.n8n.io/n8nio/n8n" ...$opts
}

def metabase [action: string = "start"] {
    let opts = [
        "--restart" "unless-stopped"
        "-p" "3000:3000"
        "-v" "metabase_data:/metabase-data"
    ]
    _docker_svc $action "metabase" "http://localhost:3000" "metabase/metabase" ...$opts
}

def jackett [action: string = "start"] {
    let opts = [
        "--restart" "unless-stopped"
        "-p" "9117:9117"
        "-e" "PUID=1000"
        "-e" "PGID=1000"
        "-e" $"TZ=($env.GENERIC_TIMEZONE? | default 'Etc/UTC')"
        "-e" "AUTO_UPDATE=true"
        "-v" "jackett_config:/config"
        "-v" "jackett_downloads:/downloads"
    ]
    _docker_svc $action "jackett" "http://localhost:9117" "lscr.io/linuxserver/jackett:latest" ...$opts
}

def lobechat [action: string = "start"] {
    let envfile = ($env.HOME | path join ".config" "images" "lobechat" ".env")
    let opts = if ($envfile | path exists) {
        ["--restart" "always" "-p" "3210:3210" "-e" "ACCESS_CODE=lobe66" "--env-file" $envfile]
    } else {
        ["--restart" "always" "-p" "3210:3210" "-e" "ACCESS_CODE=lobe66"]
    }
    _docker_svc $action "lobechat" "http://localhost:3210" "lobehub/lobe-chat" ...$opts
}

# Set INFISICAL_DB_URI, INFISICAL_REDIS_URL, INFISICAL_SITE_URL before `infisical start`
def infisical [action: string = "start"] {
    let version = ($env.INFISICAL_VERSION? | default "latest")
    if ($env.INFISICAL_DB_URI? | is-empty)    { print "set INFISICAL_DB_URI";    return }
    if ($env.INFISICAL_REDIS_URL? | is-empty) { print "set INFISICAL_REDIS_URL"; return }
    if ($env.INFISICAL_SITE_URL? | is-empty)  { print "set INFISICAL_SITE_URL";  return }
    let opts = [
        "--restart" "unless-stopped"
        "-p" "80:8080"
        "-e" $"ENCRYPTION_KEY=($env.INFISICAL_ENCRYPTION_KEY? | default 'f40c9178624764ad85a6830b37ce239a')"
        "-e" $"AUTH_SECRET=($env.INFISICAL_AUTH_SECRET? | default 'q6LRi7c717a3DQ8JUxlWYkZpMhG4+RHLoFUVt3Bvo2U=')"
        "-e" $"DB_CONNECTION_URI=($env.INFISICAL_DB_URI)"
        "-e" $"REDIS_URL=($env.INFISICAL_REDIS_URL)"
        "-e" $"SITE_URL=($env.INFISICAL_SITE_URL)"
    ]
    _docker_svc $action "infisical" "http://localhost:80" $"infisical/infisical:($version)" ...$opts
}

def teleup [...args] {
    let action = if ($args | is-empty) { "start" } else { $args | first }
    let name = "teleup"
    let image = "nekmo/telegram-upload:master"
    let config_dir = ($env.HOME | path join ".config" "telegram-upload")
    let files_dir = ($env.HOME | path join "Movies")
    if $action == "start" {
        if not ($config_dir | path exists) { mkdir $config_dir }
        if not ($files_dir | path exists)  { mkdir $files_dir }
        let opts = [
            "--restart" "unless-stopped"
            "-v" $"($config_dir):/config"
            "-v" $"($files_dir):/files"
            "-e" $"TZ=($env.GENERIC_TIMEZONE? | default 'Etc/UTC')"
            "--entrypoint" "sleep"
            "--"
            "infinity"
        ]
        _docker_svc "start" $name "—" $image ...$opts
    } else {
        _docker_svc $action $name "—" $image
    }
}

# ── Registries (for the mh / dsvc / lsvc / wth / codh help menus) ────────────
const DSVC_REGISTRY = [
    {service: "dozzle",    url: "http://localhost:8080", description: "Live docker container log viewer"}
    {service: "floci",     url: "http://localhost:4566", description: "Floci docker UI"}
    {service: "n8n",       url: "http://localhost:5678", description: "Workflow automation / low-code"}
    {service: "metabase",  url: "http://localhost:3000", description: "Open-source BI dashboards"}
    {service: "lobechat",  url: "http://localhost:3210", description: "Multi-LLM chat UI"}
    {service: "infisical", url: "http://localhost:80",   description: "Self-hosted secrets manager"}
    {service: "jackett",   url: "http://localhost:9117", description: "Torrent indexer / proxy"}
    {service: "bashly",    url: "—", description: "CLI generator via dannyben/bashly (ephemeral)"}
    {service: "teleup",    url: "—", description: "Telegram upload (files: ~/Movies)"}
]

const LSVC_REGISTRY = [
    {alias: "lg",   command: "lazygit",     description: "Terminal UI for git"}
    {alias: "ld",   command: "lazydocker",  description: "Terminal UI for Docker"}
    {alias: "lssh", command: "lazyssh",     description: "TUI for SSH connection management"}
    {alias: "lsql", command: "lazysql",     description: "TUI for SQL databases"}
    {alias: "lenv", command: "lazyenv",     description: "TUI for .env files"}
    {alias: "lnpm", command: "lazynpm",     description: "TUI for npm"}
    {alias: "lact", command: "lazyactions", description: "TUI for GitHub Actions workflows"}
]

const WT_ALIASES = [
    {alias: "ws",  expands_to: "wt switch <branch>",         description: "Switch to a worktree branch"}
    {alias: "wsc", expands_to: "wt switch -c <branch>",      description: "Create + switch to a new worktree"}
    {alias: "wsx", expands_to: "wt switch -c -x <cmd> <br>", description: "Create worktree + run command (e.g. wsx claude feat-a)"}
    {alias: "wl",  expands_to: "wt list",                    description: "List worktrees"}
    {alias: "wlf", expands_to: "wt list --full",             description: "List worktrees with CI status + summaries"}
    {alias: "wm",  expands_to: "wt merge [branch]",          description: "Merge worktree branch + clean up"}
    {alias: "wr",  expands_to: "wt remove [branch]",         description: "Remove a worktree"}
]

const COD_ALIASES = [
    {alias: "co",   binary: "codex",    description: "Codex CLI"}
    {alias: "oc",   binary: "opencode", description: "OpenCode"}
    {alias: "cc",   binary: "claude",   description: "Claude Code"}
    {alias: "cl",   binary: "cline",    description: "Cline"}
    {alias: "cpl",  binary: "copilot",  description: "GitHub Copilot"}
    {alias: "kil",  binary: "kilocode", description: "Kilo Code"}
    {alias: "qw",   binary: "qwen",     description: "Qwen"}
    {alias: "ag",   binary: "auggie",   description: "Auggie"}
    {alias: "misv", binary: "vibe",     description: "Vibe coding"}
    {alias: "fb",   binary: "freebuff", description: "FreeBuff"}
]

const MH_REGISTRY = [
    {submenu: "docker", command: "dsvc", description: "Docker service wrappers (start/stop/status/rm); also teleup"}
    {submenu: "lazy",   command: "lsvc", description: "Lazy-toolkit TUIs (lazygit, lazydocker, lazysql, ...)"}
    {submenu: "wt",     command: "wth",  description: "Worktrunk aliases (wt switch, list, merge, remove)"}
    {submenu: "agent",  command: "codh", description: "Coding agent aliases (claude, opencode, codex, ...)"}
]

def dsvc [] {
    print ""
    let rows = ($DSVC_REGISTRY | each {|s|
        let state = (try { ^docker inspect -f '{{.State.Status}}' $s.service err> /dev/null | str trim } catch { '' })
        let state = if ($state | is-empty) { '—' } else { $state }
        {service: $s.service, url: $s.url, state: $state, description: $s.description}
    })
    $rows | table | print
    print ""
    print "  Use <service> [start|stop|status|rm] to control."
    print ""
}

def lsvc [] {
    print ""
    let rows = ($LSVC_REGISTRY | each {|s|
        let installed = (which $s.command | is-not-empty)
        {alias: $s.alias, command: $s.command, state: (if $installed {'installed'} else {'missing'}), description: $s.description}
    })
    $rows | table | print
    print ""
    print "  Run <alias> to launch the TUI."
    print ""
}

def wth [] {
    print ""
    $WT_ALIASES | table | print
    print ""
    print "  Core wt workflow: wsc <branch> → work → wm"
    print "  For Claude Code in a worktree: wsx claude <branch>"
    print ""
}

def codh [] {
    print ""
    $COD_ALIASES | table | print
    print ""
}

def "nu-complete-mh-submenu" [] { $MH_REGISTRY | get submenu }

def mh [submenu?: string@nu-complete-mh-submenu] {
    if $submenu != null {
        let matches = ($MH_REGISTRY | where submenu == $submenu)
        if ($matches | is-empty) {
            print $"mh: unknown submenu '($submenu)'"
            print $"Available: (($MH_REGISTRY | get submenu | str join ' '))"
            return
        }
        let cmd = ($matches | first).command
        match $cmd {
            "dsvc" => { dsvc }
            "lsvc" => { lsvc }
            "wth"  => { wth }
            "codh" => { codh }
        }
        return
    }
    print ""
    $MH_REGISTRY | table | print
    print ""
    print "  Run mh <submenu> or the command directly."
    print ""
}

# ── Git extras ───────────────────────────────────────────────────────────────
# gcls — sparse clone a single path. (zsh version had a cd bug; this cds correctly.)
def gcls [repo: string, path: string] {
    ^git clone --filter=blob:none --sparse $"git@github.com:($repo)"
    let dir = ($repo | split row '/' | last | str replace -r '\.git$' '')
    cd $dir
    ^git sparse-checkout set $path
}

def gitfco [path: string] {
    let selected = (^git log --all --reverse
        --pretty=format:'%C(yellow)%h%Creset %C(white)%<(50,trunc)%s%Creset %C(cyan)%an%Creset %C(green)%ad%Creset'
        --date=relative
        -- $path
        | ^fzf --ansi --no-sort --reverse --height=80%
            --preview 'git show --color=always {1}'
            --preview-window=right:60%)
    if ($selected | is-not-empty) {
        let commit = ($selected | split row ' ' | first)
        print $"🔁 Checking out commit ($commit)"
        ^git checkout $commit
    } else {
        print "❌ No commit selected"
    }
}

# h — search command history with fzf. (nushell can't `eval` a string, so the
# selected command is printed; use Ctrl+R for the built-in history menu.)
def h [] {
    let cmd = (history | get command | reverse | ^fzf --tac | str trim)
    if ($cmd | is-not-empty) { print $cmd }
}

# y — yazi wrapper that cds into the dir yazi last visited.
def --env y [...args] {
    let tmp = (^mktemp -t yazi-cwd | str trim)
    ^yazi ...$args --cwd-file $tmp
    if ($tmp | path exists) {
        let cwd = (open --raw $tmp | str trim)
        ^rm -f $tmp
        if ($cwd | is-not-empty) and ($cwd != $env.PWD) {
            cd $cwd
        }
    }
}
