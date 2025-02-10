#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Clear Cache
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🗑️
# @raycast.packageName System Tools
# @raycast.needsConfirmation false

# Documentation:
# @raycast.description Clear Library Cache
# @raycast.author Hardik Soni
# @raycast.authorURL https://raycast.com/hardik_soni

# Clearing the cache
if rm -rf ~/Library/Caches/*; then
  echo "Cache cleared successfully! 🎉"
else
  echo "Failed to clear cache. Please check permissions."
fi