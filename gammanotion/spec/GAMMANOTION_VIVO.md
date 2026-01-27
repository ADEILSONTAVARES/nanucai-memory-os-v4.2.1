# GammaNotion Vivo — OG10 Spec (v0.1)

## Objetivo
Ser o ambiente vivo do NANUCAI: páginas, cards, biblioteca e painéis, com navegação simples e export SSOT.

## Regras
- Tudo versionado no SSOT
- Links importantes entram em gndrive/links/links_index.md
- Mouse Inteligente atua sobre blocos (UI e código) via diffs

## Navegação (menu)
- Home (boas-vindas + status do projeto)
- SSOT (documentos canônicos OG10)
- PrM (ações, runbooks, checkpoints)
- GNDrive (links, manifests, exports)
- Biblioteca (placeholder)
- Suporte (placeholder)
- Settings (idiomas, perfis)

## Cards (modelo)
Campos mínimos:
- id, title, type, tags[], updated_at
- source_path (arquivo no repo) ou url
- actions[] (abrir, editar, exportar, rodar doctor)

## Integração SSOT
- `gndrive/manifest/gn_manifest.json` é o índice mestre
- `doctor/doctor_fast.sh` é gate obrigatório
