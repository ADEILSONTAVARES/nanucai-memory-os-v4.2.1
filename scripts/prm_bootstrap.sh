#!/usr/bin/env bash
set -euo pipefail
echo "[PrM] bootstrap: ensuring OG10 skeleton..."

mkdir -p prm/{spec,actions,runbooks} ssot/evidence doctor scripts mcp_registry docs

echo "[PrM] done."
