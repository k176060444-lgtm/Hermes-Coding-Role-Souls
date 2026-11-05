# Lightweight Codex CLI role selector. Preview by default; never creates a Codex native agent.
[CmdletBinding()]
param(
    [ValidateSet('planner','quality_reviewer','tester_gate_a','arbitrator')]
    [string]$Role='planner',
    [string]$Model,
    [string]$WorkDir,
    [string]$TaskFile,
    [string]$CodexExe='D:\codex\codex-agent.exe',
    [string]$ProxyUrl,
    [switch]$Execute
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$soulFile=Join-Path $PSScriptRoot ($Role+'.md')
if (-not (Test-Path -LiteralPath $soulFile -PathType Leaf)) {throw "Role Soul not installed: $soulFile"}
$hash=(Get-FileHash -LiteralPath $soulFile -Algorithm SHA256).Hash
Write-Host "Role=$Role Soul=$soulFile SHA256=$hash Execute=$Execute"
if (-not $Execute) {
    Write-Host 'PREVIEW ONLY: Codex CLI has not been called.'
    Write-Host 'A real run requires -Execute -Model <approved-model> -WorkDir <approved-worktree> -TaskFile <task-input-file>.'
    Write-Host 'Check codex exec --help for the installed version before real execution.'
    return
}
if (-not $Model -or -not $WorkDir -or -not $TaskFile) {
    throw 'Real execution needs -Model, -WorkDir and -TaskFile from approved task assignment.'
}
if (-not (Test-Path -LiteralPath $CodexExe -PathType Leaf)) {throw "Codex EXE missing: $CodexExe"}
if (-not (Test-Path -LiteralPath $WorkDir -PathType Container)) {throw "WorkDir missing: $WorkDir"}
if (-not (Test-Path -LiteralPath $TaskFile -PathType Leaf)) {throw "TaskFile missing: $TaskFile"}
if ($ProxyUrl) {
    if ($ProxyUrl -notmatch '^http://127\.0\.0\.1:[0-9]+$') {
        throw 'Only an explicitly supplied loopback HTTP proxy is accepted'
    }
    $env:HTTP_PROXY=$ProxyUrl; $env:HTTPS_PROXY=$ProxyUrl
    $env:NO_PROXY='127.0.0.1,localhost,::1'
}
$utf8NoBom=New-Object System.Text.UTF8Encoding($false)
$OutputEncoding=$utf8NoBom
$soul=[IO.File]::ReadAllText($soulFile,[Text.Encoding]::UTF8)
$task=[IO.File]::ReadAllText((Resolve-Path -LiteralPath $TaskFile).Path,[Text.Encoding]::UTF8)
$prompt="你必须遵守以下当前单一角色完整Soul。不能擅自代替Hermes审批或切换角色。`n`n===ROLE SOUL===`n$soul`n===TASK INPUT===`n$task`n===END TASK INPUT===`n"
# stdout is Codex JSONL; preserve it as the native stream, do not claim it is one JSON object.
$prompt | & $CodexExe exec -m $Model -C $WorkDir --json -
exit $LASTEXITCODE
