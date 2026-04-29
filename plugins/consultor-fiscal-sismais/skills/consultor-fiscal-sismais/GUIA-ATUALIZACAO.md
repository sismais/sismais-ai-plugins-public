# Guia de Atualização da Base de Documentos

Instruções para a IA buscar, verificar e baixar documentos oficiais do Portal da NF-e e manter a base `doc_sources/` atualizada.

## Fontes oficiais

| Portal | URL | Conteúdo |
|--------|-----|----------|
| Portal NF-e – Notas Técnicas | https://www.nfe.fazenda.gov.br/portal/listaConteudo.aspx?tipoConteudo=04BIflQt1aY= | NTs vigentes e não vigentes |
| Portal NF-e – Informes Técnicos | https://www.nfe.fazenda.gov.br/portal/listaConteudo.aspx?tipoConteudo=GkYFsaqVOIQ= | Informes técnicos |
| Portal NF-e – Manuais | https://www.nfe.fazenda.gov.br/portal/listaConteudo.aspx?tipoConteudo=ndIjl+iEFdE= | MOC, Anexos, manuais diversos |
| Portal NF-e – Schemas XML | https://www.nfe.fazenda.gov.br/portal/listaConteudo.aspx?tipoConteudo=BMPFMBoln3w= | Pacotes de liberação XSD |
| ACBr – SVN Schemas NFe | `svn://svn.code.sf.net/p/acbr/code/trunk2/Exemplos/ACBrDFe/Schemas/NFe` | XSDs atualizados da NF-e/NFC-e (fonte preferida) |
| CONFAZ | https://www.confaz.fazenda.gov.br | Atos COTEPE, Ajustes SINIEF |

## Como a Sefaz organiza os documentos

### Numeração das Notas Técnicas

Formato: **NT ANO.NNN vX.YY**

- **ANO** – ano de criação da série (ex.: 2025)
- **NNN** – sequencial no ano (001, 002, 003...)
- **vX.YY** – versão (v1.00, v1.01, v1.10, v1.20...)

Cada nova versão **substitui** a anterior da mesma série. Ex.: NT 2025.002 v1.34 substitui v1.33.

Uma NT pode também **substituir outra NT diferente**. Ex.: NT 2025.002 v1.00 substituiu RT NT 2024.002 v1.10.

### Seções do portal

Desde 11/10/2022 a página de NTs tem duas seções:

- **Documentos vigentes** – versões em uso (as que importam para a base)
- **Documentos não vigentes** – versões históricas (guardar em `doc_sources/historico/`)

### Informe Técnico vs Nota Técnica

| Tipo | Propósito | Impacto |
|------|-----------|---------|
| **Nota Técnica (NT)** | Altera leiaute, regras de validação, campos, schemas | Alto – exige mudança no sistema |
| **Informe Técnico (IT)** | Atualiza tabelas (NCM, CFOP, cBenef), comunica orientações | Médio – exige atualização de tabelas |
| **NT Conjunta** | Afeta múltiplos DFe (NF-e + CT-e + MDF-e etc.) | Alto – verificar impacto cruzado |
| **RT (Reforma Tributária)** | Prefixo para NTs da reforma (IBS/CBS) | Alto – campos e regras novos |

---

## Procedimento de atualização (para a IA)

Quando o usuário pedir para atualizar/buscar documentos, siga este procedimento passo a passo.

### Passo 1 – Navegar no portal e capturar os links

1. Usar `browser_navigate` para abrir a URL da página de Notas Técnicas:
   ```
   https://www.nfe.fazenda.gov.br/portal/listaConteudo.aspx?tipoConteudo=04BIflQt1aY=
   ```

2. Usar `browser_snapshot` para capturar a estrutura da página.

3. **Identificar a seção "Documentos vigentes"** no snapshot. A página tem duas seções:
   - Links **antes** do texto "Documentos não vigentes" → são **vigentes**
   - Links **depois** desse texto → são **não vigentes** (ignorar para `notas_tecnicas/`)

4. Extrair de cada link vigente:
   - **Texto do link** (ex.: `Nota Técnica 2025.002 v.1.34 - Publicada em 04/12/2025`)
   - **href** (ex.: `exibirArquivo.aspx?conteudo=XXXX`)

### Passo 2 – Montar a URL de download e o nome do arquivo

Cada link aponta para `exibirArquivo.aspx?conteudo=<ID>`. A URL completa fica:

```
https://www.nfe.fazenda.gov.br/portal/exibirArquivo.aspx?conteudo=<ID>
```

**Convenção de nomes:**

