# Marketplace Público Sismais — Plano de Implementação

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implementar a v1 do marketplace público `sismais-ai-plugins` (Claude Code), contendo o plugin de exemplo `hello-sismais`, o plugin real `consultor-fiscal-sismais` refatorado para o formato esperado, scripts de onboarding cross-platform, CI de validação e documentação em português.

**Architecture:** Repo Git público no padrão de marketplace do Claude Code (`.claude-plugin/marketplace.json` + pasta `plugins/<nome>/` por plugin). Onboarding via one-liner que chama `install.sh`/`install.ps1`; CI via GitHub Actions roda um validador Node sem dependências. Sem build/gerador — plugins são markdown + JSON puros.

**Tech Stack:** Markdown (skills), JSON (manifestos), Bash, PowerShell, Node.js (validador, sem deps), GitHub Actions, Git.

**Spec:** [docs/superpowers/specs/2026-04-28-marketplace-publico-design.md](../specs/2026-04-28-marketplace-publico-design.md)

---

## Decisões de implementação congeladas

Algumas decisões deixadas em aberto pelo spec foram resolvidas para este plano:

1. **Localização do `doc_sources/` no `consultor-fiscal-sismais`:** todo o material da skill (`doc_sources/`, `scripts/`, `CATALOGO-DOCUMENTOS.md`, `GUIA-ATUALIZACAO.md`, `INDICE-REGRAS-CAMPOS.md`) **fica dentro de `plugins/consultor-fiscal-sismais/skills/consultor-fiscal-sismais/`**, sibling de `SKILL.md`. Razão: preserva a semântica original ("doc_sources fica na mesma pasta deste SKILL.md") sem precisar reescrever a skill, e mantém o plugin root limpo (apenas `.claude-plugin/` + `skills/`).

2. **Mecanismo de adição de marketplace nos scripts:** **edição programática de `~/.claude/settings.json`**, sob backup. Razão: determinístico, independe de subcommands do CLI (que podem variar entre versões do Claude Code), e o arquivo já tem schema documentado (`enabledPlugins` etc.). A Tarefa 7 valida essa decisão antes de codar os scripts; se o engenheiro descobrir que existe um CLI estável (`claude plugin marketplace add ...`), pode trocar — mas a edição de JSON é o fallback seguro.

3. **Conteúdo da skill `hello-sismais`:** texto curto em PT, descrição com triggers PT, sem código adicional.

---

## Mapa de arquivos

**Criados:**

- `.claude-plugin/marketplace.json` — manifesto do marketplace
- `plugins/hello-sismais/.claude-plugin/plugin.json` — manifesto do plugin de exemplo
- `plugins/hello-sismais/skills/hello-sismais/SKILL.md` — skill de exemplo
- `plugins/consultor-fiscal-sismais/.claude-plugin/plugin.json` — manifesto do plugin fiscal
- `scripts/install.sh` — onboarding bash
- `scripts/install.ps1` — onboarding PowerShell
- `scripts/validate.mjs` — validador Node
- `tests/validate.test.mjs` — testes do validador (Node test runner builtin)
- `tests/fixtures/...` — fixtures pra testes de validador
- `.github/workflows/validate.yml` — CI
- `README.md` — documentação principal em PT
- `CONTRIBUTING.md` — guia de contribuição em PT
- `LICENSE` — MIT
- `.gitignore`
- `.gitattributes`

**Movidos/refatorados:**

- `consultor-fiscal-sismais/` → `plugins/consultor-fiscal-sismais/skills/consultor-fiscal-sismais/` (todo o conteúdo)
- Pastas `.svn/` recursivas em `doc_sources/esquemas_xml/NFe_NFCe/` → **removidas**

**Já existentes (não tocar exceto se indicado):**

- `.claude/settings.json` — já habilita `agent-sdk-dev@claude-plugins-official`; ok como está
- `docs/superpowers/specs/2026-04-28-marketplace-publico-design.md` — spec aprovado

---

## Convenções deste plano

- **Working directory:** `d:/Sismais/Fontes/sismais-ai-plugins/` (Windows). Comandos shell no plano usam sintaxe Unix; o engenheiro adapta para PowerShell quando necessário (p.ex. `mkdir -p` → `New-Item -ItemType Directory -Force`).
- **Idioma:** mensagens visíveis ao usuário (skills, scripts, README, CONTRIBUTING) em PT. Nomes de arquivos, código e mensagens de commit em EN.
- **Commits:** após cada tarefa concluída, mensagem em formato `tipo: descrição` (ex: `feat:`, `chore:`, `docs:`, `test:`, `fix:`).
- **Não publicar nada no GitHub** durante este plano; o repo é local até a Tarefa 12 ditar push.

---

## Task 1: Inicializar Git e arquivos de base

**Files:**

- Create: `.gitignore`
- Create: `.gitattributes`
- Create: `LICENSE`

- [ ] **Step 1: Inicializar repositório git**

```bash
git -C "d:/Sismais/Fontes/sismais-ai-plugins" init -b main
```

Expected: `Initialized empty Git repository in d:/Sismais/Fontes/sismais-ai-plugins/.git/`. Se já houver `.git/`, pular.

- [ ] **Step 2: Criar `.gitignore`**

Criar `d:/Sismais/Fontes/sismais-ai-plugins/.gitignore` com:

```
# Node
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Python
__pycache__/
*.pyc
*.pyo
.venv/
venv/

# IDE
.vscode/
.idea/
*.swp

# OS
.DS_Store
Thumbs.db

# Logs
*.log

# Local config (mas mantém .claude/ versionado pois settings é compartilhado)
```

- [ ] **Step 3: Criar `.gitattributes`**

Criar `d:/Sismais/Fontes/sismais-ai-plugins/.gitattributes` com:

```
# Garante line endings consistentes
*.md text eol=lf
*.json text eol=lf
*.mjs text eol=lf
*.yml text eol=lf
*.yaml text eol=lf
*.sh text eol=lf
*.ps1 text eol=crlf
*.py text eol=lf

# Binários
*.pdf binary
*.png binary
*.jpg binary
*.jpeg binary
*.zip binary
*.gz binary

# Schemas XSD são texto, mas mantém eol=lf
*.xsd text eol=lf
*.xml text eol=lf
```

- [ ] **Step 4: Criar `LICENSE`**

Criar `d:/Sismais/Fontes/sismais-ai-plugins/LICENSE` com texto MIT padrão:

```
MIT License

Copyright (c) 2026 Sismais

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

- [ ] **Step 5: Verificar status e commitar**

```bash
git -C "d:/Sismais/Fontes/sismais-ai-plugins" status
```

Expected: lista untracked files incluindo `.gitignore`, `.gitattributes`, `LICENSE`, `.claude/settings.json`, `consultor-fiscal-sismais/`, `docs/`.

```bash
git -C "d:/Sismais/Fontes/sismais-ai-plugins" add .gitignore .gitattributes LICENSE .claude/settings.json docs/
git -C "d:/Sismais/Fontes/sismais-ai-plugins" commit -m "chore: initial repo skeleton with license and base config"
```

Expected: commit cria com 4+ arquivos. **Não** adicionar `consultor-fiscal-sismais/` ainda (é refatorado na Tarefa 5).

---

## Task 2: marketplace.json + plugin hello-sismais

**Files:**

- Create: `.claude-plugin/marketplace.json`
- Create: `plugins/hello-sismais/.claude-plugin/plugin.json`
- Create: `plugins/hello-sismais/skills/hello-sismais/SKILL.md`

- [ ] **Step 1: Criar marketplace.json com hello-sismais**

```bash
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/.claude-plugin"
```

Criar `d:/Sismais/Fontes/sismais-ai-plugins/.claude-plugin/marketplace.json`:

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
    }
  ]
}
```

