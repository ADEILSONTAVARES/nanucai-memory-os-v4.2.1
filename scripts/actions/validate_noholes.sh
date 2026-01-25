#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."

if [[ -f .venv/bin/activate ]]; then
  source .venv/bin/activate
else
  python3 -m venv .venv
  source .venv/bin/activate
fi

python -m pip install -q -r requirements-dev.txt
python scripts/generate_studio_specs.py
python ssot/validators/no_holes_52_studios.py
