
#!/usr/bin/env bash
set -euo pipefail

# Base config
BASE_URL="https://ollama.com"
CATEGORY="${1:-cloud}"              # You can override: ./script.sh vision
SEARCH_URL="${BASE_URL}/search?c=${CATEGORY}"

PARALLEL_JOBS="${PARALLEL_JOBS:-8}" # Max parallel curl processes

OUT_DIR="models_html"               # Where model pages' HTML will be saved
URL_LIST_FILE="model_urls.txt"      # Discovered model URLs
PULL_COMMANDS_FILE="cloud_models_pull.txt"  # Final output with ollama pull commands

echo "==> Fetching search page: ${SEARCH_URL}" >&2

# 1) Fetch SSR HTML and extract /library/* links
MODEL_URLS=$(
  curl -sS "${SEARCH_URL}" \
    | grep -o 'href="/library/[^"]\+"' \
    | sed 's/href="//; s/"$//' \
    | sort -u \
    | sed "s#^/#${BASE_URL}/#"
)

if [ -z "${MODEL_URLS}" ]; then
  echo "No model URLs found on search page. Exiting." >&2
  exit 1
fi

echo "==> Discovered model URLs:" >&2
echo "${MODEL_URLS}" >&2

# Save URLs for reference
echo "${MODEL_URLS}" > "${URL_LIST_FILE}"
echo "==> Saved model URL list to ${URL_LIST_FILE}" >&2

# 2) Download each model page in parallel
mkdir -p "${OUT_DIR}"

echo "==> Downloading model pages into ${OUT_DIR}/ (parallel: ${PARALLEL_JOBS})" >&2
echo "${MODEL_URLS}" \
  | xargs -n1 -P"${PARALLEL_JOBS}" -I{} sh -c '
      url="$1"
      name=$(basename "$url")
      out="'"${OUT_DIR}"'/${name}.html"
      echo "   Fetching $url -> $out" >&2
      curl -sS "$url" -o "$out"
    ' _ {}

echo "==> Finished downloading model pages." >&2

# 3) Parse each model HTML and extract model names ending with "-cloud"
#
# We look for:
#   - Text nodes like: >cogito-2.1:671b-cloud<
#   - Input values:    value="cogito-2.1:671b-cloud"
#
# Then we deduplicate and produce `ollama pull <model-name>` lines.

TMP_MODELS_WITH_CLOUD="$(mktemp)"

echo "==> Extracting *-cloud model tags from HTML..." >&2
> "${TMP_MODELS_WITH_CLOUD}"

for file in "${OUT_DIR}"/*.html; do
  [ -e "$file" ] || continue

  # From anchor text / table cells (e.g. cogito-2.1:671b-cloud)
  grep -Eo '>[A-Za-z0-9._:-]+-cloud<' "$file" 2>/dev/null \
    | sed -E 's/[<>]//g' \
    >> "${TMP_MODELS_WITH_CLOUD}" || true

  # From hidden command inputs (e.g. value="cogito-2.1:671b-cloud")
  grep -Eo 'value="[A-Za-z0-9._:-]+-cloud"' "$file" 2>/dev/null \
    | sed -E 's/value="(.*)"/\1/' \
    >> "${TMP_MODELS_WITH_CLOUD}" || true
done

if [ ! -s "${TMP_MODELS_WITH_CLOUD}" ]; then
  echo "==> No *-cloud model names found in the downloaded pages." >&2
  rm -f "${TMP_MODELS_WITH_CLOUD}"
  exit 0
fi

# 4) Deduplicate and write final ollama pull commands
sort -u "${TMP_MODELS_WITH_CLOUD}" \
  | sed 's/^/ollama pull /' \
  > "${PULL_COMMANDS_FILE}"

rm -f "${TMP_MODELS_WITH_CLOUD}"

echo "==> Generated pull commands in: ${PULL_COMMANDS_FILE}" >&2
echo "Contents:" >&2
cat "${PULL_COMMANDS_FILE}" >&2