(consultor-fiscal-sismais é adicionado na Tarefa 6, depois de refatorado.)

- [ ] **Step 2: Criar plugin.json do hello-sismais**

```bash
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/plugins/hello-sismais/.claude-plugin"
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/plugins/hello-sismais/skills/hello-sismais"
```

Criar `d:/Sismais/Fontes/sismais-ai-plugins/plugins/hello-sismais/.claude-plugin/plugin.json`:

```json
{
  "name": "hello-sismais",
  "version": "0.1.0",
  "description": "Plugin de exemplo da Sismais — valida instalação",
  "author": { "name": "Sismais" }
}
```

- [ ] **Step 3: Criar SKILL.md do hello-sismais**

Criar `d:/Sismais/Fontes/sismais-ai-plugins/plugins/hello-sismais/skills/hello-sismais/SKILL.md`:

```markdown
---
name: hello-sismais
description: Skill de exemplo da Sismais. Aciona quando o usuário pergunta "o sismais está instalado", "testar plugin sismais", "validar marketplace sismais", "verificar instalação do sismais", ou similar. Confirma que o marketplace público está configurado e o plugin de exemplo ativo.
---

# Hello, Sismais

Este é o plugin de exemplo do marketplace público da Sismais. Sua única função é confirmar que tudo está instalado corretamente.

Quando esta skill é acionada, responda ao usuário com:

1. Confirmação de que o marketplace `sismais` está configurado.
2. Versão deste plugin (0.1.0).
3. Link para o README: `https://github.com/sismais/sismais-ai-plugins`.
4. Sugestão de próximos passos (ex.: "explore os outros plugins do marketplace via `/plugin marketplace list`").

Mantenha a resposta curta e em português.
```

- [ ] **Step 4: Validar JSON manualmente**

```bash
node -e "JSON.parse(require('fs').readFileSync('d:/Sismais/Fontes/sismais-ai-plugins/.claude-plugin/marketplace.json','utf8'));console.log('marketplace.json OK')"
node -e "JSON.parse(require('fs').readFileSync('d:/Sismais/Fontes/sismais-ai-plugins/plugins/hello-sismais/.claude-plugin/plugin.json','utf8'));console.log('plugin.json OK')"
```

Expected: ambos imprimem `OK`. Se erro de JSON, corrigir antes de commitar.

- [ ] **Step 5: Commitar**

```bash
git -C "d:/Sismais/Fontes/sismais-ai-plugins" add .claude-plugin plugins/hello-sismais
git -C "d:/Sismais/Fontes/sismais-ai-plugins" commit -m "feat: add marketplace manifest and hello-sismais example plugin"
```

---

## Task 3: Validador Node (validate.mjs) com TDD

O validador é a única peça com lógica testável. Vamos seguir TDD: criar fixtures (cenários quebrados), escrever teste que espera o validador detectar o problema, depois implementar.

**Files:**

- Create: `tests/fixtures/valid/` (estrutura mínima válida)
- Create: `tests/fixtures/missing-marketplace/` (sem `.claude-plugin/marketplace.json`)
- Create: `tests/fixtures/bad-json/` (JSON inválido)
- Create: `tests/fixtures/missing-plugin-folder/` (entrada em marketplace.json aponta pra pasta inexistente)
- Create: `tests/fixtures/name-mismatch/` (plugin.json.name != marketplace.plugins[].name)
- Create: `tests/fixtures/skill-no-frontmatter/` (SKILL.md sem frontmatter YAML)
- Create: `tests/fixtures/has-svn/` (estrutura válida com pasta `.svn/` proibida)
- Create: `tests/validate.test.mjs` (testes Node builtin)
- Create: `scripts/validate.mjs` (validador)

- [ ] **Step 1: Criar fixture válida mínima**

```bash
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/tests/fixtures/valid/.claude-plugin"
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/tests/fixtures/valid/plugins/foo/.claude-plugin"
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/tests/fixtures/valid/plugins/foo/skills/foo"
```

`tests/fixtures/valid/.claude-plugin/marketplace.json`:

```json
{
  "name": "test",
  "owner": { "name": "Test" },
  "plugins": [
    { "name": "foo", "source": "./plugins/foo", "description": "Foo plugin", "version": "0.1.0" }
  ]
}
```

`tests/fixtures/valid/plugins/foo/.claude-plugin/plugin.json`:

```json
{ "name": "foo", "version": "0.1.0", "description": "Foo" }
```

`tests/fixtures/valid/plugins/foo/skills/foo/SKILL.md`:

```markdown
---
name: foo
description: Foo skill description for testing
---

# Foo

Body.
```

- [ ] **Step 2: Escrever teste para fixture válida (deve passar)**

Criar `d:/Sismais/Fontes/sismais-ai-plugins/tests/validate.test.mjs`:

```javascript
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { validate } from '../scripts/validate.mjs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const fixture = (name) => path.join(__dirname, 'fixtures', name);

test('valid fixture returns no errors', () => {
  const result = validate(fixture('valid'));
  assert.deepEqual(result.errors, []);
  assert.equal(result.ok, true);
});
```

- [ ] **Step 3: Rodar o teste — deve falhar (validate ainda não existe)**

```bash
node --test "d:/Sismais/Fontes/sismais-ai-plugins/tests/validate.test.mjs"
```

Expected: FAIL com erro tipo `Cannot find module '../scripts/validate.mjs'`.

- [ ] **Step 4: Implementar validador mínimo (validate.mjs)**

Criar `d:/Sismais/Fontes/sismais-ai-plugins/scripts/validate.mjs`:

```javascript
import { readFileSync, readdirSync, statSync, existsSync } from 'node:fs';
import path from 'node:path';

function readJson(filePath) {
  try {
    return JSON.parse(readFileSync(filePath, 'utf8'));
  } catch (err) {
    return { __error: `${filePath}: JSON inválido — ${err.message}` };
  }
}

function parseFrontmatter(md) {
  const match = md.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  if (!match) return null;
  const block = match[1];
  const out = {};
  for (const line of block.split(/\r?\n/)) {
    const m = line.match(/^([a-zA-Z_][a-zA-Z0-9_-]*):\s*(.*)$/);
    if (m) out[m[1]] = m[2].trim();
  }
  return out;
}

function* walk(dir) {
  for (const entry of readdirSync(dir)) {
    const full = path.join(dir, entry);
    const st = statSync(full);
    if (st.isDirectory()) {
      yield { type: 'dir', path: full, name: entry };
      yield* walk(full);
    } else {
      yield { type: 'file', path: full, name: entry };
    }
  }
}

