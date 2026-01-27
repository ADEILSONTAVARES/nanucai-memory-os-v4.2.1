#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "== Doctor Fast (OG10) =="

for d in ssot doctor scripts mcp_registry prm; do
  test -d "$d" || (echo "missing dir: $d" && exit 1)
done

# Anti-secrets simples
if rg -n --hidden -S "(OPENAI_API_KEY=|ghp_|github_pat_|sk-)" . 2>/dev/null; then
  echo "❌ Possible secret found in repo. Remove it."
  exit 1
fi

echo "✅ PASS"
