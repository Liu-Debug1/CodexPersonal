# Codex 项目包

项目包是各项目 Codex 扩展的可编辑来源。普通项目的 `.codex/skills/` 是由项目包完整部署的运行副本；`CodexGlobal` 以 manifest 的 `targetSkillsPath` 管理全局 Codex Skill 子目录。

<!-- PROJECTS:START -->
| 项目 | 项目绝对路径 | 项目包路径 | Skill | Plugin | MCP | CLI | Skill 最后更新 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Codex | D:\桌面\Codex | D:\桌面\Codex\项目包\Codex | find-skills | 无 | 无 | 无 | 2026-08-30 |
| CodexGlobal | C:\Users\Liuzwei\.codex | D:\桌面\Codex\项目包\CodexGlobal | codex-skill-governance、disk-cleaner-skills、prompt-optimizer、source-code-explainer、vibehub | 无 | 无 | 无 | 2026-08-30 |
| Ob_Learning | D:\桌面\Ob_Learning | D:\桌面\Codex\项目包\Ob_Learning | 学习秘书团、code-review-cpp、defuddle、disk-cleaner、dispatching-parallel-agents、docx、english-article-review、find-skills、frontend-design、grill-me、grilling、handoff、json-canvas、karpathy-guidelines、leetcode-review、obsidian、obsidian-bases、obsidian-cli、obsidian-markdown、pdf-translate、planning-with-files、pptx、setup-codex、skill-creator、skill-vetter、wechat-article-to-obsidian、xlsx | 无 | 无 | 无 | 2026-08-30 |
<!-- PROJECTS:END -->

## 统一流程

1. 在 `项目包/<项目名>/skills/` 修改项目 Skill。
2. 运行 `codex-skill-governance/scripts/Sync-CodexProjectPackage.ps1 -ProjectName <项目名> -Mode PlanSkills`。
3. 预检通过后运行 `DeploySkills`；默认替换项目 `.codex/skills/`，`CodexGlobal` 仅替换 manifest 登记的子目录。
4. 运行 `VerifySkills`，并确认本总览中的更新时间已刷新。

