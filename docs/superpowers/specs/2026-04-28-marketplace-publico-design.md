# Marketplace Público de Plugins de IA Sismais — Design

**Data:** 2026-04-28
**Repo:** `sismais/sismais-ai-plugins` (público)
**Status:** Aprovado para implementação

## Contexto e objetivo

A Sismais quer distribuir skills, agents, slash commands e MCP servers para IAs (começando por Claude Code) através de um marketplace próprio. Conteúdo público (clientes Sismais + comunidade externa) e conteúdo interno (time Sismais, incluindo não-devs de marketing e suporte) precisam de canais separados.

Este documento especifica o **marketplace público** (`sismais-ai-plugins`). Um marketplace privado paralelo (`sismais-ai-plugins-internal`) será criado depois e seguirá as mesmas convenções; o onboarding deste repo já antecipa essa adição.

Decisões fundamentais já tomadas:

- **Dois repos separados**, não monorepo. Claude Code resolve marketplace = 1 repo, então misturar público e privado num só não funciona.
- **Plugins em `plugins/<nome>/`**, não na raiz. Convenção do marketplace oficial (`claude-plugins-official`) e mantém raiz limpa para infra (scripts, CI, docs).
- **Sem build/gerador**: plugins são markdown + JSON puros, instalados diretamente pelo Claude Code. Multi-IA (Cursor, Copilot, Gemini) é fora do escopo da v1.

## Escopo da v1

### Dentro

1. Estrutura do repo seguindo convenções do Claude Code (`.claude-plugin/marketplace.json`).
2. Plugin de exemplo `hello-sismais` — skill mínima que valida instalação ponta-a-ponta.
3. Plugin real `consultor-fiscal-sismais` — refatorado para o formato esperado (criação de `.claude-plugin/plugin.json`, mover `SKILL.md` para `skills/<nome>/SKILL.md`, remover artefatos `.svn/`).
4. Scripts de onboarding (`install.sh`, `install.ps1`) com one-liners.
5. CI de validação via GitHub Actions.
6. Documentação em português (README, CONTRIBUTING).
7. Arquivos auxiliares: LICENSE (MIT), `.gitignore`, `.gitattributes`.

### Fora (v2+)

- Marketplace privado `sismais-ai-plugins-internal` (repo separado, futuro).
- Suporte a outras IAs (Cursor, Copilot, Gemini).
- Distribuição dos `doc_sources/` via release/CDN (v1 mantém os 90 MB no repo, ver "Conteúdo pesado" abaixo).
- Plugins temáticos adicionais (`sismais-dev`, `sismais-marketing`, `sismais-suporte`) — virão depois.
- Onboarding com integração `gh auth` para repo privado.

## Estrutura do repo

```
sismais-ai-plugins/
├── .claude-plugin/
│   └── marketplace.json
├── plugins/
│   ├── hello-sismais/
│   │   ├── .claude-plugin/plugin.json
│   │   └── skills/hello-sismais/SKILL.md
│   └── consultor-fiscal-sismais/
│       ├── .claude-plugin/plugin.json
│       ├── skills/consultor-fiscal-sismais/SKILL.md
│       ├── doc_sources/                    # 90 MB, sem .svn/
│       ├── scripts/
│       │   ├── pesquisar_docs.py
│       │   └── requirements.txt
│       ├── CATALOGO-DOCUMENTOS.md
│       ├── GUIA-ATUALIZACAO.md
│       └── INDICE-REGRAS-CAMPOS.md
├── scripts/
│   ├── install.sh
│   ├── install.ps1
│   └── validate.mjs
├── .github/workflows/validate.yml
├── docs/superpowers/specs/                 # specs e planos
├── .claude/settings.json                   # já existe
├── README.md
├── CONTRIBUTING.md
├── LICENSE                                 # MIT
├── .gitignore
└── .gitattributes
```

### Convenções

