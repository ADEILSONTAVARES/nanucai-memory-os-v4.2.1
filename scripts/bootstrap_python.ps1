$ErrorActionPreference = "Stop"

if (!(Test-Path ".venv")) {
  python -m venv .venv
}

.\.venv\Scripts\python -m pip install --upgrade pip | Out-Null
.\.venv\Scripts\python -m pip install -r requirements.txt | Out-Null

Write-Host "OK: python venv pronto + deps instaladas."
Write-Host "Teste: .\scripts\nc.ps1 repo"