| Padrão do texto | Nome do arquivo |
|-----------------|-----------------|
| `Nota Técnica AAAA.NNN v.X.YY` | `NT_AAAA.NNN_vX.YY.pdf` |
| `Nota Técnica Conjunta AAAA.NNN` | `NTC_AAAA.NNN.pdf` |
| `Nota Técnica NFC-e AAAA.NNN v.X.YY` | `NT_AAAA.NNN_vX.YY.pdf` |
| RT / Reforma Tributária | **Ignorar** – já foram substituídas por NTs regulares |

Exemplos de parsing:
- `"Nota Técnica 2019.001.v.1.70"` → `NT_2019.001_v1.70.pdf`
- `"Nota Técnica 2025.002 v.1.34"` → `NT_2025.002_v1.34.pdf`
- `"Nota Técnica 2014.002 - v.1.30"` → `NT_2014.002_v1.30.pdf`
- `"Nota Técnica Conjunta 2025.001"` → `NTC_2025.001.pdf`
- `"Nota Técnica 2020.003 - v.1.00"` → `NT_2020.003_v1.00.pdf`
- Texto sem versão: `"Nota Técnica 2013.008"` → `NT_2013.008.pdf`

### Passo 3 – Comparar com a base local

Antes de baixar, verificar o que já existe em `doc_sources/notas_tecnicas/`:

1. Listar arquivos existentes na pasta.
2. Comparar com a lista de vigentes do portal.
3. Identificar:
   - **Novos** – NTs que não existem na base local
   - **Atualizados** – NTs com versão superior na base (mover versão antiga para `historico/`)
   - **Já existentes** – pular

### Passo 4 – Baixar os PDFs

**IMPORTANTE:** O portal bloqueia requisições diretas (403 Forbidden). Usar o browser MCP:

Para cada NT nova/atualizada:

1. Usar `browser_navigate` para a URL de download: `https://www.nfe.fazenda.gov.br/portal/exibirArquivo.aspx?conteudo=<ID>`
2. O browser vai abrir/baixar o PDF.
3. Salvar o arquivo na pasta correta com o nome padronizado.

**Alternativa via Shell** (se o browser não conseguir baixar PDFs diretamente):

```powershell
# Usar Invoke-WebRequest com headers de browser
Invoke-WebRequest -Uri "URL" -OutFile "caminho/arquivo.pdf" -Headers @{
    "Referer" = "https://www.nfe.fazenda.gov.br/portal/listaConteudo.aspx?tipoConteudo=04BIflQt1aY="
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
}
```

Se também der 403, usar `curl`:

```bash
curl -L -o "caminho/arquivo.pdf" \
  -H "Referer: https://www.nfe.fazenda.gov.br/portal/listaConteudo.aspx?tipoConteudo=04BIflQt1aY=" \
  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)" \
  "URL_DO_PDF"
```

### Passo 5 – Organizar na base

| Documento | Destino |
|-----------|---------|
| NT vigente (última versão) | `doc_sources/notas_tecnicas/` |
| IT vigente | `doc_sources/informes_tecnicos/` |
| MOC / Anexos | `doc_sources/manuais/` |
| Tabelas (NCM, CFOP, cBenef...) | `doc_sources/tabelas/` |
| Schemas XSD | `doc_sources/esquemas_xml/` |
| Versão antiga substituída | Mover para `doc_sources/historico/` |

### Passo 6 – Atualizar o catálogo

Após incluir novos documentos, atualizar `CATALOGO-DOCUMENTOS.md`:

- Adicionar/atualizar entrada com: arquivo, documento, data de publicação, descrição
- Atualizar seção "Status da Base" com data da verificação
- Se uma versão antiga foi substituída, mover a entrada para seção de histórico

---

## Procedimento para Informes Técnicos e Manuais

As páginas de Informes e Manuais seguem o mesmo padrão de navegação. Repetir o procedimento acima com as URLs correspondentes:

- **Informes:** `tipoConteudo=GkYFsaqVOIQ=`
- **Manuais:** `tipoConteudo=ndIjl+iEFdE=`
- **Schemas:** `tipoConteudo=BMPFMBoln3w=`

Adaptar o filtro de texto e a convenção de nomes:

| Tipo | Filtro no texto do link | Nome do arquivo |
|------|------------------------|-----------------|
| Informe Técnico | Contém "Informe" | `IT_AAAA.NNN_vX.YY.pdf` |
| MOC | Contém "MOC" ou "Manual de Orientação" | `MOC_vX.Y.pdf` |
| Anexo MOC | Contém "Anexo" | `MOC_AnexoN_vX.Y.pdf` |
| Schema/Pacote | Contém "Pacote" ou "Schema" | Nome original do ZIP |

---

