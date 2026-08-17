# Source Record

## Upstream

- Repository: https://github.com/addyosmani/agent-skills
- Maintainer: Addy Osmani
- Pinned commit: `df1edb2e05487d0aa6d93c747141e0aed1187f25`
- Upstream version: `0.6.7`
- License: MIT (`LICENSE`)
- Imported: 2026-08-17

## Contents

This source package preserves the upstream repository layout, including:

- 24 reusable skills under `skills/`
- shared checklists under `references/`
- Codex plugin metadata under `.codex-plugin/`
- upstream validation scripts and evaluation fixtures
- upstream documentation and license files

The repository also contains integrations for Claude Code and other agents. Those files are retained here for source fidelity, but they are not copied into a Codex project's `.codex/skills/` directory.

## Validation

Validated against the pinned checkout before import:

- `scripts/validate-skills.js`: 24 skills, 0 errors, 0 warnings
- `scripts/validate-reference-links.js`: passed
- `scripts/validate-commands.js`: passed
- `.codex-plugin/plugin.json`: present and declares `./skills/`

## Deployment boundary

This directory is the reusable personal source package. It is not a project runtime directory. When a project needs these skills, create a project package containing the selected skill directories (and any required shared references), register it in that project's `manifest.json`, then deploy through `Sync-CodexProjectPackage.ps1` and verify SHA-256 results.

Do not deploy the upstream Claude-specific hooks, commands, or agent files as Codex runtime configuration.
