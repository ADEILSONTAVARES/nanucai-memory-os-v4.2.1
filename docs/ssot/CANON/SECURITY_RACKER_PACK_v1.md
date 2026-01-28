# SECURITY_RACKER_PACK v1 (NANUCAI)

Objetivo: reduzir risco de invasão, limitar estrago e permitir restauração rápida.

## Camada A: Repo (GitHub)
- Branch principal protegida (sem push direto, só PR)
- Checks obrigatórios: CI PASS_STRICT
- 2FA obrigatório na conta GitHub
- Secrets somente via GitHub Secrets (nunca no repo)
- Scanner de segredos em CI e pre-commit

## Camada B: Runtime (VPS)
- Processo 24/7 com supervisor (systemd)
- Usuário sem root para rodar o serviço
- Firewall ativo (na nuvem e no SO)
- Fail2ban (protege SSH e tentativas repetidas)
- Logs e receipts fora do Git (runtime/)

## Camada C: Backup e “segunda linha”
- Código: GitHub já é 1 cópia, mas precisa 2ª linha (mirror em outro remote privado)
- Dados: snapshots automáticos + retenção + teste de restore
- Artefatos: storage com versionamento e replicação (quando aplicável)

## AutoCura e Restore (sem mágica)
- AutoCura = reiniciar serviço + rollback para último “known good” se healthcheck falhar
- Restore = restaurar snapshot + re-deploy do último release tag
- Regra de ouro: “sem evidence, sem restore automático”

