# Sismais AI Plugins (público)

Marketplace público de plugins de IA da Sismais para [Claude Code](https://docs.anthropic.com/pt-br/docs/claude-code/overview).

## Instalação rápida

**Pré-requisito:** [Claude Code instalado](https://docs.anthropic.com/pt-br/docs/claude-code/overview) e Node.js 20+ (apenas para o instalador no Linux/Mac; o instalador do Windows usa PowerShell nativo).

### Linux / Mac

```bash
curl -fsSL https://raw.githubusercontent.com/sismais/sismais-ai-plugins-public/main/scripts/install.sh | bash
```

### Windows (PowerShell)

```powershell
iwr -useb https://raw.githubusercontent.com/sismais/sismais-ai-plugins-public/main/scripts/install.ps1 | iex
```

> Se o PowerShell bloquear: `powershell -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/sismais/sismais-ai-plugins-public/main/scripts/install.ps1 | iex"`.

Na **primeira execução** do Claude Code após o instalador, o cliente pedirá confirmação para confiar no marketplace `sismais` — aceite. As configurações são lidas a cada inicialização do Claude Code; nenhum reinício adicional é necessário.

### Manual

1. Abra (ou crie) o arquivo `~/.claude/settings.json` (no Windows: `%USERPROFILE%\.claude\settings.json`).
2. Adicione (mesclando com o conteúdo existente):

   ```json
   {
     "extraKnownMarketplaces": {
       "sismais": {
         "source": { "source": "github", "repo": "sismais/sismais-ai-plugins-public" }
       }
     },
     "enabledPlugins": {
       "hello-sismais@sismais": true
     }
   }
   ```

3. Reabra o Claude Code. Aceite o prompt de confiança no primeiro uso.

## Plugins disponíveis

| Plugin | Descrição | Categoria |
|---|---|---|
| [hello-sismais](plugins/hello-sismais) | Plugin de exemplo — valida instalação | example |
| [consultor-fiscal-sismais](plugins/consultor-fiscal-sismais) | Consultor fiscal especialista em NF-e, NFC-e, NFS-e e tributação brasileira | fiscal |

## Como validar a instalação

Após rodar o instalador (e aceitar o prompt de confiança no primeiro lançamento), abra o Claude Code e pergunte:

> o sismais está instalado?

A skill `hello-sismais` deve responder confirmando que o marketplace está ativo.

## Para o time Sismais (acesso interno)

Há um marketplace privado paralelo com plugins internos da Sismais. **Em breve** — o repo `sismais/sismais-ai-plugins-private` ainda não está disponível. Quando estiver, este README receberá as instruções específicas (autenticação via `gh auth` ou token GitHub).

<a id="interno"></a>

## Contribuindo

Veja [CONTRIBUTING.md](CONTRIBUTING.md) para criar e submeter um novo plugin.

## Licença

[MIT](LICENSE)

## Contato

Issues e dúvidas: [github.com/sismais/sismais-ai-plugins-public/issues](https://github.com/sismais/sismais-ai-plugins-public/issues)
