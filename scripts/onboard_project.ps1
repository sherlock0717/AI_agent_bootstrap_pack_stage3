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

& (Join-Path $PSScriptRoot "register_external_project.ps1") `
  -ProjectId $ProjectId `
  -ProjectName $ProjectName `
  -ExternalRootPath $ExternalRootPath `
  -ProjectType $ProjectType `
  -ProjectRole $ProjectRole `
  -Owner $Owner `
  -Description $Description `
  -Purpose $Purpose `
  -Limitations $Limitations

& (Join-Path $PSScriptRoot "new_project_note.ps1") `
  -ProjectName $ProjectName `
  -Title "$ProjectName 项目接入初始化"

& (Join-Path $PSScriptRoot "refresh_knowledge_indexes.ps1")

Write-Host "Onboarding completed for project: $ProjectName" -ForegroundColor Green
