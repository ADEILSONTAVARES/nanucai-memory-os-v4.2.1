#!/usr/bin/env python3
import os, sys, yaml
from copy import deepcopy

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
BASILEIA = os.path.join(ROOT, "ssot", "studios", "basileia_52.yaml")
TEMPLATE = os.path.join(ROOT, "ssot", "studios", "spec_template.yaml")
OUT_DIR = os.path.join(ROOT, "ssot", "studios", "specs")

def load_yaml(path):
    with open(path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)

def dump_yaml(path, obj):
    with open(path, "w", encoding="utf-8") as f:
        yaml.safe_dump(obj, f, sort_keys=False, allow_unicode=True)

def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    bas, tpl = load_yaml(BASILEIA), load_yaml(TEMPLATE)
    
    for s in bas["studios"]:
        spec = deepcopy(tpl)
        spec["studio_id"], spec["name"], spec["category"] = s["id"], s["name"], s["category"]
        spec["description"] = s.get("description", "")
        
        for k, v in spec["evidence_paths"].items():
            spec["evidence_paths"][k] = v.replace("{studio_id}", s["id"])
        
        dump_yaml(os.path.join(OUT_DIR, f'{s["id"]}.yaml'), spec)
    
    print(f"✅ Generated {len(bas['studios'])} studio specs")
    return 0

if __name__ == "__main__":
    sys.exit(main())
