#!/usr/bin/env python3
import json, os, sys, time, uuid, datetime, subprocess

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
VAULT_RECEIPTS = os.path.join(ROOT, "vault", "receipts")
VAULT_METRICS = os.path.join(ROOT, "vault", "metrics")

def now_iso():
    return datetime.datetime.now(datetime.UTC).replace(microsecond=0).isoformat().replace('+00:00','Z')

def write_json(path, obj):
    with open(path, "w", encoding="utf-8") as f:
        json.dump(obj, f, ensure_ascii=False, indent=2)

def main():
    os.makedirs(VAULT_RECEIPTS, exist_ok=True)
    os.makedirs(VAULT_METRICS, exist_ok=True)

    job_id = "job_" + uuid.uuid4().hex[:12]
    studio_id = os.environ.get("NANUCAI_STUDIO_ID", "S00")
    plan_id = os.environ.get("NANUCAI_PLAN_ID", "99D")
    execute_mode = "EXECUTE" if os.environ.get("NANUCAI_EXECUTE", "false").lower() in ("1","true","yes","on") else "SAFE"

    job_request = {
        "job_id": job_id,
        "studio_id": studio_id,
        "action": os.environ.get("NANUCAI_ACTION", "validate_noholes"),
        "parameters": {"dry_run": True},
        "plan_id": plan_id,
        "execute_mode": execute_mode,
        "requested_at": now_iso(),
    }

    started = time.time()
    started_at = now_iso()

    status = "OK"
    error_obj = None
    try:
        action = job_request["action"]
        artifacts_dir = os.path.join(ROOT, "vault", "artifacts", job_id)
        os.makedirs(artifacts_dir, exist_ok=True)
        log_path = os.path.join(artifacts_dir, f"{action}.log")

        if action == "validate_noholes":
            proc = subprocess.run(["bash","scripts/actions/validate_noholes.sh"], capture_output=True, text=True)
            out = (proc.stdout or "") + "\n" + (proc.stderr or "")
            with open(log_path, "w", encoding="utf-8") as f:
                f.write(out)
            job_request["parameters"]["exit_code"] = proc.returncode
            if proc.returncode != 0:
                raise RuntimeError(f"validate_noholes failed (exit_code={proc.returncode})")
        else:
            with open(log_path, "w", encoding="utf-8") as f:
                f.write(f"unknown action: {action}\n")
            raise RuntimeError(f"unknown action: {action}")
")
            raise RuntimeError(f"unknown action: {action}")
    except Exception as e:
        status = "ERROR"
        error_obj = {"message": str(e)}

    finished = time.time()
    finished_at = now_iso()
    duration_ms = round((finished - started) * 1000.0, 2)

    receipt_id = "rcpt_" + uuid.uuid4().hex[:12]
    receipt = {
        "receipt_id": receipt_id,
        "job_id": job_id,
        "studio_id": studio_id,
        "status": status,
        "started_at": started_at,
        "finished_at": finished_at,
        "evidence_refs": [
            "ssot/contracts/job_request.yaml",
            "ssot/contracts/receipt.yaml",
            "ssot/contracts/metric_event.yaml",
        ],
        "artifacts": [f"vault/artifacts/{job_id}/{job_request['action']}.log"],
    }
    if error_obj:
        receipt["error"] = error_obj

    metric = {
        "event_id": "evt_" + uuid.uuid4().hex[:12],
        "job_id": job_id,
        "studio_id": studio_id,
        "name": "job.duration_ms",
        "value": duration_ms,
        "unit": "ms",
        "recorded_at": now_iso(),
    }

    req_path = os.path.join(VAULT_RECEIPTS, f"{job_id}.job_request.json")
    rcpt_path = os.path.join(VAULT_RECEIPTS, f"{job_id}.receipt.json")
    met_path = os.path.join(VAULT_METRICS, f"{job_id}.metric_event.json")

    write_json(req_path, job_request)
    write_json(rcpt_path, receipt)
    write_json(met_path, metric)

    print(f"✅ job_request: {req_path}")
    print(f"✅ receipt:      {rcpt_path}")
    print(f"✅ metric_event: {met_path}")
    return 0 if status == "OK" else 1

if __name__ == "__main__":
    sys.exit(main())
