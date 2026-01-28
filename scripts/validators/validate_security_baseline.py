#!/usr/bin/env python3
from pathlib import Path
import sys

def fail(msg: str):
  print(f"FAIL: security_baseline: {msg}")
  raise SystemExit(1)

def ok(msg: str):
  print(f"PASS: security_baseline: {msg}")

base = Path(".")
req_files = [
  "docs/ssot/CANON/VEREDITO_REPO_v13_2.md",
  "docs/ssot/CANON/SECURITY_RACKER_PACK_v1.md",
  "registries/security/security_baseline.yaml",
  ".github/workflows/ci_pass_strict.yml",
  ".gitignore",
]

for f in req_files:
  if not (base / f).exists():
    fail(f"arquivo obrigatório faltando: {f}")

gitignore = (base / ".gitignore").read_text(encoding="utf-8", errors="replace")
must = ["runtime/", ".vault/", "*.env"]
missing = [m for m in must if m not in gitignore]
if missing:
  fail(f".gitignore precisa conter: {missing}")

ok("arquivos e .gitignore OK")
