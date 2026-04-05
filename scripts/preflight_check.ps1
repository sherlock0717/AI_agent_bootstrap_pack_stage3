param(
  [switch]$Strict,
  [switch]$SkipConfigValidation,
  [switch]$SkipSystemHealth
)

$root = Split-Path -Parent $PSScriptRoot
$passes = @()
$warnings = @()
$fails = @()

function Add-Pass {
  param([string]$Name, [string]$Message)
  $script:passes += [pscustomobject]@{
    name = $Name
    status = "pass"
    message = $Message
  }
}

function Add-Warning {
  param([string]$Name, [string]$Message)
  $script:warnings += [pscustomobject]@{
    name = $Name
    status = "warning"
    message = $Message
  }
}

function Add-Fail {
  param([string]$Name, [string]$Message)
  $script:fails += [pscustomobject]@{
    name = $Name
    status = "fail"
    message = $Message
  }
}

function Test-CommandExists {
  param([string]$CommandName, [string]$Label)
  $cmd = Get-Command $CommandName -ErrorAction SilentlyContinue
  if ($null -ne $cmd) {
    Add-Pass $Label "Command available: $CommandName"
    return $true
  } else {
    Add-Fail $Label "Command not found: $CommandName"
    return $false
  }
}

function Test-PathExists {
  param([string]$Label, [string]$Path)
  if (Test-Path $Path) {
    Add-Pass $Label "Found: $Path"
    return $true
  } else {
    Add-Fail $Label "Missing: $Path"
    return $false
  }
}

Write-Host ""
Write-Host "=== Preflight Check ===" -ForegroundColor Cyan

# 1. tool commands
$hasGit = Test-CommandExists -CommandName "git" -Label "command.git"
$hasPython = Test-CommandExists -CommandName "python" -Label "command.python"

# 2. critical directories
$dirs = @(
  "config",
  "scripts",
  "docs",
  "knowledge",
  "projects",
  "outputs",
  "logs"
)
foreach ($dir in $dirs) {
  Test-PathExists -Label ("dir." + $dir) -Path (Join-Path $root $dir) | Out-Null
}

