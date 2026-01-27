#!/usr/bin/env bash
set -euo pipefail

FILE="${1:-}"
APPEND_TEXT="${2:-}"

if [[ -z "$FILE" || -z "$APPEND_TEXT" ]]; then
  echo "usage: prm/actions/prm_apply_append.sh <file_path> <append_text>"
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

TMP_PATCH="/tmp/prm_auto.patch"
TMP_BAK="/tmp/prm_auto.bak"

test -f "$FILE" || (echo "file not found: $FILE" && exit 1)

cp "$FILE" "$TMP_BAK"
printf "\n%s\n" "$APPEND_TEXT" >> "$FILE"
git diff > "$TMP_PATCH"
git checkout -- "$FILE"

mouse/actions/apply_patch.sh "$TMP_PATCH"

git add "$FILE" ssot/evidence
git commit -m "feat(prm): apply append via mouse (evidence)"
git push

rm -f "$TMP_PATCH" "$TMP_BAK"
echo "[PrM] done."
