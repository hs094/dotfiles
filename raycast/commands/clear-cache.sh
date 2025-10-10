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
# @raycast.authorURL https://raycast.com/hs094

CACHE_DIR=~/Library/Caches
TOTAL_DELETED=0
ERROR_OCCURRED=0

# Convert bytes to human-readable KB/MB/GB
human_readable() {
  BYTES=$1
  if [ $BYTES -lt 1024 ]; then
    echo "${BYTES} B"
  elif [ $BYTES -lt $((1024**2)) ]; then
    echo "$((BYTES / 1024)) KB"
  elif [ $BYTES -lt $((1024**3)) ]; then
    echo "$((BYTES / 1024 / 1024)) MB"
  else
    echo "$((BYTES / 1024 / 1024 / 1024)) GB"
  fi
}

# Iterate over cache items
for ITEM in "$CACHE_DIR"/*; do
  if [ -e "$ITEM" ] && [ -w "$ITEM" ]; then
    SIZE=$(du -sb "$ITEM" | cut -f1)
    if ! rm -rf "$ITEM"; then
      ERROR_OCCURRED=1
    else
      TOTAL_DELETED=$((TOTAL_DELETED + SIZE))
    fi
  fi
done

HR_SIZE=$(human_readable $TOTAL_DELETED)

# Determine what message to show
if [ $ERROR_OCCURRED -eq 1 ]; then
  # An error happened during deletion
  echo "Failed to clear cache. Please check permissions."
elif [ $TOTAL_DELETED -gt 0 ]; then
  # Some files were successfully deleted
  echo "Cache cleared successfully! 🎉 ($HR_SIZE)"
else
  # No files were deleted (no writable files)
  echo "No cache cleared (no permissions or cache already empty)."
fi
