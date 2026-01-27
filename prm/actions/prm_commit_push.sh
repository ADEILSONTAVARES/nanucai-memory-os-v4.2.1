#!/usr/bin/env bash
set -euo pipefail

MSG="${1:-chore(prm): commit + push}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

./doctor/doctor_fast.sh

git add -A
git commit -m "$MSG" || (echo "nothing to commit" && exit 0)
git push

echo "[PrM] commit+push done."
