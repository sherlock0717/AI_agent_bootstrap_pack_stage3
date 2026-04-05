param(
  [switch]$Strict,
  [string]$OutputJson = "",
  [string]$OutputMd = ""
)

$root = Split-Path -Parent $PSScriptRoot
$issues = @()
$warnings = @()
$passes = @()

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

function Add-Issue {
  param([string]$Name, [string]$Message)
  $script:issues += [pscustomobject]@{
    name = $Name
    status = "fail"
    message = $Message
  }
}

function Test-FileExists {
  param([string]$Label, [string]$Path)
  if (Test-Path $Path) {
    Add-Pass $Label "Found: $Path"
    return $true
  } else {
    Add-Issue $Label "Missing file: $Path"
    return $false
  }
}

function Test-Pattern {
  param(
    [string]$Label,
    [string]$Path,
    [string]$Pattern,
    [string]$Description
  )

  if (!(Test-Path $Path)) {
    Add-Issue $Label "Cannot inspect missing file: $Path"
    return $false
  }

  $content = Get-Content -Path $Path -Raw -Encoding UTF8
  if ($content -match $Pattern) {
    Add-Pass $Label "Found $Description"
    return $true
  } else {
    Add-Issue $Label "Missing $Description in $Path"
    return $false
  }
}

function Get-RegexValues {
  param(
    [string]$Path,
    [string]$Pattern
  )

  if (!(Test-Path $Path)) { return @() }

  $content = Get-Content -Path $Path -Raw -Encoding UTF8
  $matches = [regex]::Matches($content, $Pattern)
  $results = @()

  foreach ($m in $matches) {
    $results += $m.Groups[1].Value
  }

  return $results
}

$configDir = Join-Path $root "config"
$projectsDir = Join-Path $root "projects"

$projectRegistry = Join-Path $configDir "project_registry.yaml"
$taskRouter = Join-Path $configDir "task_router.yaml"
$systemRoutes = Join-Path $configDir "system_routes.yaml"
$toolRoles = Join-Path $configDir "tool_roles.yaml"
$techWatch = Join-Path $configDir "tech_watch_sources.yaml"

# 1. key config files
Test-FileExists "project_registry" $projectRegistry | Out-Null
Test-FileExists "task_router" $taskRouter | Out-Null
Test-FileExists "system_routes" $systemRoutes | Out-Null
Test-FileExists "tool_roles" $toolRoles | Out-Null
Test-FileExists "tech_watch_sources" $techWatch | Out-Null

# 2. required patterns in project_registry
$registryPatterns = @(
  @{ key = "projects"; pattern = "(?m)^\s*projects:\s*$"; desc = "root key projects" },
  @{ key = "id"; pattern = "(?m)^\s*-\s*id:\s*.+$"; desc = "project id entry" },
  @{ key = "name"; pattern = "(?m)^\s*name:\s*.+$"; desc = "project name entry" },
  @{ key = "manifest_path"; pattern = "(?m)^\s*manifest_path:\s*.+$"; desc = "manifest_path" },
  @{ key = "local_agents_path"; pattern = "(?m)^\s*local_agents_path:\s*.+$"; desc = "local_agents_path" }
)
foreach ($item in $registryPatterns) {
  Test-Pattern "project_registry.$($item.key)" $projectRegistry $item.pattern $item.desc | Out-Null
}

# 3. referenced manifest paths and local agents paths
$manifestPaths = Get-RegexValues -Path $projectRegistry -Pattern '(?m)^\s*manifest_path:\s*"?([^"\r\n]+)"?\s*$'
$agentPaths = Get-RegexValues -Path $projectRegistry -Pattern '(?m)^\s*local_agents_path:\s*"?([^"\r\n]+)"?\s*$'

foreach ($relPath in $manifestPaths) {
  $full = Join-Path $root $relPath
  if (Test-Path $full) {
    Add-Pass "registry.manifest_ref" "Found manifest: $relPath"
  } else {
    Add-Issue "registry.manifest_ref" "Missing manifest referenced by registry: $relPath"
  }
}

foreach ($relPath in $agentPaths) {
  $full = Join-Path $root $relPath
  if (Test-Path $full) {
    Add-Pass "registry.local_agents_ref" "Found local agents: $relPath"
  } else {
    Add-Issue "registry.local_agents_ref" "Missing local agents referenced by registry: $relPath"
  }
}

