# Mouse Inteligente — OG10 Spec (v0.1)

## Objetivo
Permitir editar qualquer coisa (UI/código/texto) com ações guiadas e patches auditáveis.

## Ações v0.1
1) select_target: aponta um arquivo + intervalo (linhas) ou caminho lógico
2) propose_patch: gera patch unificado (diff) + justificativa curta
3) apply_patch: aplica patch, roda Doctor Fast, registra evidência
4) undo_patch: reverte último patch (git revert/reset) com evidência

## Regras
- Sempre gerar patch em formato unificado
- Sempre registrar evidência em ssot/evidence/
- Doctor Fast obrigatório após aplicar patch
