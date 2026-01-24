#!/usr/bin/env bash
set -euo pipefail

MODE="${NANUCAI_EXECUTE:-false}"

case "$MODE" in
  1|true|TRUE|yes|YES|on|ON)
    echo "▶️  EXECUTION MODE: EXECUTE (pode gerar custo)"
    exit 0
    ;;
  *)
    echo "🟢 EXECUTION MODE: SAFE (sem custo)"
    echo "   Para EXECUTE: NANUCAI_EXECUTE=true"
    exit 0
    ;;
esac