export function validate(repoRoot) {
  const errors = [];
  const push = (msg) => errors.push(msg);

  // 1. marketplace.json existe e é JSON válido
  const mpPath = path.join(repoRoot, '.claude-plugin', 'marketplace.json');
  if (!existsSync(mpPath)) {
    push(`marketplace.json não encontrado em ${mpPath}`);
    return { ok: false, errors };
  }
  const mp = readJson(mpPath);
  if (mp.__error) {
    push(mp.__error);
    return { ok: false, errors };
  }

  // 2. Schema mínimo
  for (const field of ['name', 'owner', 'plugins']) {
    if (!(field in mp)) push(`marketplace.json: campo "${field}" obrigatório`);
  }
  if (!Array.isArray(mp.plugins)) {
    push('marketplace.json: "plugins" deve ser array');
    return { ok: false, errors };
  }

  // 3. Cada plugin
  for (const p of mp.plugins) {
    for (const f of ['name', 'source', 'version', 'description']) {
      if (!(f in p)) push(`marketplace.json plugin: campo "${f}" obrigatório (entrada: ${JSON.stringify(p)})`);
    }
    if (!p.source) continue;
    const pluginDir = path.join(repoRoot, p.source);
    if (!existsSync(pluginDir)) {
      push(`marketplace.json: source "${p.source}" aponta para pasta inexistente`);
      continue;
    }
    const pluginJsonPath = path.join(pluginDir, '.claude-plugin', 'plugin.json');
    if (!existsSync(pluginJsonPath)) {
      push(`${p.source}: .claude-plugin/plugin.json não encontrado`);
      continue;
    }
    const pj = readJson(pluginJsonPath);
    if (pj.__error) { push(pj.__error); continue; }
    if (pj.name !== p.name) {
      push(`${p.source}: plugin.json.name "${pj.name}" != marketplace name "${p.name}"`);
    }
    for (const f of ['name', 'version']) {
      if (!(f in pj)) push(`${p.source}/.claude-plugin/plugin.json: campo "${f}" obrigatório`);
    }

    // 4. Skills frontmatter
    const skillsDir = path.join(pluginDir, 'skills');
    if (existsSync(skillsDir)) {
      for (const skillName of readdirSync(skillsDir)) {
        const skillMd = path.join(skillsDir, skillName, 'SKILL.md');
        if (!existsSync(skillMd)) continue;
        const fm = parseFrontmatter(readFileSync(skillMd, 'utf8'));
        if (!fm) {
          push(`${path.relative(repoRoot, skillMd)}: frontmatter YAML ausente ou inválido`);
          continue;
        }
        for (const f of ['name', 'description']) {
          if (!fm[f]) push(`${path.relative(repoRoot, skillMd)}: frontmatter sem "${f}"`);
        }
      }
    }
  }

  // 5. Sem .svn anywhere
  for (const entry of walk(repoRoot)) {
    if (entry.type === 'dir' && entry.name === '.svn') {
      push(`pasta .svn proibida encontrada: ${path.relative(repoRoot, entry.path)}`);
    }
    if (entry.type === 'dir' && entry.name === 'node_modules') {
      // skip walking node_modules — não recursivo no walk atual, mas evita ruído
    }
  }

  return { ok: errors.length === 0, errors };
}

// CLI
if (import.meta.url === `file://${process.argv[1].replace(/\\/g, '/')}` ||
    process.argv[1].endsWith('validate.mjs')) {
  const root = process.argv[2] || process.cwd();
  const result = validate(root);
  if (result.ok) {
    console.log(`✔ Validação OK (${root})`);
    process.exit(0);
  } else {
    console.error(`✗ ${result.errors.length} erro(s) em ${root}:`);
    for (const e of result.errors) console.error(`  - ${e}`);
    process.exit(1);
  }
}
```

- [ ] **Step 5: Rodar teste — deve passar**

```bash
node --test "d:/Sismais/Fontes/sismais-ai-plugins/tests/validate.test.mjs"
```

Expected: `# pass 1`, `# fail 0`.

- [ ] **Step 6: Adicionar fixtures negativas e seus testes**

Criar fixtures restantes:

```bash
# missing-marketplace: pasta vazia
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/tests/fixtures/missing-marketplace"

# bad-json
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/tests/fixtures/bad-json/.claude-plugin"
```

`tests/fixtures/bad-json/.claude-plugin/marketplace.json`:

```
{ this is not valid json
```

```bash
# missing-plugin-folder
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/tests/fixtures/missing-plugin-folder/.claude-plugin"
```

`tests/fixtures/missing-plugin-folder/.claude-plugin/marketplace.json`:

```json
{
  "name": "test",
  "owner": { "name": "Test" },
  "plugins": [
    { "name": "ghost", "source": "./plugins/ghost", "description": "Missing", "version": "0.1.0" }
  ]
}
```

```bash
# name-mismatch
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/tests/fixtures/name-mismatch/.claude-plugin"
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/tests/fixtures/name-mismatch/plugins/foo/.claude-plugin"
```

`tests/fixtures/name-mismatch/.claude-plugin/marketplace.json`:

```json
{
  "name": "test",
  "owner": { "name": "Test" },
  "plugins": [
    { "name": "foo", "source": "./plugins/foo", "description": "Mismatch", "version": "0.1.0" }
  ]
}
```

`tests/fixtures/name-mismatch/plugins/foo/.claude-plugin/plugin.json`:

```json
{ "name": "bar", "version": "0.1.0", "description": "Wrong name" }
```

```bash
# skill-no-frontmatter
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/tests/fixtures/skill-no-frontmatter/.claude-plugin"
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/tests/fixtures/skill-no-frontmatter/plugins/foo/.claude-plugin"
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/tests/fixtures/skill-no-frontmatter/plugins/foo/skills/foo"
```

`tests/fixtures/skill-no-frontmatter/.claude-plugin/marketplace.json`:

```json
{
  "name": "test",
  "owner": { "name": "Test" },
  "plugins": [
    { "name": "foo", "source": "./plugins/foo", "description": "X", "version": "0.1.0" }
  ]
}
```

`tests/fixtures/skill-no-frontmatter/plugins/foo/.claude-plugin/plugin.json`:

```json
{ "name": "foo", "version": "0.1.0", "description": "X" }
```

`tests/fixtures/skill-no-frontmatter/plugins/foo/skills/foo/SKILL.md`:

```markdown
# Foo skill without frontmatter

Body.
```

```bash
# has-svn (estrutura válida + .svn proibido)
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/tests/fixtures/has-svn/.claude-plugin"
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/tests/fixtures/has-svn/plugins/foo/.claude-plugin"
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/tests/fixtures/has-svn/plugins/foo/skills/foo"
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/tests/fixtures/has-svn/plugins/foo/.svn"
```

`tests/fixtures/has-svn/.claude-plugin/marketplace.json`:

```json
{
  "name": "test",
  "owner": { "name": "Test" },
  "plugins": [
    { "name": "foo", "source": "./plugins/foo", "description": "X", "version": "0.1.0" }
  ]
}
```

`tests/fixtures/has-svn/plugins/foo/.claude-plugin/plugin.json`:

```json
{ "name": "foo", "version": "0.1.0", "description": "X" }
```

`tests/fixtures/has-svn/plugins/foo/skills/foo/SKILL.md`:

```markdown
---
name: foo
description: Foo skill for has-svn fixture
---

Body.
```

`tests/fixtures/has-svn/plugins/foo/.svn/.gitkeep`: arquivo vazio (só pra git rastrear a pasta).

- [ ] **Step 7: Adicionar testes para fixtures negativas**

Anexar ao final de `tests/validate.test.mjs`:

```javascript
test('missing marketplace.json reports error', () => {
  const result = validate(fixture('missing-marketplace'));
  assert.equal(result.ok, false);
  assert.ok(result.errors.some(e => e.includes('marketplace.json não encontrado')));
});

test('bad JSON reports parse error', () => {
  const result = validate(fixture('bad-json'));
  assert.equal(result.ok, false);
  assert.ok(result.errors.some(e => e.includes('JSON inválido')));
});

test('plugin source pointing to missing folder is detected', () => {
  const result = validate(fixture('missing-plugin-folder'));
  assert.equal(result.ok, false);
  assert.ok(result.errors.some(e => e.includes('pasta inexistente')));
});

test('name mismatch between marketplace and plugin.json is detected', () => {
  const result = validate(fixture('name-mismatch'));
  assert.equal(result.ok, false);
  assert.ok(result.errors.some(e => e.includes('plugin.json.name')));
});

test('skill without frontmatter is detected', () => {
  const result = validate(fixture('skill-no-frontmatter'));
  assert.equal(result.ok, false);
  assert.ok(result.errors.some(e => e.includes('frontmatter YAML ausente')));
});

test('forbidden .svn folder is detected', () => {
  const result = validate(fixture('has-svn'));
  assert.equal(result.ok, false);
  assert.ok(result.errors.some(e => e.includes('.svn proibida')));
});
```