- 1 plugin = 1 pasta em `plugins/`. O nome da pasta, o `name` em `plugin.json` e a entrada em `marketplace.json.plugins[].name` devem coincidir.
- Plugins temáticos futuros seguem o naming `sismais-<tema>` (ex: `sismais-dev`, `sismais-marketing`).
- `hello-sismais` é o template de referência para novos plugins.

## marketplace.json

`.claude-plugin/marketplace.json`:

```json
{
  "name": "sismais",
  "owner": {
    "name": "Sismais",
    "url": "https://github.com/sismais"
  },
  "metadata": {
    "description": "Marketplace público de plugins de IA da Sismais",
    "version": "0.1.0"
  },
  "plugins": [
    {
      "name": "hello-sismais",
      "source": "./plugins/hello-sismais",
      "description": "Plugin de exemplo — valida instalação e serve de template",
      "version": "0.1.0",
      "category": "example",
      "tags": ["example", "template"]
    },
    {
      "name": "consultor-fiscal-sismais",
      "source": "./plugins/consultor-fiscal-sismais",
      "description": "Consultor fiscal especialista em NF-e, NFC-e, NFS-e e tributação brasileira",
      "version": "0.1.0",
      "category": "fiscal",
      "tags": ["fiscal", "tributario", "nfe", "nfce", "nfse", "sefaz", "brasil"]
    }
  ]
}
```

## Plugins

### `hello-sismais` (exemplo)

**`plugins/hello-sismais/.claude-plugin/plugin.json`:**

```json
{
  "name": "hello-sismais",
  "version": "0.1.0",
  "description": "Plugin de exemplo da Sismais — valida instalação",
  "author": { "name": "Sismais" }
}
```

**`plugins/hello-sismais/skills/hello-sismais/SKILL.md`:**

Frontmatter mínimo + corpo curto, em português. A skill deve ativar quando o usuário perguntar "o sismais está instalado?", "testar plugin sismais", "validar marketplace sismais" ou similar, e responder confirmando o nome do marketplace, a versão do plugin e link para o README. O `description` no frontmatter lista os triggers em PT.

### `consultor-fiscal-sismais` (refatoração)

Plugin já existe na raiz do repo (em `consultor-fiscal-sismais/`) mas não está no formato esperado pelo Claude Code. Refatoração:

1. Mover `consultor-fiscal-sismais/` → `plugins/consultor-fiscal-sismais/`.
2. Criar `plugins/consultor-fiscal-sismais/.claude-plugin/plugin.json` com `name`, `version`, `description`, `author`.
3. Mover `SKILL.md` da raiz do plugin para `skills/consultor-fiscal-sismais/SKILL.md`. Frontmatter já existe e está adequado.
4. Atualizar referências internas no `SKILL.md` se necessário (a skill faz referência a `doc_sources/` "na mesma pasta deste SKILL.md" — após mover, essa pasta passa a ser `skills/consultor-fiscal-sismais/`, mas `doc_sources/` continua em `plugins/consultor-fiscal-sismais/doc_sources/`. A skill precisa apontar para o caminho correto, possivelmente usando um path relativo ao plugin root, não ao SKILL.md). Avaliar se mover `doc_sources/`, `CATALOGO-DOCUMENTOS.md`, etc., para dentro de `skills/consultor-fiscal-sismais/` é mais limpo, ou se ajustar a skill é mais simples.
5. Remover todas as pastas `.svn/` recursivamente de `doc_sources/`.
6. Verificar que `scripts/pesquisar_docs.py` ainda funciona após o move (ajustar paths se necessário).

A decisão sobre onde fica `doc_sources/` (dentro de `skills/<name>/` ou no plugin root) é uma decisão de implementação a ser resolvida no plano. Ambos funcionam; o que importa é que a skill consiga encontrar os documentos consistentemente.

## Conteúdo pesado (`doc_sources`)

V1 mantém os ~90 MB de PDFs/XSDs no repo. Trade-off aceito: simplicidade > tamanho do clone. Mitigações na v1:

- Remover todas as pastas `.svn/` (artefatos de checkout SVN dos schemas Sefaz).
- `.gitattributes` marca PDFs e XSDs como binário (`*.pdf binary`, `*.xsd text eol=lf`).
- Documentar no CONTRIBUTING que adições a `doc_sources/` devem ser feitas via PR e revisadas para evitar bloat acidental.

V2 deve migrar para distribuição via GitHub Release ou CDN, com a skill baixando para cache local na primeira execução. Critério para acionar v2: repo passar de ~250 MB ou mais de 3 plugins precisarem de corpus pesado.

## Onboarding scripts

### Localização e formato

- `scripts/install.sh` — bash, para Linux/Mac.
- `scripts/install.ps1` — PowerShell, para Windows.

### One-liners (documentados no README)

- Linux/Mac: `curl -fsSL https://raw.githubusercontent.com/sismais/sismais-ai-plugins/main/scripts/install.sh | bash`
- Windows: `iwr -useb https://raw.githubusercontent.com/sismais/sismais-ai-plugins/main/scripts/install.ps1 | iex`

### Fluxo

1. **Pré-checagem:** verifica se Claude Code está instalado (`claude --version`). Se não, mostra link para instalar e sai com código 1.
2. **Adicionar marketplace público:** registra o marketplace `sismais/sismais-ai-plugins`. Se já estiver adicionado, segue (idempotente).
3. **Pergunta sobre interno:** "Você é membro do time Sismais? (s/N)". Se sim, mostra instruções para adicionar o marketplace privado quando ele existir (na v1 não roda nada — só informa).
4. **Seleção de plugins:** lista os plugins do marketplace público com checkboxes (multi-select). Default: `hello-sismais` marcado.
5. **Instalação:** para cada selecionado, instala o plugin a partir do marketplace `sismais`.
6. **Mensagem final:** "Pronto. Abra o Claude Code e digite `/help` para ver comandos disponíveis."

### Mecanismo de adição/instalação

O modo exato de adicionar marketplace e instalar plugin via shell precisa ser confirmado no plano de implementação. Possibilidades:

- **CLI direta** (se `claude` expõe subcommands `plugin marketplace add` / `plugin install` em modo headless).
- **Edição de `~/.claude/settings.json`** programática para acrescentar o marketplace e habilitar plugins (mecanismo confiável, mas mais invasivo).
- **Flag `--add-marketplace` no startup** do `claude`.

O plano deve testar essas alternativas e escolher a mais robusta antes de codar o script. Default sugerido se houver dúvida: edição de `settings.json` (sob backup), por ser determinística e independer de capacidades do CLI que podem mudar entre versões.

### Princípios

- **Idempotente:** rodar de novo não quebra. Verifica estado antes de cada ação.
- **Mensagens em português**, com indicadores visuais (`✔`/`✗`).
- **Falha graciosa:** em caso de erro, mostra mensagem clara em PT, sem stack trace bruto. Sai com código não-zero.
- **Sem dependências externas** além do que o usuário já tem (bash/PS, `claude` CLI, `curl`/`iwr`).
- **Sem `gh auth` na v1** — esse passo só será necessário quando o marketplace privado existir.

## CI de validação

`.github/workflows/validate.yml` — dispara em `push` e `pull_request`.

### Validações

1. **Sintaxe JSON:** `marketplace.json` e todos os `plugin.json` parseiam.
2. **Schema:** `marketplace.json` tem `name`, `owner`, `plugins[]`. Cada item de `plugins[]` tem `name`, `source`, `version`, `description`. Cada `plugin.json` tem `name`, `version`.
3. **Consistência marketplace ↔ plugin:** para cada entrada em `plugins[]`, a pasta apontada por `source` existe e o `plugin.json` lá dentro tem o mesmo `name`.
4. **Frontmatter de skills:** para cada `plugins/*/skills/*/SKILL.md`, o frontmatter YAML é parseável e contém `name` + `description`.
5. **Sem `.svn/`:** falha se qualquer pasta `.svn/` for encontrada (regressão).

