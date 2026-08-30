# Codex Global Skill 项目包

## 项目信息

- 全局 Codex 根目录：`C:\Users\Liuzwei\.codex`
- 全局 Skill 运行目录：`C:\Users\Liuzwei\.codex\skills`
- 项目包 Skill 来源：`D:\桌面\Codex\项目包\CodexGlobal\skills`
- 部署范围：只管理 manifest 登记的直接子目录；`.system` 和未登记的全局 Skill 保持不变。

## 受管资产

<!-- ASSETS:START -->
| 类型 | 资产 |
| --- | --- |
| Skill (5) | codex-skill-governance、disk-cleaner-skills、prompt-optimizer、source-code-explainer、vibehub |
| Plugin | 无 |
| MCP | 无 |
| CLI | 无 |
| 内容 SHA-256 | d580529be108b63715cbf787bb0aa7b0d58990701db1de315553f5a80c67a898 |
| 文件数量 | 52 |
| Skill 最后更新 | 2026-08-30 |
<!-- ASSETS:END -->

## 部署与验证

```powershell
& 'D:\桌面\Codex\LIU-Skill-repository\技能管理\创建与同步\codex-skill-governance\scripts\Sync-CodexProjectPackage.ps1' -ProjectName CodexGlobal -Mode PlanSkills
& 'D:\桌面\Codex\LIU-Skill-repository\技能管理\创建与同步\codex-skill-governance\scripts\Sync-CodexProjectPackage.ps1' -ProjectName CodexGlobal -Mode DeploySkills
& 'D:\桌面\Codex\LIU-Skill-repository\技能管理\创建与同步\codex-skill-governance\scripts\Sync-CodexProjectPackage.ps1' -ProjectName CodexGlobal -Mode VerifySkills
```






