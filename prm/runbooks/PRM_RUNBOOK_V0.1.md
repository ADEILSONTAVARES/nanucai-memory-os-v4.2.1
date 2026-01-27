# PrM Runbook v0.1 (OG10)

## Princípio
- Nada existe fora do SSOT (GitHub)
- Toda mudança: patch -> apply -> doctor -> evidence -> commit -> push

## Ações
1) Gerar patch a partir de edição:
   - Crie um arquivo temporário com o conteúdo final: /tmp/new.txt
   - Rode:
     prm/actions/prm_make_patch_from_edit.sh <file> /tmp/new.txt
   - Ele retorna o caminho do patch (em /tmp/...)

2) Aplicar patch com evidência:
   - prm/actions/prm_apply_patchfile.sh /tmp/prm_patch_*.diff "feat(prm): ..."

3) Commit/push com gate:
   - prm/actions/prm_commit_push.sh "chore(prm): ..."

## Evidências
- Mouse registra em: ssot/evidence/mouse_apply_*.log
- Doctor Fast é obrigatório.