- [ ] **Step 8: Rodar todos os testes**

```bash
node --test "d:/Sismais/Fontes/sismais-ai-plugins/tests/validate.test.mjs"
```

Expected: `# pass 7`, `# fail 0`. Se algum falhar, ajustar `validate.mjs` até passar.

- [ ] **Step 9: Rodar validador contra repo real**

```bash
node "d:/Sismais/Fontes/sismais-ai-plugins/scripts/validate.mjs" "d:/Sismais/Fontes/sismais-ai-plugins"
```

Expected: pode reportar erro sobre `consultor-fiscal-sismais/` (que ainda está na raiz, não em `plugins/`, e não tem manifestos). **Isso é esperado** — será corrigido na Tarefa 5. O validador NÃO deve dar erro para o `hello-sismais` ou `marketplace.json`.

Se o validador reportar erros sobre `consultor-fiscal-sismais/.svn` ou similar enquanto está na raiz: ajustar para que `walk` só inspecione `plugins/` (não a raiz toda) — atualizar lógica para varrer apenas `path.join(repoRoot, 'plugins')` quando existir, evitando que pastas órfãs causem ruído. Reaplicar testes.

- [ ] **Step 10: Commitar**

```bash
git -C "d:/Sismais/Fontes/sismais-ai-plugins" add scripts/validate.mjs tests/
git -C "d:/Sismais/Fontes/sismais-ai-plugins" commit -m "feat: add Node validator with TDD coverage"
```

---

## Task 4: CI workflow

**Files:**

- Create: `.github/workflows/validate.yml`

- [ ] **Step 1: Criar workflow**

```bash
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/.github/workflows"
```

Criar `d:/Sismais/Fontes/sismais-ai-plugins/.github/workflows/validate.yml`:

```yaml
name: validate

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Run validator tests
        run: node --test tests/validate.test.mjs

      - name: Validate marketplace structure
        run: node scripts/validate.mjs .
```

- [ ] **Step 2: Verificar sintaxe YAML local**

```bash
node -e "const fs=require('fs');const yml=fs.readFileSync('d:/Sismais/Fontes/sismais-ai-plugins/.github/workflows/validate.yml','utf8');console.log('lido:',yml.length,'bytes');console.log('linhas:',yml.split('\n').length)"
```

Expected: imprime tamanho > 0 e número de linhas > 10. Validação de YAML profundo só acontece quando o GitHub Actions tenta executar — sintaxe básica vai a olho.

- [ ] **Step 3: Commitar**

```bash
git -C "d:/Sismais/Fontes/sismais-ai-plugins" add .github/workflows/validate.yml
git -C "d:/Sismais/Fontes/sismais-ai-plugins" commit -m "ci: add validate workflow on push and PR"
```

---

## Task 5: Refatorar consultor-fiscal-sismais

Move o plugin existente para `plugins/consultor-fiscal-sismais/`, com toda a estrutura interna agora dentro de `skills/consultor-fiscal-sismais/` (decisão congelada acima).

**Files:**

- Move: `consultor-fiscal-sismais/*` → `plugins/consultor-fiscal-sismais/skills/consultor-fiscal-sismais/`
- Create: `plugins/consultor-fiscal-sismais/.claude-plugin/plugin.json`
- Delete: todas as pastas `.svn/` recursivas

- [ ] **Step 1: Criar nova estrutura**

```bash
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/plugins/consultor-fiscal-sismais/.claude-plugin"
mkdir -p "d:/Sismais/Fontes/sismais-ai-plugins/plugins/consultor-fiscal-sismais/skills/consultor-fiscal-sismais"
```

- [ ] **Step 2: Mover conteúdo do plugin antigo para a nova localização**

```bash
mv "d:/Sismais/Fontes/sismais-ai-plugins/consultor-fiscal-sismais/SKILL.md" \
   "d:/Sismais/Fontes/sismais-ai-plugins/plugins/consultor-fiscal-sismais/skills/consultor-fiscal-sismais/SKILL.md"

mv "d:/Sismais/Fontes/sismais-ai-plugins/consultor-fiscal-sismais/CATALOGO-DOCUMENTOS.md" \
   "d:/Sismais/Fontes/sismais-ai-plugins/plugins/consultor-fiscal-sismais/skills/consultor-fiscal-sismais/CATALOGO-DOCUMENTOS.md"

mv "d:/Sismais/Fontes/sismais-ai-plugins/consultor-fiscal-sismais/GUIA-ATUALIZACAO.md" \
   "d:/Sismais/Fontes/sismais-ai-plugins/plugins/consultor-fiscal-sismais/skills/consultor-fiscal-sismais/GUIA-ATUALIZACAO.md"

mv "d:/Sismais/Fontes/sismais-ai-plugins/consultor-fiscal-sismais/INDICE-REGRAS-CAMPOS.md" \
   "d:/Sismais/Fontes/sismais-ai-plugins/plugins/consultor-fiscal-sismais/skills/consultor-fiscal-sismais/INDICE-REGRAS-CAMPOS.md"

mv "d:/Sismais/Fontes/sismais-ai-plugins/consultor-fiscal-sismais/scripts" \
   "d:/Sismais/Fontes/sismais-ai-plugins/plugins/consultor-fiscal-sismais/skills/consultor-fiscal-sismais/scripts"

mv "d:/Sismais/Fontes/sismais-ai-plugins/consultor-fiscal-sismais/doc_sources" \
   "d:/Sismais/Fontes/sismais-ai-plugins/plugins/consultor-fiscal-sismais/skills/consultor-fiscal-sismais/doc_sources"
```

- [ ] **Step 3: Verificar que a pasta antiga ficou vazia e removê-la**

```bash
ls -la "d:/Sismais/Fontes/sismais-ai-plugins/consultor-fiscal-sismais/" 2>&1
```

Expected: pasta vazia (só `.` e `..`). Se houver conteúdo restante, mover para o destino correto antes de prosseguir.

```bash
rmdir "d:/Sismais/Fontes/sismais-ai-plugins/consultor-fiscal-sismais"
```

- [ ] **Step 4: Remover todas as pastas `.svn/` recursivamente**

```bash
find "d:/Sismais/Fontes/sismais-ai-plugins/plugins/consultor-fiscal-sismais" -type d -name ".svn" -exec rm -rf {} + 2>/dev/null
```

(Em PowerShell: `Get-ChildItem -Path "d:/Sismais/Fontes/sismais-ai-plugins/plugins/consultor-fiscal-sismais" -Recurse -Directory -Force -Filter ".svn" | Remove-Item -Recurse -Force`)

Verificar:

```bash
find "d:/Sismais/Fontes/sismais-ai-plugins/plugins/consultor-fiscal-sismais" -type d -name ".svn" 2>&1
```

Expected: saída vazia (nenhuma `.svn` restante).

- [ ] **Step 5: Criar plugin.json**

Criar `d:/Sismais/Fontes/sismais-ai-plugins/plugins/consultor-fiscal-sismais/.claude-plugin/plugin.json`:

```json
{
  "name": "consultor-fiscal-sismais",
  "version": "0.1.0",
  "description": "Consultor fiscal especialista em NF-e, NFC-e, NFS-e e tributação brasileira",
  "author": { "name": "Sismais" }
}
```

