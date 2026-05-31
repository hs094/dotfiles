# Helper functions backing aliases and suffix aliases.

# Open md/yaml in cmux when inside a cmux session, else a local fallback.
# md  -> cmux markdown open | $EDITOR
# yaml -> cmux open          | bat -l yaml
_open_cmux() {
  if [[ -n "$CMUX_SURFACE_ID" ]]; then
    case "$1" in
      *.md)           cmux markdown open "$@" ;;
      *)              cmux open "$@" ;;
    esac
  else
    case "$1" in
      *.yaml|*.yml)   bat -l yaml "$@" ;;
      *)              "$EDITOR" "$@" ;;
    esac
  fi
}
