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

6. **Teste no Claude Code** apontando o marketplace para o caminho local. Edite `~/.claude/settings.json` (Windows: `%USERPROFILE%\.claude\settings.json`):

   ```json
   {
     "extraKnownMarketplaces": {
       "sismais-local": {
         "source": { "source": "directory", "path": "/caminho/absoluto/para/sismais-ai-plugins-public" }
       }
     },
     "enabledPlugins": {
       "<seu-plugin>@sismais-local": true
     }
   }
   ```

   Reabra o Claude Code, aceite o prompt de confiança e provoque a skill com uma das frases listadas no `description`.

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

Abra uma issue: [github.com/sismais/sismais-ai-plugins-public/issues](https://github.com/sismais/sismais-ai-plugins-public/issues)
