param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,

    [Parameter(Mandatory=$true)]
    [string]$TaskId,

    [string]$RunId = "",

    [string]$ReviewerProfile = "standard",

    [string]$SystemRoot = "C:\Users\22358\Desktop\系统\AI_agent_bootstrap_pack_stage3",

    [string]$ExternalProjectsRoot = "C:\Users\22358\Desktop\项目",

    [string]$PythonExe = "C:\Users\22358\Desktop\项目\AI_System_Console_Starter\.venv\Scripts\python.exe"
)

$ErrorActionPreference = "Stop"

$workerPath = Join-Path $SystemRoot "scripts\review_task_worker.py"

if (-not (Test-Path $workerPath)) {
    throw "未找到 reviewer worker：$workerPath"
}

if (-not (Test-Path $PythonExe)) {
    throw "未找到 Python 可执行文件：$PythonExe"
}

$argList = @(
    $workerPath,
    "--system-root", $SystemRoot,
    "--external-projects-root", $ExternalProjectsRoot,
    "--project-name", $ProjectName,
    "--task-id", $TaskId,
    "--reviewer-profile", $ReviewerProfile
)

if ($RunId -and $RunId.Trim() -ne "") {
    $argList += @("--run-id", $RunId.Trim())
}

$env:PYTHONIOENCODING = "utf-8"

Write-Host "==> 开始执行 reviewer" -ForegroundColor Cyan
Write-Host "项目: $ProjectName"
Write-Host "任务: $TaskId"
Write-Host "Profile: $ReviewerProfile"
if ($RunId) {
    Write-Host "RunId: $RunId"
}

& $PythonExe @argList
$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) {
    throw "reviewer 执行失败，退出码：$exitCode"
}

Write-Host "==> reviewer 执行完成" -ForegroundColor Green