### Implementação

Um único script Node `scripts/validate.mjs`, sem dependências npm (usa apenas `node:fs`, `node:path` e parsing manual mínimo de YAML para frontmatter — frontmatter de skill é simples e plano). Workflow roda `node scripts/validate.mjs` numa GitHub-hosted runner. Sai com código não-zero em qualquer falha; mensagens são humanas e indicam o arquivo problemático.

Razão de não usar `npm install`: validação é simples; evita 30+ segundos de instalação por run, e evita lock files num repo que de outra forma não tem dependências Node.

## Documentação

### `README.md`

Em português, contém:

1. O que é o marketplace (parágrafo curto).
2. Como instalar:
   - Pré-requisito: Claude Code instalado (link).
   - Comando one-liner para Linux/Mac e Windows.
   - Alternativa manual (3 comandos).
3. Tabela de plugins disponíveis: nome, descrição, categoria, link para a pasta do plugin.
4. Como contribuir: link para `CONTRIBUTING.md`.
5. Licença, contato.

### `CONTRIBUTING.md`

Em português, contém:

1. Como adicionar um novo plugin: copiar `hello-sismais` como template, ajustar nomes, adicionar conteúdo, registrar em `marketplace.json`.
2. Convenções de naming: `sismais-<tema>` para temáticos.
3. Como testar localmente: instalar o marketplace por path local (`./caminho/para/sismais-ai-plugins`) e instalar o plugin a partir desse marketplace. Comando exato confirmado durante a implementação.
4. Checklist de revisão antes de abrir PR (CI verde, README do plugin presente, etc.).

### `LICENSE`

MIT. Texto padrão SPDX.

### `.gitignore`

Padrão para projetos mistos: `node_modules/`, `__pycache__/`, `*.pyc`, `.venv/`, `.vscode/`, `.idea/`, `.DS_Store`, `Thumbs.db`, `*.log`.

### `.gitattributes`

- `*.pdf binary`
- `*.xsd text eol=lf`
- `*.sh text eol=lf`
- `*.ps1 text eol=crlf`
- `*.md text eol=lf`

## Riscos e mitigações

- **Repo cresce muito** com adições futuras a `doc_sources/`. Mitigação: monitorar tamanho; v2 migra para release/CDN quando passar de 250 MB ou mais de 3 plugins precisarem de corpus.
- **Onboarding script falha em ambiente Windows com restrições de execution policy.** Mitigação: documentar `Set-ExecutionPolicy -Scope Process Bypass` como fallback no README. O one-liner com `iex` já contorna parcialmente.
- **Path do `doc_sources/` quebra após mover skill para `skills/<name>/`.** Mitigação: tratado explicitamente na refatoração (seção "consultor-fiscal-sismais"); a decisão de path é parte do plano de implementação.
- **Plugin de exemplo não dispara automaticamente.** Mitigação: skill description rica em triggers ("test sismais plugin", "is sismais installed", "/hello-sismais"); usuário pode forçar via skill manual invocation.
- **Validação de CI quebra com mudanças no Claude Code marketplace schema.** Mitigação: testes manuais antes de bumping versão; CI valida estrutura mínima estável, não schema completo.

## Critérios de aceitação da v1

1. Em uma máquina limpa com Claude Code instalado, rodar o one-liner do README adiciona o marketplace e instala `hello-sismais` com sucesso.
2. Com `hello-sismais` instalado, perguntar ao Claude "test sismais plugin" dispara a skill e ela responde confirmando instalação.
3. Com `consultor-fiscal-sismais` instalado, perguntar uma questão fiscal típica (ex: "qual a NT vigente para NF-e?") dispara a skill e ela pesquisa em `doc_sources/`.
4. CI passa verde em `main`.
5. README e CONTRIBUTING estão completos e em português.
6. Repo não contém pastas `.svn/`.
