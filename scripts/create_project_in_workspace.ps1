param(
  [Parameter(Mandatory=$true)][string]$ProjectId,
  [Parameter(Mandatory=$true)][string]$ProjectName,

  [string]$FolderName = "",
  [string]$ProjectType = "pilot_project",
  [string]$ProjectRole = "external_subproject",
  [string]$Owner = "孙海澄",
  [string]$Description = "",
  [string]$Purpose = "作为 AI 系统接入的外部项目",
  [string]$Limitations = "当前阶段以系统接入与流程验证为主。",

  [switch]$CreateBrief,
  [switch]$CreatePlan,
  [switch]$StartFirstWork,
  [switch]$NeedRepoContext,
  [switch]$DryRun
)

$root = Split-Path -Parent $PSScriptRoot
$configPath = Join-Path $root "config\workspace_paths.yaml"

if (!(Test-Path $configPath)) {
  throw "workspace_paths.yaml not found: $configPath"
}

if ([string]::IsNullOrWhiteSpace($FolderName)) {
  $FolderName = $ProjectName
}

$configContent = Get-Content -Path $configPath -Raw -Encoding UTF8
$match = [regex]::Match($configContent, '(?m)^\s*external_projects_root:\s*"?([^"\r\n]+)"?\s*$')

if (-not $match.Success) {
  throw "Could not read external_projects_root from workspace_paths.yaml"
}

$externalProjectsRoot = $match.Groups[1].Value -replace '/', '\'
$targetDir = Join-Path $externalProjectsRoot $FolderName
$targetDirNormalized = $targetDir -replace '\\','/'

Write-Host ""
Write-Host "=== Create Project In Workspace ===" -ForegroundColor Cyan
Write-Host "ProjectId            : $ProjectId"
Write-Host "ProjectName          : $ProjectName"
Write-Host "ExternalProjectsRoot : $externalProjectsRoot"
Write-Host "TargetDir            : $targetDir"
Write-Host "DryRun               : $DryRun"
Write-Host ""

if ($DryRun) {
  Write-Host "[DRY-RUN] Would ensure target directory exists: $targetDir" -ForegroundColor Yellow
  Write-Host "[DRY-RUN] Would bootstrap lifecycle using target dir." -ForegroundColor Yellow

  & (Join-Path $PSScriptRoot "project_lifecycle_bootstrap.ps1") `
    -ProjectId $ProjectId `
    -ProjectName $ProjectName `
    -ExternalRootPath $targetDirNormalized `
    -ProjectType $ProjectType `
    -ProjectRole $ProjectRole `
    -Owner $Owner `
    -Description $Description `
    -Purpose $Purpose `
    -Limitations $Limitations `
    -CreateBrief:$CreateBrief `
    -CreatePlan:$CreatePlan `
    -StartFirstWork:$StartFirstWork `
    -NeedRepoContext:$NeedRepoContext `
    -DryRun

  Write-Host ""
  Write-Host "Workspace project bootstrap dry-run completed." -ForegroundColor Green
  exit 0
}

if (!(Test-Path $targetDir)) {
  New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
  Write-Host "Created external project directory: $targetDir" -ForegroundColor Green
} else {
  Write-Host "External project directory already exists: $targetDir" -ForegroundColor Yellow
}

& (Join-Path $PSScriptRoot "project_lifecycle_bootstrap.ps1") `
  -ProjectId $ProjectId `
  -ProjectName $ProjectName `
  -ExternalRootPath $targetDirNormalized `
  -ProjectType $ProjectType `
  -ProjectRole $ProjectRole `
  -Owner $Owner `
  -Description $Description `
  -Purpose $Purpose `
  -Limitations $Limitations `
  -CreateBrief:$CreateBrief `
  -CreatePlan:$CreatePlan `
  -StartFirstWork:$StartFirstWork `
  -NeedRepoContext:$NeedRepoContext

Write-Host ""
Write-Host "Workspace project bootstrap completed." -ForegroundColor Green
