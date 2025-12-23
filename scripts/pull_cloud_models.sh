
#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------
# Config
# ---------------------------------------
BASE_URL="https://ollama.com"
CATEGORY="${1:-cloud}"                       # Usage: ./script.sh [category], default: cloud
SEARCH_URL="${BASE_URL}/search?c=${CATEGORY}"

PARALLEL_JOBS="${PARALLEL_JOBS:-8}"          # For parallel pulls
PULL_PARALLEL="${PULL_PARALLEL:-1}"          # 1 = parallel (default), 0 = sequential

echo "==> Fetching search page: ${SEARCH_URL}" >&2

# ---------------------------------------
# 1) Fetch search page and extract /library/* URLs
# ---------------------------------------
MODEL_URLS=$(
  curl -sS "${SEARCH_URL}" \
    | grep -o 'href="/library/[^"]\+"' \
    | sed 's/href="//; s/"$//' \
    | sort -u \
    | sed "s#^/#${BASE_URL}/#"
)

if [ -z "${MODEL_URLS}" ]; then
  echo "No model URLs found on search page. Exiting." >&2
  exit 0
fi

echo "==> Discovered model URLs:" >&2
echo "${MODEL_URLS}" >&2

# ---------------------------------------
# 2) Fetch each model page and extract *-cloud variants
# ---------------------------------------
cloud_models=""

echo "==> Scanning model pages for *-cloud tags..." >&2

while IFS= read -r url; do
  [ -n "$url" ] || continue
  echo "   Fetching model page: $url" >&2

  html="$(curl -sS "$url")"

  # From table / anchor text: >cogito-2.1:671b-cloud<
  found1=$(
    printf '%s\n' "$html" \
      | grep -Eo '>[A-Za-z0-9._:-]+-cloud<' 2>/dev/null \
      | sed -E 's/[<>]//g' || true
  )

  # From hidden command inputs: value="cogito-2.1:671b-cloud"
  found2=$(
    printf '%s\n' "$html" \
      | grep -Eo 'value="[A-Za-z0-9._:-]+-cloud"' 2>/dev/null \
      | sed -E 's/value="(.*)"/\1/' || true
  )

  # From README code blocks: `ollama run cogito-2.1:671b-cloud`
  found3=$(
    printf '%s\n' "$html" \
      | grep -Eo 'ollama run [A-Za-z0-9._:-]+-cloud' 2>/dev/null \
      | sed -E 's/.*ollama run ([A-Za-z0-9._:-]*-cloud).*/\1/' || true
  )

  # Append to our in-memory list
  if [ -n "${found1}" ] || [ -n "${found2}" ] || [ -n "${found3}" ]; then
    cloud_models="${cloud_models}
${found1}
${found2}
${found3}"
  fi
done <<< "${MODEL_URLS}"

# Clean / dedupe
MODEL_NAMES=$(
  printf '%s\n' "${cloud_models}" \
    | sed '/^[[:space:]]*$/d' \
    | sort -u
)

if [ -z "${MODEL_NAMES}" ]; then
  echo "==> No *-cloud models found. Nothing to pull." >&2
  exit 0
fi

echo "==> *-cloud models to pull:" >&2
echo "${MODEL_NAMES}" >&2

# ---------------------------------------
# 3) Pull models (parallel or sequential)
# ---------------------------------------
if [ "${PULL_PARALLEL}" = "1" ]; then
  echo "==> Pulling models in parallel (up to ${PARALLEL_JOBS} jobs)..." >&2
  printf '%s\n' "${MODEL_NAMES}" \
    | xargs -n1 -P"${PARALLEL_JOBS}" -I{} sh -c '
        model="$1"
        echo "   ollama pull ${model}" >&2
        ollama pull "${model}"
      ' _ {}
else
  echo "==> Pulling models sequentially..." >&2
  while IFS= read -r model; do
    [ -n "$model" ] || continue
    echo "   ollama pull ${model}" >&2
    ollama pull "${model}"
  done <<< "${MODEL_NAMES}"
fi

echo "==> Done ✅" >&2
