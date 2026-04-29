#!/usr/bin/env bash

# Exit immediately if a command fails
set -e

# Export Anthropic environment variables
export ANTHROPIC_AUTH_TOKEN="ollama"
export ANTHROPIC_BASE_URL="http://localhost:11434"

echo "✅ ANTHROPIC_AUTH_TOKEN and ANTHROPIC_BASE_URL have been set."

