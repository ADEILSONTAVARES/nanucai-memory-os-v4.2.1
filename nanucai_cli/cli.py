#!/usr/bin/env python3
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

try:
    import yaml
except Exception:
    print("FAIL: faltou PyYAML. Rode: python3 -m pip install pyyaml")
    sys.exit(2)

BASILEIA_PATH = Path("registries/basileia_registry.yaml")
CANON_DIR = Path("docs/ssot/CANON")
GATE = Path("scripts/gate_pass_strict.py")

def fail(msg: str, code: int = 1) -> None:
    print(f"FAIL: {msg}")
    raise SystemExit(code)

def cmd_basileia() -> None:
    if not BASILEIA_PATH.exists():
        fail(f"Arquivo não encontrado: {BASILEIA_PATH}")

    data = yaml.safe_load(BASILEIA_PATH.read_text(encoding="utf-8", errors="replace"))
    studios = data.get("studios", [])
    if not isinstance(studios, list):
        fail("basileia_registry.yaml inválido: studios deve ser lista")

    ids = []
    layer_map = {}
    for s in studios:
        if isinstance(s, dict) and "id" in s:
            sid = str(s["id"])
            ids.append(sid)
            layer_map[sid] = s.get("layer")

    total = len(ids)
    # tenta contar por layer, fallback por faixa
    product = [i for i in ids if layer_map.get(i) == "product"]
    control = [i for i in ids if layer_map.get(i) == "control_plane"]

    if not product and not control:
        # fallback: S00-S40 = product, S41-S51 = control_plane
        product = [f"S{i:02d}" for i in range(0, 41) if f"S{i:02d}" in ids]
        control = [f"S{i:02d}" for i in range(41, 52) if f"S{i:02d}" in ids]

    print("BASILEIA")
    print("========")
    print(f"Total: {total}")
    print(f"Product (S00-S40): {len(product)}")
    print(f"Control Plane (S41-S51): {len(control)}")

    if total != 52:
        fail(f"BASILEIA precisa ter 52 Studios. Achou {total}.")
    print("PASS: BASILEIA 52 ✅")

def cmd_canonico() -> None:
    if not CANON_DIR.exists():
        fail(f"Pasta canônica não existe: {CANON_DIR}")

    docs = sorted([p for p in CANON_DIR.glob("*.md") if p.is_file()])
    print("CANONICO")
    print("========")
    print(str(CANON_DIR) + "/")
    for p in docs:
        print(f"- {p.name}")
    print(f"Total: {len(docs)} arquivo(s)")

def cmd_repo() -> int:
    # Se existir gate central, usa ele. Se não, roda validator mínimo de policy.
    if GATE.exists():
        return subprocess.run(["python3", str(GATE)], check=False).returncode

    # fallback mínimo (não deixa buraco): policy precisa passar
    v = Path("scripts/validators/validate_repo_policy_git.py")
    if not v.exists():
        fail("gate_pass_strict.py não existe e validate_repo_policy_git.py também não. Crie o validator.")
    return subprocess.run(["python3", str(v)], check=False).returncode

def main() -> int:
    parser = argparse.ArgumentParser(prog="nanucai")
    parser.add_argument("cmd", choices=["basileia", "canonico", "repo"])
    args = parser.parse_args()

    if args.cmd == "basileia":
        cmd_basileia()
        return 0
    if args.cmd == "canonico":
        cmd_canonico()
        return 0
    if args.cmd == "repo":
        rc = cmd_repo()
        if rc == 0:
            print("PASS: PASS_STRICT ✅")
        else:
            print("FAIL: PASS_STRICT ❌")
        return rc

    return 0

if __name__ == "__main__":
    raise SystemExit(main())
