# POLÍTICA CANÔNICA — O QUE PODE IR PARA O GIT (v13.2)
Data: 2026-01-27
Objetivo: manter SSOT auditável no repo sem vazar segredos e sem “runtime drift”.

## 1) Pode ir para o repo (permitido)
### 1.1 SSOT e documentação
- Documentos SSOT do NANUCAI (arquitetura, governança, fluxos, specs)
- Modelagem de concorrentes (inclui “Claude model”, desde que não contenha segredos nem dados pessoais)
- Guias operacionais (GitHubOps, Doctor, Evidence, Detetive7x, Flags)

### 1.2 Código e contratos
- Código-fonte (Python/TS/etc.)
- Schemas (JSON Schema, YAML contracts)
- Registries (BASILEIA, MCP registry, flags, policies)
- CI workflows e scripts de validação
- Métricas “alvo” (targets), quando marcadas como alvo e não como medição real

### 1.3 Evidência em modo seguro
- Resumos em “hash-only” (sem payload bruto)
- Referência para evidência completa no GNDrive (caminho/URI)
- Exemplo de hash em hex (64 chars), sem colar qualquer credencial

## 2) Não pode ir para o repo (proibido)
### 2.1 Segredos e credenciais
- Tokens, chaves, segredos, cookies, session ids
- Arquivos de ambiente com valores (ex.: *.env com conteúdo real)
- Qualquer coisa que permita autenticar em serviços

### 2.2 Runtime e estado vivo (sempre fora do Git)
- Pasta runtime inteira (receipts diários, logs, filas, cache, backups)
- Banco local do gateway (SQLite) e arquivos de sincronização
- Qualquer artefato gerado continuamente pelo scheduler

### 2.3 Dados pessoais e conteúdo bruto sensível
- Payloads de mensagens (WhatsApp/Telegram) com dados pessoais
- Logs com texto bruto do usuário
- Capturas de tela que mostrem dados pessoais ou segredos

## 3) Onde cada coisa mora
### 3.1 Repo (GitHub)
- SSOT: docs/ssot/CANON/
- Registries: registries/
- Schemas: schemas/
- Validators: scripts/validators/
- CI: .github/workflows/

### 3.2 VPS (fora do Git)
- Runtime: /var/lib/nanucai/runtime/gn_drive/
- Segredos: /etc/nanucai/gateway.env (chmod 600)

### 3.3 Local (Mac/Windows/Linux, fora do Git)
- Runtime local: ./runtime/ (ignorando no Git)
- Segredos locais: .vault/ (ignorando no Git)

## 4) Regra simples de decisão
Se o conteúdo tiver:
- segredo, credencial, token, cookie, dado pessoal, payload bruto, logs brutos, estado vivo
→ fica fora do Git.

Se for:
- especificação, contrato, registry, schema, validator, CI, documentação comparativa
→ pode ir para o Git.

## 5) “Documento da Claude” no repo
Permitido, desde que:
- seja modelagem e specs (GitHubOps, memória, plugins, métricas, arquitetura)
- não inclua tokens, prints com segredos, nem dados pessoais
- se mencionar evidência, use referência GNDrive + hash em hex

Assinatura: NANUCAI SSOT Tribunal
