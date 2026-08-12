# utils.nu — helper functions (translated from zsh/utils.zsh)

# Open md/yaml in cmux when inside a cmux session, else a local fallback.
#   md   -> cmux markdown open | $EDITOR
#   yaml -> cmux open          | bat -l yaml
def _open_cmux [
    file: path
    ...rest
] {
    if ($env.CMUX_SURFACE_ID? | is-not-empty) {
        if ($file | str ends-with ".md") {
            ^cmux markdown open $file ...$rest
        } else {
            ^cmux open $file ...$rest
        }
    } else {
        if ($file | str ends-with ".yaml") or ($file | str ends-with ".yml") {
            ^bat -l yaml $file ...$rest
        } else {
            ^$env.EDITOR $file ...$rest
        }
    }
}
