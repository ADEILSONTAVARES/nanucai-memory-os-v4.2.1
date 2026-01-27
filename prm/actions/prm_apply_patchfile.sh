#!/usr/bin/env bash
set -euo pipefail

PATCH_FILE="${1:-}"
COMMIT_MSG="${2:-feat(prm): apply patch (mouse+doctor+evidence)}"

if [[ -z "$PATCH_FILE" || ! -f "$PATCH_FILE" ]]; then
  echo "usage: prm/actions/prm_apply_patchfile.sh <patch_file.diff> [commit_message]"
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

# Aplica via Mouse (gera evidência + roda doctor_fast)
mouse/actions/apply_patch.sh "$PATCH_FILE"

# Commit e push com evidência
git add -A
git commit -m "$COMMIT_MSG" || (echo "nothing to commit" && exit 0)
git push

echo "[PrM] applied + committed + pushed."
