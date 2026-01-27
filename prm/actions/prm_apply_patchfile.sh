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

# snapshot antes
BEFORE="$(mktemp)"
AFTER="$(mktemp)"
git status --porcelain > "$BEFORE"

# aplica via Mouse (gera evidência + roda doctor_fast)
mouse/actions/apply_patch.sh "$PATCH_FILE"

# snapshot depois
git status --porcelain > "$AFTER"

# Descobrir arquivos realmente alterados pelo patch (M/A)
CHANGED_FILES="$(comm -13 <(sort "$BEFORE") <(sort "$AFTER") | awk '{print $2}' | grep -v '^ssot/evidence/' || true)"

# Sempre incluir evidências
git add ssot/evidence || true

# Adicionar apenas arquivos realmente alterados (se existirem)
if [[ -n "${CHANGED_FILES}" ]]; then
  while IFS= read -r f; do
    [[ -n "$f" ]] && git add "$f" || true
  done <<< "$CHANGED_FILES"
fi

rm -f "$BEFORE" "$AFTER"

git commit -m "$COMMIT_MSG" || (echo "nothing to commit" && exit 0)
git push

echo "[PrM] applied + committed + pushed (v0.2 safe)."