- [ ] **Step 6: Verificar que o frontmatter da SKILL.md continua válido**

```bash
head -5 "d:/Sismais/Fontes/sismais-ai-plugins/plugins/consultor-fiscal-sismais/skills/consultor-fiscal-sismais/SKILL.md"
```

Expected: começa com `---` + linhas `name:` e `description:`. Se algo fora isso, investigar.

- [ ] **Step 7: Rodar validador contra o repo**

```bash
node "d:/Sismais/Fontes/sismais-ai-plugins/scripts/validate.mjs" "d:/Sismais/Fontes/sismais-ai-plugins"
```

Expected: o validador agora reporta um erro do tipo `marketplace.json: source "./plugins/consultor-fiscal-sismais" não está listado` — espera-se que a entrada no marketplace seja adicionada na Tarefa 6.

Na verdade, o validador atual não reclama de plugins **órfãos** (presentes em disk mas ausentes do marketplace.json). Isso é OK — a regra é "tudo no marketplace.json deve existir", não o contrário. Validador deve passar nesse momento. Se reportar erro sobre `.svn` ou similar, voltar ao Step 4 e limpar.

- [ ] **Step 8: Commitar refatoração**

```bash
git -C "d:/Sismais/Fontes/sismais-ai-plugins" add plugins/consultor-fiscal-sismais
git -C "d:/Sismais/Fontes/sismais-ai-plugins" status
```

Expected: status mostra centenas de arquivos novos (todo o `doc_sources/`). Confirmar que **nenhuma pasta `.svn/`** aparece. Se aparecer, voltar ao Step 4.

```bash
git -C "d:/Sismais/Fontes/sismais-ai-plugins" commit -m "refactor: relocate consultor-fiscal-sismais to plugins/ with proper manifest"
```

(Commit pode ser grande devido ao `doc_sources/` — esperado.)

---

## Task 6: Adicionar consultor-fiscal-sismais ao marketplace.json

**Files:**

- Modify: `.claude-plugin/marketplace.json`

- [ ] **Step 1: Editar marketplace.json**

Substituir o conteúdo de `d:/Sismais/Fontes/sismais-ai-plugins/.claude-plugin/marketplace.json` por:

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

- [ ] **Step 2: Rodar validador**

```bash
node "d:/Sismais/Fontes/sismais-ai-plugins/scripts/validate.mjs" "d:/Sismais/Fontes/sismais-ai-plugins"
```

Expected: `✔ Validação OK`. Se ainda houver erro, investigar.

- [ ] **Step 3: Rodar testes do validador (regressão)**

```bash
node --test "d:/Sismais/Fontes/sismais-ai-plugins/tests/validate.test.mjs"
```

Expected: `# pass 7`, `# fail 0`.

- [ ] **Step 4: Commitar**

```bash
git -C "d:/Sismais/Fontes/sismais-ai-plugins" add .claude-plugin/marketplace.json
git -C "d:/Sismais/Fontes/sismais-ai-plugins" commit -m "feat: register consultor-fiscal-sismais in marketplace"
```

---

## Task 7: Confirmar mecanismo de install e adicionar marketplace

Tarefa de **research** — descobrir o jeito robusto de fazer o onboarding ANTES de codar os scripts. Decisão default: editar `~/.claude/settings.json`.

- [ ] **Step 1: Ler documentação do Claude Code sobre marketplaces**

Consultar (via WebFetch ou similar) a documentação oficial:

- `https://docs.claude.com/en/docs/claude-code/plugins`
- `https://docs.claude.com/en/docs/claude-code/plugin-marketplaces`

Anotar:
- Existe subcommand `claude plugin marketplace add`? Se sim, qual a sintaxe exata?
- Onde fica o arquivo de settings que armazena marketplaces? (`~/.claude/settings.json`? `~/.claude.json`?)
- Como o Claude Code identifica plugins habilitados?

- [ ] **Step 2: Inspecionar estado local do Claude Code do usuário**

Em uma máquina com Claude Code instalado:

```bash
ls -la "$HOME/.claude/" 2>&1 | head -20
cat "$HOME/.claude/settings.json" 2>&1 | head -30
```

(Em Windows: `Get-ChildItem $HOME/.claude/`, `Get-Content $HOME/.claude/settings.json`)

Anotar:
- Quais arquivos existem em `~/.claude/`?
- Qual o schema do `settings.json`? Há campo `marketplaces`? `enabledPlugins`?
- Há um arquivo separado `~/.claude/plugins.json` ou similar?

- [ ] **Step 3: Tentar `claude --help` e variações**

```bash
claude --help 2>&1 | head -50
claude plugin --help 2>&1 | head -30
claude plugin marketplace --help 2>&1 | head -30
```

Anotar comandos disponíveis e suas sintaxes.

- [ ] **Step 4: Documentar a decisão**

Acrescentar no topo de `scripts/install.sh` (ainda não criado — será criado na próxima tarefa) um comentário em PT explicando o mecanismo escolhido. Para fins deste plano, **default congelado:** edição de `~/.claude/settings.json` (com backup `.bak` antes de modificar).

Esquema esperado a confirmar (ajustar nos próximos steps se a investigação acima descobrir diferente):

```json
{
  "marketplaces": {
    "sismais": { "source": "https://github.com/sismais/sismais-ai-plugins" }
  },
  "enabledPlugins": {
    "hello-sismais@sismais": true
  }
}
```

Se o CLI `claude plugin marketplace add` existir e for confiável, o script pode preferir chamá-lo. Caso contrário, edita JSON.

- [ ] **Step 5: Sem commit — esta tarefa é puramente investigativa**

Sem alteração de arquivo. Os achados servem de input para as Tarefas 8 e 9.

---

## Task 8: install.sh (Linux/Mac)

**Files:**

- Create: `scripts/install.sh`

- [ ] **Step 1: Criar install.sh**

Criar `d:/Sismais/Fontes/sismais-ai-plugins/scripts/install.sh`:

