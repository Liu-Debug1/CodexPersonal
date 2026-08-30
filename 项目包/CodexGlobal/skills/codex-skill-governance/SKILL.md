---
name: codex-skill-governance
description: Govern Skills and Plugins across a personal repository, agent global runtime, project packages, and project runtimes. Use when the user asks to check skill drift, sync skills, update the personal Skill repository, propagate a Skill update to projects, write project changes back to the personal repository, audit manifests and SHA-256 hashes, or manage Plugin registration and drift. The bundled PowerShell script is agent-agnostic and reads paths from governance.config.json.
compatibility: Windows PowerShell 5.1 or later. Read-only by default; Apply mode requires a generated plan and an explicit ChangeId.
---

# Agent Skill Governance

Use this Skill to keep Codex extension assets aligned without turning project runtimes into editable sources. The governing model is:

1. `D:\桌面\Codex\LIU-Skill-repository\` stores approved personal source assets.
2. `D:\桌面\Codex\项目包\<project>\skills\` stores the deployable source for that project.
3. `<project>\.codex\skills\` is only a deployed runtime copy.
4. `C:\Users\Liuzwei\.codex\skills\` is managed through the `CodexGlobal` project package, which replaces only manifest-registered direct Skill subdirectories and preserves `.system`.
5. Plugin caches are managed by their installation mechanism, never by direct copy.

The Skill is named `codex-skill-governance` for compatibility with the existing Codex installation, but its implementation is not Codex-specific. Copy the whole Skill directory to another Agent, edit `governance.config.json`, and keep the bundled `scripts/codex-skill-governance.ps1` with `SKILL.md`.

The core problem this Skill prevents is configuration drift: multiple copies of the same asset changing independently until it is unclear which copy is authoritative. Hashes and manifest records make the comparison deterministic.

## Trigger

Use this Skill for requests such as:

- “检查 skill 有没有漂移”
- “把个人库的 skill 同步到项目”
- “把这个项目里的 skill 更新回个人库”
- “统一更新所有用了这个 skill 的项目”
- “核对项目包 manifest 和运行目录哈希”
- “检查 Plugin 版本或登记状态”

Do not use this Skill for creating a new Skill from scratch; use `skill-creator` for that. Do not use the retired legacy Claude Code synchronization Skill for this repository: it does not understand project packages or manifests.

## Non-Negotiable Safety Rules

- Never edit a project `.codex\skills\` directory directly.
- Never delete or overwrite a personal source, project package, global runtime, or Plugin cache without a plan and an explicitly selected ChangeId.
- Never merge three-way differences automatically.
- Never report success without a post-action hash verification.
- Never use symlinks, junctions, or hard links as the synchronization mechanism.
- Treat Plugin caches as installation-managed state. This Skill may read metadata and generate an installation plan, but it must not copy, delete, or rename cache directories.

## Commands

Use the personal-library copy as the authoritative command entry point:

```powershell
$script = 'D:\桌面\Codex\LIU-Skill-repository\技能管理\创建与同步\codex-skill-governance\scripts\codex-skill-governance.ps1'
```

The global runtime copy is an installation target, not an editable source. Use it only when the personal-library copy is unavailable.

Read-only audit:

```powershell
& $script -Mode Audit
```

Generate a JSON and Markdown plan without modifying assets:

```powershell
& $script -Mode Plan -AssetName obsidian -OutputPath "$env:TEMP\obsidian-governance-plan.json"
```

Generate a deletion plan without modifying assets:

```powershell
# Delete from one project package and runtime only; retain the personal source.
& $script -Mode Plan -AssetName old-skill -ProjectName Ob_Learning -DeletionScope Project -OutputPath "$env:TEMP\old-skill-project-delete.json"

