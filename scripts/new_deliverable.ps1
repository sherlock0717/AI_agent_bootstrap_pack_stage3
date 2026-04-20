param(
  [Parameter(Mandatory=$true)][string]$ProjectName,
  [Parameter(Mandatory=$true)]
  [ValidateSet("brief","plan","spec","report","deck_outline","content_script")]
  [string]$Type,
  [Parameter(Mandatory=$true)][string]$Title
)

function Emit-CreateResultJson {
  param(
    [bool]$Success,
    [string]$ProjectNameValue,
    [string]$DeliverableTypeValue,
    [string]$TitleValue,
    [string]$CreatedFilePath,
    [string]$CreatedDirectory,
    [string]$Message,
    [string]$ErrorCategory,
    [string]$ErrorMessage
  )

  $payload = [ordered]@{
    success = $Success
    project_name = $ProjectNameValue
    deliverable_type = $DeliverableTypeValue
    title = $TitleValue
    created_file_path = $(if ($CreatedFilePath) { $CreatedFilePath } else { $null })
    created_directory = $(if ($CreatedDirectory) { $CreatedDirectory } else { $null })
    message = $Message
    error_category = $(if ($ErrorCategory) { $ErrorCategory } else { $null })
    error_message = $(if ($ErrorMessage) { $ErrorMessage } else { $null })
  }
  Write-Output ($payload | ConvertTo-Json -Depth 4 -Compress)
}

try {
  $root = Split-Path -Parent $PSScriptRoot
  $projectDir = Join-Path $root ("deliverables\projects\" + $ProjectName)
  New-Item -ItemType Directory -Path $projectDir -Force | Out-Null

  switch ($Type) {
    "brief"         { $templatePath = Join-Path $root "templates\deliverables\brief.template.md" }
    "plan"          { $templatePath = Join-Path $root "templates\deliverables\plan.template.md" }
    "spec"          { $templatePath = Join-Path $root "templates\deliverables\spec.template.md" }
    "report"        { $templatePath = Join-Path $root "templates\deliverables\report.template.md" }
    "deck_outline"  { $templatePath = Join-Path $root "templates\deliverables\deck_outline.template.md" }
    "content_script"{ $templatePath = Join-Path $root "templates\deliverables\content_script.template.md" }
  }

  if (!(Test-Path $templatePath)) {
    throw "Template not found: $templatePath"
  }

  $template = Get-Content -Path $templatePath -Raw -Encoding UTF8
  $template = $template.Replace("__TITLE__", $Title)
  $template = $template.Replace("__PROJECT_NAME__", $ProjectName)
  $template = $template.Replace("__DATE__", (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))

  $timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
  $safeTitle = ($Title -replace '[\\/:*?"<>| ]','_')
  $filePath = Join-Path $projectDir ($timestamp + "-" + $Type + "-" + $safeTitle + ".md")

  Set-Content -Path $filePath -Value $template -Encoding UTF8
  Write-Host "Created deliverable: $filePath" -ForegroundColor Green
  Emit-CreateResultJson `
    -Success $true `
    -ProjectNameValue $ProjectName `
    -DeliverableTypeValue $Type `
    -TitleValue $Title `
    -CreatedFilePath $filePath `
    -CreatedDirectory $projectDir `
    -Message "交付物创建成功。" `
    -ErrorCategory "" `
    -ErrorMessage ""
}
catch {
  $err = $_.Exception.Message
  $errorCategory = "create_failed"
  $lower = $err.ToLowerInvariant()
  if ($lower.Contains("template not found")) {
    $errorCategory = "template_missing"
  } elseif ($lower.Contains("access") -or $lower.Contains("unauthorized")) {
    $errorCategory = "permission_denied"
  } elseif ($lower.Contains("path") -or $lower.Contains("directory")) {
    $errorCategory = "directory_error"
  }
  Emit-CreateResultJson `
    -Success $false `
    -ProjectNameValue $ProjectName `
    -DeliverableTypeValue $Type `
    -TitleValue $Title `
    -CreatedFilePath "" `
    -CreatedDirectory "" `
    -Message "交付物创建失败。" `
    -ErrorCategory $errorCategory `
    -ErrorMessage $err
  exit 1
}
