#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Start and Verify Colima
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🐳
# @raycast.packageName Developer Utils

# Documentation:
# @raycast.description This script starts Colima, a lightweight container runtime for macOS, and verifies that it’s running properly. If Colima is not installed, it prompts the user to install it.
# @raycast.author hardik_soni
# @raycast.authorURL https://raycast.com/hardik_soni

# Check if Colima is installed
if ! command -v colima &> /dev/null
then
    echo "❌ Colima is not installed. Install it using: brew install colima"
    exit 1
fi

# Start Colima
echo "🚀 Starting Colima..."
start_output=$(colima start)

echo "✅ Colima is running successfully!"