#!/usr/bin/env bash
set -euo pipefail

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧾 Receipt Harness (SAFE)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

python3 scripts/run_job_request.py >/tmp/nanucai_job_out.txt

REQ_PATH="$(grep -Eo 'vault/receipts/[^ ]+job_request\.json' /tmp/nanucai_job_out.txt | tail -n 1)"
RCPT_PATH="$(grep -Eo 'vault/receipts/[^ ]+receipt\.json' /tmp/nanucai_job_out.txt | tail -n 1)"
MET_PATH="$(grep -Eo 'vault/metrics/[^ ]+metric_event\.json' /tmp/nanucai_job_out.txt | tail -n 1)"

test -f "$REQ_PATH"
test -f "$RCPT_PATH"
test -f "$MET_PATH"

python3 - <<PY
import json, os
req=json.load(open("$REQ_PATH","r",encoding="utf-8"))
rc=json.load(open("$RCPT_PATH","r",encoding="utf-8"))
me=json.load(open("$MET_PATH","r",encoding="utf-8"))

arts = rc.get("artifacts") or []
ledger = [a for a in arts if a.startswith("ledger/api_history/") and a.endswith(".json")]
assert ledger, "missing ledger/api_history artifact"
lp = ledger[0]
assert os.path.exists(lp), f"missing ledger file: {lp}"

ev=json.load(open(lp,"r",encoding="utf-8"))
for k in ["call_id","job_id","studio_id","action","command","started_at","finished_at","duration_ms","exit_code","stdout_bytes","stderr_bytes","provider","execute_mode"]:
    assert k in ev, f"api_call_event missing {k}"

print("✅ harness: receipt ok + metric ok + api_history ok")
PY

echo "✅ Receipt Harness: PASSED"
