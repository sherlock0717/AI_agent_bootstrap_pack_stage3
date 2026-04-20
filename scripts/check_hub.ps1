param(
    [switch]$Strict,
    [switch]$SkipDocker
)

$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$HubRoot = 'D:\AI_Hub'
$OutputDir = Join-Path $RepoRoot 'outputs\health'

New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

$passes = @()
$warnings = @()
$fails = @()

function Add-Result {
    param([string]$Status, [string]$Name, [string]$Message)
    $item = [pscustomobject]@{ name = $Name; status = $Status; message = $Message }
    switch ($Status) {
        'pass' { $script:passes += $item }
        'warning' { $script:warnings += $item }
        'fail' { $script:fails += $item }
    }
}

function Test-HubPath {
    param([string]$Name, [string]$Path, [switch]$Required)
    if (Test-Path $Path) {
        Add-Result 'pass' $Name "Found: $Path"
    } elseif ($Required) {
        Add-Result 'fail' $Name "Missing: $Path"
    } else {
        Add-Result 'warning' $Name "Missing optional path: $Path"
    }
}

function Test-HubCommand {
    param([string]$Name, [string]$Command, [switch]$Required)
    $cmd = Get-Command $Command -ErrorAction SilentlyContinue
    if ($null -ne $cmd) {
        Add-Result 'pass' $Name "Command available: $Command"
        return $true
    }
    if ($Required) {
        Add-Result 'fail' $Name "Command not found: $Command"
    } else {
        Add-Result 'warning' $Name "Optional command not found: $Command"
    }
    return $false
}

function Test-DockerStatus {
    if ($SkipDocker) {
        Add-Result 'warning' 'docker.status' 'Skipped by user.'
        return
    }

    $hasDocker = Test-HubCommand -Name 'command.docker' -Command 'docker' -Required
    if (-not $hasDocker) { return }

    try {
        docker info | Out-Null
        Add-Result 'pass' 'docker.info' 'Docker daemon is available.'
    } catch {
        Add-Result 'fail' 'docker.info' 'Docker command exists, but Docker daemon is not available. Start Docker Desktop first.'
        return
    }

    try {
        $runningId = docker ps -q -f 'name=^n8n$' | Out-String
        $existingId = docker ps -aq -f 'name=^n8n$' | Out-String
        if (-not [string]::IsNullOrWhiteSpace($runningId)) {
            Add-Result 'pass' 'n8n.container' 'n8n container is running.'
        } elseif (-not [string]::IsNullOrWhiteSpace($existingId)) {
            Add-Result 'warning' 'n8n.container' 'n8n container exists but is not running.'
        } else {
            Add-Result 'warning' 'n8n.container' 'n8n container has not been created yet.'
        }
    } catch {
        Add-Result 'warning' 'n8n.container' $_.Exception.Message
    }
}

Write-Host ''
Write-Host '=== AI Hub Repository Health Check ===' -ForegroundColor Cyan
Write-Host "Repository: $RepoRoot"
Write-Host "Runtime   : $HubRoot"
Write-Host ''

Test-HubPath -Name 'repo.config' -Path (Join-Path $RepoRoot 'config') -Required
Test-HubPath -Name 'repo.docs' -Path (Join-Path $RepoRoot 'docs') -Required
Test-HubPath -Name 'repo.scripts' -Path (Join-Path $RepoRoot 'scripts') -Required
Test-HubPath -Name 'config.hub_manifest' -Path (Join-Path $RepoRoot 'config\hub_manifest.yaml') -Required
Test-HubPath -Name 'config.capabilities' -Path (Join-Path $RepoRoot 'config\capabilities.yaml') -Required
Test-HubPath -Name 'config.services' -Path (Join-Path $RepoRoot 'config\services.yaml') -Required
Test-HubPath -Name 'config.project_registry' -Path (Join-Path $RepoRoot 'config\project_registry.yaml') -Required

