[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$ProjectName,

    [Parameter(Mandatory = $true)]
    [ValidateSet('PlanSkills', 'DeploySkills', 'VerifySkills')]
    [string]$Mode
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-RelativePath {
    param(
        [Parameter(Mandatory = $true)][string]$BasePath,
        [Parameter(Mandatory = $true)][string]$Path
    )

    $base = (Resolve-Path -LiteralPath $BasePath).Path.TrimEnd('\\')
    $fullPath = (Resolve-Path -LiteralPath $Path).Path
    if (-not $fullPath.StartsWith($base, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Path is outside the expected root: $fullPath"
    }

    return $fullPath.Substring($base.Length).TrimStart('\\').Replace('\\', '/')
}

function Get-ContentHash {
    param([Parameter(Mandatory = $true)][string[]]$Entries)

    $payload = [System.Text.Encoding]::UTF8.GetBytes([string]::Join("`n", @($Entries | Sort-Object)))
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    try {
        return ([System.BitConverter]::ToString($sha256.ComputeHash($payload))).Replace('-', '').ToLowerInvariant()
    }
    finally {
        $sha256.Dispose()
    }
}

function Test-NoReparsePoint {
    param([Parameter(Mandatory = $true)][string]$Path)

    $rootItem = Get-Item -LiteralPath $Path -Force
    if (($rootItem.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw "Reparse points are not allowed in managed paths: $Path"
    }

    $reparsePoints = @(Get-ChildItem -LiteralPath $Path -Force -Recurse | Where-Object {
        ($_.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0
    })
    if ($reparsePoints.Count -gt 0) {
        throw "Reparse points are not allowed in managed paths: $($reparsePoints[0].FullName)"
    }
}

function Get-DirectorySnapshot {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        return $null
    }

    Test-NoReparsePoint -Path $Path
    $entries = foreach ($file in @(Get-ChildItem -LiteralPath $Path -File -Force -Recurse | Sort-Object FullName)) {
        $relativePath = Get-RelativePath -BasePath $Path -Path $file.FullName
        $fileHash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
        "$relativePath`t$fileHash"
    }

    return [pscustomobject]@{
        FileCount = @($entries).Count
        Entries = @($entries | Sort-Object)
        ContentSha256 = Get-ContentHash -Entries @($entries)
    }
}

function Get-SkillEntries {
    param([Parameter(Mandatory = $true)][string]$SkillsPath)

    if (-not (Test-Path -LiteralPath $SkillsPath -PathType Container)) {
        throw "Project package skills directory is missing: $SkillsPath"
    }

    Test-NoReparsePoint -Path $SkillsPath
    $skillEntries = foreach ($skillDirectory in @(Get-ChildItem -LiteralPath $SkillsPath -Directory -Force | Sort-Object Name)) {
        $skillFile = Join-Path $skillDirectory.FullName 'SKILL.md'
        if (-not (Test-Path -LiteralPath $skillFile -PathType Leaf)) {
            throw "Each managed Skill directory must contain SKILL.md: $($skillDirectory.FullName)"
        }

        $snapshot = Get-DirectorySnapshot -Path $skillDirectory.FullName
        [pscustomobject]@{
            Name = $skillDirectory.Name
            Source = 'project-package'
            Version = 'local'
            Sha256 = $snapshot.ContentSha256
        }
    }

    if (@($skillEntries).Count -eq 0) {
        throw "Project package contains no Skills: $SkillsPath"
    }

    return @($skillEntries)
}

function Read-Manifest {
    param([Parameter(Mandatory = $true)][string]$ManifestPath)

    if (-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)) {
        throw "Project package manifest is missing: $ManifestPath"
    }

    $manifest = Get-Content -LiteralPath $ManifestPath -Raw -Encoding utf8 | ConvertFrom-Json
    foreach ($property in @('projectName', 'projectPath', 'targetAgent', 'managedAssets')) {
        if ($null -eq $manifest.$property -or [string]::IsNullOrWhiteSpace([string]$manifest.$property)) {
            throw "Manifest property is required: $property"
        }
    }
    foreach ($assetType in @('skills', 'plugins', 'mcp', 'cli')) {
        if ($null -eq $manifest.managedAssets.$assetType) {
            $manifest.managedAssets | Add-Member -MemberType NoteProperty -Name $assetType -Value @()
        }
    }

    return $manifest
}

function New-Context {
    param([Parameter(Mandatory = $true)][string]$RequestedProjectName)

    $codexRoot = Split-Path -Parent $PSScriptRoot
    $packagesRoot = Join-Path $codexRoot '项目包'
    $packageRoot = Join-Path $packagesRoot $RequestedProjectName
    $manifestPath = Join-Path $packageRoot 'manifest.json'
    $manifest = Read-Manifest -ManifestPath $manifestPath

    if ($manifest.projectName -ne $RequestedProjectName) {
        throw "ProjectName does not match manifest.projectName: $RequestedProjectName"
    }
    if ($manifest.targetAgent -ne 'Codex') {
        throw "This script only deploys Codex project packages: $($manifest.targetAgent)"
    }
    if (-not (Test-Path -LiteralPath $manifest.projectPath -PathType Container)) {
        throw "Manifest projectPath does not exist: $($manifest.projectPath)"
    }

    $projectPath = (Resolve-Path -LiteralPath $manifest.projectPath).Path
    $projectCodexPath = Join-Path $projectPath '.codex'
    if (-not (Test-Path -LiteralPath $projectCodexPath -PathType Container)) {
        throw "Project Codex directory does not exist: $projectCodexPath"
    }

    return [pscustomobject]@{
        CodexRoot = $codexRoot
        PackagesRoot = $packagesRoot
        PackageRoot = $packageRoot
        PackageSkillsPath = Join-Path $packageRoot 'skills'
        PackageReadmePath = Join-Path $packageRoot 'README.md'
        ManifestPath = $manifestPath
        Manifest = $manifest
        ProjectPath = $projectPath
        ProjectCodexPath = $projectCodexPath
        TargetSkillsPath = Join-Path $projectCodexPath 'skills'
    }
}

function Test-Preflight {
    param([Parameter(Mandatory = $true)]$Context)

    if ((Split-Path -Leaf $Context.TargetSkillsPath) -ne 'skills') {
        throw "Refusing to manage a target other than a skills directory: $($Context.TargetSkillsPath)"
    }

    $skillEntries = Get-SkillEntries -SkillsPath $Context.PackageSkillsPath
    $packageSnapshot = Get-DirectorySnapshot -Path $Context.PackageSkillsPath
    $targetSnapshot = Get-DirectorySnapshot -Path $Context.TargetSkillsPath

    return [pscustomobject]@{
        SkillEntries = $skillEntries
        PackageSnapshot = $packageSnapshot
        TargetSnapshot = $targetSnapshot
    }
}

function Test-SnapshotMatch {
    param(
        [Parameter(Mandatory = $true)]$Expected,
        [Parameter(Mandatory = $true)]$Actual
    )

    if ($null -eq $Actual) {
        return $false
    }
    return $Expected.FileCount -eq $Actual.FileCount -and $Expected.ContentSha256 -eq $Actual.ContentSha256
}

function Remove-DeclaredLegacyPaths {
    param([Parameter(Mandatory = $true)]$Context)

    $legacyPaths = @($Context.Manifest.legacyPathsToRemove)
    foreach ($relativePath in $legacyPaths) {
        if ([string]::IsNullOrWhiteSpace([string]$relativePath)) {
            throw 'legacyPathsToRemove cannot contain an empty path.'
        }

        $candidatePath = [System.IO.Path]::GetFullPath((Join-Path $Context.ProjectPath $relativePath))
        $projectRoot = $Context.ProjectPath.TrimEnd([char]'\')
        if (-not $candidatePath.StartsWith($projectRoot + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Legacy cleanup path is outside the project root: $relativePath"
        }
        if ($candidatePath -eq $Context.TargetSkillsPath) {
            throw "Legacy cleanup path cannot be the managed Skill target: $relativePath"
        }
        if (-not (Test-Path -LiteralPath $candidatePath)) {
            continue
        }

        Test-NoReparsePoint -Path $candidatePath
        Remove-Item -LiteralPath $candidatePath -Recurse -Force
        Write-Output "Removed declared legacy path: $candidatePath"
    }
}

function Get-AssetNames {
    param($Assets)

    $items = @($Assets)
    if ($items.Count -eq 0) {
        return '无'
    }

    $names = foreach ($item in $items) {
        if ($item -is [string]) {
            $item
        }
        elseif ($null -ne $item.name) {
            [string]$item.name
        }
        else {
            [string]$item
        }
    }
    return (@($names) -join '、')
}

function Replace-MarkerBlock {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$StartMarker,
        [Parameter(Mandatory = $true)][string]$EndMarker,
        [Parameter(Mandatory = $true)][string]$Replacement
    )

    $content = Get-Content -LiteralPath $Path -Raw -Encoding utf8
    $startIndex = $content.IndexOf($StartMarker, [System.StringComparison]::Ordinal)
    $endIndex = $content.IndexOf($EndMarker, [System.StringComparison]::Ordinal)
    if ($startIndex -lt 0 -or $endIndex -lt 0 -or $endIndex -lt $startIndex) {
        throw "Required documentation markers are missing: $Path"
    }

    $prefix = $content.Substring(0, $startIndex + $StartMarker.Length)
    $suffix = $content.Substring($endIndex)
    $updated = $prefix + "`r`n" + $Replacement.TrimEnd() + "`r`n" + $suffix
    Set-Content -LiteralPath $Path -Value $updated -Encoding utf8
}

function Update-ManifestAndDocumentation {
    param(
        [Parameter(Mandatory = $true)]$Context,
        [Parameter(Mandatory = $true)]$Preflight
    )

    $manifestSkills = foreach ($skill in $Preflight.SkillEntries) {
        [pscustomobject]@{
            name = $skill.Name
            source = $skill.Source
            version = $skill.Version
            sha256 = $skill.Sha256
        }
    }
    $today = (Get-Date).ToString('yyyy-MM-dd')
    $now = (Get-Date).ToString('o')
    $Context.Manifest.managedAssets.skills = @($manifestSkills)
    $Context.Manifest.skillsLastUpdated = $today
    $Context.Manifest.lastVerifiedAt = $now
    $Context.Manifest.contentSha256 = $Preflight.PackageSnapshot.ContentSha256
    $Context.Manifest.fileCount = $Preflight.PackageSnapshot.FileCount
    $Context.Manifest | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $Context.ManifestPath -Encoding utf8

    $skillNames = @($Preflight.SkillEntries | ForEach-Object { $_.Name }) -join '、'
    $assetBlock = @(
        '| 类型 | 资产 |',
        '| --- | --- |',
        "| Skill ($(@($Preflight.SkillEntries).Count)) | $skillNames |",
        "| Plugin | $(Get-AssetNames -Assets $Context.Manifest.managedAssets.plugins) |",
        "| MCP | $(Get-AssetNames -Assets $Context.Manifest.managedAssets.mcp) |",
        "| CLI | $(Get-AssetNames -Assets $Context.Manifest.managedAssets.cli) |",
        "| 内容 SHA-256 | $($Preflight.PackageSnapshot.ContentSha256) |",
        "| 文件数量 | $($Preflight.PackageSnapshot.FileCount) |",
        "| Skill 最后更新 | $today |"
    ) -join "`r`n"
    Replace-MarkerBlock -Path $Context.PackageReadmePath -StartMarker '<!-- ASSETS:START -->' -EndMarker '<!-- ASSETS:END -->' -Replacement $assetBlock

    $projectRows = foreach ($packageDirectory in @(Get-ChildItem -LiteralPath $Context.PackagesRoot -Directory -Force | Sort-Object Name)) {
        $otherManifestPath = Join-Path $packageDirectory.FullName 'manifest.json'
        if (-not (Test-Path -LiteralPath $otherManifestPath -PathType Leaf)) {
            continue
        }
        $otherManifest = Read-Manifest -ManifestPath $otherManifestPath
        $fixtureProperty = $otherManifest.PSObject.Properties['isTestFixture']
        if ($null -ne $fixtureProperty -and [bool]$fixtureProperty.Value) {
            continue
        }
        $skillNames = Get-AssetNames -Assets $otherManifest.managedAssets.skills
        "| $($otherManifest.projectName) | $($otherManifest.projectPath) | $($packageDirectory.FullName) | $skillNames | $(Get-AssetNames -Assets $otherManifest.managedAssets.plugins) | $(Get-AssetNames -Assets $otherManifest.managedAssets.mcp) | $(Get-AssetNames -Assets $otherManifest.managedAssets.cli) | $($otherManifest.skillsLastUpdated) |"
    }
    $projectTable = @(
        '| 项目 | 项目绝对路径 | 项目包路径 | Skill | Plugin | MCP | CLI | Skill 最后更新 |',
        '| --- | --- | --- | --- | --- | --- | --- | --- |'
    ) + @($projectRows)
    Replace-MarkerBlock -Path (Join-Path $Context.PackagesRoot 'README.md') -StartMarker '<!-- PROJECTS:START -->' -EndMarker '<!-- PROJECTS:END -->' -Replacement ($projectTable -join "`r`n")
}

function Show-Plan {
    param(
        [Parameter(Mandatory = $true)]$Context,
        [Parameter(Mandatory = $true)]$Preflight
    )

    Write-Output "Project: $($Context.Manifest.projectName)"
    Write-Output "Package skills: $($Context.PackageSkillsPath)"
    Write-Output "Target skills: $($Context.TargetSkillsPath)"
    Write-Output "Managed Skills: $(@($Preflight.SkillEntries).Count)"
    Write-Output "Package files: $($Preflight.PackageSnapshot.FileCount)"
    Write-Output "Package SHA-256: $($Preflight.PackageSnapshot.ContentSha256)"
    if ([string]::IsNullOrWhiteSpace([string]$Context.Manifest.contentSha256)) {
        Write-Output 'Manifest status: no prior Skill content hash is recorded.'
    }
    elseif ($Context.Manifest.contentSha256 -eq $Preflight.PackageSnapshot.ContentSha256) {
        Write-Output 'Manifest status: package content matches the last deployment record.'
    }
    else {
        Write-Output 'Manifest status: package content changed since the last deployment record; deployment will update the record.'
    }
    if ($null -eq $Preflight.TargetSnapshot) {
        Write-Output 'Target status: missing; deployment will create it.'
    }
    else {
        Write-Output "Target files: $($Preflight.TargetSnapshot.FileCount)"
        Write-Output "Target SHA-256: $($Preflight.TargetSnapshot.ContentSha256)"
        Write-Output 'Target status: the entire target skills directory will be deleted and replaced.'
    }
}

$context = New-Context -RequestedProjectName $ProjectName
$preflight = Test-Preflight -Context $context

switch ($Mode) {
    'PlanSkills' {
        Show-Plan -Context $context -Preflight $preflight
    }
    'VerifySkills' {
        if (-not (Test-SnapshotMatch -Expected $preflight.PackageSnapshot -Actual $preflight.TargetSnapshot)) {
            throw "Verification failed: $($context.TargetSkillsPath) does not match the project package."
        }
        Write-Output "Verification passed: $($context.Manifest.projectName) Skill runtime matches the project package."
    }
    'DeploySkills' {
        Show-Plan -Context $context -Preflight $preflight
        if (Test-Path -LiteralPath $context.TargetSkillsPath) {
            Remove-Item -LiteralPath $context.TargetSkillsPath -Recurse -Force
        }
        Copy-Item -LiteralPath $context.PackageSkillsPath -Destination $context.ProjectCodexPath -Recurse -Force

        $afterDeployment = Get-DirectorySnapshot -Path $context.TargetSkillsPath
        if (-not (Test-SnapshotMatch -Expected $preflight.PackageSnapshot -Actual $afterDeployment)) {
            throw "Deployment failed: copied Skill runtime does not match the project package."
        }

        Remove-DeclaredLegacyPaths -Context $context
        Update-ManifestAndDocumentation -Context $context -Preflight $preflight
        Write-Output "Deployment passed: $($context.TargetSkillsPath) now matches the project package."
    }
}