```bash
#!/usr/bin/env bash
# Onboarding do marketplace público Sismais para Claude Code (Linux/Mac).
#
# Uso:
#   curl -fsSL https://raw.githubusercontent.com/sismais/sismais-ai-plugins/main/scripts/install.sh | bash
#
# Mecanismo: edição de ~/.claude/settings.json (com backup .bak).
# Se a Tarefa 7 confirmou um CLI estável (claude plugin marketplace add ...),
# preferir o CLI; o JSON edit é o fallback.

set -euo pipefail

MARKETPLACE_NAME="sismais"
MARKETPLACE_REPO="sismais/sismais-ai-plugins"
MARKETPLACE_URL="https://github.com/${MARKETPLACE_REPO}"
SETTINGS_FILE="${HOME}/.claude/settings.json"

c_green=$'\033[0;32m'
c_red=$'\033[0;31m'
c_yellow=$'\033[1;33m'
c_reset=$'\033[0m'

info()    { printf '%s\n' "$1"; }
ok()      { printf '%b✔%b %s\n' "$c_green" "$c_reset" "$1"; }
warn()    { printf '%b!%b %s\n' "$c_yellow" "$c_reset" "$1"; }
fail()    { printf '%b✗%b %s\n' "$c_red" "$c_reset" "$1" >&2; exit 1; }

# 1. Pré-checagem
command -v claude >/dev/null 2>&1 || fail "Claude Code não encontrado. Instale antes: https://docs.claude.com/en/docs/claude-code/install"
ok "Claude Code detectado: $(claude --version 2>&1 | head -1)"

command -v node >/dev/null 2>&1 || fail "Node.js é necessário para edição segura do settings.json. Instale Node 20+."

# 2. Garantir que ~/.claude/settings.json existe
mkdir -p "$(dirname "$SETTINGS_FILE")"
if [[ ! -f "$SETTINGS_FILE" ]]; then
  echo '{}' > "$SETTINGS_FILE"
  ok "Criado $SETTINGS_FILE"
fi

# 3. Backup
cp "$SETTINGS_FILE" "${SETTINGS_FILE}.bak.$(date +%Y%m%d-%H%M%S)"
ok "Backup salvo em ${SETTINGS_FILE}.bak.*"

# 4. Adicionar marketplace via Node (idempotente)
node --input-type=module -e "
import { readFileSync, writeFileSync } from 'node:fs';
const path = '$SETTINGS_FILE';
const cfg = JSON.parse(readFileSync(path, 'utf8'));
cfg.marketplaces ??= {};
const existing = cfg.marketplaces['$MARKETPLACE_NAME'];
if (!existing || existing.source !== '$MARKETPLACE_URL') {
  cfg.marketplaces['$MARKETPLACE_NAME'] = { source: '$MARKETPLACE_URL' };
  writeFileSync(path, JSON.stringify(cfg, null, 2));
  console.log('marketplace_added');
} else {
  console.log('marketplace_already_present');
}
"
ok "Marketplace público '$MARKETPLACE_NAME' configurado"

# 5. Pergunta sobre interno
echo
read -p "Você é membro do time Sismais (acesso ao marketplace privado)? [s/N] " is_internal
if [[ "$is_internal" =~ ^[sSyY]$ ]]; then
  warn "O marketplace interno ainda não está disponível. Quando estiver, rode novamente este script ou siga as instruções em https://github.com/sismais/sismais-ai-plugins#interno"
fi

# 6. Habilitar plugins recomendados (default: hello-sismais)
echo
info "Plugins disponíveis no marketplace público:"
info "  [x] hello-sismais          (validador de instalação)"
info "  [ ] consultor-fiscal-sismais (consultor fiscal)"
echo
read -p "Habilitar 'consultor-fiscal-sismais' agora? [s/N] " want_fiscal

node --input-type=module -e "
import { readFileSync, writeFileSync } from 'node:fs';
const path = '$SETTINGS_FILE';
const cfg = JSON.parse(readFileSync(path, 'utf8'));
cfg.enabledPlugins ??= {};
cfg.enabledPlugins['hello-sismais@sismais'] = true;
if ('${want_fiscal:-N}' === 's' || '${want_fiscal:-N}' === 'S') {
  cfg.enabledPlugins['consultor-fiscal-sismais@sismais'] = true;
}
writeFileSync(path, JSON.stringify(cfg, null, 2));
"

ok "Plugins habilitados"

# 7. Mensagem final
echo
ok "Pronto. Abra o Claude Code e digite '/help' para ver os comandos disponíveis."
ok "Para validar a instalação, pergunte ao Claude: 'o sismais está instalado?'"
```

- [ ] **Step 2: Tornar executável**

```bash
chmod +x "d:/Sismais/Fontes/sismais-ai-plugins/scripts/install.sh" 2>/dev/null || true
```

(No Windows o flag não tem efeito, mas o git rastreia o `+x` via `core.fileMode`/`.gitattributes`.)

- [ ] **Step 3: Smoke test (dry-run em ambiente seguro)**

Em uma máquina Linux/Mac (ou WSL), rodar:

```bash
HOME="/tmp/sismais-test" bash "d:/Sismais/Fontes/sismais-ai-plugins/scripts/install.sh" </dev/null || true
```

Expected: o script tenta detectar `claude` e provavelmente falha com "Claude Code não encontrado" (porque o HOME forçado não tem o CLI no PATH — esperado). O ponto é confirmar que **falha graciosa** e mensagem clara, não stack trace bash. Se `claude` estiver no PATH, ele vai mais longe — observar saída e ajustar se houver erro.

Se o engenheiro estiver em Windows puro, este step pode ser pulado e validado depois (ou em WSL).

- [ ] **Step 4: Commitar**

```bash
git -C "d:/Sismais/Fontes/sismais-ai-plugins" add scripts/install.sh
git -C "d:/Sismais/Fontes/sismais-ai-plugins" commit -m "feat: add install.sh onboarding script for Linux/Mac"
```

---

## Task 9: install.ps1 (Windows)

**Files:**

- Create: `scripts/install.ps1`

- [ ] **Step 1: Criar install.ps1**

Criar `d:/Sismais/Fontes/sismais-ai-plugins/scripts/install.ps1`:

```powershell
# Onboarding do marketplace público Sismais para Claude Code (Windows).
#
# Uso:
#   iwr -useb https://raw.githubusercontent.com/sismais/sismais-ai-plugins/main/scripts/install.ps1 | iex
#
# Mecanismo: edição de $HOME/.claude/settings.json (com backup .bak).

$ErrorActionPreference = 'Stop'

$MarketplaceName = 'sismais'
$MarketplaceRepo = 'sismais/sismais-ai-plugins'
$MarketplaceUrl  = "https://github.com/$MarketplaceRepo"
$SettingsFile    = Join-Path $HOME '.claude/settings.json'

function Write-Ok($msg)   { Write-Host "✔ $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "! $msg" -ForegroundColor Yellow }
function Fail($msg)       { Write-Host "✗ $msg" -ForegroundColor Red; exit 1 }

# 1. Pré-checagem
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Fail "Claude Code não encontrado. Instale antes: https://docs.claude.com/en/docs/claude-code/install"
}
Write-Ok "Claude Code detectado: $(claude --version 2>&1 | Select-Object -First 1)"

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Fail "Node.js é necessário para edição segura do settings.json. Instale Node 20+."
}

# 2. Garantir settings.json
$settingsDir = Split-Path $SettingsFile -Parent
if (-not (Test-Path $settingsDir)) { New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null }
if (-not (Test-Path $SettingsFile)) { '{}' | Set-Content -Path $SettingsFile -NoNewline; Write-Ok "Criado $SettingsFile" }

# 3. Backup
$ts = Get-Date -Format 'yyyyMMdd-HHmmss'
Copy-Item $SettingsFile "$SettingsFile.bak.$ts"
Write-Ok "Backup salvo em $SettingsFile.bak.$ts"

# 4. Adicionar marketplace
$nodeScript = @"
import { readFileSync, writeFileSync } from 'node:fs';
const cfg = JSON.parse(readFileSync(process.argv[1], 'utf8'));
cfg.marketplaces ??= {};
const existing = cfg.marketplaces['$MarketplaceName'];
if (!existing || existing.source !== '$MarketplaceUrl') {
  cfg.marketplaces['$MarketplaceName'] = { source: '$MarketplaceUrl' };
  writeFileSync(process.argv[1], JSON.stringify(cfg, null, 2));
}
"@
node --input-type=module -e $nodeScript $SettingsFile
Write-Ok "Marketplace público '$MarketplaceName' configurado"

# 5. Pergunta interno
Write-Host ""
$isInternal = Read-Host "Você é membro do time Sismais (acesso ao marketplace privado)? [s/N]"
if ($isInternal -match '^[sSyY]$') {
    Write-Warn "O marketplace interno ainda não está disponível. Quando estiver, rode novamente este script ou siga as instruções em https://github.com/sismais/sismais-ai-plugins#interno"
}

# 6. Plugins
Write-Host ""
Write-Host "Plugins disponíveis no marketplace público:"
Write-Host "  [x] hello-sismais            (validador de instalação)"
Write-Host "  [ ] consultor-fiscal-sismais (consultor fiscal)"
Write-Host ""
$wantFiscal = Read-Host "Habilitar 'consultor-fiscal-sismais' agora? [s/N]"

$enableScript = @"
import { readFileSync, writeFileSync } from 'node:fs';
const cfg = JSON.parse(readFileSync(process.argv[1], 'utf8'));
cfg.enabledPlugins ??= {};
cfg.enabledPlugins['hello-sismais@sismais'] = true;
if ('$wantFiscal' === 's' || '$wantFiscal' === 'S') {
  cfg.enabledPlugins['consultor-fiscal-sismais@sismais'] = true;
}
writeFileSync(process.argv[1], JSON.stringify(cfg, null, 2));
"@
node --input-type=module -e $enableScript $SettingsFile
Write-Ok "Plugins habilitados"

# 7. Mensagem final
Write-Host ""
Write-Ok "Pronto. Abra o Claude Code e digite '/help' para ver os comandos disponíveis."
Write-Ok "Para validar a instalação, pergunte ao Claude: 'o sismais está instalado?'"
```

