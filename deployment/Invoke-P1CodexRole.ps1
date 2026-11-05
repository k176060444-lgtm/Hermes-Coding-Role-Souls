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
    [ValidateSet('read-only','workspace-write','danger-full-access')]
    [string]$SandboxMode,
    [switch]$Execute,
    [switch]$PreviewPrompt,
    [string]$PromptOutputFile
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ($PreviewPrompt -and $Execute) { throw '-PreviewPrompt and -Execute are mutually exclusive.' }
if ($PSBoundParameters.ContainsKey('PromptOutputFile') -and -not $PreviewPrompt) {
    throw '-PromptOutputFile requires -PreviewPrompt.'
}
if ($PreviewPrompt -and (-not $TaskFile -or -not $PromptOutputFile)) {
    throw '-PreviewPrompt requires -TaskFile and -PromptOutputFile.'
}
$soulFile=Join-Path $PSScriptRoot ($Role+'.md')
if (-not (Test-Path -LiteralPath $soulFile -PathType Leaf)) {throw "Role Soul not installed: $soulFile"}
$hash=(Get-FileHash -LiteralPath $soulFile -Algorithm SHA256).Hash
Write-Host "Role=$Role Soul=$soulFile SHA256=$hash Execute=$Execute"
if (-not $Execute -and -not $PreviewPrompt) {
    Write-Host 'PREVIEW ONLY: Codex CLI has not been called.'
    Write-Host 'A real run requires -Execute -Model <approved-model> -WorkDir <approved-worktree> -TaskFile <task-input-file>.'
    Write-Host 'Check codex exec --help for the installed version before real execution.'
    return
}
if (-not $PreviewPrompt) {
    if (-not $Model -or -not $WorkDir -or -not $TaskFile) {
        throw 'Real execution needs -Model, -WorkDir and -TaskFile from approved task assignment.'
    }
    if (-not (Test-Path -LiteralPath $CodexExe -PathType Leaf)) {throw "Codex EXE missing: $CodexExe"}
    if (-not (Test-Path -LiteralPath $WorkDir -PathType Container)) {throw "WorkDir missing: $WorkDir"}
}
if (-not (Test-Path -LiteralPath $TaskFile -PathType Leaf)) {throw "TaskFile missing: $TaskFile"}
$utf8Strict=New-Object System.Text.UTF8Encoding($false, $true)
function Read-StrictUtf8([string]$Path) {
    $bytes=[IO.File]::ReadAllBytes($Path)
    $offset=0
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) { $offset=3 }
    $text=$utf8Strict.GetString($bytes, $offset, $bytes.Length - $offset)
    if ($text.Contains([char]0xFFFD)) { throw "Replacement character in input: $Path" }
    return $text
}
$soul=Read-StrictUtf8 $soulFile
$taskPath=(Resolve-Path -LiteralPath $TaskFile).Path
$task=Read-StrictUtf8 $taskPath
$prompt="你必须遵守以下当前单一角色完整Soul。不能擅自代替Hermes审批或切换角色。`n`n===ROLE SOUL===`n$soul`n===TASK INPUT===`n$task`n===END TASK INPUT===`n"
if ($prompt.Contains([char]0xFFFD) -or $prompt.IndexOf($soul,[StringComparison]::Ordinal) -lt 0 -or $prompt.IndexOf($task,[StringComparison]::Ordinal) -lt 0) {
    throw 'Prompt validation failed: replacement character or incomplete input.'
}
if ($PreviewPrompt) {
    $promptBytes=$utf8Strict.GetBytes($prompt)
    $stream=New-Object System.IO.FileStream($PromptOutputFile, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
    try { $stream.Write($promptBytes,0,$promptBytes.Length) } finally { $stream.Dispose() }
    $roundTrip=Read-StrictUtf8 $PromptOutputFile
    if ($roundTrip -cne $prompt) { throw 'Prompt output round-trip mismatch.' }
    $promptHash=(Get-FileHash -LiteralPath $PromptOutputFile -Algorithm SHA256).Hash
    $taskBytes=(Get-Item -LiteralPath $taskPath).Length
    Write-Host "PromptCharacters=$($prompt.Length) PromptBytes=$($promptBytes.Length) PromptSHA256=$promptHash SoulSHA256=$hash TaskBytes=$taskBytes RoundTrip=PASS"
    Write-Host 'PROMPT PREVIEW ONLY: Codex CLI has not been called.'
    return
}
if ($ProxyUrl) {
    if ($ProxyUrl -notmatch '^http://127\.0\.0\.1:[0-9]+$') {
        throw 'Only an explicitly supplied loopback HTTP proxy is accepted'
    }
    $env:HTTP_PROXY=$ProxyUrl; $env:HTTPS_PROXY=$ProxyUrl
    $env:NO_PROXY='127.0.0.1,localhost,::1'
}
$OutputEncoding=New-Object System.Text.UTF8Encoding($false)
# stdout is Codex JSONL; preserve it as the native stream, do not claim it is one JSON object.
$codexArgs=@('exec','-m',$Model,'-C',$WorkDir)
if ($SandboxMode) { $codexArgs += @('-s',$SandboxMode) }
$codexArgs += @('--json','-')
$prompt | & $CodexExe @codexArgs
exit $LASTEXITCODE
