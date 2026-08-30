[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('Audit', 'Plan', 'Apply', 'Verify')]
    [string]$Mode,

    [string]$AssetName,
    [string]$ProjectName,
    [ValidateSet('None', 'Project', 'Personal')]
    [string]$DeletionScope = 'None',
    [string]$OutputPath,
    [string]$PlanPath,
    [string]$ChangeId,
    [string]$ConfigPath,
    [string]$CodexRoot,
    [string]$GlobalSkillsPath,
    [string]$PluginCachePath,
    [string]$SyncScriptPath,
    [string]$RuntimeDirectoryName,
    [string]$PersonalLibraryName,
    [string]$PackagesDirectoryName,
    [string]$TargetAgent,
    [switch]$IncludeFixtures
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-FullPath {
    param([Parameter(Mandatory = $true)][string]$Path)

    return [System.IO.Path]::GetFullPath($Path)
}

function Get-ScriptRoot {
    return Split-Path -Parent $PSScriptRoot
}

function Read-GovernanceConfig {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $null
    }

    $resolvedPath = Get-FullPath -Path $Path
    if (-not (Test-Path -LiteralPath $resolvedPath -PathType Leaf)) {
        throw "Governance config is missing: $resolvedPath"
    }

    try {
        return Get-Content -LiteralPath $resolvedPath -Raw -Encoding utf8 | ConvertFrom-Json
    }
    catch {
        throw "Invalid governance config JSON: $resolvedPath. $($_.Exception.Message)"
    }
}

function Get-ConfigValue {
    param(
        $Config,
        [Parameter(Mandatory = $true)][string]$Name,
        $Default
    )

    if ($null -eq $Config) {
        return $Default
    }
    $property = $Config.PSObject.Properties[$Name]
    if ($null -eq $property -or [string]::IsNullOrWhiteSpace([string]$property.Value)) {
        return $Default
    }
    return $property.Value
}

function Resolve-GovernancePath {
    param(
        [AllowNull()][string]$Value,
        [Parameter(Mandatory = $true)][string]$Default,
        [Parameter(Mandatory = $true)][string]$BasePath
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        $Value = $Default
    }
    if ([System.IO.Path]::IsPathRooted($Value)) {
        return Get-FullPath -Path $Value
    }
    return Get-FullPath -Path (Join-Path $BasePath $Value)
}

function Test-PathWithin {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Root
    )

    $fullPath = Get-FullPath -Path $Path
    $fullRoot = (Get-FullPath -Path $Root).TrimEnd('\')
    return $fullPath.Equals($fullRoot, [System.StringComparison]::OrdinalIgnoreCase) -or
        $fullPath.StartsWith($fullRoot + '\', [System.StringComparison]::OrdinalIgnoreCase)
}

function Assert-PathWithin {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Root,
        [Parameter(Mandatory = $true)][string]$Description
    )

    if (-not (Test-PathWithin -Path $Path -Root $Root)) {
        throw "$Description is outside the managed root. Path: $Path Root: $Root"
    }
}

function Test-NoReparsePoint {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        return
    }

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