- [ ] **Step 2: Smoke test em PowerShell**

Em PowerShell (Windows ou cross-platform `pwsh`):

```powershell
$env:HOME = "$env:TEMP/sismais-test"
& "d:/Sismais/Fontes/sismais-ai-plugins/scripts/install.ps1"
```

Expected: similar ao install.sh — falha graciosa se `claude` não estiver no PATH; caso esteja, conduz a configuração.

Se ocorrer erro `running scripts is disabled` por execution policy, documentar workaround (rodar via `iex` ou `powershell -ExecutionPolicy Bypass -File ...`).

- [ ] **Step 3: Commitar**

```bash
git -C "d:/Sismais/Fontes/sismais-ai-plugins" add scripts/install.ps1
git -C "d:/Sismais/Fontes/sismais-ai-plugins" commit -m "feat: add install.ps1 onboarding script for Windows"
```

---

## Task 10: README.md

**Files:**

- Create: `README.md`

- [ ] **Step 1: Criar README**

Criar `d:/Sismais/Fontes/sismais-ai-plugins/README.md`:

```markdown
# Sismais AI Plugins (público)

Marketplace público de plugins de IA da Sismais para [Claude Code](https://docs.claude.com/en/docs/claude-code).

## Instalação rápida

**Pré-requisito:** [Claude Code instalado](https://docs.claude.com/en/docs/claude-code/install) e Node.js 20+.

### Linux / Mac

```bash
curl -fsSL https://raw.githubusercontent.com/sismais/sismais-ai-plugins/main/scripts/install.sh | bash
```

### Windows (PowerShell)

```powershell
iwr -useb https://raw.githubusercontent.com/sismais/sismais-ai-plugins/main/scripts/install.ps1 | iex
```

> Se o PowerShell bloquear: `powershell -ExecutionPolicy Bypass -Command "iwr -useb https://... | iex"`.

### Manual

1. Edite `~/.claude/settings.json` adicionando:

   ```json
   {
     "marketplaces": {
       "sismais": { "source": "https://github.com/sismais/sismais-ai-plugins" }
     },
     "enabledPlugins": {
       "hello-sismais@sismais": true
     }
   }
   ```

2. Abra o Claude Code. O plugin `hello-sismais` deve estar ativo.

## Plugins disponíveis

| Plugin | Descrição | Categoria |
|---|---|---|
| [hello-sismais](plugins/hello-sismais) | Plugin de exemplo — valida instalação | example |
| [consultor-fiscal-sismais](plugins/consultor-fiscal-sismais) | Consultor fiscal especialista em NF-e, NFC-e, NFS-e e tributação brasileira | fiscal |

## Como validar a instalação

Após rodar o instalador, abra o Claude Code e pergunte:

> o sismais está instalado?

A skill `hello-sismais` deve responder confirmando que o marketplace está ativo.

## Para o time Sismais (acesso interno)

Há um marketplace privado adicional com plugins internos da Sismais. **Em breve** — o repo `sismais/sismais-ai-plugins-internal` ainda não está disponível. Quando estiver, este README receberá as instruções.

## Contribuindo

Veja [CONTRIBUTING.md](CONTRIBUTING.md) para criar e submeter um novo plugin.

## Licença

[MIT](LICENSE)

## Contato

Issues e dúvidas: [github.com/sismais/sismais-ai-plugins/issues](https://github.com/sismais/sismais-ai-plugins/issues)
```

- [ ] **Step 2: Verificar links relativos**

```bash
ls "d:/Sismais/Fontes/sismais-ai-plugins/plugins/hello-sismais" "d:/Sismais/Fontes/sismais-ai-plugins/plugins/consultor-fiscal-sismais" "d:/Sismais/Fontes/sismais-ai-plugins/CONTRIBUTING.md" "d:/Sismais/Fontes/sismais-ai-plugins/LICENSE"
```

Expected: `plugins/...` existem, `LICENSE` existe, `CONTRIBUTING.md` ainda não (será criado na próxima tarefa — link vai aparecer quebrado até lá; aceitável).

- [ ] **Step 3: Commitar**

```bash
git -C "d:/Sismais/Fontes/sismais-ai-plugins" add README.md
git -C "d:/Sismais/Fontes/sismais-ai-plugins" commit -m "docs: add README in Portuguese"
```

---

## Task 11: CONTRIBUTING.md

**Files:**

- Create: `CONTRIBUTING.md`

- [ ] **Step 1: Criar CONTRIBUTING**

Criar `d:/Sismais/Fontes/sismais-ai-plugins/CONTRIBUTING.md`:

```markdown
# Contribuindo com o Sismais AI Plugins

Obrigado pelo interesse. Este guia explica como adicionar um plugin ao marketplace público.

## Pré-requisitos

- Node.js 20+ (para rodar o validador local)
- Claude Code instalado, para testar o plugin
- Git

## Estrutura de um plugin

Cada plugin é uma pasta dentro de `plugins/`:

```
plugins/<nome-do-plugin>/
├── .claude-plugin/
│   └── plugin.json          # manifesto
├── skills/                  # opcional
│   └── <skill-name>/
│       └── SKILL.md
├── agents/                  # opcional
├── commands/                # opcional
└── .mcp.json                # opcional (MCP servers)
```

O nome da pasta, o `name` no `plugin.json` e a entrada no `marketplace.json` devem coincidir.

## Passo a passo: adicionar um novo plugin

1. **Copie o template** `plugins/hello-sismais` para `plugins/<seu-plugin>`.

2. **Renomeie** referências a `hello-sismais` em todos os arquivos copiados:
   - `plugins/<seu-plugin>/.claude-plugin/plugin.json` (campo `name`)
   - Pasta `plugins/<seu-plugin>/skills/<seu-plugin>/`
   - `SKILL.md` frontmatter (`name`, `description`)

3. **Escreva o conteúdo da skill** em `SKILL.md`. O `description` no frontmatter deve listar **triggers em português** que façam a skill ser ativada (ex.: "aciona quando o usuário pergunta sobre X, Y ou Z").

4. **Registre o plugin** em `.claude-plugin/marketplace.json`, adicionando uma entrada em `plugins[]`:

   ```json
   {
     "name": "<seu-plugin>",
     "source": "./plugins/<seu-plugin>",
     "description": "Descrição curta",
     "version": "0.1.0",
     "category": "<categoria>",
     "tags": ["..."]
   }
   ```

5. **Valide localmente:**

   ```bash
   node scripts/validate.mjs .
   ```

   Deve imprimir `✔ Validação OK`. Se falhar, leia a mensagem e corrija.

6. **Teste no Claude Code** apontando o marketplace para o caminho local:

   - Edite `~/.claude/settings.json`:

     ```json
     {
       "marketplaces": {
         "sismais-local": { "source": "/caminho/absoluto/para/sismais-ai-plugins" }
       },
       "enabledPlugins": {
         "<seu-plugin>@sismais-local": true
       }
     }
     ```

   - Abra o Claude Code e provoque a skill com uma das frases listadas no `description`.

## Convenções

- **Naming:** `sismais-<tema>` (ex.: `sismais-dev`, `sismais-marketing`).
- **Idioma:** skills, agents, commands e mensagens visíveis ao usuário em **português**. Código e nomes de arquivos em inglês.
- **Versionamento:** começa em `0.1.0`. Bump de patch para correções, minor para conteúdo novo, major para mudanças incompatíveis.
- **Tamanho:** plugins **leves** (apenas markdown + JSON). Conteúdo binário pesado (>5 MB) deve ser justificado e idealmente migrado para release/CDN no futuro.

## Checklist antes de abrir PR

- [ ] `node scripts/validate.mjs .` passa
- [ ] `node --test tests/validate.test.mjs` passa
- [ ] Plugin foi testado localmente no Claude Code
- [ ] README do repo (tabela de plugins) atualizada se aplicável
- [ ] Sem pastas `.svn/`, `node_modules/`, `__pycache__/` no diff
- [ ] Mensagem de commit em formato `feat:`/`fix:`/`docs:`/`chore:`

## Onde tirar dúvidas

Abra uma issue: [github.com/sismais/sismais-ai-plugins/issues](https://github.com/sismais/sismais-ai-plugins/issues)
```

