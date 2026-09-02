#!/usr/bin/env bash

# # Exit immediately if a command exits with a non-zero status
# set -eo pipefail
#
# # --- LOAD SECRETS FROM macOS KEYCHAIN ---
# GH_TOKEN="$(
#   security find-generic-password \
#     -a "$USER" \
#     -s "work-gh-token" \
#     -w
# )"
# export GH_TOKEN

# Exit immediately if a command exits with a non-zero status
set -eo pipefail

# --- LOAD SECRETS FROM .env ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$SCRIPT_DIR/.env" ]; then
  set -a
  source "$SCRIPT_DIR/.env"
  set +a
fi


# --- CONFIGURATION ---
TARGET_REPO="simbianai/SimbianOS"
# --- --- --- --- --- -

echo "=================================================="
echo "Starting PR sync for $TARGET_REPO at $(date)"
echo "=================================================="

# 1. Check if GitHub CLI is installed and authenticated
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI ('gh') is not installed." >&2
    exit 1
fi

if ! gh auth status --hostname github.com --active &> /dev/null; then
    echo "Error: Not authenticated. Please run 'gh auth login' first." >&2
    exit 1
fi

# 2. Check remaining primary rate limit before starting
echo "Checking API rate limit..."

REMAINING_LIMIT=$(gh api rate_limit --jq '.rate.remaining')

echo "Current available API budget: $REMAINING_LIMIT requests."

if [ "$REMAINING_LIMIT" -lt 50 ]; then
    echo "Warning: Rate limit is dangerously low ($REMAINING_LIMIT). Aborting run." >&2
    exit 1
fi

# 3. Fetch open PRs; eligibility is checked immediately before processing each one.
echo "Querying open pull requests..."

PR_LIST=$(
    gh pr list \
        --author "@me" \
        --repo "$TARGET_REPO" \
        --state open \
        --json number \
        --jq '.[].number'
)

# Handle empty results cleanly
if [ -z "$PR_LIST" ]; then
    echo "No open pull requests found."
    echo "Execution finished cleanly."
    exit 0
fi

# 4. Merge eligible PRs
echo "Found matching PRs. Processing queue..."

for PR_NUM in $PR_LIST; do
    echo "----------------------------------------"
    echo "Processing PR #$PR_NUM..."

    # Optional safety check immediately before merging.
    # This protects against PR state changing between `gh pr list`
    # and the actual merge attempt.
    PR_STATE=$(
        gh pr view "$PR_NUM" \
            --repo "$TARGET_REPO" \
            --json labels,mergeable,mergeStateStatus \
            --jq '
                if any(.labels[]?; (.name | ascii_downcase) == "do not merge") then "SKIP_LABEL"
                elif .mergeStateStatus == "BEHIND" then "UPDATE"
                elif (
                    .mergeable == "MERGEABLE"
                    and .mergeStateStatus == "CLEAN"
                ) then "MERGE"
                else "SKIP"
                end
            '
    )

    # GitHub can report BLOCKED while an out-of-date PR has checks pending.
    if [ "$PR_STATE" = "SKIP" ]; then
        PR_REFS=$(
            gh api "repos/$TARGET_REPO/pulls/$PR_NUM" \
                --jq '"\(.base.ref)\t\(.head.label)"'
        )
        IFS=$'\t' read -r BASE_REF HEAD_REF <<< "$PR_REFS"
        PR_BEHIND=$(
            gh api "repos/$TARGET_REPO/compare/$BASE_REF...$HEAD_REF" \
                --jq '.behind_by'
        )
        if [ "$PR_BEHIND" -gt 0 ]; then
            PR_STATE="UPDATE"
        fi
    fi

    case "$PR_STATE" in
        SKIP_LABEL)
            echo "Skipping PR #$PR_NUM: it has the 'do not merge' label."
            continue
            ;;
        UPDATE)
            echo "Updating PR #$PR_NUM branch from its base branch..."
            if ! gh pr update-branch "$PR_NUM" --repo "$TARGET_REPO"; then
                echo "Failed to update PR #$PR_NUM branch." >&2
            else
                echo "Updated PR #$PR_NUM branch from its base branch."
            fi
            continue
            ;;
        SKIP)
            echo "Skipping PR #$PR_NUM: it is not clean/mergeable."
            continue
            ;;
    esac

    gh pr merge "$PR_NUM" \
        --squash \
        --repo "$TARGET_REPO"

    echo "Successfully merged PR #$PR_NUM."

    # Secondary rate limit safeguard
    echo "Sleeping for 2 seconds to respect rate limits..."
    sleep 2
done

echo "=================================================="
echo "All eligible PRs processed successfully."
echo "=================================================="
