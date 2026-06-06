#!/bin/bash
set -euo pipefail

cd ~/.config/homebrew
rm -f Brewfile
brew bundle dump
echo "Brewfile Updated 🚀"