# 3. critical files
$files = @(
  "AGENTS.md",
  "CLAUDE.md",
  ".github/copilot-instructions.md",
  "config/project_registry.yaml",
  "config/task_router.yaml",
  "config/system_routes.yaml",
  "config/tool_roles.yaml",
  "config/path_rules.yaml",
  "scripts/run_system_check.ps1",
  "scripts/validate_configs.ps1",
  "scripts/start_day.ps1",
  "scripts/start_project_work.ps1",
  "scripts/run_maintenance_cycle.ps1",
  "scripts/publish_snapshot.ps1"
)
foreach ($file in $files) {
  Test-PathExists -Label ("file." + $file.Replace("/",".")) -Path (Join-Path $root $file.Replace("/","\")) | Out-Null
}

# 4. git checks
if ($hasGit) {
  try {
    $remote = git -C $root remote -v | Out-String
    if ([string]::IsNullOrWhiteSpace($remote)) {
      Add-Warning "git.remote" "No git remote configured."
    } else {
      Add-Pass "git.remote" "Git remote found."
    }

    $status = git -C $root status --short | Out-String
    if ([string]::IsNullOrWhiteSpace($status)) {
      Add-Pass "git.status" "Working tree clean."
    } else {
      Add-Warning "git.status" "Working tree has pending changes."
    }

    $branch = git -C $root branch --show-current | Out-String
    if ([string]::IsNullOrWhiteSpace($branch)) {
      Add-Warning "git.branch" "Could not determine current branch."
    } else {
      Add-Pass "git.branch" ("Current branch: " + $branch.Trim())
    }
  }
  catch {
    Add-Fail "git.check" $_.Exception.Message
  }
}

# 5. python version
if ($hasPython) {
  try {
    $pythonVersion = python --version 2>&1 | Out-String
    Add-Pass "python.version" $pythonVersion.Trim()
  }
  catch {
    Add-Fail "python.version" $_.Exception.Message
  }
}

# 6. run config validation
if (-not $SkipConfigValidation) {
  try {
    $stamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
    $valJson = Join-Path $root ("outputs\health\" + $stamp + "-preflight-config-validation.json")
    $valMd = Join-Path $root ("outputs\health\" + $stamp + "-preflight-config-validation.md")

    & (Join-Path $PSScriptRoot "validate_configs.ps1") -OutputJson $valJson -OutputMd $valMd

    if (Test-Path $valJson) {
      $val = Get-Content -Path $valJson -Raw -Encoding UTF8 | ConvertFrom-Json
      if ([int]$val.fail_count -gt 0) {
        Add-Fail "config.validation" ("Config validation reported fail_count=" + $val.fail_count)
      } elseif ([int]$val.warning_count -gt 0) {
        Add-Warning "config.validation" ("Config validation passed with warnings=" + $val.warning_count)
      } else {
        Add-Pass "config.validation" "Config validation passed cleanly."
      }
    } else {
      Add-Fail "config.validation" "Validation JSON output was not created."
    }
  }
  catch {
    Add-Fail "config.validation" $_.Exception.Message
  }
} else {
  Add-Warning "config.validation" "Skipped by user."
}

# 7. run system health
if (-not $SkipSystemHealth) {
  try {
    & (Join-Path $PSScriptRoot "run_system_check.ps1")
    Add-Pass "system.health" "run_system_check.ps1 completed."
  }
  catch {
    Add-Fail "system.health" $_.Exception.Message
  }
} else {
  Add-Warning "system.health" "Skipped by user."
}

# 8. write report
$reportDir = Join-Path $root "outputs\health"
New-Item -ItemType Directory -Path $reportDir -Force | Out-Null

$stamp2 = Get-Date -Format "yyyy-MM-dd_HHmmss"
$jsonPath = Join-Path $reportDir ($stamp2 + "-preflight.json")
$mdPath = Join-Path $reportDir ($stamp2 + "-preflight.md")

$result = [pscustomobject]@{
  timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
  root = $root
  pass_count = $passes.Count
  warning_count = $warnings.Count
  fail_count = $fails.Count
  passes = $passes
  warnings = $warnings
  fails = $fails
}

$result | ConvertTo-Json -Depth 6 | Set-Content -Path $jsonPath -Encoding UTF8

$md = "# Preflight Check`r`n`r`n"
$md += "- 时间: $($result.timestamp)`r`n"
$md += "- Root: $($result.root)`r`n"
$md += "- Pass: $($result.pass_count)`r`n"
$md += "- Warning: $($result.warning_count)`r`n"
$md += "- Fail: $($result.fail_count)`r`n`r`n"

$md += "## Passes`r`n"
if ($passes.Count -eq 0) {
  $md += "- 无`r`n"
} else {
  foreach ($item in $passes) {
    $md += "- [$($item.name)] $($item.message)`r`n"
  }
}

$md += "`r`n## Warnings`r`n"
if ($warnings.Count -eq 0) {
  $md += "- 无`r`n"
} else {
  foreach ($item in $warnings) {
    $md += "- [$($item.name)] $($item.message)`r`n"
  }
}

$md += "`r`n## Fails`r`n"
if ($fails.Count -eq 0) {
  $md += "- 无`r`n"
} else {
  foreach ($item in $fails) {
    $md += "- [$($item.name)] $($item.message)`r`n"
  }
}

Set-Content -Path $mdPath -Value $md -Encoding UTF8

Write-Host ""
Write-Host "=== Preflight Summary ===" -ForegroundColor Cyan
Write-Host "Pass    : $($result.pass_count)" -ForegroundColor Green
Write-Host "Warning : $($result.warning_count)" -ForegroundColor Yellow
Write-Host "Fail    : $($result.fail_count)" -ForegroundColor Red
Write-Host "JSON    : $jsonPath"
Write-Host "MD      : $mdPath"
Write-Host ""

if ($Strict -and $fails.Count -gt 0) {
  exit 1
}