- [ ] **Step 2: Commitar**

```bash
git -C "d:/Sismais/Fontes/sismais-ai-plugins" add CONTRIBUTING.md
git -C "d:/Sismais/Fontes/sismais-ai-plugins" commit -m "docs: add CONTRIBUTING guide in Portuguese"
```

---

## Task 12: Smoke test ponta-a-ponta

Validação final dos critérios de aceitação do spec.

- [ ] **Step 1: Validador passa**

```bash
node "d:/Sismais/Fontes/sismais-ai-plugins/scripts/validate.mjs" "d:/Sismais/Fontes/sismais-ai-plugins"
```

Expected: `✔ Validação OK`.

- [ ] **Step 2: Testes do validador passam**

```bash
node --test "d:/Sismais/Fontes/sismais-ai-plugins/tests/validate.test.mjs"
```

Expected: `# pass 7`, `# fail 0`.

- [ ] **Step 3: Verificar ausência de `.svn/`**

```bash
find "d:/Sismais/Fontes/sismais-ai-plugins" -type d -name ".svn" 2>&1
```

Expected: saída vazia.

- [ ] **Step 4: Verificar estrutura final**

```bash
ls -la "d:/Sismais/Fontes/sismais-ai-plugins/" 2>&1
ls -la "d:/Sismais/Fontes/sismais-ai-plugins/plugins/" 2>&1
ls "d:/Sismais/Fontes/sismais-ai-plugins/plugins/hello-sismais/" "d:/Sismais/Fontes/sismais-ai-plugins/plugins/consultor-fiscal-sismais/" 2>&1
```

Expected:
- Raiz: `.claude/`, `.claude-plugin/`, `.git/`, `.github/`, `.gitattributes`, `.gitignore`, `CONTRIBUTING.md`, `LICENSE`, `README.md`, `docs/`, `plugins/`, `scripts/`, `tests/`.
- `plugins/`: `hello-sismais/`, `consultor-fiscal-sismais/`.
- Cada plugin: `.claude-plugin/`, `skills/`.

- [ ] **Step 5: Smoke test do install no Claude Code (manual)**

Em uma máquina com Claude Code instalado:

1. Backup do `~/.claude/settings.json` atual.
2. Apontar o marketplace para o repo local:
   - Editar `~/.claude/settings.json` adicionando:
     ```json
     {
       "marketplaces": {
         "sismais-test": { "source": "d:/Sismais/Fontes/sismais-ai-plugins" }
       },
       "enabledPlugins": {
         "hello-sismais@sismais-test": true
       }
     }
     ```
3. Abrir Claude Code numa pasta qualquer e perguntar: "o sismais está instalado?"
4. Expected: skill `hello-sismais` é acionada e responde confirmando.

5. Habilitar `consultor-fiscal-sismais@sismais-test` no settings, reabrir Claude Code e perguntar: "qual a Nota Técnica vigente para NF-e em 2026?"
6. Expected: skill `consultor-fiscal-sismais` é acionada, lê arquivos em `doc_sources/` e responde com base nos documentos.

7. Restaurar o backup do `settings.json`.

Se algum passo falhar, **não** prosseguir — investigar e abrir issue/correção. Possíveis causas:
- Skill description com triggers fracos (ajustar frontmatter).
- Path do `doc_sources/` inválido (a skill referencia "na mesma pasta deste SKILL.md" — após move, `doc_sources/` está em `plugins/consultor-fiscal-sismais/skills/consultor-fiscal-sismais/doc_sources/`, sibling do `SKILL.md`, então deve funcionar).
- Schema do `~/.claude/settings.json` diferente do assumido (ajustar Tarefa 7 e scripts).

- [ ] **Step 6: Commit final (se houver ajustes)**

Se algum ajuste foi feito durante o smoke test, commitar com `fix:` ou `feat:`.

```bash
git -C "d:/Sismais/Fontes/sismais-ai-plugins" status
```

Expected: `nothing to commit, working tree clean` (se nada precisou de ajuste).

- [ ] **Step 7: Tag de versão**

```bash
git -C "d:/Sismais/Fontes/sismais-ai-plugins" tag -a v0.1.0 -m "v0.1.0: marketplace público inicial com hello-sismais e consultor-fiscal-sismais"
```

- [ ] **Step 8: Verificar log final**

```bash
git -C "d:/Sismais/Fontes/sismais-ai-plugins" log --oneline
```

Expected: ~12 commits, um por tarefa, mensagens em formato `tipo: descrição`.

---

## Self-review (do plano)

Verificações finais aplicadas ao plano antes de entregá-lo:

1. **Spec coverage:**
   - Estrutura do repo → Tasks 1, 2, 5
   - marketplace.json + plugins → Tasks 2, 5, 6
   - Onboarding scripts → Tasks 7, 8, 9
   - CI de validação → Tasks 3, 4
   - Documentação → Tasks 10, 11
   - Refatoração consultor-fiscal-sismais → Task 5
   - Conteúdo pesado (sem .svn) → Task 5 + verificações em 12
   - Critérios de aceitação → Task 12
   - **Coberto.**

2. **Placeholder scan:** sem TBDs, TODOs ou "implement later" no plano. Decisões deferidas pelo spec foram congeladas no início ("Decisões de implementação congeladas") com razão e fallback.

3. **Type consistency:**
   - `validate(repoRoot)` retorna `{ ok, errors }` consistentemente em testes e implementação.
   - `marketplaces` e `enabledPlugins` usados consistentemente em install.sh, install.ps1, README e CONTRIBUTING.
   - Nomes de plugins (`hello-sismais`, `consultor-fiscal-sismais`) idênticos em pasta, plugin.json, marketplace.json e settings.json.

4. **Riscos não tratados:**
   - Schema de `~/.claude/settings.json` é assumido; Task 7 valida e Task 12 (smoke test) é o portão real. Se o schema diferir, scripts e docs precisam revisão antes de `v0.1.0`.

---

## Execution Handoff

**Plan complete and saved to `docs/superpowers/plans/2026-04-28-marketplace-publico.md`. Two execution options:**

**1. Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, review between tasks, fast iteration.

**2. Inline Execution** — Execute tasks in this session using `superpowers:executing-plans`, batch execution with checkpoints.

**Which approach?**
