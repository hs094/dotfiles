# Cron Configuration

Cron jobs for macOS, managed through a version-controlled configuration file.

## Directory Structure

```text
~/.config/
├── cron/
│   ├── README.md
│   └── crontab
├── scripts/
│   ├── cron-log.sh
│   └── auto-close-prs/
│       └── auto_close_prs.sh
└── logs/
    ├── auto_pr.log
    └── update_pi.log
```

## Quick Reference

| Action | Command |
|---|---|
| Install/update jobs | `crontab ~/.config/cron/crontab` |
| List active jobs | `crontab -l` |
| Edit config | `nvim ~/.config/cron/crontab` |
| Edit active crontab | `crontab -e` |
| Remove all user jobs | `crontab -r` |
| View root jobs | `sudo crontab -l` |
| Monitor logs | `tail -f ~/.config/logs/*.log` |
| Check cron process | `pgrep -fl cron` |

## Installation

### First-time setup

```bash
mkdir -p ~/.config/cron ~/.config/logs
chmod +x ~/.config/scripts/cron-log.sh
crontab ~/.config/cron/crontab
```

### Applying changes

After editing `~/.config/cron/crontab`, run:

```bash
crontab ~/.config/cron/crontab
```

**Important:** Cron does not automatically read files from `~/.config/cron/`. Changes must be installed explicitly.

### Optional shell alias

Add to `~/.zshrc`:

```bash
alias cron-sync='crontab "$HOME/.config/cron/crontab"'
```

Then run `cron-sync` after editing.

## Crontab Format

```text
┌──────── minute (0–59)
│ ┌────── hour (0–23)
│ │ ┌──── day of month (1–31)
│ │ │ ┌── month (1–12)
│ │ │ │ ┌ day of week (0–7, Sunday = 0 or 7)
│ │ │ │ │
* * * * * command
```

Examples:

| Expression | Schedule |
|---|---|
| `* * * * *` | Every minute |
| `*/15 * * * *` | Every 15 minutes |
| `0 * * * *` | Every hour |
| `0 0 * * *` | Daily at midnight |
| `0 9 * * 1-5` | Weekdays at 9 AM |
| `0 0 * * 0` | Every Sunday at midnight |

## Environment Variables

Use uppercase variable names:

```cron
SHELL=/bin/zsh
HOME=/Users/hardik.soni
PATH=/Users/hardik.soni/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin
```

**Important considerations:**

- Cron runs with a minimal environment.
- Environment assignments in crontabs do not perform shell-style variable expansion.
- `$HOME` can be used inside job commands.
- Cron does not normally load `.zshrc`.
- Prefer absolute paths for executables when necessary.
- Use the regular user's crontab instead of root's unless elevated privileges are required.

## Logging

The reusable logging wrapper is located at:

```text
~/.config/scripts/cron-log.sh
```

Example implementation:

```bash
#!/bin/zsh
set -o pipefail

"$@" 2>&1 | while IFS= read -r line; do
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$line"
done
```

Usage:

```cron
* * * * * "$HOME/.config/scripts/cron-log.sh" pi update --all >> "$HOME/.config/logs/update_pi.log" 2>&1
```

This timestamps each output line. Commands that produce no output will not generate timestamped lines.

## Debugging

### Inspect actual cron environment

Temporarily add:

```cron
* * * * * { id -un; pwd; env | sort; } > /tmp/cron-debug.log 2>&1
```

Inspect:

```bash
cat /tmp/cron-debug.log
```

Remove the temporary job after debugging.

### Check system cron activity (macOS)

```bash
log show --last 1h --style compact --predicate 'process == "cron"'
```

Live monitoring:

```bash
log stream --style compact --predicate 'process == "cron"'
```

### Common issues

| Problem | Possible cause |
|---|---|
| Job does not run | Wrong user's crontab or invalid schedule |
| Command not found | Missing executable in `PATH` |
| Wrong home directory | Running under root or incorrect `HOME` |
| Pi extensions not updating | Different package configuration or working directory |
| Logs missing | Directory missing, permissions, or log cleanup |
| Job works manually but not in cron | Different environment or working directory |

## Backup and Restore

Backup active configuration:

```bash
crontab -l > ~/.config/cron/crontab
```

Restore:

```bash
crontab ~/.config/cron/crontab
```

**Warning:** Installing a crontab replaces the entire active crontab for that user.

## Dotfiles / Git

Track these files:

```text
cron/README.md
cron/crontab
scripts/cron-log.sh
```

Avoid committing log files, credentials, or secrets.

When cloning configuration onto a different machine, update the `HOME` and `PATH` assignments before installing the crontab.

## Notes

- Cron entries use the system's configured timezone unless a supported timezone override is configured.
- A `%` inside a crontab command must be escaped as `\%`; this is not required inside external shell scripts.
- Cron may start a new job before the previous invocation finishes. Consider `flock` or another locking mechanism for long-running jobs.
- Log cleanup deletes existing history; use log rotation when retention matters.
- On macOS, `launchd` is a native alternative to cron for more advanced scheduling and service management.

