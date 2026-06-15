# Onboarding do marketplace público Sismais para Claude Code (Windows).
#
# Uso:
#   iwr -useb https://raw.githubusercontent.com/sismais/sismais-ai-plugins-public/main/scripts/install.ps1 | iex

$ErrorActionPreference = 'Stop'

$MarketplaceName = 'sismais'
$MarketplaceRepo = 'sismais/sismais-ai-plugins-public'
$SettingsFile    = Join-Path $HOME '.claude/settings.json'

function Write-Ok($msg)   { Write-Host "✔ $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "! $msg" -ForegroundColor Yellow }
function Fail($msg)       { Write-Host "✗ $msg" -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "═══════════════════════════════════════════════════"
Write-Host " Instalação do marketplace público Sismais"
Write-Host " para Claude Code"
Write-Host "═══════════════════════════════════════════════════"
Write-Host ""

# 1. Pré-checagem: Claude Code
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Fail "Claude Code não encontrado. Instale antes: https://docs.anthropic.com/pt-br/docs/claude-code/overview"
}
$claudeVersion = (claude --version 2>&1 | Select-Object -First 1)
Write-Ok "Claude Code detectado: $claudeVersion"

Write-Host ""

# 2. Garantir settings.json
$settingsDir = Split-Path $SettingsFile -Parent
if (-not (Test-Path $settingsDir)) { New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null }
if (-not (Test-Path $SettingsFile)) {
    '{}' | Set-Content -Path $SettingsFile -Encoding UTF8 -NoNewline
    Write-Ok "Criado $SettingsFile"
} else {
    Write-Ok "Arquivo de configurações encontrado: $SettingsFile"
}

# 3. Backup
$ts = Get-Date -Format 'yyyyMMdd-HHmmss'
Copy-Item $SettingsFile "$SettingsFile.bak.$ts"
Write-Ok "Backup salvo em $SettingsFile.bak.$ts"

Write-Host ""

# 4. Carregar settings (com fallback se vazio/corrompido)
try {
    $rawContent = Get-Content -Path $SettingsFile -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($rawContent)) {
        $cfg = @{}
    } else {
        $cfg = $rawContent | ConvertFrom-Json -AsHashtable
        if ($null -eq $cfg) { $cfg = @{} }
    }
} catch {
    Write-Warn "settings.json corrompido — usando objeto vazio. Backup mantido em $SettingsFile.bak.$ts"
    $cfg = @{}
}

# 5. Adicionar marketplace (com aviso se conflito)
if (-not $cfg.ContainsKey('extraKnownMarketplaces')) {
    $cfg['extraKnownMarketplaces'] = @{}
}
$desired = @{ source = @{ source = 'github'; repo = $MarketplaceRepo } }
$existing = $cfg['extraKnownMarketplaces'][$MarketplaceName]

# Compare canonically: normalize both objects to JSON with consistent key order by going through
# PSCustomObject (which ConvertTo-Json serializes in definition order) then parsing and re-serializing.
# We normalize via the same JSON text → PSCustomObject → JSON path for both sides.
function ConvertTo-NormalizedJson($obj) {
    # Convert to JSON string first (may have varying key order from hashtable),
    # then parse as PSCustomObject (preserves JSON key order), then re-serialize.
    ($obj | ConvertTo-Json -Depth 10) | ConvertFrom-Json | ConvertTo-Json -Depth 10 -Compress
}
$existingNorm = if ($null -ne $existing) { ConvertTo-NormalizedJson $existing } else { '' }
$desiredNorm  = ConvertTo-NormalizedJson $desired

if (($null -ne $existing) -and ($existingNorm -ne $desiredNorm)) {
    Write-Warn "AVISO: extraKnownMarketplaces.$MarketplaceName já existia com configuração diferente — substituindo pela canônica"
}
if ($existingNorm -ne $desiredNorm) {
    $cfg['extraKnownMarketplaces'][$MarketplaceName] = $desired
}
Write-Ok "Marketplace público '$MarketplaceName' configurado em extraKnownMarketplaces"

# 6. Pergunta interno
Write-Host ""
$isInternal = Read-Host "Você é membro do time Sismais (acesso ao marketplace privado)? [s/N]"
Write-Host ""
if ($isInternal -match '^(s|y|sim|yes)$') {
    Write-Warn "O marketplace interno ainda não está disponível publicamente."
    Write-Warn "Quando estiver, rode novamente este script ou siga as instruções em:"
    Write-Warn "  https://github.com/sismais/sismais-ai-plugins-public#interno"
}

# 7. Plugins
Write-Host ""
Write-Host "Plugins disponíveis no marketplace público:"
Write-Host "  [x] hello-sismais            — validador de instalação (sempre habilitado)"
Write-Host "  [ ] consultor-fiscal-sismais — consultor fiscal NF-e/NFC-e/NFS-e"
Write-Host ""
$wantFiscal = Read-Host "Habilitar 'consultor-fiscal-sismais' agora? [s/N]"
Write-Host ""

$enableFiscal = ($wantFiscal -match '^(s|y|sim|yes)$')

# 8. Habilitar plugins (idempotente — sempre seta o valor explícito)
if (-not $cfg.ContainsKey('enabledPlugins')) {
    $cfg['enabledPlugins'] = @{}
}
$cfg['enabledPlugins']["hello-sismais@$MarketplaceName"] = $true
$cfg['enabledPlugins']["consultor-fiscal-sismais@$MarketplaceName"] = $enableFiscal

# 9. Escrever de volta (com newline final, alinhado com install.sh)
$json = ($cfg | ConvertTo-Json -Depth 10) + "`n"
[System.IO.File]::WriteAllText($SettingsFile, $json, [System.Text.UTF8Encoding]::new($false))

if ($enableFiscal) {
    Write-Ok "Plugins habilitados: hello-sismais, consultor-fiscal-sismais"
} else {
    Write-Ok "Plugin habilitado: hello-sismais"
}

# 10. Mensagem final
Write-Host ""
Write-Host "═══════════════════════════════════════════════════"
Write-Ok "Configuração concluída!"
Write-Host "═══════════════════════════════════════════════════"
Write-Host ""
Write-Host "Próximos passos:"
Write-Host "  1. Abra (ou reabra) o Claude Code."
Write-Host "  2. Na primeira execução, ele pedirá confirmação para confiar no"
Write-Host "     marketplace Sismais — aceite quando solicitado."
Write-Host "  3. Para validar a instalação, pergunte ao Claude Code:"
Write-Host "     'o sismais está instalado?'"
Write-Host ""
