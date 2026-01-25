#!/usr/bin/env bash
set -euo pipefail

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧾 Receipt Harness (SAFE)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

python3 scripts/run_job_request.py >/tmp/nanucai_job_out.txt

# pega os caminhos que o script imprimiu
REQ_PATH="$(grep -Eo 'vault/receipts/[^ ]+job_request\.json' /tmp/nanucai_job_out.txt | tail -n 1)"
RCPT_PATH="$(grep -Eo 'vault/receipts/[^ ]+receipt\.json' /tmp/nanucai_job_out.txt | tail -n 1)"
MET_PATH="$(grep -Eo 'vault/metrics/[^ ]+metric_event\.json' /tmp/nanucai_job_out.txt | tail -n 1)"

test -f "$REQ_PATH"
test -f "$RCPT_PATH"
test -f "$MET_PATH"

python3 - <<PY
import json
req=json.load(open("$REQ_PATH","r",encoding="utf-8"))
rc=json.load(open("$RCPT_PATH","r",encoding="utf-8"))
me=json.load(open("$MET_PATH","r",encoding="utf-8"))

for k in ["job_id","studio_id","action","parameters","plan_id","execute_mode","requested_at"]:
    assert k in req, f"job_request missing {k}"

for k in ["receipt_id","job_id","studio_id","status","started_at","finished_at","evidence_refs","artifacts"]:
    assert k in rc, f"receipt missing {k}"

for k in ["event_id","job_id","studio_id","name","value","unit","recorded_at"]:
    assert k in me, f"metric_event missing {k}"

assert rc["job_id"] == req["job_id"]
assert me["job_id"] == req["job_id"]
print("✅ harness: contracts ok + receipt ok + metric_event ok")
PY

echo "✅ Receipt Harness: PASSED"
