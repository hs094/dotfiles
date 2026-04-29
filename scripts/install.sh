#!/usr/bin/env bash

set -euo pipefail

echo "🚀 Installing all skills (non-interactive mode)"

SKILLS=(
  "to-prd"
  "to-issues"
  "grill-me"
  "design-an-interface"
  "request-refactor-plan"
  "tdd"
  "triage-issue"
  "improve-codebase-architecture"
  "migrate-to-shoehorn"
  "scaffold-exercises"
  "setup-pre-commit"
  "git-guardrails-claude-code"
  "write-a-skill"
  "edit-article"
  "ubiquitous-language"
  "obsidian-vault"
)

# 🎯 Choose ONLY the agents you actually use
AGENTS="claude-code,cursor,github-copilot"

for skill in "${SKILLS[@]}"; do
  echo "📦 Installing $skill"

  npx skills@latest add "mattpocock/skills/$skill" \
    --yes \
    --scope global \
    --method symlink \
    --agents "$AGENTS"

done

echo "✅ All skills installed (zero prompts)"
