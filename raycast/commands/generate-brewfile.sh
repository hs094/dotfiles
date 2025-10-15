#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Generate Brewfile
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Developer Utils
# @raycast.needsConfirmation false

# Documentation:
# @raycast.description The generate_brewfile.sh script automates the process of backing up your currently installed Homebrew packages. 
# @raycast.author hardik_soni
# @raycast.authorURL https://raycast.com/hardik_soni

# Define the output path
CONFIG_DIR="$HOME/.config"
BREWFILE_PATH="$CONFIG_DIR/Brewfile"

# Create ~/.config if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Generate the Brewfile
echo "Generating Brewfile at $BREWFILE_PATH..."
brew bundle dump --file="$BREWFILE_PATH" --force

# Confirmation
if [ -f "$BREWFILE_PATH" ]; then
    echo "✅ Brewfile Successfully Generated"
    # Close Raycast window after successful completion
    osascript -e 'tell application "Raycast" to activate' -e 'tell application "System Events" to keystroke "w" using command down'
else
    echo "❌ Failed to create Brewfile."
    exit 1
fi

