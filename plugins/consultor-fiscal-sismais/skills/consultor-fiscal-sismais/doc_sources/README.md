# doc_sources – Base de Documentos Fiscais

Repositório local de documentos oficiais da Sefaz para consulta pelo agente fiscal.

## Estrutura

```
doc_sources/
├── notas_tecnicas/     # Notas Técnicas vigentes (última versão de cada série)
├── informes_tecnicos/  # Informes Técnicos vigentes
├── manuais/            # MOC, Anexos I-IV, manuais diversos
├── tabelas/            # NCM, CFOP, CST, cBenef, cClassTrib (CSV/JSON/Excel)
├── esquemas_xml/       # Schemas XSD (Pacotes de Liberação)
└── historico/          # Versões antigas/substituídas (não usar para respostas)
```

## Convenção de nomes

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Nota Técnica | `NT_AAAA.NNN_vX.YY.pdf` | `NT_2025.002_v1.34.pdf` |
| NT Conjunta | `NTC_AAAA.NNN_vX.YY.pdf` | `NTC_2025.001.pdf` |
| RT (Reforma Trib.) | `RT_NT_AAAA.NNN_vX.YY.pdf` | `RT_NT_2024.002_v1.10.pdf` |
| Informe Técnico | `IT_AAAA.NNN_vX.YY.pdf` | `IT_2025.002_v1.40.pdf` |
| Manual | `MOC_vX.Y.pdf` | `MOC_v7.0.pdf` |
| Anexo MOC | `MOC_AnexoN_vX.Y.pdf` | `MOC_Anexo1_v7.0.pdf` |
| Tabela | `TAB_<nome>_AAAA-MM.<ext>` | `TAB_NCM_2025-12.csv` |
| Schema | `<nome>_vX.YY.xsd` | `nfe_v4.00.xsd` |

## Regras

1. Manter apenas **uma versão** de cada documento (a vigente)
2. Ao atualizar, mover a versão anterior para `historico/`
3. Atualizar `CATALOGO-DOCUMENTOS.md` após cada inclusão/remoção
4. A pasta `historico/` não é consultada pelo agente para respostas

## Dependências para pesquisa

Instaladas automaticamente pelo script `scripts/pesquisar_docs.py` na primeira execução (pdfplumber, openpyxl).
