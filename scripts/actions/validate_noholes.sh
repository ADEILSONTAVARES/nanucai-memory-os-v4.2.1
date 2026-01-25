#!/usr/bin/env bash
set -euo pipefail

python -m pip install -r requirements-dev.txt >/dev/null

python scripts/generate_studio_specs.py
python ssot/validators/no_holes_52_studios.py
