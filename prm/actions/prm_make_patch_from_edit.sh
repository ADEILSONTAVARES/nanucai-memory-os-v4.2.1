#!/usr/bin/env bash
set -euo pipefail

FILE="${1:-}"
TMP_TEXT_FILE="${2:-}"

if [[ -z "$FILE" || -z "$TMP_TEXT_FILE" ]]; then
  echo "usage: prm/actions/prm_make_patch_from_edit.sh <file_path> <tmp_text_file>"
  echo "example: prm/actions/prm_make_patch_from_edit.sh gammanotion/spec/GAMMANOTION_VIVO.md /tmp/new.txt"
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

test -f "$FILE" || (echo "file not found: $FILE" && exit 1)
test -f "$TMP_TEXT_FILE" || (echo "tmp_text_file not found: $TMP_TEXT_FILE" && exit 1)

OUT_PATCH="/tmp/prm_patch_$(date -u +%Y%m%dT%H%M%SZ).diff"
BAK="/tmp/prm_bak_$(date -u +%Y%m%dT%H%M%SZ)"

cp "$FILE" "$BAK"
cp "$TMP_TEXT_FILE" "$FILE"

git diff > "$OUT_PATCH" || true

# restaura o arquivo
mv "$BAK" "$FILE"

if [[ ! -s "$OUT_PATCH" ]]; then
  echo "no diff generated (empty patch)."
  rm -f "$OUT_PATCH"
  exit 2
fi

echo "$OUT_PATCH"
