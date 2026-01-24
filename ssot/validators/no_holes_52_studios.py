#!/usr/bin/env python3
import os, sys, yaml

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SPECS_DIR = os.path.join(ROOT, "ssot", "studios", "specs")

REQUIRED_FIELDS = ["studio_id", "name", "category", "memory_by_plan", "connectors_mcp",
                   "evidence_paths", "receipts_policy", "gates", "retention_policy", "cost_contribution"]
PLANS = ["69", "99D", "297", "699", "999"]
MEMORY_REQUIRED = ["hot_redis", "trash", "deep", "cost_contribution"]

def load_yaml(path):
    with open(path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)

def validate_spec(filepath):
    errors = []
    try:
        spec = load_yaml(filepath)
    except Exception as e:
        return [f"YAML parse error: {e}"]
    
    if not spec:
        return ["Empty spec"]
    
    for field in REQUIRED_FIELDS:
        if field not in spec:
            errors.append(f"Missing '{field}'")
    
    mbp = spec.get("memory_by_plan", {})
    for plan in PLANS:
        if plan not in mbp:
            errors.append(f"Missing memory_by_plan['{plan}']")
        else:
            for req in MEMORY_REQUIRED:
                if req not in mbp[plan]:
                    errors.append(f"Missing memory_by_plan['{plan}']['{req}']")
    
    for plan in PLANS:
        if plan not in spec.get("retention_policy", {}):
            errors.append(f"Missing retention_policy['{plan}']")
        if plan not in spec.get("cost_contribution", {}):
            errors.append(f"Missing cost_contribution['{plan}']")
    
    return errors

def main():
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("🔍 NO HOLES VALIDATOR v4.2.1 (ENDURECIDO)")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("")
    
    if not os.path.isdir(SPECS_DIR):
        print(f"❌ ERROR: Missing specs dir: {SPECS_DIR}")
        return 1
    
    files = sorted([f for f in os.listdir(SPECS_DIR) if f.endswith(".yaml")])
    
    if len(files) != 52:
        print(f"❌ ERROR: Expected 52 specs, found {len(files)}")
        return 1
    
    total_errors, failed = 0, []
    
    for fn in files:
        errors = validate_spec(os.path.join(SPECS_DIR, fn))
        if errors:
            total_errors += len(errors)
            failed.append(fn)
            print(f"❌ {fn}")
            for err in errors:
                print(f"   └─ {err}")
        else:
            print(f"✓ {fn}")
    
    print("")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print(f"SUMMARY: {len(files)-len(failed)} passed, {len(failed)} failed, {total_errors} errors")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    if total_errors > 0:
        print("\n❌ VALIDATION FAILED")
        return 1
    else:
        print("\n✅ ALL 52 SPECS VALIDATED - NO HOLES!")
        return 0

if __name__ == "__main__":
    sys.exit(main())