Test-HubPath -Name 'runtime.root' -Path $HubRoot -Required
Test-HubPath -Name 'runtime.config' -Path (Join-Path $HubRoot 'config') -Required
Test-HubPath -Name 'runtime.docs' -Path (Join-Path $HubRoot 'docs') -Required
Test-HubPath -Name 'runtime.scripts' -Path (Join-Path $HubRoot 'scripts') -Required
Test-HubPath -Name 'runtime.obsidian_vault' -Path (Join-Path $HubRoot 'obsidian_vault') -Required
Test-HubPath -Name 'runtime.voice' -Path (Join-Path $HubRoot 'voice') -Required
Test-HubPath -Name 'runtime.tools' -Path (Join-Path $HubRoot 'tools') -Required
Test-HubPath -Name 'runtime.venvs' -Path (Join-Path $HubRoot 'venvs') -Required
Test-HubPath -Name 'runtime.check_script' -Path (Join-Path $HubRoot 'scripts\check_hub.ps1') -Required
Test-HubPath -Name 'runtime.start_script' -Path (Join-Path $HubRoot 'scripts\start_hub.ps1') -Required
Test-HubPath -Name 'runtime.start_n8n' -Path (Join-Path $HubRoot 'scripts\start_n8n.ps1') -Required
Test-HubPath -Name 'runtime.open_voice' -Path (Join-Path $HubRoot 'scripts\open_voice_env.ps1') -Required
Test-HubPath -Name 'voice.edge_tts' -Path (Join-Path $HubRoot 'voice\.venv\Scripts\edge-tts.exe') -Required
Test-HubPath -Name 'voice.whisper_test' -Path (Join-Path $HubRoot 'voice\test_whisper.py') -Required
Test-HubPath -Name 'graphify.cli' -Path (Join-Path $HubRoot 'venvs\graphify\Scripts\graphify.exe') -Required
Test-HubPath -Name 'codebase_memory.binary' -Path (Join-Path $HubRoot 'tools\codebase-memory-mcp\ui_extract\codebase-memory-mcp.exe') -Required

Test-HubCommand -Name 'command.python' -Command 'python' -Required | Out-Null
Test-HubCommand -Name 'command.obsidian' -Command 'obsidian' | Out-Null
Test-DockerStatus

$timestamp = Get-Date -Format 'yyyy-MM-dd_HHmmss'
$jsonPath = Join-Path $OutputDir "$timestamp-hub-repo-health.json"
$mdPath = Join-Path $OutputDir "$timestamp-hub-repo-health.md"

$result = [pscustomobject]@{
    timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    repository_root = $RepoRoot
    hub_runtime_root = $HubRoot
    pass_count = $passes.Count
    warning_count = $warnings.Count
    fail_count = $fails.Count
    passes = $passes
    warnings = $warnings
    fails = $fails
}

$result | ConvertTo-Json -Depth 6 | Set-Content -Path $jsonPath -Encoding UTF8

$md = "# AI Hub Repository Health Check`r`n`r`n"
$md += "- Time: $($result.timestamp)`r`n"
$md += "- Repository: $($result.repository_root)`r`n"
$md += "- Runtime: $($result.hub_runtime_root)`r`n"
$md += "- Pass: $($result.pass_count)`r`n"
$md += "- Warning: $($result.warning_count)`r`n"
$md += "- Fail: $($result.fail_count)`r`n`r`n"

$md += "## Passes`r`n"
if ($passes.Count -eq 0) { $md += "- None`r`n" } else { foreach ($item in $passes) { $md += "- [$($item.name)] $($item.message)`r`n" } }
$md += "`r`n## Warnings`r`n"
if ($warnings.Count -eq 0) { $md += "- None`r`n" } else { foreach ($item in $warnings) { $md += "- [$($item.name)] $($item.message)`r`n" } }
$md += "`r`n## Fails`r`n"
if ($fails.Count -eq 0) { $md += "- None`r`n" } else { foreach ($item in $fails) { $md += "- [$($item.name)] $($item.message)`r`n" } }

Set-Content -Path $mdPath -Value $md -Encoding UTF8

Write-Host ''
Write-Host '=== AI Hub Repository Health Summary ===' -ForegroundColor Cyan
Write-Host "Pass    : $($result.pass_count)" -ForegroundColor Green
Write-Host "Warning : $($result.warning_count)" -ForegroundColor Yellow
Write-Host "Fail    : $($result.fail_count)" -ForegroundColor Red
Write-Host "JSON    : $jsonPath"
Write-Host "MD      : $mdPath"
Write-Host ''

if ($Strict -and $fails.Count -gt 0) { exit 1 }