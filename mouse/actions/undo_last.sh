#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

TS="$(date -u +%Y%m%dT%H%M%SZ)"
EVID="ssot/evidence/mouse_undo_${TS}.log"

echo "[mouse] undo last commit (soft reset 1)" | tee "$EVID"
git reset --soft HEAD~1 2>&1 | tee -a "$EVID"
echo "[mouse] done (changes kept staged)" | tee -a "$EVID"