# 4. inspect each project manifest
$manifestFiles = Get-ChildItem -Path $projectsDir -Recurse -File -Filter "project_manifest.yaml" -ErrorAction SilentlyContinue

foreach ($mf in $manifestFiles) {
  $labelBase = "manifest.$($mf.Directory.Name)"
  $isTemplateManifest = ($mf.Directory.Name -eq "_project_template")

  $requiredManifestPatterns = @(
    @{ key = "project"; pattern = "(?m)^\s*project:\s*$"; desc = "root key project" },
    @{ key = "id"; pattern = "(?m)^\s*id:\s*.+$"; desc = "id" },
    @{ key = "name"; pattern = "(?m)^\s*name:\s*.+$"; desc = "name" },
    @{ key = "local_agents_path"; pattern = "(?m)^\s*local_agents_path:\s*.+$"; desc = "local_agents_path" },
    @{ key = "knowledge_scope"; pattern = "(?m)^\s*knowledge_scope:\s*.+$"; desc = "knowledge_scope" },
    @{ key = "outputs_path"; pattern = "(?m)^\s*outputs_path:\s*.+$"; desc = "outputs_path" },
    @{ key = "log_path"; pattern = "(?m)^\s*log_path:\s*.+$"; desc = "log_path" }
  )

  foreach ($item in $requiredManifestPatterns) {
    Test-Pattern "$labelBase.$($item.key)" $mf.FullName $item.pattern $item.desc | Out-Null
  }

  $knowledgeScope = Get-RegexValues -Path $mf.FullName -Pattern '(?m)^\s*knowledge_scope:\s*"?([^"\r\n]+)"?\s*$'
  $outputsPath = Get-RegexValues -Path $mf.FullName -Pattern '(?m)^\s*outputs_path:\s*"?([^"\r\n]+)"?\s*$'
  $logPath = Get-RegexValues -Path $mf.FullName -Pattern '(?m)^\s*log_path:\s*"?([^"\r\n]+)"?\s*$'
  $localAgentsPath = Get-RegexValues -Path $mf.FullName -Pattern '(?m)^\s*local_agents_path:\s*"?([^"\r\n]+)"?\s*$'

  foreach ($rel in $knowledgeScope) {
    $full = Join-Path $root $rel
    if (Test-Path $full) {
      Add-Pass "$labelBase.knowledge_scope_ref" "Found knowledge scope: $rel"
    } elseif ($isTemplateManifest -and $rel -match "__PROJECT_NAME__") {
      Add-Warning "$labelBase.knowledge_scope_ref" "Template placeholder path not resolved yet: $rel"
    } else {
      Add-Warning "$labelBase.knowledge_scope_ref" "Knowledge scope path not found: $rel"
    }
  }

  foreach ($rel in $outputsPath) {
    $full = Join-Path $root $rel
    if (Test-Path $full) {
      Add-Pass "$labelBase.outputs_path_ref" "Found outputs path: $rel"
    } elseif ($isTemplateManifest -and $rel -match "__PROJECT_NAME__") {
      Add-Warning "$labelBase.outputs_path_ref" "Template placeholder path not resolved yet: $rel"
    } else {
      Add-Warning "$labelBase.outputs_path_ref" "Outputs path not found: $rel"
    }
  }

  foreach ($rel in $logPath) {
    $full = Join-Path $root $rel
    if (Test-Path $full) {
      Add-Pass "$labelBase.log_path_ref" "Found log path: $rel"
    } elseif ($isTemplateManifest -and $rel -match "__PROJECT_NAME__") {
      Add-Warning "$labelBase.log_path_ref" "Template placeholder path not resolved yet: $rel"
    } else {
      Add-Warning "$labelBase.log_path_ref" "Log path not found: $rel"
    }
  }

  foreach ($rel in $localAgentsPath) {
    $full = Join-Path $root $rel
    if (Test-Path $full) {
      Add-Pass "$labelBase.local_agents_ref" "Found local agents path: $rel"
    } elseif ($isTemplateManifest -and $rel -match "__PROJECT_NAME__") {
      Add-Warning "$labelBase.local_agents_ref" "Template placeholder path not resolved yet: $rel"
    } else {
      Add-Issue "$labelBase.local_agents_ref" "Missing local agents path: $rel"
    }
  }
}

