# Codex 项目包

项目包是各项目 Codex 扩展的可编辑来源。项目内 `.codex/skills/` 只作为由项目包完整部署的运行副本。

<!-- PROJECTS:START -->
| 项目 | 项目绝对路径 | 项目包路径 | Skill | Plugin | MCP | CLI | Skill 最后更新 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Codex | D:\桌面\Codex | D:\桌面\Codex\项目包\Codex | find-skills | 无 | 无 | 无 | 2026-08-03 |
| Ob_Learning | D:\桌面\Ob_Learning | D:\桌面\Codex\项目包\Ob_Learning | 学习秘书团、code-review-cpp、defuddle、disk-cleaner、dispatching-parallel-agents、docx、find-skills、frontend-design、grill-me、grilling、handoff、json-canvas、karpathy-guidelines、leetcode-review、mubu-diet-recorder、obsidian、obsidian-bases、obsidian-cli、obsidian-markdown、pdf-translate、planning-with-files、pptx、setup-codex、skill-creator、skill-sync-repo、skill-vetter、wechat-article-to-obsidian、xlsx | 无 | 无 | 无 | 2026-08-16 |
<!-- PROJECTS:END -->

## 统一流程

1. 在 `项目包/<项目名>/skills/` 修改项目 Skill。
2. 运行 `Sync-CodexProjectPackage.ps1 -ProjectName <项目名> -Mode PlanSkills`。
3. 预检通过后运行 `DeploySkills`，仅替换目标项目的 `.codex/skills/`。
4. 运行 `VerifySkills`，并确认本总览中的更新时间已刷新。









