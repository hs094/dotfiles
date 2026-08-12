# hooks.nu — directory-change hooks (translated from zsh/hooks.zsh)
#
# Active in zsh:  _chpwd_nvm_use, _chpwd_herdr_tab_title
# Disabled in zsh (add-zsh-hook commented out): _chpwd_python_venv, _chpwd_node_install
#   — defined here too; to enable, add them to the PWD hook list at the bottom.

# nvm: switch to the node version pinned in .nvmrc.
# NOTE: nvm.sh is bash/zsh-only and cannot run inside nushell. This uses `fnm`
# (the nushell-friendly replacement) if installed; otherwise it's a no-op.
def _chpwd_nvm_use [] {
    if not ('.nvmrc' | path exists) { return }
    if (which fnm | is-not-empty) {
        try { ^fnm use --install-if-missing } catch { null }
    }
}

# herdr: set the terminal tab title to `folder` or `folder:branch`.
def _chpwd_herdr_tab_title [] {
    if (which herdr | is-empty) { return }
    let folder = ($env.PWD | path basename)
    let branch = (try { ^git rev-parse --abbrev-ref HEAD | str trim } catch { '' })
    let title = if ($branch | is-not-empty) { $"($folder):($branch)" } else { $folder }
    if $title == ($env._HERDR_LAST_TAB_TITLE? | default '') { return }
    $env._HERDR_LAST_TAB_TITLE = $title
    let tab_id = (try { ^herdr api snapshot | from json | get focused_tab_id } catch { null })
    if ($tab_id | is-not-empty) {
        try { ^herdr tab rename $tab_id $title } catch { null }
    }
}

# ── Disabled helpers (mirror the commented-out zsh hooks) ────────────────────
# Auto-activate .venv / venv on cd (nushell-style: prepend bin, set VIRTUAL_ENV).
def --env _chpwd_python_venv [] {
    if ($env.VIRTUAL_ENV? | is-not-empty) { return }
    for venv in ['.venv' 'venv'] {
        if ($venv | path exists) and ($venv | path join 'bin' | path exists) {
            $env.VIRTUAL_ENV = ($venv | path expand)
            $env.PATH = ($env.PATH | prepend ($venv | path join 'bin'))
            return
        }
    }
}
# Auto npm-install when package.json exists without node_modules.
def _chpwd_node_install [] {
    if ('package.json' | path exists) and not ('node_modules' | path exists) {
        ^npm install
    }
}

# ── Register the active PWD hooks ────────────────────────────────────────────
# (zoxide already adds its own via vendor/zoxide.nu — we just append ours.)
$env.config = ($env.config
    | upsert hooks { default {} }
    | upsert hooks.env_change { default {} }
    | upsert hooks.env_change.PWD { default [] })
$env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD | append [
    { code: {|_, dir| _chpwd_nvm_use } }
    { code: {|_, dir| _chpwd_herdr_tab_title } }
])
