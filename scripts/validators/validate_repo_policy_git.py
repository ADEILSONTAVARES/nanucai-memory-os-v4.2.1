#!/usr/bin/env python3
from pathlib import Path
import subprocess
import sys

def fail(msg: str):
    print("FAIL:", msg)
    sys.exit(1)

# Arquivos canônicos obrigatórios
REQ = [
    "docs/ssot/CANON/REPO_POLICY_GIT_v13_2.md",
    "docs/ssot/CANON/CLAUDE_MODELING_NANUCAI_v13_2.md",
]

for r in REQ:
    if not Path(r).exists():
        fail(f"Arquivo obrigatório ausente: {r}")

# .gitignore deve ignorar runtime, .vault e arquivos de ambiente
gi = Path(".gitignore")
if not gi.exists():
    fail(".gitignore ausente")

gtext = gi.read_text(encoding="utf-8", errors="replace").splitlines()
need = {"runtime/": False, ".vault/": False, "*.env": False}
for line in gtext:
    s = line.strip()
    if s in need:
        need[s] = True

missing = [k for k, v in need.items() if not v]
if missing:
    fail(f".gitignore precisa conter: {missing}")

# runtime/.vault/*.env não podem estar rastreados no git
def git_ls(prefix: str) -> str:
    try:
        out = subprocess.check_output(["git", "ls-files", prefix], text=True).strip()
        return out
    except Exception:
        return ""

if git_ls("runtime"):
    fail("runtime/ está rastreado no git (proibido)")
if git_ls(".vault"):
    fail(".vault/ está rastreado no git (proibido)")

all_files = subprocess.check_output(["git", "ls-files"], text=True).splitlines()
for f in all_files:
    lf = f.lower()
    if lf.endswith(".env") or "/.env" in lf:
        fail(f"Arquivo de ambiente rastreado no git (proibido): {f}")

print("PASS: repo_policy_git")
