#!/usr/bin/env bash
set -euo pipefail

# cria venv local do repo (não suja o Python do sistema)
if [ ! -d ".venv" ]; then
  python3 -m venv .venv
fi

. .venv/bin/activate
python -m pip install --upgrade pip >/dev/null
python -m pip install -r requirements.txt >/dev/null

echo "OK: python venv pronto + deps instaladas."
echo "Teste: ./scripts/nc repo"
