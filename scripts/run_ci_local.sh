#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 NANUCAI CI Local Runner v4.2.1"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Ativar venv
if [[ -f .venv/bin/activate ]]; then
    source .venv/bin/activate
fi

# Execution Guard
bash scripts/execution_guard.sh
echo ""

# Generate specs
echo "🔧 Generating specs..."
python scripts/generate_studio_specs.py
echo ""

# Validate
echo "🔍 Validating..."
python ssot/validators/no_holes_52_studios.py
echo ""

# Paid tasks
if [[ "${NANUCAI_EXECUTE:-false}" == "true" ]]; then
    bash scripts/execute_paid_tasks.sh
else
    echo "🟢 SAFE: skipping paid tasks"
fi

echo ""
echo "✅ CI Local Runner: PASSED"
