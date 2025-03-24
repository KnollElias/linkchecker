#!/bin/bash
set -e

source config.sh

DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "[DRY RUN] No crawling or network requests will be made."
fi

mkdir -p "$OUTPUT_DIR"
timestamp=$(date +"%Y%m%d_%H%M%S")
report="$OUTPUT_DIR/broken_links_$timestamp.txt"

if ! $DRY_RUN; then
  echo "Crawling $BASE_URL ... (progress shown live)"
  > "$TEMP_LOG"

  wget --spider --recursive --no-verbose \
       --output-file="$TEMP_LOG" \
       --level="$CRAWL_DEPTH" \
       --user-agent="$USER_AGENT" \
       --reject-regex="$EXCLUDE_PATTERN" \
       "$BASE_URL" &

  WGET_PID=$!

  tail -f "$TEMP_LOG" --pid=$WGET_PID | while read -r line; do
    if [[ "$line" == *"http"* ]]; then
      echo "Checking: ${line##* }"
    fi
  done

  wait $WGET_PID

  echo "Broken links from crawl:" > "$report"
  grep -i "broken link" "$TEMP_LOG" >> "$report"
  grep -i "404 Not Found" "$TEMP_LOG" >> "$report"
  rm "$TEMP_LOG"
else
  echo "[DRY RUN] Skipped crawling and temp log generation." > "$report"
fi

for file in "${INCLUDE_MANUAL_LINKS[@]}"; do
  if [[ -f "$file" ]]; then
    echo -e "\nBroken links from $file:" >> "$report"
    total=$(grep -cve '^\s*$' "$file")
    count=0
    while IFS= read -r url; do
      [[ -z "$url" ]] && continue
      ((count++))
      if $DRY_RUN; then
        echo "[DRY RUN] Would check: $url"
      else
        echo "[$count/$total] Checking: $url"
        status=$(curl -o /dev/null -s -w "%{http_code}" "$url")
        if [[ "$status" != "200" ]]; then
          echo "$url -> HTTP $status" >> "$report"
        fi
      fi
    done < "$file"
  fi
done

echo "Done. Report saved to $
