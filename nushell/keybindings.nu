# keybindings.nu — line-editor keybindings (translated from zsh/bindkeys.zsh)
# Returned as a list via `nu-keybindings` so config.nu can append it to
# $env.config.keybindings.
#
# Nushell's `until` event is multi-action-per-key, not prefix-then-key chords,
# so the zsh `^X*` bindings (^X^e, ^Xl, ^Xc, ^Xgc, ^Xgd, …) are NOT portable.
# Use instead: Ctrl+O (edit command line in $EDITOR) and Ctrl+L (clear screen,
# keep buffer) — both nushell defaults — plus the gd/gl/… git aliases.
#
# Not ported (no nushell equivalent):
#   - magic-space (^space history expansion — nushell has no `!`-expansion)
#   - ^Xc copy-command-to-clipboard (reading the line buffer from a keybinding
#     closure isn't supported by reedline)
#   - ^?  backward-delete-char (nushell handles backspace natively)

def nu-keybindings [] {
    [
        # ^B — beginning of line
        { name: ctrl_b_beginning_of_line
          modifier: control
          keycode: char_b
          mode: [vi_insert vi_normal]
          event: { edit: MoveToLineStart } }

        # ^E — end of line
        { name: ctrl_e_end_of_line
          modifier: control
          keycode: char_e
          mode: [vi_insert vi_normal]
          event: { edit: MoveToLineEnd } }

        # ^[^?  (Alt+Backspace) — backward delete word
        { name: alt_backspace_backward_delete_word
          modifier: alt
          keycode: backspace
          mode: [vi_insert vi_normal]
          event: { edit: BackspaceWord } }

        # ^p — previous history
        { name: ctrl_p_history_prev
          modifier: control
          keycode: char_p
          mode: [vi_insert vi_normal]
          event: { send: PreviousHistory } }

        # ^n — next history
        { name: ctrl_n_history_next
          modifier: control
          keycode: char_n
          mode: [vi_insert vi_normal]
          event: { send: NextHistory } }

        # ^U — undo  (zsh mapped ^U to undo)
        { name: ctrl_u_undo
          modifier: control
          keycode: char_u
          mode: [vi_insert vi_normal]
          event: { edit: Undo } }
        # NOTE: zsh's ^X* chords aren't portable to nushell (no multi-key
        # chords). Ctrl+O edits the line in $EDITOR; Ctrl+L clears the screen.
    ]
}
