#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

PATCH_FILE="${1:-}"
if [[ -z "$PATCH_FILE" || ! -f "$PATCH_FILE" ]]; then
  echo "usage: mouse/actions/apply_patch.sh <patch_file.diff>"
  exit 1
fi

TS="$(date -u +%Y%m%dT%H%M%SZ)"
EVID="ssot/evidence/mouse_apply_${TS}.log"

echo "[mouse] applying patch: $PATCH_FILE" | tee "$EVID"
git apply "$PATCH_FILE" 2>&1 | tee -a "$EVID"

./doctor/doctor_fast.sh 2>&1 | tee -a "$EVID"

git status --porcelain | tee -a "$EVID"
echo "[mouse] PASS" | tee -a "$EVID"
