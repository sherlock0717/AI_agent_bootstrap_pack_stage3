param(
  [Parameter(Mandatory=$true)][string]$ProjectId,
  [Parameter(Mandatory=$true)][string]$ProjectName,
  [Parameter(Mandatory=$true)][string]$ExternalRootPath,
  [string]$ProjectType = "pilot_project",
  [string]$ProjectRole = "external_subproject",
  [string]$Owner = "孙海澄",
  [string]$Description = "",
  [string]$Purpose = "作为 AI 系统接入的外部项目",
  [string]$Limitations = "当前阶段以系统接入与流程验证为主。"
)

$root = Split-Path -Parent $PSScriptRoot
$templateDir = Join-Path $root "projects\_project_template"
$projectDir = Join-Path $root ("projects\" + $ProjectName)

if (!(Test-Path $templateDir)) {
  throw "模板目录不存在: $templateDir"
}

if (Test-Path $projectDir) {
  throw "项目目录已存在: $projectDir"
}

Copy-Item -Path $templateDir -Destination $projectDir -Recurse

$externalPathNormalized = $ExternalRootPath -replace "\\","/"

$replaceMap = @{
  "__PROJECT_ID__" = $ProjectId
  "__PROJECT_NAME__" = $ProjectName
  "__PROJECT_TYPE__" = $ProjectType
  "__PROJECT_ROLE__" = $ProjectRole
  "__EXTERNAL_PROJECT_ROOT_PATH__" = $externalPathNormalized
  "__OWNER__" = $Owner
  "__PROJECT_DESCRIPTION__" = $Description
  "__PROJECT_PURPOSE__" = $Purpose
  "__CURRENT_LIMITATIONS__" = $Limitations
}

$targetFiles = @(
  (Join-Path $projectDir "project_manifest.yaml"),
  (Join-Path $projectDir "AGENTS.local.md")
)

foreach ($file in $targetFiles) {
  $content = Get-Content -Path $file -Raw -Encoding UTF8
  foreach ($key in $replaceMap.Keys) {
    $content = $content.Replace($key, $replaceMap[$key])
  }
  Set-Content -Path $file -Value $content -Encoding UTF8
}

$readme = @"
# $ProjectName

这是 $ProjectName 在系统母目录中的项目登记点。

- 项目 ID：$ProjectId
- 项目类型：$ProjectType
- 项目角色：$ProjectRole
- 外部仓库路径：$externalPathNormalized

注意：
- 这里不是项目真实代码仓库
- 这里只保存项目在系统中的接入信息、manifest 和局部规则
"@
Set-Content -Path (Join-Path $projectDir "README.md") -Value $readme -Encoding UTF8

$dirs = @(
  (Join-Path $root ("knowledge\projects\" + $ProjectName)),
  (Join-Path $root ("outputs\projects\" + $ProjectName)),
  (Join-Path $root ("logs\projects\" + $ProjectName))
)

foreach ($dir in $dirs) {
  New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

$registryPath = Join-Path $root "config\project_registry.yaml"

if (!(Test-Path $registryPath)) {
  Set-Content -Path $registryPath -Value "projects:`r`n" -Encoding UTF8
}

$registryContent = Get-Content -Path $registryPath -Raw -Encoding UTF8

if ($registryContent -match "(?m)^\s*-\s*id:\s*$ProjectId\s*$" -or $registryContent -match "(?m)^\s*name:\s*$ProjectName\s*$") {
  throw "注册表中已存在相同的 ProjectId 或 ProjectName。"
}

$entry = @"

  - id: $ProjectId
    name: $ProjectName
    type: $ProjectType
    status: active
    role: $ProjectRole
    repo_mode: external
    root_path: "$externalPathNormalized"
    manifest_path: "projects/$ProjectName/project_manifest.yaml"
    local_agents_path: "projects/$ProjectName/AGENTS.local.md"
    notes: >
      $Purpose
"@

Add-Content -Path $registryPath -Value $entry -Encoding UTF8

Write-Host "Project registered successfully: $ProjectName" -ForegroundColor Green
Write-Host "Project directory: $projectDir" -ForegroundColor Green
