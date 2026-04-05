param()

$root = Split-Path -Parent $PSScriptRoot

Write-Host ""
Write-Host "=== New Project Wizard ===" -ForegroundColor Cyan

$ProjectId = Read-Host "Project ID (例如: uxlab)"
$ProjectName = Read-Host "Project Name (例如: UXLab)"
$ExternalRootPath = Read-Host "External Root Path (项目真实路径)"
$ProjectType = Read-Host "Project Type [默认: pilot_project]"
$ProjectRole = Read-Host "Project Role [默认: external_subproject]"
$Owner = Read-Host "Owner [默认: 孙海澄]"
$Description = Read-Host "Description"
$Purpose = Read-Host "Purpose [默认: 作为 AI 系统接入的外部项目]"
$Limitations = Read-Host "Limitations [默认: 当前阶段以系统接入与流程验证为主。]"

if ([string]::IsNullOrWhiteSpace($ProjectType)) { $ProjectType = "pilot_project" }
if ([string]::IsNullOrWhiteSpace($ProjectRole)) { $ProjectRole = "external_subproject" }
if ([string]::IsNullOrWhiteSpace($Owner)) { $Owner = "孙海澄" }
if ([string]::IsNullOrWhiteSpace($Purpose)) { $Purpose = "作为 AI 系统接入的外部项目" }
if ([string]::IsNullOrWhiteSpace($Limitations)) { $Limitations = "当前阶段以系统接入与流程验证为主。" }

Write-Host ""
Write-Host "Please confirm:" -ForegroundColor Yellow
Write-Host "ProjectId        : $ProjectId"
Write-Host "ProjectName      : $ProjectName"
Write-Host "ExternalRootPath : $ExternalRootPath"
Write-Host "ProjectType      : $ProjectType"
Write-Host "ProjectRole      : $ProjectRole"
Write-Host "Owner            : $Owner"
Write-Host "Description      : $Description"
Write-Host "Purpose          : $Purpose"
Write-Host "Limitations      : $Limitations"

$confirm = Read-Host "Continue? (Y/N)"
if ($confirm -ne "Y" -and $confirm -ne "y") {
  Write-Host "Cancelled." -ForegroundColor Yellow
  exit 0
}

& (Join-Path $PSScriptRoot "onboard_project.ps1") `
  -ProjectId $ProjectId `
  -ProjectName $ProjectName `
  -ExternalRootPath $ExternalRootPath `
  -ProjectType $ProjectType `
  -ProjectRole $ProjectRole `
  -Owner $Owner `
  -Description $Description `
  -Purpose $Purpose `
  -Limitations $Limitations

Write-Host "Project wizard completed." -ForegroundColor Green
