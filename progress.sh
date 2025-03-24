#!/bin/bash
set -e

source config.sh

for file in "${INCLUDE_MANUAL_LINKS[@]}"; do
  if [[ -f "$file" ]]; then
    total=$(grep -cve '^\s*$' "$file")
    echo "Checking $total URLs in $file..."

    count=0
    while IFS= read -r url; do
      [[ -z "$url" ]] && continue
      ((count++))
      printf "[%d/%d] %s\n" "$count" "$total" "$url"
      curl -o /dev/null -s -w "%{http_code}\n" "$url" > /dev/null
    done < "$file"
  fi
done
