# 21bao role-only deployment. Defaults to preview. Does not invoke models.
[CmdletBinding()]
param(
    [switch]$Apply,
    [switch]$Force
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ($Force -and -not $Apply) { throw '-Force requires -Apply' }
$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$manifest = Get-Content -LiteralPath (Join-Path $root 'roles.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$checksums = @{}
foreach ($line in (Get-Content -LiteralPath (Join-Path $root 'SHA256SUMS.txt') -Encoding UTF8)) {
    if ($line -match '^([a-f0-9]{64})\s{2}(.+)$') { $checksums[$matches[2]] = $matches[1] }
}

# Validate all source files and plan all updates BEFORE writing anything.
$plan = New-Object System.Collections.ArrayList
foreach ($entry in $manifest.roles.PSObject.Properties) {
    $id = $entry.Name
    $value = $entry.Value
    $rel = [string]$value.soul_file
    $source = Join-Path $root ($rel.Replace('/', [IO.Path]::DirectorySeparatorChar))
    if (!(Test-Path -LiteralPath $source -PathType Leaf)) { throw "Soul missing: $source" }
    $hash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash.ToLowerInvariant()
    if (-not $checksums.ContainsKey($rel) -or $checksums[$rel] -ne $hash) {
        throw "Source checksum mismatch for $rel; refusing deployment"
    }
    $soul = [IO.File]::ReadAllText($source, [Text.Encoding]::UTF8)
    if (-not $soul.StartsWith("# $id ") -or $soul -notmatch 'Soul-Version:' -or $soul -notmatch '## 法定交付物') {
        throw "Incomplete or unexpected Soul format: $rel"
    }
    if ($value.harness -eq 'opencode') {
        $target = Join-Path (Join-Path $HOME '.config\opencode\agents') ([string]$value.installed_name + '.md')
        # The Markdown body is the exact source Soul; frontmatter is only agent metadata.
        $description = "P1 role $id; roles-only soft instructions"
        $expectedContent = "---`ndescription: $description`nmode: all`n---`n`n" + $soul
    } elseif ($value.harness -eq 'codex') {
        $target = Join-Path (Join-Path $HOME '.codex\p1-roles') ($id + '.md')
        $expectedContent = $soul
    } else { throw "Unknown harness for $id" }
    $oldContent = if (Test-Path -LiteralPath $target -PathType Leaf) {
        [IO.File]::ReadAllText($target, [Text.Encoding]::UTF8)
    } else { $null }
    $action = if ($null -eq $oldContent) { 'CREATE' } elseif ($oldContent -ceq $expectedContent) { 'UNCHANGED' } else { 'CONFLICT' }
    [void]$plan.Add([pscustomobject]@{
        Role=$id; Harness=[string]$value.harness; Source=$source; Target=$target;
        SourceSHA256=$hash; Action=$action; Text=$expectedContent
    })
}
$helperSource = Join-Path $PSScriptRoot 'Invoke-P1CodexRole.ps1'
$helperRel='deployment/Invoke-P1CodexRole.ps1'
$helperHash=(Get-FileHash -LiteralPath $helperSource -Algorithm SHA256).Hash.ToLowerInvariant()
if (-not $checksums.ContainsKey($helperRel) -or $checksums[$helperRel] -ne $helperHash) {
    throw 'Codex helper source checksum mismatch'
}
$helperTarget=Join-Path $HOME '.codex\p1-roles\Invoke-P1CodexRole.ps1'
$helperText=[IO.File]::ReadAllText($helperSource,[Text.Encoding]::UTF8)
$helperExisting=if(Test-Path -LiteralPath $helperTarget -PathType Leaf) {[IO.File]::ReadAllText($helperTarget,[Text.Encoding]::UTF8)}else{$null}
$helperAction=if($null -eq $helperExisting){'CREATE'}elseif($helperExisting -ceq $helperText){'UNCHANGED'}else{'CONFLICT'}
[void]$plan.Add([pscustomobject]@{
    Role='codex-helper'; Harness='codex'; Source=$helperSource; Target=$helperTarget;
    SourceSHA256=$helperHash; Action=$helperAction; Text=$helperText
})

Write-Host "Source: $root"
Write-Host "Package version: $($manifest.package_version) | mode: $(if($Apply){'APPLY'}else{'PREVIEW'})"
$plan | Select-Object Role,Harness,Action,Target,SourceSHA256 | Format-Table -AutoSize -Wrap
if (-not $Apply) {
    Write-Host 'PREVIEW ONLY: no files modified. Use -Apply after reviewing target paths.'
    return
}
$conflicts=@($plan | Where-Object { $_.Action -eq 'CONFLICT' })
if ($conflicts.Count -and -not $Force) {
    throw "Found $($conflicts.Count) existing different p1-* files. Refusing partial write; review diffs/backups and use -Apply -Force only with approval."
}
$stamp=Get-Date -Format 'yyyyMMdd-HHmmss'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
foreach ($p in $plan) {
    if ($p.Action -eq 'UNCHANGED') { continue }
    $parent = Split-Path -Path $p.Target -Parent
    if (-not (Test-Path -LiteralPath $parent)) { [void](New-Item -ItemType Directory -Force -Path $parent) }
    if ($p.Action -eq 'CONFLICT') {
        $backup = "$($p.Target).backup-$stamp"
        Copy-Item -LiteralPath $p.Target -Destination $backup -ErrorAction Stop
        Write-Host "BACKUP $backup"
    }
    [IO.File]::WriteAllText($p.Target, $p.Text, $utf8NoBom)
    $installedText=[IO.File]::ReadAllText($p.Target, [Text.Encoding]::UTF8)
    if ($installedText -cne $p.Text) { throw "Installed content mismatch: $($p.Target)" }
    $installedHash=(Get-FileHash -LiteralPath $p.Target -Algorithm SHA256).Hash.ToLowerInvariant()
    Write-Host "INSTALLED $($p.Role) $($p.Target) SHA256=$installedHash"
}
Write-Host 'ROLE INSTALL COMPLETE: configuration files only; no model was invoked or software restarted.'