# 5. task_router key checks
$taskRouterPatterns = @(
  @{ key = "task_routes"; pattern = "(?m)^\s*task_routes:\s*$"; desc = "root key task_routes" },
  @{ key = "preferred_tool"; pattern = "(?m)^\s*preferred_tool:\s*.+$"; desc = "preferred_tool" },
  @{ key = "fallback_tool"; pattern = "(?m)^\s*fallback_tool:\s*.+$"; desc = "fallback_tool" },
  @{ key = "script_first"; pattern = "(?m)^\s*script_first:\s*.+$"; desc = "script_first" },
  @{ key = "notes_target"; pattern = "(?m)^\s*notes_target:\s*.+$"; desc = "notes_target" },
  @{ key = "description"; pattern = "(?m)^\s*description:\s*.+$"; desc = "description" }
)
foreach ($item in $taskRouterPatterns) {
  Test-Pattern "task_router.$($item.key)" $taskRouter $item.pattern $item.desc | Out-Null
}

# 6. system_routes and standard entrypoints
Test-Pattern "system_routes.daily_routes" $systemRoutes '(?m)^\s*daily_routes:\s*$' "daily_routes" | Out-Null
Test-Pattern "system_routes.standard_entrypoints" $systemRoutes '(?m)^\s*standard_entrypoints:\s*$' "standard_entrypoints" | Out-Null

$entryScriptPaths = Get-RegexValues -Path $systemRoutes -Pattern '(?m)^\s*[a-zA-Z0-9_]+\s*:\s*"?(scripts/[^"\r\n]+)"?\s*$'
foreach ($rel in $entryScriptPaths) {
  $full = Join-Path $root ($rel -replace '/', '\')
  if (Test-Path $full) {
    Add-Pass "system_routes.entrypoint_ref" "Found entrypoint script: $rel"
  } else {
    Add-Issue "system_routes.entrypoint_ref" "Missing entrypoint script: $rel"
  }
}

# 7. tool_roles and tech_watch basic checks
Test-Pattern "tool_roles.tools" $toolRoles '(?m)^\s*tools:\s*$' "root key tools" | Out-Null
Test-Pattern "tech_watch.sources" $techWatch '(?m)^[\s\-]*.+$' "non-empty content" | Out-Null

# summary objects
$summary = [pscustomobject]@{
  timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
  root = $root
  pass_count = $passes.Count
  warning_count = $warnings.Count
  fail_count = $issues.Count
  passes = $passes
  warnings = $warnings
  issues = $issues
}

if ([string]::IsNullOrWhiteSpace($OutputJson)) {
  $OutputJson = Join-Path $root "outputs\health\config_validation.json"
}

if ([string]::IsNullOrWhiteSpace($OutputMd)) {
  $OutputMd = Join-Path $root "outputs\health\config_validation.md"
}

New-Item -ItemType Directory -Path (Split-Path $OutputJson -Parent) -Force | Out-Null
New-Item -ItemType Directory -Path (Split-Path $OutputMd -Parent) -Force | Out-Null

$summary | ConvertTo-Json -Depth 6 | Set-Content -Path $OutputJson -Encoding UTF8

$md = "# Config Validation`r`n`r`n"
$md += "- 时间: $($summary.timestamp)`r`n"
$md += "- Root: $($summary.root)`r`n"
$md += "- Pass: $($summary.pass_count)`r`n"
$md += "- Warning: $($summary.warning_count)`r`n"
$md += "- Fail: $($summary.fail_count)`r`n`r`n"

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
if ($issues.Count -eq 0) {
  $md += "- 无`r`n"
} else {
  foreach ($item in $issues) {
    $md += "- [$($item.name)] $($item.message)`r`n"
  }
}

Set-Content -Path $OutputMd -Value $md -Encoding UTF8

Write-Host ""
Write-Host "=== Config Validation Summary ===" -ForegroundColor Cyan
Write-Host "Pass    : $($summary.pass_count)" -ForegroundColor Green
Write-Host "Warning : $($summary.warning_count)" -ForegroundColor Yellow
Write-Host "Fail    : $($summary.fail_count)" -ForegroundColor Red
Write-Host "JSON    : $OutputJson"
Write-Host "MD      : $OutputMd"
Write-Host ""

if ($Strict -and $issues.Count -gt 0) {
  exit 1
}