function Get-RelativePath {
    param(
        [Parameter(Mandatory = $true)][string]$BasePath,
        [Parameter(Mandatory = $true)][string]$Path
    )

    $base = (Get-FullPath -Path $BasePath).TrimEnd('\')
    $fullPath = Get-FullPath -Path $Path
    Assert-PathWithin -Path $fullPath -Root $base -Description 'Relative path input'
    return $fullPath.Substring($base.Length).TrimStart('\').Replace('\', '/')
}

function Get-ContentHash {
    param([Parameter(Mandatory = $true)][AllowEmptyCollection()][string[]]$Entries)

    $payload = [System.Text.Encoding]::UTF8.GetBytes([string]::Join("`n", @($Entries | Sort-Object)))
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    try {
        return ([System.BitConverter]::ToString($sha256.ComputeHash($payload))).Replace('-', '').ToLowerInvariant()
    }
    finally {
        $sha256.Dispose()
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
        Exists = $true
        FileCount = @($entries).Count
        Entries = @($entries | Sort-Object)
        ContentSha256 = Get-ContentHash -Entries @($entries)
    }
}

function Get-SnapshotHash {
    param($Snapshot)

    if ($null -eq $Snapshot) {
        return $null
    }
    return [string]$Snapshot.ContentSha256
}

function Get-OptionalPropertyValue {
    param(
        $Object,
        [Parameter(Mandatory = $true)][string]$Name
    )

    if ($null -eq $Object) {
        return $null
    }
    $property = $Object.PSObject.Properties[$Name]
    if ($null -eq $property) {
        return $null
    }
    return $property.Value
}

function Get-AssetName {
    param($Asset)

    if ($Asset -is [string]) {
        return [string]$Asset
    }
    $name = Get-OptionalPropertyValue -Object $Asset -Name 'name'
    if ($null -ne $name) {
        return [string]$name
    }
    return $null
}

function Get-SkillName {
    param([Parameter(Mandatory = $true)][string]$SkillDirectory)

    $skillFile = Join-Path $SkillDirectory 'SKILL.md'
    if (-not (Test-Path -LiteralPath $skillFile -PathType Leaf)) {
        throw "SKILL.md is missing: $SkillDirectory"
    }

    $lines = @(Get-Content -LiteralPath $skillFile -Encoding utf8 -TotalCount 80)
    $match = $lines -join "`n" | Select-String -Pattern '(?m)^\s*name\s*:\s*(?<name>[^\r\n]+)\s*$' -AllMatches
    if ($null -eq $match -or $match.Matches.Count -eq 0) {
        throw "Skill frontmatter name is missing: $skillFile"
    }

    $name = $match.Matches[0].Groups['name'].Value.Trim()
    return $name.Trim('"', "'")
}

function Get-SkillIndex {
    param([Parameter(Mandatory = $true)][string]$PersonalLibraryRoot)

    $index = @{}
    if (-not (Test-Path -LiteralPath $PersonalLibraryRoot -PathType Container)) {
        return $index
    }

    $skillFiles = @(Get-ChildItem -LiteralPath $PersonalLibraryRoot -File -Filter 'SKILL.md' -Force -Recurse)
    foreach ($skillFile in $skillFiles) {
        try {
            $skillDirectory = $skillFile.Directory.FullName
            $name = Get-SkillName -SkillDirectory $skillDirectory
            if ([string]::IsNullOrWhiteSpace($name)) {
                continue
            }
            $record = [pscustomobject]@{
                name = $name
                path = $skillDirectory
                snapshot = Get-DirectorySnapshot -Path $skillDirectory
            }
            if (-not $index.ContainsKey($name)) {
                $index[$name] = @()
            }
            $index[$name] = @($index[$name]) + $record
        }
        catch {
            continue
        }
    }
    return $index
}

function Get-Manifest {
    param([Parameter(Mandatory = $true)][string]$Path)

    try {
        return Get-Content -LiteralPath $Path -Raw -Encoding utf8 | ConvertFrom-Json
    }
    catch {
        throw "Invalid manifest JSON: $Path. $($_.Exception.Message)"
    }
}

function Get-ProjectContexts {
    param(
        [Parameter(Mandatory = $true)][string]$PackagesRoot,
        [Parameter(Mandatory = $true)][string]$RuntimeDirectory,
        [switch]$IncludeFixtures
    )

    $contexts = @()
    if (-not (Test-Path -LiteralPath $PackagesRoot -PathType Container)) {
        return $contexts
    }

    foreach ($packageDirectory in @(Get-ChildItem -LiteralPath $PackagesRoot -Directory -Force | Sort-Object Name)) {
        $manifestPath = Join-Path $packageDirectory.FullName 'manifest.json'
        if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
            continue
        }

        $manifest = Get-Manifest -Path $manifestPath
        $isFixture = [bool](Get-OptionalPropertyValue -Object $manifest -Name 'isTestFixture')
        if ($isFixture -and -not $IncludeFixtures) {
            continue
        }

        $projectName = [string](Get-OptionalPropertyValue -Object $manifest -Name 'projectName')
        $projectPath = [string](Get-OptionalPropertyValue -Object $manifest -Name 'projectPath')
        if ([string]::IsNullOrWhiteSpace($projectName) -or [string]::IsNullOrWhiteSpace($projectPath)) {
            throw "Manifest must define projectName and projectPath: $manifestPath"
        }

        $projectPath = Get-FullPath -Path $projectPath
        $targetSkillsPath = [string](Get-OptionalPropertyValue -Object $manifest -Name 'targetSkillsPath')
        if ([string]::IsNullOrWhiteSpace($targetSkillsPath)) {
            $targetSkillsPath = Join-Path (Join-Path $projectPath $RuntimeDirectory) 'skills'
        }
        else {
            $targetSkillsPath = Get-FullPath -Path $targetSkillsPath
        }
        $contexts += [pscustomobject]@{
            projectName = $projectName
            projectPath = $projectPath
            packagePath = $packageDirectory.FullName
            manifestPath = $manifestPath
            manifest = $manifest
            packageSkillsPath = Join-Path $packageDirectory.FullName 'skills'
            runtimeSkillsPath = $targetSkillsPath
        }
    }
    return @($contexts)
}

function Get-ManifestSkillMap {
    param($Manifest)

    $map = @{}
    $skills = @(Get-OptionalPropertyValue -Object (Get-OptionalPropertyValue -Object $Manifest -Name 'managedAssets') -Name 'skills')
    foreach ($skill in $skills) {
        $name = Get-AssetName -Asset $skill
        if (-not [string]::IsNullOrWhiteSpace($name)) {
            $map[$name] = $skill
        }
    }
    return $map
}

function Get-PackageSkillNames {
    param(
        [Parameter(Mandatory = $true)][string]$PackageSkillsPath,
        [Parameter(Mandatory = $true)][string]$RuntimeSkillsPath,
        $ManifestSkillMap
    )

    $names = @($ManifestSkillMap.Keys)
    if (Test-Path -LiteralPath $PackageSkillsPath -PathType Container) {
        foreach ($directory in @(Get-ChildItem -LiteralPath $PackageSkillsPath -Directory -Force)) {
            $skillFile = Join-Path $directory.FullName 'SKILL.md'
            if (Test-Path -LiteralPath $skillFile -PathType Leaf) {
                try {
                    $names += Get-SkillName -SkillDirectory $directory.FullName
                }
                catch {
                    $names += $directory.Name
                }
            }
        }
    }
    if (Test-Path -LiteralPath $RuntimeSkillsPath -PathType Container) {
        foreach ($directory in @(Get-ChildItem -LiteralPath $RuntimeSkillsPath -Directory -Force)) {
            $skillFile = Join-Path $directory.FullName 'SKILL.md'
            if (Test-Path -LiteralPath $skillFile -PathType Leaf) {
                try {
                    $names += Get-SkillName -SkillDirectory $directory.FullName
                }
                catch {
                    $names += $directory.Name
                }
            }
        }
    }
    return @($names | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Sort-Object -Unique)
}

function Resolve-PersonalSource {
    param(
        $ManifestRecord,
        [hashtable]$PersonalIndex,
        [Parameter(Mandatory = $true)][string]$PersonalLibraryRoot,
        [Parameter(Mandatory = $true)][string]$AssetName
    )

    $configuredPath = Get-OptionalPropertyValue -Object $ManifestRecord -Name 'sourcePath'
    if (-not [string]::IsNullOrWhiteSpace([string]$configuredPath)) {
        $configuredPath = Get-FullPath -Path ([string]$configuredPath)
        if (-not (Test-PathWithin -Path $configuredPath -Root $PersonalLibraryRoot)) {
            return [pscustomobject]@{ status = 'invalid-source-path'; path = $configuredPath; candidates = @() }
        }
        return [pscustomobject]@{ status = 'configured'; path = $configuredPath; candidates = @($configuredPath) }
    }

    $candidates = @()
    if ($PersonalIndex.ContainsKey($AssetName)) {
        $candidates = @($PersonalIndex[$AssetName] | ForEach-Object { $_.path })
    }
    if ($candidates.Count -eq 1) {
        return [pscustomobject]@{ status = 'resolved'; path = $candidates[0]; candidates = $candidates }
    }
    if ($candidates.Count -gt 1) {
        return [pscustomobject]@{ status = 'ambiguous'; path = $null; candidates = $candidates }
    }
    return [pscustomobject]@{ status = 'missing'; path = $null; candidates = @() }
}

function Get-SkillStatus {
    param(
        $PersonalSnapshot,
        $PackageSnapshot,
        $RuntimeSnapshot,
        [string]$ManifestHash,
        [string]$SourceStatus
    )

    if ($SourceStatus -eq 'ambiguous' -or $SourceStatus -eq 'invalid-source-path') {
        return 'ambiguous'
    }
    if ($null -eq $PackageSnapshot) {
        return 'package-missing'
    }
    if ($null -eq $PersonalSnapshot) {
        return 'unregistered-source'
    }
    $personalHash = Get-SnapshotHash -Snapshot $PersonalSnapshot
    $packageHash = Get-SnapshotHash -Snapshot $PackageSnapshot
    $runtimeHash = Get-SnapshotHash -Snapshot $RuntimeSnapshot

    $runtimeExists = $null -ne $RuntimeSnapshot
    if ($personalHash -eq $packageHash -and $packageHash -eq $runtimeHash) {
        return 'clean'
    }
    if ($personalHash -eq $packageHash) {
        if (-not $runtimeExists) { return 'runtime-missing' }
        return 'runtime-drift'
    }
    if ($personalHash -eq $runtimeHash -or $packageHash -eq $runtimeHash -or -not $runtimeExists) {
        if ($ManifestHash -eq $personalHash) { return 'package-drift' }
        if ($ManifestHash -eq $packageHash) { return 'personal-drift' }
        return 'conflict'
    }
    return 'conflict'
}

function Get-ProjectSkillFindings {
    param(
        $ProjectContext,
        [hashtable]$PersonalIndex,
        [Parameter(Mandatory = $true)][string]$PersonalLibraryRoot,
        [string]$AssetFilter
    )

    $manifestMap = Get-ManifestSkillMap -Manifest $ProjectContext.manifest
    $names = Get-PackageSkillNames -PackageSkillsPath $ProjectContext.packageSkillsPath -RuntimeSkillsPath $ProjectContext.runtimeSkillsPath -ManifestSkillMap $manifestMap
    if (-not [string]::IsNullOrWhiteSpace($AssetFilter)) {
        $names = @($names | Where-Object { $_ -eq $AssetFilter })
    }

    $findings = @()
    foreach ($name in $names) {
        $manifestRecord = $null
        if ($manifestMap.ContainsKey($name)) {
            $manifestRecord = $manifestMap[$name]
        }
        $source = Resolve-PersonalSource -ManifestRecord $manifestRecord -PersonalIndex $PersonalIndex -PersonalLibraryRoot $PersonalLibraryRoot -AssetName $name
        $packagePath = Join-Path $ProjectContext.packageSkillsPath $name
        $runtimePath = Join-Path $ProjectContext.runtimeSkillsPath $name
        $personalSnapshot = if ($null -ne $source.path) { Get-DirectorySnapshot -Path $source.path } else { $null }
        $packageSnapshot = Get-DirectorySnapshot -Path $packagePath
        $runtimeSnapshot = Get-DirectorySnapshot -Path $runtimePath
        $manifestHash = [string](Get-OptionalPropertyValue -Object $manifestRecord -Name 'sha256')
        $status = Get-SkillStatus -PersonalSnapshot $personalSnapshot -PackageSnapshot $packageSnapshot -RuntimeSnapshot $runtimeSnapshot -ManifestHash $manifestHash -SourceStatus $source.status

        $findings += [pscustomobject]@{
            assetType = 'Skill'
            assetName = $name
            projectName = $ProjectContext.projectName
            projectPath = $ProjectContext.projectPath
            manifestPath = $ProjectContext.manifestPath
            sourceStatus = $source.status
            sourceCandidates = @($source.candidates)
            personalPath = $source.path
            packagePath = $packagePath
            runtimePath = $runtimePath
            manifestHash = $manifestHash
            personalHash = Get-SnapshotHash -Snapshot $personalSnapshot
            packageHash = Get-SnapshotHash -Snapshot $packageSnapshot
            runtimeHash = Get-SnapshotHash -Snapshot $runtimeSnapshot
            personalFileCount = if ($null -ne $personalSnapshot) { $personalSnapshot.FileCount } else { 0 }
            packageFileCount = if ($null -ne $packageSnapshot) { $packageSnapshot.FileCount } else { 0 }
            runtimeFileCount = if ($null -ne $runtimeSnapshot) { $runtimeSnapshot.FileCount } else { 0 }
            status = $status
        }
    }
    return @($findings)
}

function Get-GlobalFindings {
    param(
        [hashtable]$PersonalIndex,
        [Parameter(Mandatory = $true)][string]$GlobalRoot,
        [string]$AssetFilter
    )

    $findings = @()
    foreach ($name in @($PersonalIndex.Keys | Sort-Object)) {
        if (-not [string]::IsNullOrWhiteSpace($AssetFilter) -and $name -ne $AssetFilter) {
            continue
        }
        $entries = @($PersonalIndex[$name])
        if ($entries.Count -ne 1) {
            continue
        }
        $personal = $entries[0]
        $globalPath = Join-Path $GlobalRoot $name
        $globalSnapshot = Get-DirectorySnapshot -Path $globalPath
        if ($null -eq $globalSnapshot -and [string]::IsNullOrWhiteSpace($AssetFilter)) {
            continue
        }
        $status = if ($null -eq $globalSnapshot) { 'global-missing' } elseif ((Get-SnapshotHash $personal.snapshot) -eq (Get-SnapshotHash $globalSnapshot)) { 'clean' } else { 'global-drift' }
        $findings += [pscustomobject]@{
            assetType = 'Skill'
            assetName = $name
            personalPath = $personal.path
            globalPath = $globalPath
            personalHash = Get-SnapshotHash -Snapshot $personal.snapshot
            globalHash = Get-SnapshotHash -Snapshot $globalSnapshot
            status = $status
        }
    }
    return @($findings)
}

function Merge-ProjectGlobalFindings {
    param(
        [object[]]$GlobalFindings,
        [object[]]$ProjectContexts,
        [Parameter(Mandatory = $true)][string]$GlobalRoot,
        [string]$AssetFilter
    )

    $index = @{}
    foreach ($finding in @($GlobalFindings)) {
        if ($null -eq $finding) {
            continue
        }
        $index[$finding.assetName] = $finding
    }
    $normalizedGlobalRoot = (Get-FullPath -Path $GlobalRoot).TrimEnd('\')
    foreach ($context in @($ProjectContexts)) {
        $runtimeRoot = (Get-FullPath -Path $context.runtimeSkillsPath).TrimEnd('\')
        if (-not $runtimeRoot.Equals($normalizedGlobalRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            continue
        }
        $manifestMap = Get-ManifestSkillMap -Manifest $context.manifest
        foreach ($skillName in @($manifestMap.Keys)) {
            if (-not [string]::IsNullOrWhiteSpace($AssetFilter) -and $skillName -ne $AssetFilter) {
                continue
            }
            if ($index.ContainsKey($skillName)) {
                continue
            }
            $packagePath = Join-Path $context.packageSkillsPath $skillName
            $runtimePath = Join-Path $context.runtimeSkillsPath $skillName
            $packageSnapshot = Get-DirectorySnapshot -Path $packagePath
            $runtimeSnapshot = Get-DirectorySnapshot -Path $runtimePath
            $status = if ($null -eq $runtimeSnapshot) { 'global-missing' } elseif ((Get-SnapshotHash -Snapshot $packageSnapshot) -eq (Get-SnapshotHash -Snapshot $runtimeSnapshot)) { 'clean' } else { 'global-drift' }
            $index[$skillName] = [pscustomobject]@{
                assetType = 'Skill'
                assetName = $skillName
                personalPath = [string](Get-OptionalPropertyValue -Object $manifestMap[$skillName] -Name 'sourcePath')
                globalPath = $runtimePath
                personalHash = Get-SnapshotHash -Snapshot $packageSnapshot
                globalHash = Get-SnapshotHash -Snapshot $runtimeSnapshot
                status = $status
            }
        }
    }
    return @($index.Values | Sort-Object assetName)
}

function Get-PluginManifestPath {
    param([Parameter(Mandatory = $true)][string]$PluginDirectory)

    foreach ($relative in @('.codex-plugin\plugin.json', '.claude-plugin\plugin.json')) {
        $candidate = Join-Path $PluginDirectory $relative
        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            return $candidate
        }
    }
    return $null
}

function Get-PluginSourceIndex {
    param([Parameter(Mandatory = $true)][string]$PluginRoot)

    $records = @()
    if (-not (Test-Path -LiteralPath $PluginRoot -PathType Container)) {
        return $records
    }
    foreach ($directory in @(Get-ChildItem -LiteralPath $PluginRoot -Directory -Force)) {
        $metadataPath = Get-PluginManifestPath -PluginDirectory $directory.FullName
        if ($null -eq $metadataPath) {
            continue
        }
        try {
            $metadata = Get-Content -LiteralPath $metadataPath -Raw -Encoding utf8 | ConvertFrom-Json
            $name = [string](Get-OptionalPropertyValue -Object $metadata -Name 'name')
            if ([string]::IsNullOrWhiteSpace($name)) {
                $name = $directory.Name
            }
            $version = [string](Get-OptionalPropertyValue -Object $metadata -Name 'version')
            $records += [pscustomobject]@{
                name = $name
                version = $version
                sourcePath = $directory.FullName
                metadataPath = $metadataPath
                sourceHash = Get-SnapshotHash -Snapshot (Get-DirectorySnapshot -Path $directory.FullName)
                metadataStatus = if ([string]::IsNullOrWhiteSpace($version)) { 'version-missing' } else { 'ok' }
            }
        }
        catch {
            $records += [pscustomobject]@{
                name = $directory.Name
                version = $null
                sourcePath = $directory.FullName
                metadataPath = $metadataPath
                sourceHash = $null
                metadataStatus = 'invalid-metadata'
            }
        }
    }
    return @($records)
}

function Get-PluginCacheIndex {
    param([Parameter(Mandatory = $true)][string]$PluginCacheRoot)

    $records = @()
    if (-not (Test-Path -LiteralPath $PluginCacheRoot -PathType Container)) {
        return $records
    }
    foreach ($metadataPath in @(Get-ChildItem -LiteralPath $PluginCacheRoot -File -Filter 'plugin.json' -Force -Recurse)) {
        try {
            $metadata = Get-Content -LiteralPath $metadataPath.FullName -Raw -Encoding utf8 | ConvertFrom-Json
            $name = [string](Get-OptionalPropertyValue -Object $metadata -Name 'name')
            if ([string]::IsNullOrWhiteSpace($name)) {
                continue
            }
            $records += [pscustomobject]@{
                name = $name
                version = [string](Get-OptionalPropertyValue -Object $metadata -Name 'version')
                metadataPath = $metadataPath.FullName
                cachePath = $metadataPath.Directory.Parent.FullName
            }
        }
        catch {
            continue
        }
    }
    return @($records)
}

function Get-PluginFindings {
    param(
        [Parameter(Mandatory = $true)][string]$PluginRoot,
        [Parameter(Mandatory = $true)][string]$PluginCacheRoot,
        [string]$AssetFilter
    )

    $sources = @(Get-PluginSourceIndex -PluginRoot $PluginRoot)
    $cache = @(Get-PluginCacheIndex -PluginCacheRoot $PluginCacheRoot)
    $findings = @()
    foreach ($source in $sources) {
        if (-not [string]::IsNullOrWhiteSpace($AssetFilter) -and $source.name -ne $AssetFilter) {
            continue
        }
        $matches = @($cache | Where-Object { $_.name -eq $source.name })
        $status = 'cache-missing'
        if ($matches.Count -gt 0) {
            $sameVersion = @($matches | Where-Object { $_.version -eq $source.version }).Count -gt 0
            $status = if ($sameVersion) { 'clean-metadata' } else { 'version-drift' }
        }
        $findings += [pscustomobject]@{
            assetType = 'Plugin'
            assetName = $source.name
            sourcePath = $source.sourcePath
            metadataPath = $source.metadataPath
            sourceHash = $source.sourceHash
            sourceVersion = $source.version
            installed = @($matches | Select-Object version, metadataPath, cachePath)
            status = $status
            verification = if ($matches.Count -gt 0) { 'metadata-only; cache source hash is not compared' } else { 'not-installed-or-not-discoverable' }
        }
    }
    return @($findings)
}

function Get-ProjectPluginFindings {
    param(
        $ProjectContext,
        [object[]]$PluginSources,
        [object[]]$PluginCache,
        [string]$AssetFilter
    )

    $plugins = @(Get-OptionalPropertyValue -Object (Get-OptionalPropertyValue -Object $ProjectContext.manifest -Name 'managedAssets') -Name 'plugins')
    $findings = @()
    foreach ($plugin in $plugins) {
        $name = Get-AssetName -Asset $plugin
        if ([string]::IsNullOrWhiteSpace($name)) {
            continue
        }
        if (-not [string]::IsNullOrWhiteSpace($AssetFilter) -and $name -ne $AssetFilter) {
            continue
        }

        $configuredPath = [string](Get-OptionalPropertyValue -Object $plugin -Name 'sourcePath')
        $source = $null
        if (-not [string]::IsNullOrWhiteSpace($configuredPath)) {
            $source = @($PluginSources | Where-Object { $_.sourcePath -eq $configuredPath })[0]
        }
        if ($null -eq $source) {
            $source = @($PluginSources | Where-Object { $_.name -eq $name })[0]
        }

        $matches = @($PluginCache | Where-Object { $_.name -eq $name })
        $status = if ($null -eq $source) {
            'unregistered-source'
        }
        elseif ([string]::IsNullOrWhiteSpace($source.version)) {
            'metadata-missing'
        }
        elseif ($matches.Count -eq 0) {
            'cache-missing'
        }
        elseif (@($matches | Where-Object { $_.version -eq $source.version }).Count -eq 0) {
            'version-drift'
        }
        else {
            'clean-metadata'
        }

        $findings += [pscustomobject]@{
            assetType = 'Plugin'
            assetName = $name
            projectName = $ProjectContext.projectName
            manifestPath = $ProjectContext.manifestPath
            sourcePath = if ($null -ne $source) { $source.sourcePath } else { $configuredPath }
            metadataPath = if ($null -ne $source) { $source.metadataPath } else { $null }
            sourceHash = if ($null -ne $source) { $source.sourceHash } else { $null }
            sourceVersion = if ($null -ne $source) { $source.version } else { $null }
            installed = @($matches | Select-Object version, metadataPath, cachePath)
            status = $status
            verification = if ($matches.Count -gt 0) { 'metadata-only; cache source hash is not compared' } else { 'not-installed-or-not-discoverable' }
        }
    }
    return @($findings)
}

function Get-SnapshotRecord {
    param($Snapshot)

    if ($null -eq $Snapshot) {
        return $null
    }
    return [pscustomobject]@{
        path = $null
        fileCount = $Snapshot.FileCount
        sha256 = $Snapshot.ContentSha256
    }
}

function New-Change {
    param(
        [Parameter(Mandatory = $true)][string]$AssetType,
        [Parameter(Mandatory = $true)][string]$AssetName,
        [Parameter(Mandatory = $true)][string]$Operation,
        [string]$ProjectName,
        [string]$SourcePath,
        [string]$TargetPath,
        [string]$SourceHash,
        [string]$TargetHash,
        [string]$NewHash,
        [string]$Reason,
        [string]$Risk,
        [string]$SyncProjectName
    )

    return [pscustomobject]@{
        id = $null
        assetType = $AssetType
        assetName = $AssetName
        operation = $Operation
        status = if ($Operation -eq 'plugin-install-plan' -or $Operation -eq 'manual-review') { 'manual-review' } else { 'requires-confirmation' }
        projectName = $ProjectName
        syncProjectName = $SyncProjectName
        source = [pscustomobject]@{ path = $SourcePath; sha256 = $SourceHash }
        target = [pscustomobject]@{ path = $TargetPath; sha256 = $TargetHash }
        expectedSourceSha256 = $SourceHash
        expectedTargetSha256 = $TargetHash
        newSha256 = $NewHash
        dependsOn = @()
        reason = $Reason
        risk = $Risk
    }
}

function Get-Summary {
    param(
        $ProjectFindings,
        $GlobalFindings,
        $PluginFindings
    )

    $skillStatuses = if ($null -eq $ProjectFindings) { @() } else { @($ProjectFindings | ForEach-Object { $_.status }) }
    $globalStatuses = if ($null -eq $GlobalFindings) { @() } else { @($GlobalFindings | ForEach-Object { $_.status }) }
    $pluginStatuses = if ($null -eq $PluginFindings) { @() } else { @($PluginFindings | ForEach-Object { $_.status }) }
    $skillStatuses = @($skillStatuses)
    $globalStatuses = @($globalStatuses)
    $pluginStatuses = @($pluginStatuses)
    $nonClean = @($skillStatuses + $globalStatuses + $pluginStatuses | Where-Object { $_ -notin @('clean', 'clean-metadata') }).Count
    return [pscustomobject]@{
        skills = [pscustomobject]@{
            total = $skillStatuses.Count
            clean = @($skillStatuses | Where-Object { $_ -eq 'clean' }).Count
            nonClean = @($skillStatuses | Where-Object { $_ -ne 'clean' }).Count
        }
        globalSkills = [pscustomobject]@{
            total = $globalStatuses.Count
            clean = @($globalStatuses | Where-Object { $_ -eq 'clean' }).Count
            nonClean = @($globalStatuses | Where-Object { $_ -ne 'clean' }).Count
        }
        plugins = [pscustomobject]@{
            total = $pluginStatuses.Count
            clean = @($pluginStatuses | Where-Object { $_ -eq 'clean-metadata' }).Count
            nonClean = @($pluginStatuses | Where-Object { $_ -ne 'clean-metadata' }).Count
        }
        nonClean = $nonClean
    }
}

function New-GovernanceReport {
    param([string]$AssetFilter)

    $personalRoot = Join-Path $CodexRoot $PersonalLibraryName
    $packagesRoot = Join-Path $CodexRoot $PackagesDirectoryName
    $pluginRoot = Join-Path $personalRoot 'Pluging插件'
    $personalIndex = Get-SkillIndex -PersonalLibraryRoot $personalRoot
    $projectContexts = Get-ProjectContexts -PackagesRoot $packagesRoot -RuntimeDirectory $RuntimeDirectoryName -IncludeFixtures:$IncludeFixtures
    $projectFindings = @()
    foreach ($context in $projectContexts) {
        $projectFindings += Get-ProjectSkillFindings -ProjectContext $context -PersonalIndex $personalIndex -PersonalLibraryRoot $personalRoot -AssetFilter $AssetFilter
    }
    $globalFindings = Get-GlobalFindings -PersonalIndex $personalIndex -GlobalRoot $GlobalSkillsPath -AssetFilter $AssetFilter
    $globalFindings = Merge-ProjectGlobalFindings -GlobalFindings $globalFindings -ProjectContexts $projectContexts -GlobalRoot $GlobalSkillsPath -AssetFilter $AssetFilter
    $pluginSources = @(Get-PluginSourceIndex -PluginRoot $pluginRoot)
    $pluginCache = @(Get-PluginCacheIndex -PluginCacheRoot $PluginCachePath)
    $pluginFindings = @(Get-PluginFindings -PluginRoot $pluginRoot -PluginCacheRoot $PluginCachePath -AssetFilter $AssetFilter)
    foreach ($context in $projectContexts) {
        $pluginFindings += Get-ProjectPluginFindings -ProjectContext $context -PluginSources $pluginSources -PluginCache $pluginCache -AssetFilter $AssetFilter
    }
    $projects = foreach ($context in $projectContexts) {
        [pscustomobject]@{
            projectName = $context.projectName
            projectPath = $context.projectPath
            packagePath = $context.packagePath
            manifestPath = $context.manifestPath
            packageSkillsPath = $context.packageSkillsPath
            runtimeSkillsPath = $context.runtimeSkillsPath
            skills = @($projectFindings | Where-Object { $_.projectName -eq $context.projectName })
        }
    }

    return [pscustomobject]@{
        schemaVersion = 1
        generatedAt = (Get-Date).ToString('o')
        codexRoot = Get-FullPath -Path $CodexRoot
        personalLibraryRoot = $personalRoot
        globalSkillsPath = Get-FullPath -Path $GlobalSkillsPath
        pluginCachePath = Get-FullPath -Path $PluginCachePath
        projects = @($projects)
        personalSources = @($personalIndex.Keys | Sort-Object | ForEach-Object {
            $entries = @($personalIndex[$_])
            [pscustomobject]@{
                assetName = $_
                candidates = @($entries | ForEach-Object {
                    [pscustomobject]@{
                        path = $_.path
                        sha256 = Get-SnapshotHash -Snapshot $_.snapshot
                        fileCount = $_.snapshot.FileCount
                    }
                })
            }
        })
        globalSkills = @($globalFindings)
        plugins = @($pluginFindings)
        summary = Get-Summary -ProjectFindings $projectFindings -GlobalFindings $globalFindings -PluginFindings $pluginFindings
        errors = @()
    }
}

function Add-ChangeId {
    param([object[]]$Changes)

    $number = 0
    foreach ($change in @($Changes)) {
        $number++
        $change.id = 'C{0:D3}' -f $number
    }
    return @($Changes)
}

function Test-GlobalSkillManagedByProject {
    param(
        [Parameter(Mandatory = $true)]$Report,
        [Parameter(Mandatory = $true)]$GlobalFinding,
        [Parameter(Mandatory = $true)][string]$GlobalRoot
    )

    $normalizedGlobalRoot = (Get-FullPath -Path $GlobalRoot).TrimEnd('\')
    foreach ($project in @($Report.projects)) {
        if ([string]::IsNullOrWhiteSpace([string]$project.runtimeSkillsPath)) {
            continue
        }
        $runtimeRoot = (Get-FullPath -Path $project.runtimeSkillsPath).TrimEnd('\')
        if (-not $runtimeRoot.Equals($normalizedGlobalRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            continue
        }
        if (@($project.skills | Where-Object { $_.assetName -eq $GlobalFinding.assetName }).Count -gt 0) {
            return $true
        }
    }

    return $false
}

function New-GovernancePlan {
    param([string]$AssetFilter)

    $report = New-GovernanceReport -AssetFilter $AssetFilter
    $changes = @()
    $deployProjects = @{}
    $skillFindings = @($report.projects | ForEach-Object { $_.skills })
    foreach ($finding in $skillFindings) {
        switch ($finding.status) {
            'personal-drift' {
                $changes += New-Change -AssetType 'Skill' -AssetName $finding.assetName -Operation 'sync-project-package' -ProjectName $finding.projectName -SourcePath $finding.personalPath -TargetPath $finding.packagePath -SourceHash $finding.personalHash -TargetHash $finding.packageHash -NewHash $finding.personalHash -Reason 'Personal source differs while package and runtime match the manifest baseline.' -Risk 'writes project package and then requires project deployment' -SyncProjectName $finding.projectName
                $deployProjects[$finding.projectName] = $finding
            }
            'package-drift' {
                $changes += New-Change -AssetType 'Skill' -AssetName $finding.assetName -Operation 'writeback-personal-library' -ProjectName $finding.projectName -SourcePath $finding.packagePath -TargetPath $finding.personalPath -SourceHash $finding.packageHash -TargetHash $finding.personalHash -NewHash $finding.packageHash -Reason 'Project package differs while personal source and runtime match the manifest baseline; project version is the candidate source.' -Risk 'promotes a project change into the personal source library' -SyncProjectName $null
            }
            'runtime-drift' { $deployProjects[$finding.projectName] = $finding }
            'runtime-missing' { $deployProjects[$finding.projectName] = $finding }
            'conflict' { continue }
        }
    }
    foreach ($projectName in @($deployProjects.Keys | Sort-Object)) {
        $finding = $deployProjects[$projectName]
        $context = @($report.projects | Where-Object { $_.projectName -eq $projectName })[0]
        $packageRoot = Join-Path $context.packagePath 'skills'
        $runtimeRoot = $context.runtimeSkillsPath
        $packageSnapshot = Get-DirectorySnapshot -Path $packageRoot
        $runtimeSnapshot = Get-DirectorySnapshot -Path $runtimeRoot
        $changes += New-Change -AssetType 'Skill' -AssetName '*' -Operation 'deploy-project' -ProjectName $projectName -SourcePath $packageRoot -TargetPath $runtimeRoot -SourceHash (Get-SnapshotHash $packageSnapshot) -TargetHash (Get-SnapshotHash $runtimeSnapshot) -NewHash (Get-SnapshotHash $packageSnapshot) -Reason 'Project runtime is missing or differs from the project package.' -Risk 'replaces the project .codex/skills directory through the guarded deployment script' -SyncProjectName $projectName
    }
    foreach ($finding in @($report.globalSkills | Where-Object { $_.status -in @('global-drift', 'global-missing') })) {
        if (Test-GlobalSkillManagedByProject -Report $report -GlobalFinding $finding -GlobalRoot $GlobalSkillsPath) {
            continue
        }
        $changes += New-Change -AssetType 'Skill' -AssetName $finding.assetName -Operation 'sync-global-runtime' -SourcePath $finding.personalPath -TargetPath $finding.globalPath -SourceHash $finding.personalHash -TargetHash $finding.globalHash -NewHash $finding.personalHash -Reason 'Global Agent runtime differs from the personal source library.' -Risk 'replaces one global Skill runtime directory' -SyncProjectName $null
    }
    foreach ($finding in @($report.plugins | Where-Object { $_.status -ne 'clean-metadata' })) {
        $changes += New-Change -AssetType 'Plugin' -AssetName $finding.assetName -Operation 'plugin-install-plan' -SourcePath $finding.sourcePath -TargetPath $report.pluginCachePath -SourceHash $finding.sourceHash -TargetHash $null -NewHash $null -Reason "Plugin status: $($finding.status). Use the Plugin's supported installer or update mechanism." -Risk 'manual Plugin installation required; cache is never copied by this Skill' -SyncProjectName $null
    }
    $changes = Add-ChangeId -Changes $changes
    return [pscustomobject]@{
        schemaVersion = 1
        generatedAt = $report.generatedAt
        codexRoot = $report.codexRoot
        personalLibraryRoot = $report.personalLibraryRoot
        globalSkillsPath = $report.globalSkillsPath
        changes = @($changes)
        conflicts = @($skillFindings | Where-Object { $_.status -in @('conflict', 'ambiguous', 'unregistered-source', 'package-missing') })
        report = $report
    }
}

function New-DeletionPlan {
    param(
        [Parameter(Mandatory = $true)][string]$AssetFilter,
        [Parameter(Mandatory = $true)][ValidateSet('Project', 'Personal')][string]$Scope,
        [string]$RequestedProjectName
    )

    if ([string]::IsNullOrWhiteSpace($AssetFilter)) {
        throw 'Skill deletion requires -AssetName.'
    }
    if ($Scope -eq 'Project' -and [string]::IsNullOrWhiteSpace($RequestedProjectName)) {
        throw 'Project deletion requires -ProjectName.'
    }

    $report = New-GovernanceReport -AssetFilter $AssetFilter
    $personalSource = $report.personalSources | Where-Object { $_.assetName -eq $AssetFilter } | Select-Object -First 1
    if ($Scope -eq 'Personal') {
        if ($null -eq $personalSource) {
            throw "Personal source Skill is not found: $AssetFilter"
        }
        if (@($personalSource.candidates).Count -ne 1) {
            throw "Personal source Skill is ambiguous: $AssetFilter. Specify sourcePath in the project manifest or resolve duplicate names first."
        }
    }

    $changes = @()
    $projectChanges = @()
    foreach ($project in @($report.projects)) {
        $finding = $project.skills | Where-Object { $_.assetName -eq $AssetFilter } | Select-Object -First 1
        if ($null -eq $finding) {
            continue
        }

        $includeProject = $Scope -eq 'Personal' -or $project.projectName -eq $RequestedProjectName
        if (-not $includeProject) {
            continue
        }
        if ($Scope -eq 'Project' -and $project.projectName -ne $RequestedProjectName) {
            continue
        }
        if ($null -ne $finding.packagePath -and -not [string]::IsNullOrWhiteSpace($finding.packageHash)) {
            $projectChanges += New-Change -AssetType 'Skill' -AssetName $AssetFilter -Operation 'remove-project-skill' -ProjectName $project.projectName -SourcePath $null -TargetPath $finding.packagePath -SourceHash $null -TargetHash $finding.packageHash -NewHash $null -Reason 'Remove the Skill from this project package while retaining the personal source.' -Risk 'deletes the project package copy and deploys the package' -SyncProjectName $project.projectName
        }
    }

    $changes += @($projectChanges | Sort-Object projectName)
    $projectChangesByName = @{}
    $runtimeOnlyProjects = @{}
    foreach ($change in @($projectChanges)) {
        $projectChangesByName[$change.projectName] = $change
    }
    foreach ($project in @($report.projects)) {
        $finding = $project.skills | Where-Object { $_.assetName -eq $AssetFilter } | Select-Object -First 1
        $includeRuntimeOnlyProject = $Scope -eq 'Personal' -or $project.projectName -eq $RequestedProjectName
        if ($includeRuntimeOnlyProject -and $null -ne $finding -and [string]::IsNullOrWhiteSpace($finding.packageHash) -and -not [string]::IsNullOrWhiteSpace($finding.runtimeHash)) {
            $runtimeOnlyProjects[$project.projectName] = $project
        }
    }

    foreach ($project in @($report.projects)) {
        if (-not $projectChangesByName.ContainsKey($project.projectName) -and -not $runtimeOnlyProjects.ContainsKey($project.projectName)) {
            continue
        }
        $packageRoot = Join-Path $project.packagePath 'skills'
        $runtimeRoot = $project.runtimeSkillsPath
        $packageSnapshot = Get-DirectorySnapshot -Path $packageRoot
        $runtimeSnapshot = Get-DirectorySnapshot -Path $runtimeRoot
        $changes += New-Change -AssetType 'Skill' -AssetName $AssetFilter -Operation 'deploy-project' -ProjectName $project.projectName -SourcePath $packageRoot -TargetPath $runtimeRoot -SourceHash (Get-SnapshotHash $packageSnapshot) -TargetHash (Get-SnapshotHash $runtimeSnapshot) -NewHash (Get-SnapshotHash $packageSnapshot) -Reason 'Remove the deleted Skill from the project runtime.' -Risk 'replaces the project runtime skills directory through the guarded deployment script' -SyncProjectName $project.projectName
    }

    if ($Scope -eq 'Personal') {
        $globalFinding = $report.globalSkills | Where-Object { $_.assetName -eq $AssetFilter } | Select-Object -First 1
        $globalManagedByProject = $null -ne $globalFinding -and (Test-GlobalSkillManagedByProject -Report $report -GlobalFinding $globalFinding -GlobalRoot $GlobalSkillsPath)
        if ($null -ne $globalFinding -and -not $globalManagedByProject -and -not [string]::IsNullOrWhiteSpace($globalFinding.globalHash)) {
            $changes += New-Change -AssetType 'Skill' -AssetName $AssetFilter -Operation 'remove-global-skill' -SourcePath $null -TargetPath $globalFinding.globalPath -SourceHash $null -TargetHash $globalFinding.globalHash -NewHash $null -Reason 'Remove the retired Skill from the agent global runtime.' -Risk 'deletes one global runtime Skill directory' -SyncProjectName $null
        }

        $source = $personalSource.candidates[0]
        $personalChange = New-Change -AssetType 'Skill' -AssetName $AssetFilter -Operation 'remove-personal-source' -SourcePath $null -TargetPath $source.path -SourceHash $null -TargetHash $source.sha256 -NewHash $null -Reason 'Remove the retired Skill from the personal source library after all registered copies are removed.' -Risk 'deletes the personal source Skill and is intended as a recoverable soft delete until Git history is committed' -SyncProjectName $null
        $changes += $personalChange
    }

    $changes = Add-ChangeId -Changes $changes
    foreach ($deployChange in @($changes | Where-Object { $_.operation -eq 'deploy-project' })) {
        $removeChange = $changes | Where-Object { $_.operation -eq 'remove-project-skill' -and $_.projectName -eq $deployChange.projectName } | Select-Object -First 1
        if ($null -ne $removeChange) {
            $deployChange.dependsOn = @($removeChange.id)
        }
    }
    $personalChange = $changes | Where-Object { $_.operation -eq 'remove-personal-source' } | Select-Object -First 1
    if ($null -ne $personalChange) {
        $dependencies = @($changes | Where-Object { $_.operation -in @('deploy-project', 'remove-global-skill') } | ForEach-Object { $_.id })
        $personalChange.dependsOn = @($dependencies)
    }

    $conflictFindings = @()
    if ($Scope -eq 'Personal') {
        $conflictFindings = @($report.projects | ForEach-Object { $_.skills } | Where-Object {
            $_.assetName -eq $AssetFilter -and $_.status -in @('conflict', 'ambiguous')
        })
    }

    return [pscustomobject]@{
        schemaVersion = 1
        generatedAt = $report.generatedAt
        codexRoot = $report.codexRoot
        personalLibraryRoot = $report.personalLibraryRoot
        globalSkillsPath = $report.globalSkillsPath
        deletionScope = $Scope
        changes = @($changes)
        conflicts = @($conflictFindings)
        report = $report
    }
}

function Convert-PlanToMarkdown {
    param($Plan)

    $lines = @(
        '# Codex Skill Governance Plan',
        '',
        "Generated: $($Plan.generatedAt)",
        '',
        '| ID | Asset | Operation | Source | Target | Risk |',
        '| --- | --- | --- | --- | --- | --- |'
    )
    foreach ($change in @($Plan.changes)) {
        $lines += "| $($change.id) | $($change.assetType): $($change.assetName) | $($change.operation) | $($change.source.path) | $($change.target.path) | $($change.risk) |"
    }
    $lines += @('', '## Conflicts and Manual Review', '')
    foreach ($finding in @($Plan.conflicts)) {
        $lines += "- $($finding.projectName): $($finding.assetName) — $($finding.status)"
    }
    if (@($Plan.conflicts).Count -eq 0) {
        $lines += '- None reported.'
    }
    return $lines -join "`r`n"
}

function Write-PlanFiles {
    param(
        $Plan,
        [Parameter(Mandatory = $true)][string]$JsonPath
    )

    $jsonPath = Get-FullPath -Path $JsonPath
    if ([System.IO.Path]::GetExtension($jsonPath).ToLowerInvariant() -ne '.json') {
        $jsonPath = "$jsonPath.json"
    }
    $parent = Split-Path -Parent $jsonPath
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
    $Plan | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $jsonPath -Encoding utf8
    $markdownPath = [System.IO.Path]::ChangeExtension($jsonPath, '.md')
    Convert-PlanToMarkdown -Plan $Plan | Set-Content -LiteralPath $markdownPath -Encoding utf8
    return [pscustomobject]@{ jsonPath = $jsonPath; markdownPath = $markdownPath }
}

function Assert-CopyTarget {
    param(
        [Parameter(Mandatory = $true)][string]$Operation,
        [Parameter(Mandatory = $true)][string]$TargetPath,
        [Parameter(Mandatory = $true)][string]$CodexRootPath,
        [Parameter(Mandatory = $true)][string]$GlobalRoot
    )

    switch ($Operation) {
        'sync-project-package' {
            Assert-PathWithin -Path $TargetPath -Root (Join-Path $CodexRootPath $script:PackagesDirectoryName) -Description 'Project package target'
            $targetSkillsRoot = Split-Path -Parent (Get-FullPath -Path $TargetPath)
            $targetPackageRoot = Split-Path -Parent $targetSkillsRoot
            $packagesRoot = Get-FullPath -Path (Join-Path $CodexRootPath $script:PackagesDirectoryName)
            if ((Split-Path -Leaf $targetSkillsRoot) -ne 'skills' -or -not (Split-Path -Parent $targetPackageRoot).Equals($packagesRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
                throw 'Project package target must be one direct Skill directory under 项目包/<project>/skills.'
            }
        }
        'writeback-personal-library' {
            Assert-PathWithin -Path $TargetPath -Root (Join-Path $CodexRootPath $script:PersonalLibraryName) -Description 'Personal library target'
            if ((Get-FullPath -Path $TargetPath).TrimEnd('\').Equals((Get-FullPath -Path (Join-Path $CodexRootPath $script:PersonalLibraryName)).TrimEnd('\'), [System.StringComparison]::OrdinalIgnoreCase)) {
                throw 'Personal library target must be one Skill directory, not the repository root.'
            }
        }
        'sync-global-runtime' {
            Assert-PathWithin -Path $TargetPath -Root $GlobalRoot -Description 'Global runtime target'
            if ((Get-FullPath -Path $TargetPath).TrimEnd('\').Equals((Get-FullPath -Path $GlobalRoot).TrimEnd('\'), [System.StringComparison]::OrdinalIgnoreCase)) {
                throw 'Global runtime target must be one Skill directory, not the global root.'
            }
        }
        default { throw "Copy operation is not allowed: $Operation" }
    }
}

function Assert-CopySource {
    param(
        [Parameter(Mandatory = $true)][string]$Operation,
        [Parameter(Mandatory = $true)][string]$SourcePath,
        [Parameter(Mandatory = $true)][string]$CodexRootPath,
        [Parameter(Mandatory = $true)][string]$GlobalRoot
    )

    switch ($Operation) {
        'sync-project-package' { Assert-PathWithin -Path $SourcePath -Root (Join-Path $CodexRootPath $script:PersonalLibraryName) -Description 'Personal library source' }
        'writeback-personal-library' {
            Assert-PathWithin -Path $SourcePath -Root (Join-Path $CodexRootPath $script:PackagesDirectoryName) -Description 'Project package source'
            $sourceSkillsRoot = Split-Path -Parent (Get-FullPath -Path $SourcePath)
            $sourcePackageRoot = Split-Path -Parent $sourceSkillsRoot
            $packagesRoot = Get-FullPath -Path (Join-Path $CodexRootPath $script:PackagesDirectoryName)
            if ((Split-Path -Leaf $sourceSkillsRoot) -ne 'skills' -or -not (Split-Path -Parent $sourcePackageRoot).Equals($packagesRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
                throw 'Project package source must be a direct Skill directory under 项目包/<project>/skills.'
            }
        }
        'sync-global-runtime' { Assert-PathWithin -Path $SourcePath -Root (Join-Path $CodexRootPath $script:PersonalLibraryName) -Description 'Personal library source' }
        default { throw "Copy operation is not allowed: $Operation" }
    }
}

function Copy-GovernedDirectory {
    param(
        [Parameter(Mandatory = $true)][string]$Operation,
        [Parameter(Mandatory = $true)][string]$SourcePath,
        [Parameter(Mandatory = $true)][string]$TargetPath,
        [string]$ExpectedSourceHash,
        [string]$ExpectedTargetHash,
        [Parameter(Mandatory = $true)][string]$CodexRootPath,
        [Parameter(Mandatory = $true)][string]$GlobalRoot
    )

    Assert-CopySource -Operation $Operation -SourcePath $SourcePath -CodexRootPath $CodexRootPath -GlobalRoot $GlobalRoot
    Assert-CopyTarget -Operation $Operation -TargetPath $TargetPath -CodexRootPath $CodexRootPath -GlobalRoot $GlobalRoot
    if (-not (Test-Path -LiteralPath $SourcePath -PathType Container)) {
        throw "Copy source is missing: $SourcePath"
    }
    Test-NoReparsePoint -Path $SourcePath
    $sourceSnapshot = Get-DirectorySnapshot -Path $SourcePath
    if (-not [string]::IsNullOrWhiteSpace($ExpectedSourceHash) -and $sourceSnapshot.ContentSha256 -ne $ExpectedSourceHash) {
        throw "Source changed since the plan was generated: $SourcePath"
    }

    $targetExists = Test-Path -LiteralPath $TargetPath -PathType Container
    if ($targetExists) {
        Test-NoReparsePoint -Path $TargetPath
        $targetSnapshot = Get-DirectorySnapshot -Path $TargetPath
        if ([string]::IsNullOrWhiteSpace($ExpectedTargetHash) -or $targetSnapshot.ContentSha256 -ne $ExpectedTargetHash) {
            throw "Target changed since the plan was generated: $TargetPath"
        }
    }
    elseif (-not [string]::IsNullOrWhiteSpace($ExpectedTargetHash)) {
        throw "Planned target no longer exists: $TargetPath"
    }

    $targetParent = Split-Path -Parent (Get-FullPath -Path $TargetPath)
    $targetParentRoot = if ($Operation -eq 'sync-global-runtime') { $GlobalRoot } else { $CodexRootPath }
    Assert-PathWithin -Path $targetParent -Root $targetParentRoot -Description 'Copy target parent'
    New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
    $backupRoot = Join-Path $env:TEMP 'codex-skill-governance-backups'
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    $backupPath = Join-Path $backupRoot ([guid]::NewGuid().ToString('N'))
    $hasBackup = $false
    try {
        if ($targetExists) {
            Move-Item -LiteralPath $TargetPath -Destination $backupPath -Force
            $hasBackup = $true
        }
        Copy-Item -LiteralPath $SourcePath -Destination $targetParent -Recurse -Force
        $afterSnapshot = Get-DirectorySnapshot -Path $TargetPath
        if ($afterSnapshot.ContentSha256 -ne $sourceSnapshot.ContentSha256) {
            throw "Post-copy hash verification failed: $TargetPath"
        }
        if ($hasBackup -and (Test-Path -LiteralPath $backupPath)) {
            Assert-PathWithin -Path $backupPath -Root $backupRoot -Description 'Governance backup'
            Remove-Item -LiteralPath $backupPath -Recurse -Force
        }
        return $afterSnapshot
    }
    catch {
        if ($hasBackup -and (Test-Path -LiteralPath $backupPath) -and -not (Test-Path -LiteralPath $TargetPath)) {
            Move-Item -LiteralPath $backupPath -Destination $TargetPath -Force
        }
        throw
    }
}

function Remove-GovernedDirectory {
    param(
        [Parameter(Mandatory = $true)][string]$Operation,
        [Parameter(Mandatory = $true)][string]$TargetPath,
        [string]$ExpectedTargetHash,
        [Parameter(Mandatory = $true)][string]$CodexRootPath,
        [Parameter(Mandatory = $true)][string]$GlobalRoot
    )

    switch ($Operation) {
        'remove-project-skill' {
            Assert-PathWithin -Path $TargetPath -Root (Join-Path $CodexRootPath $script:PackagesDirectoryName) -Description 'Project package deletion target'
            $targetSkillsRoot = Split-Path -Parent (Get-FullPath -Path $TargetPath)
            $targetPackageRoot = Split-Path -Parent $targetSkillsRoot
            $packagesRoot = Get-FullPath -Path (Join-Path $CodexRootPath $script:PackagesDirectoryName)
            if ((Split-Path -Leaf $targetSkillsRoot) -ne 'skills' -or -not (Split-Path -Parent $targetPackageRoot).Equals($packagesRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
                throw 'Project package deletion target must be one direct Skill directory under 项目包/<project>/skills.'
            }
        }
        'remove-global-skill' {
            Assert-PathWithin -Path $TargetPath -Root $GlobalRoot -Description 'Global runtime deletion target'
            if ((Get-FullPath -Path $TargetPath).TrimEnd('\').Equals((Get-FullPath -Path $GlobalRoot).TrimEnd('\'), [System.StringComparison]::OrdinalIgnoreCase)) {
                throw 'Global runtime deletion target must be one Skill directory, not the global root.'
            }
        }
        'remove-personal-source' {
            Assert-PathWithin -Path $TargetPath -Root (Join-Path $CodexRootPath $script:PersonalLibraryName) -Description 'Personal library deletion target'
            if ((Get-FullPath -Path $TargetPath).TrimEnd('\').Equals((Get-FullPath -Path (Join-Path $CodexRootPath $script:PersonalLibraryName)).TrimEnd('\'), [System.StringComparison]::OrdinalIgnoreCase)) {
                throw 'Personal library deletion target must be one Skill directory, not the repository root.'
            }
        }
        default { throw "Delete operation is not allowed: $Operation" }
    }

    if (-not (Test-Path -LiteralPath $TargetPath -PathType Container)) {
        throw "Deletion target is missing: $TargetPath"
    }

    Test-NoReparsePoint -Path $TargetPath
    $targetSnapshot = Get-DirectorySnapshot -Path $TargetPath
    if ([string]::IsNullOrWhiteSpace($ExpectedTargetHash) -or $targetSnapshot.ContentSha256 -ne $ExpectedTargetHash) {
        throw "Target changed since the deletion plan was generated: $TargetPath"
    }

    $backupRoot = Join-Path $env:TEMP 'codex-skill-governance-deletion-backups'
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    $backupPath = Join-Path $backupRoot ([guid]::NewGuid().ToString('N'))
    Move-Item -LiteralPath $TargetPath -Destination $backupPath -Force
    if (Test-Path -LiteralPath $TargetPath) {
        throw "Deletion verification failed: $TargetPath still exists."
    }
    return [pscustomobject]@{
        fileCount = $targetSnapshot.FileCount
        sha256 = $targetSnapshot.ContentSha256
        backupPath = $backupPath
    }
}

function Invoke-ProjectDeployment {
    param(
        [Parameter(Mandatory = $true)][string]$ProjectName,
        [Parameter(Mandatory = $true)][string]$DeploymentScript,
        [Parameter(Mandatory = $true)][string]$RepositoryRoot,
        [Parameter(Mandatory = $true)][string]$PackagesDirectory,
        [Parameter(Mandatory = $true)][string]$RuntimeDirectory,
        [Parameter(Mandatory = $true)][string]$AgentName
    )

    if (-not (Test-Path -LiteralPath $DeploymentScript -PathType Leaf)) {
        throw "Project deployment script is missing: $DeploymentScript"
    }
    & $DeploymentScript -ProjectName $ProjectName -Mode PlanSkills -RepositoryRoot $RepositoryRoot -PackagesDirectoryName $PackagesDirectory -RuntimeDirectoryName $RuntimeDirectory -TargetAgent $AgentName
    & $DeploymentScript -ProjectName $ProjectName -Mode DeploySkills -RepositoryRoot $RepositoryRoot -PackagesDirectoryName $PackagesDirectory -RuntimeDirectoryName $RuntimeDirectory -TargetAgent $AgentName
    & $DeploymentScript -ProjectName $ProjectName -Mode VerifySkills -RepositoryRoot $RepositoryRoot -PackagesDirectoryName $PackagesDirectory -RuntimeDirectoryName $RuntimeDirectory -TargetAgent $AgentName
}

function Update-PlanChange {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)]$Plan,
        [Parameter(Mandatory = $true)]$Change
    )

    $Change.status = 'applied'
    $appliedAt = (Get-Date).ToString('o')
    if ($null -eq $Change.PSObject.Properties['appliedAt']) {
        $Change | Add-Member -MemberType NoteProperty -Name appliedAt -Value $appliedAt
    }
    else {
        $Change.appliedAt = $appliedAt
    }
    $Plan | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $Path -Encoding utf8
}

function Apply-PlanChange {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)]$Plan,
        [Parameter(Mandatory = $true)]$Change
    )

    if ($Change.status -ne 'requires-confirmation') {
        throw "Change is not executable or has already been applied: $($Change.id)"
    }
    switch ($Change.operation) {
        'sync-project-package' {
            $after = Copy-GovernedDirectory -Operation $Change.operation -SourcePath $Change.source.path -TargetPath $Change.target.path -ExpectedSourceHash $Change.expectedSourceSha256 -ExpectedTargetHash $Change.expectedTargetSha256 -CodexRootPath (Get-FullPath $CodexRoot) -GlobalRoot (Get-FullPath $GlobalSkillsPath)
            if ($after.ContentSha256 -ne $Change.newSha256) { throw "Project package update hash mismatch: $($Change.target.path)" }
        }
        'writeback-personal-library' {
            $after = Copy-GovernedDirectory -Operation $Change.operation -SourcePath $Change.source.path -TargetPath $Change.target.path -ExpectedSourceHash $Change.expectedSourceSha256 -ExpectedTargetHash $Change.expectedTargetSha256 -CodexRootPath (Get-FullPath $CodexRoot) -GlobalRoot (Get-FullPath $GlobalSkillsPath)
            if ($after.ContentSha256 -ne $Change.newSha256) { throw "Personal library update hash mismatch: $($Change.target.path)" }
        }
        'sync-global-runtime' {
            $after = Copy-GovernedDirectory -Operation $Change.operation -SourcePath $Change.source.path -TargetPath $Change.target.path -ExpectedSourceHash $Change.expectedSourceSha256 -ExpectedTargetHash $Change.expectedTargetSha256 -CodexRootPath (Get-FullPath $CodexRoot) -GlobalRoot (Get-FullPath $GlobalSkillsPath)
            if ($after.ContentSha256 -ne $Change.newSha256) { throw "Global runtime update hash mismatch: $($Change.target.path)" }
        }
        'deploy-project' {
            Invoke-ProjectDeployment -ProjectName $Change.syncProjectName -DeploymentScript $SyncScriptPath -RepositoryRoot $CodexRoot -PackagesDirectory $PackagesDirectoryName -RuntimeDirectory $RuntimeDirectoryName -AgentName $TargetAgent
        }
        'remove-project-skill' {
            $result = Remove-GovernedDirectory -Operation $Change.operation -TargetPath $Change.target.path -ExpectedTargetHash $Change.expectedTargetSha256 -CodexRootPath (Get-FullPath -Path $CodexRoot) -GlobalRoot (Get-FullPath -Path $GlobalSkillsPath)
            $Change | Add-Member -MemberType NoteProperty -Name backupPath -Value $result.backupPath -Force
        }
        'remove-global-skill' {
            $result = Remove-GovernedDirectory -Operation $Change.operation -TargetPath $Change.target.path -ExpectedTargetHash $Change.expectedTargetSha256 -CodexRootPath (Get-FullPath -Path $CodexRoot) -GlobalRoot (Get-FullPath -Path $GlobalSkillsPath)
            $Change | Add-Member -MemberType NoteProperty -Name backupPath -Value $result.backupPath -Force
        }
        'remove-personal-source' {
            $result = Remove-GovernedDirectory -Operation $Change.operation -TargetPath $Change.target.path -ExpectedTargetHash $Change.expectedTargetSha256 -CodexRootPath (Get-FullPath -Path $CodexRoot) -GlobalRoot (Get-FullPath -Path $GlobalSkillsPath)
            $Change | Add-Member -MemberType NoteProperty -Name backupPath -Value $result.backupPath -Force
        }
        default {
            throw "This ChangeId requires a manual action and cannot be applied by the governance script: $($Change.operation)"
        }
    }
    Update-PlanChange -Path $Path -Plan $Plan -Change $Change
    Write-Output "Applied $($Change.id): $($Change.operation) $($Change.assetType)/$($Change.assetName)"
}

function Write-AuditSummary {
    param($Report, [string]$ModeName)

    $summary = $Report.summary
    Write-Output "$ModeName complete. Skill clean=$($summary.skills.clean)/$($summary.skills.total); global clean=$($summary.globalSkills.clean)/$($summary.globalSkills.total); Plugin metadata clean=$($summary.plugins.clean)/$($summary.plugins.total); nonClean=$($summary.nonClean)."
    $items = @($Report.projects | ForEach-Object { $_.skills } | Where-Object { $_.status -ne 'clean' })
    foreach ($item in $items) {
        Write-Output "Skill drift: $($item.projectName)/$($item.assetName) status=$($item.status) personal=$($item.personalHash) package=$($item.packageHash) runtime=$($item.runtimeHash)"
    }
    foreach ($item in @($Report.globalSkills | Where-Object { $_.status -ne 'clean' })) {
        Write-Output "Global drift: $($item.assetName) status=$($item.status) personal=$($item.personalHash) global=$($item.globalHash)"
    }
    foreach ($item in @($Report.plugins | Where-Object { $_.status -ne 'clean-metadata' })) {
        Write-Output "Plugin action: $($item.assetName) status=$($item.status) verification=$($item.verification)"
    }
}

$SkillRoot = Get-ScriptRoot
if ([string]::IsNullOrWhiteSpace($ConfigPath)) {
    $ConfigPath = Join-Path $SkillRoot 'governance.config.json'
}
$GovernanceConfig = Read-GovernanceConfig -Path $ConfigPath

$CodexRoot = Resolve-GovernancePath -Value $CodexRoot -Default (Get-ConfigValue -Config $GovernanceConfig -Name 'repositoryRoot' -Default (Get-Location).Path) -BasePath $SkillRoot
$GlobalSkillsPath = Resolve-GovernancePath -Value $GlobalSkillsPath -Default (Get-ConfigValue -Config $GovernanceConfig -Name 'globalRuntimeSkillsPath' -Default (Join-Path $env:USERPROFILE '.codex\skills')) -BasePath $SkillRoot
$PluginCachePath = Resolve-GovernancePath -Value $PluginCachePath -Default (Get-ConfigValue -Config $GovernanceConfig -Name 'pluginCachePath' -Default (Join-Path $env:USERPROFILE '.codex\plugins\cache')) -BasePath $SkillRoot
$SyncScriptPath = Resolve-GovernancePath -Value $SyncScriptPath -Default (Get-ConfigValue -Config $GovernanceConfig -Name 'projectDeployScript' -Default 'scripts\Sync-CodexProjectPackage.ps1') -BasePath $SkillRoot

if ([string]::IsNullOrWhiteSpace($RuntimeDirectoryName)) {
    $RuntimeDirectoryName = [string](Get-ConfigValue -Config $GovernanceConfig -Name 'runtimeDirectoryName' -Default '.codex')
}
if ([string]::IsNullOrWhiteSpace($PersonalLibraryName)) {
    $PersonalLibraryName = [string](Get-ConfigValue -Config $GovernanceConfig -Name 'personalLibraryName' -Default 'LIU-Skill-repository')
}
if ([string]::IsNullOrWhiteSpace($PackagesDirectoryName)) {
    $PackagesDirectoryName = [string](Get-ConfigValue -Config $GovernanceConfig -Name 'packagesDirectoryName' -Default '项目包')
}
if ([string]::IsNullOrWhiteSpace($TargetAgent)) {
    $TargetAgent = [string](Get-ConfigValue -Config $GovernanceConfig -Name 'targetAgent' -Default 'Codex')
}

switch ($Mode) {
    'Audit' {
        $report = New-GovernanceReport -AssetFilter $AssetName
        if (-not [string]::IsNullOrWhiteSpace($OutputPath)) {
            $output = Get-FullPath -Path $OutputPath
            New-Item -ItemType Directory -Path (Split-Path -Parent $output) -Force | Out-Null
            $report | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $output -Encoding utf8
            Write-Output "Audit report: $output"
        }
        Write-AuditSummary -Report $report -ModeName 'Audit'
    }
    'Verify' {
        $report = New-GovernanceReport -AssetFilter $AssetName
        if (-not [string]::IsNullOrWhiteSpace($OutputPath)) {
            $output = Get-FullPath -Path $OutputPath
            New-Item -ItemType Directory -Path (Split-Path -Parent $output) -Force | Out-Null
            $report | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $output -Encoding utf8
            Write-Output "Verification report: $output"
        }
        Write-AuditSummary -Report $report -ModeName 'Verify'
    }
    'Plan' {
        if ([string]::IsNullOrWhiteSpace($OutputPath)) {
            throw 'Plan mode requires -OutputPath for the JSON plan.'
        }
        if ($DeletionScope -ne 'None') {
            $plan = New-DeletionPlan -AssetFilter $AssetName -Scope $DeletionScope -RequestedProjectName $ProjectName
        }
        else {
            $plan = New-GovernancePlan -AssetFilter $AssetName
        }
        $paths = Write-PlanFiles -Plan $plan -JsonPath $OutputPath
        Write-Output "Plan JSON: $($paths.jsonPath)"
        Write-Output "Plan Markdown: $($paths.markdownPath)"
        Write-Output "Changes: $(@($plan.changes).Count); conflicts/manual review: $(@($plan.conflicts).Count)"
    }
    'Apply' {
        if ([string]::IsNullOrWhiteSpace($PlanPath) -or [string]::IsNullOrWhiteSpace($ChangeId)) {
            throw 'Apply mode requires -PlanPath and -ChangeId.'
        }
        $planFile = Get-FullPath -Path $PlanPath
        if (-not (Test-Path -LiteralPath $planFile -PathType Leaf)) {
            throw "Plan file is missing: $planFile"
        }
        $plan = Get-Content -LiteralPath $planFile -Raw -Encoding utf8 | ConvertFrom-Json
        if ([string]$plan.codexRoot -ne (Get-FullPath -Path $CodexRoot)) {
            throw "Plan was generated for a different Codex root: $($plan.codexRoot)"
        }
        if ([string]$plan.globalSkillsPath -ne (Get-FullPath -Path $GlobalSkillsPath)) {
            throw "Plan was generated for a different global Skill root: $($plan.globalSkillsPath)"
        }
        $matches = @($plan.changes | Where-Object { $_.id -eq $ChangeId })
        if ($matches.Count -ne 1) {
            throw "Exactly one plan change must match ChangeId $ChangeId; found $($matches.Count)."
        }
        $selectedChange = $matches[0]
        foreach ($dependencyId in @($selectedChange.dependsOn)) {
            $dependency = $plan.changes | Where-Object { $_.id -eq $dependencyId } | Select-Object -First 1
            if ($null -eq $dependency -or $dependency.status -ne 'applied') {
                throw "Change $($selectedChange.id) requires $($dependencyId) to be applied first."
            }
        }
        Apply-PlanChange -Path $planFile -Plan $plan -Change $selectedChange
    }
}