## Armadilhas comuns

1. **NTs com "Corrigido" no nome** – republicação da mesma versão com correções; substitui o PDF anterior na base
2. **NTs de tabela NCM (série 2016.003)** – substituídas pelo Informe Técnico 2025.002 a partir de v.3.70; verificar se IT não substituiu a NT
3. **RT (Reforma Tributária)** – NTs com prefixo RT foram absorvidas por NTs regulares; ex: RT NT 2024.002 → NT 2025.002. **Não baixar RTs.**
4. **Datas de vigência diferentes para homologação e produção** – verificar ambas as datas no texto da NT
5. **NTs que afetam apenas NFC-e** – ex: NT 2023.002 (NFC-e por Produtor Rural); separar impacto por modelo (55 vs 65)
6. **Seção "Documentos não vigentes"** – NUNCA baixar documentos desta seção para `notas_tecnicas/`. Se baixar, devem ir para `historico/`.

## Atualização dos Schemas XML (XSD)

### Pré-requisito: SVN CLI

A atualização dos schemas requer o cliente SVN de linha de comando. Antes de executar, verificar se está disponível:
```bash
svn --version --quiet
```
Se o comando falhar, pedir ao usuário para instalar:
- **Windows:** `winget install TortoiseSVN.TortoiseSVN` (inclui svn CLI) ou `choco install svn`
- **macOS:** `brew install subversion`
- **Linux:** `sudo apt install subversion`

### Fonte primária: SVN do ACBr

O projeto ACBr mantém os schemas XSD da NF-e/NFC-e sempre atualizados no SVN. Esta é a fonte preferida para atualização dos schemas porque o ACBr já organiza e valida os XSDs antes de publicar.

**Repositório SVN:**
```
svn://svn.code.sf.net/p/acbr/code/trunk2/Exemplos/ACBrDFe/Schemas/NFe
```

### Procedimento de atualização dos schemas

Usa-se `svn checkout` (primeira vez) ou `svn update` (vezes seguintes). O SVN retorna o status de cada arquivo (A=adicionado, U=atualizado, D=removido), o que permite saber exatamente o que mudou.

1. **Primeira vez — checkout:**
   ```bash
   svn checkout svn://svn.code.sf.net/p/acbr/code/trunk2/Exemplos/ACBrDFe/Schemas/NFe \
     "<caminho-desta-skill>/doc_sources/esquemas_xml/NFe_NFCe/"
   ```

2. **Atualizações seguintes — update** (executar dentro da pasta):
   ```bash
   cd "<caminho-desta-skill>/doc_sources/esquemas_xml/NFe_NFCe/"
   svn update
   ```
   O output mostra o status de cada arquivo:
   - `A` = arquivo novo (adicionado)
   - `U` = arquivo atualizado (conteúdo modificado)
   - `D` = arquivo removido
   - Sem prefixo = sem alteração

   Informar ao usuário quais arquivos foram alterados/adicionados/removidos.

3. **Verificar log recente** (opcional, para contexto das mudanças):
   ```bash
   svn log -l 5 svn://svn.code.sf.net/p/acbr/code/trunk2/Exemplos/ACBrDFe/Schemas/NFe
   ```

> **Nota:** Se a pasta local não tiver metadados `.svn` (foi populada via `svn export` ou cópia manual), fazer um checkout limpo para uma pasta temporária e copiar os arquivos, ou remover a pasta e fazer checkout do zero.

### Fonte alternativa: Portal da NF-e

Se o SVN do ACBr estiver indisponível, os schemas também podem ser obtidos no Portal da NF-e na página de Schemas XML:
```
https://www.nfe.fazenda.gov.br/portal/listaConteudo.aspx?tipoConteudo=BMPFMBoln3w=
```
Os schemas do portal vêm dentro de Pacotes de Liberação (ZIP). Seguir o mesmo procedimento de navegação e download descrito nos passos 1-5 acima.

### Quando atualizar schemas

- Sempre que uma NT de leiaute for publicada (ex: NT 2018.005, NT 2023.004, NT 2025.002)
- Quando houver rejeição de schema na emissão que possa indicar XSD desatualizado
- A critério do usuário, como verificação periódica

---

## Frequência recomendada

| Check | Frequência | Motivo |
|-------|------------|--------|
| Notas Técnicas | Semanal | Publicações frequentes, especialmente em períodos de reforma |
| Informes Técnicos | Quinzenal | Atualizações de tabelas (NCM tem datas de vigência) |
| Manuais (MOC) | Mensal | Atualizações menos frequentes |
| Schemas XML | A cada NT de leiaute | Atualizar via SVN ACBr ou Portal NF-e |
