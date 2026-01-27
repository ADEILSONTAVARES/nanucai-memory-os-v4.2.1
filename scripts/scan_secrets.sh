#!/usr/bin/env bash
set -euo pipefail

PATTERN='OPENAI_API_KEY\s*[:=]\s*sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}'

# FAIL se achar match
if rg -n --hidden -S "$PATTERN" \
  --glob '!.git/**' \
  --glob '!doctor/**' \
  . ; then
  echo "FAIL: secret-like pattern found (repo scan)."
  exit 2
fi

echo "PASS: no secret-like patterns found."
