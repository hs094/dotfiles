# config.nu — main nushell config (translated from zsh/.zshrc)
#
# Mirrors the zsh structure: sources tool integrations (vendor/) then the
# modular files that correspond to zsh/*.zsh. Nothing here deletes zsh — the
# zsh config under ~/.config/zsh/ is left intact.

# ── Tool integrations (generated into vendor/) ──────────────────────────────
# Regenerate any of these after a tool upgrade:
#   starship init nu         | save -f ~/.config/nushell/vendor/starship.nu
#   zoxide  init nushell     | save -f ~/.config/nushell/vendor/zoxide.nu
#   wt      config shell init nu | save -f ~/.config/nushell/vendor/wt.nu
source ~/.config/nushell/vendor/starship.nu
source ~/.config/nushell/vendor/zoxide.nu
source ~/.config/nushell/vendor/wt.nu

# ── Nushell settings ────────────────────────────────────────────────────────
# Vi mode (replaces zsh `bindkey -v`, KEYTIMEOUT=10)
$env.config.edit_mode = "vi"
# Cursor shape per vi mode (replaces the zsh zle-keymap-select escape codes)
$env.config.cursor_shape = {
    vi_insert: "line"   # beam
    vi_normal: "block"
    emacs:     "line"
}

# History (replaces HISTSIZE=5000, sharehistory, ignore dups/space)
$env.config.history.max_size = 5000
$env.config.history.sync_on_enter = true
$env.config.history.file_format = "sqlite"
$env.config.history.isolation = false

# Completions (replaces compinit + zstyle matcher-list 'm:{a-z}={A-Za-z}')
$env.config.completions.case_sensitive = false
$env.config.completions.quick = true
$env.config.completions.partial = true
$env.config.completions.algorithm = "prefix"
$env.config.completions.sort = "smart"
$env.config.completions.external.enable = true
$env.config.completions.external.max_results = 100

# Nushell ships built-in syntax highlighting & autosuggestions, replacing the
# zsh-autosuggestions / zsh-syntax-highlighting plugins.

# ── Modular config (mirrors zsh/*.zsh, sourced in dependency order) ──────────
# utils & custom first (they define functions that aliases reference),
# then hooks, then aliases (alias cd = z needs zoxide above), then cleanup.
source ~/.config/nushell/utils.nu
source ~/.config/nushell/custom.nu
source ~/.config/nushell/hooks.nu
source ~/.config/nushell/aliases.nu
source ~/.config/nushell/cleanup.nu

# ── Keybindings (from zsh/bindkeys.zsh) ─────────────────────────────────────
source ~/.config/nushell/keybindings.nu
$env.config.keybindings = ($env.config.keybindings ++ (nu-keybindings))