# Delete the personal source and every registered project/global copy.
& $script -Mode Plan -AssetName old-skill -DeletionScope Personal -OutputPath "$env:TEMP\old-skill-personal-delete.json"
```

Apply exactly one confirmed change:

```powershell
& $script -Mode Apply -PlanPath "$env:TEMP\obsidian-governance-plan.json" -ChangeId C001
```

Re-check the current state:

```powershell
& $script -Mode Verify
```

Optional parameters:

- `-AssetName`: target one Skill by name.
- `-ProjectName`: target one registered project; required for `DeletionScope Project`.
- `-DeletionScope`: `Project` removes the Skill from one project package and runtime; `Personal` removes the personal source, every registered project copy, and the global runtime copy.
- `-CodexRoot`: override the repository root for isolated tests.
- `-GlobalSkillsPath`: override the global Skill runtime path.
- `-RuntimeDirectoryName`: override `.codex` for another Agent runtime directory.
- `-PersonalLibraryName`: override `LIU-Skill-repository`.
- `-PackagesDirectoryName`: override `项目包`.
- `-PluginCachePath`: override the Plugin cache path.
- `-IncludeFixtures`: include manifests marked `isTestFixture: true`.
- `-SyncScriptPath`: override the project deployment script path.

## Portability

`governance.config.json` is the single place to adapt this Skill to another Agent:

- `repositoryRoot`: management repository root.
- `personalLibraryName`: personal source library directory name.
- `packagesDirectoryName`: project-package directory name.
- `runtimeDirectoryName`: runtime directory under each project, such as `.codex`, `.claude`, or another Agent directory.
- `globalRuntimeSkillsPath`: the Agent's global Skills directory.
- `pluginCachePath`: the Agent's Plugin cache, when applicable.
- `projectDeployScript`: guarded deployment script for project runtimes.

Keep relative paths in this file relative to the Skill root. All path parameters can still be overridden on the command line for isolated tests.

## Standard Workflow

1. Run `Audit` and read only the summary and affected records. Do not load whole Skill files into context.
2. Run `Plan` for a specific asset when possible. The generated files contain change IDs, source and target hashes, operation, reason, risk, and post-actions.
3. Present the plan to the user. A plan is not approval.
4. Apply one ChangeId at a time. Copy operations verify the expected source and target hashes before writing and verify the new target hash after writing.
5. Project runtime changes must go through `Sync-CodexProjectPackage.ps1` in this order: `PlanSkills`, `DeploySkills`, `VerifySkills`.
6. Run `Verify` after the requested changes and report clean items, remaining drift, conflicts, and Plugin actions that still require the Plugin installer. For global Codex Skills, use `CodexGlobal` rather than manually copying the global runtime.

For deletion plans, apply changes in dependency order. A project deletion is `remove-project-skill`, then `deploy-project`. A personal deletion removes each registered project copy first, removes the global runtime copy, and only then removes the personal source. The script enforces these dependencies by ChangeId.

## Drift Decisions

For each registered project Skill, compare the personal source, project package, project runtime, and manifest baseline hash:

- All three content hashes match: `clean`.
- Personal source differs while package and runtime match the manifest baseline: project package update is proposed.
- Package differs while personal source and manifest match: package is selected as the write-back candidate; personal-library overwrite still needs confirmation.
- Runtime differs while package and personal source match: project deployment is proposed to recover the runtime copy.
- All three differ, or the personal library has multiple same-name paths: `conflict` or `ambiguous`; do not overwrite automatically.
- Personal source and global runtime differ: generate a separate global-runtime update change.

The script intentionally uses the manifest hash as the last-known baseline. If a manifest has no usable baseline, the result is a manual review rather than a guessed direction.

## Plugin Handling

Plugin records should contain the plugin name, source path, plugin metadata path, version, source directory hash, installation reference, and the installed-version verification result. The governance script reads Plugin metadata and the Codex cache for comparison, but does not copy or delete cache directories. When the source and installed metadata differ, it emits a `plugin-install-plan` change that must be executed through the Plugin's supported installer.

## Completion Checklist

- The plan was generated from the current filesystem state.
- Every applied change had an explicit ChangeId.
- The source hash and expected target hash matched before a copy.
- The target hash matched the planned new hash after the copy.
- Project deployments passed `PlanSkills`, `DeploySkills`, and `VerifySkills`.
- No `.codex\agents`, project configuration, Plugin cache, or business file was changed by this Skill.
- Remaining conflicts and manual Plugin actions are reported instead of being hidden.
