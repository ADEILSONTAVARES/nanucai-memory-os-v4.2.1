#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."

# Usa venv se existir
if [[ -f .venv/bin/activate ]]; then
    source .venv/bin/activate
fi

python ssot/validators/no_holes_52_studios.py
