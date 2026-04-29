#!/usr/bin/env bash
# Onboarding do marketplace público Sismais para Claude Code (Linux/Mac).
#
# Uso:
#   curl -fsSL https://raw.githubusercontent.com/sismais/sismais-ai-plugins/main/scripts/install.sh | bash

set -euo pipefail

MARKETPLACE_NAME="sismais"
MARKETPLACE_REPO="sismais/sismais-ai-plugins"
SETTINGS_FILE="${HOME}/.claude/settings.json"

c_green=$'\033[0;32m'
c_red=$'\033[0;31m'
c_yellow=$'\033[1;33m'
c_reset=$'\033[0m'

info()    { printf '%s\n' "$1"; }
ok()      { printf '%b✔%b %s\n' "$c_green" "$c_reset" "$1"; }
warn()    { printf '%b!%b %s\n' "$c_yellow" "$c_reset" "$1"; }
fail()    { printf '%b✗%b %s\n' "$c_red" "$c_reset" "$1" >&2; exit 1; }

echo
info "══════════════════════════════════════════════════"
info " Instalação do marketplace público Sismais"
info " para Claude Code"
info "══════════════════════════════════════════════════"
echo

# 1. Pré-checagem: Claude Code
command -v claude >/dev/null 2>&1 \
  || fail "Claude Code não encontrado. Instale antes: https://docs.anthropic.com/pt-br/docs/claude-code/overview"
ok "Claude Code detectado: $(claude --version 2>&1 | head -1)"

# 2. Pré-checagem: Node.js
command -v node >/dev/null 2>&1 \
  || fail "Node.js é necessário para edição segura do settings.json. Instale o Node 20+ em https://nodejs.org/"
ok "Node.js detectado: $(node --version)"

echo

# 3. Garantir que settings.json existe
mkdir -p "$(dirname "$SETTINGS_FILE")"
if [[ ! -f "$SETTINGS_FILE" ]]; then
  printf '{}' > "$SETTINGS_FILE"
  ok "Criado $SETTINGS_FILE"
else
  ok "Arquivo de configurações encontrado: $SETTINGS_FILE"
fi

# 4. Backup do settings.json
ts=$(date +%Y%m%d-%H%M%S)
cp "$SETTINGS_FILE" "${SETTINGS_FILE}.bak.${ts}"
ok "Backup salvo em ${SETTINGS_FILE}.bak.${ts}"

echo

# 5. Adicionar marketplace ao settings.json (idempotente)
node --input-type=module <<EOF
import { readFileSync, writeFileSync } from 'node:fs';

const path = process.env.SETTINGS_FILE;
let cfg;
try {
  cfg = JSON.parse(readFileSync(path, 'utf8'));
} catch {
  cfg = {};
}

cfg.extraKnownMarketplaces ??= {};

const desired = { source: { source: 'github', repo: '${MARKETPLACE_REPO}' } };
const existing = cfg.extraKnownMarketplaces['${MARKETPLACE_NAME}'];

if (JSON.stringify(existing) !== JSON.stringify(desired)) {
  cfg.extraKnownMarketplaces['${MARKETPLACE_NAME}'] = desired;
}

writeFileSync(path, JSON.stringify(cfg, null, 2) + '\n');
EOF
ok "Marketplace público '${MARKETPLACE_NAME}' configurado em extraKnownMarketplaces"

# 6. Pergunta: membro do time interno?
read -r -p "Você é membro do time Sismais (acesso ao marketplace privado)? [s/N] " is_internal
echo
if [[ "${is_internal,,}" =~ ^(s|y|sim|yes)$ ]]; then
  warn "O marketplace interno ainda não está disponível publicamente."
  warn "Quando estiver, rode novamente este script ou siga as instruções em:"
  warn "  https://github.com/sismais/sismais-ai-plugins#interno"
fi

# 7. Plugins disponíveis e pergunta sobre consultor-fiscal-sismais
echo
info "Plugins disponíveis no marketplace público:"
info "  [x] hello-sismais            — validador de instalação (sempre habilitado)"
info "  [ ] consultor-fiscal-sismais — consultor fiscal NF-e/NFC-e/NFS-e"
echo
read -r -p "Habilitar 'consultor-fiscal-sismais' agora? [s/N] " want_fiscal
echo

# 8. Habilitar plugins escolhidos (idempotente)
if [[ "${want_fiscal,,}" =~ ^(s|y|sim|yes)$ ]]; then
  ENABLE_FISCAL="yes"
else
  ENABLE_FISCAL="no"
fi

node --input-type=module <<EOF
import { readFileSync, writeFileSync } from 'node:fs';

const path = process.env.SETTINGS_FILE;
let cfg;
try {
  cfg = JSON.parse(readFileSync(path, 'utf8'));
} catch {
  cfg = {};
}

cfg.enabledPlugins ??= {};
cfg.enabledPlugins['hello-sismais@${MARKETPLACE_NAME}'] = true;

if ('${ENABLE_FISCAL}' === 'yes') {
  cfg.enabledPlugins['consultor-fiscal-sismais@${MARKETPLACE_NAME}'] = true;
}

writeFileSync(path, JSON.stringify(cfg, null, 2) + '\n');
EOF

if [[ "$ENABLE_FISCAL" == "yes" ]]; then
  ok "Plugins habilitados: hello-sismais, consultor-fiscal-sismais"
else
  ok "Plugin habilitado: hello-sismais"
fi

# 9. Mensagem final
echo
info "══════════════════════════════════════════════════"
ok "Configuração concluída!"
info "══════════════════════════════════════════════════"
echo
info "Próximos passos:"
info "  1. Abra (ou reabra) o Claude Code."
info "  2. Na primeira execução, ele pedirá confirmação para confiar no"
info "     marketplace Sismais — aceite quando solicitado."
info "  3. Para validar a instalação, pergunte ao Claude Code:"
info "     'o sismais está instalado?'"
echo
