#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Brew Upgrade
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🍺
# @raycast.packageName Developer Utility - Script Command

# Documentation:
# @raycast.description Automatically upgrade all installed Homebrew packages to their latest available versions on a regular basis.
# @raycast.author Hardik Soni
# @raycast.authorURL https://raycast.com/hs094

{
  set -e
  trap 'echo "❌ An error occurred during the brew upgrade process."' ERR
  brew update && brew upgrade
  echo "Brew Packages Upgraded 🎉"
  trap - ERR
}

