# Codex 项目包

## 项目信息

- 项目绝对路径：`D:\桌面\Codex`
- Codex 运行目录：`D:\桌面\Codex\.codex\skills`
- 项目包 Skill 来源：`D:\桌面\Codex\项目包\Codex\skills`

## 受管资产

<!-- ASSETS:START -->
| 类型 | 资产 |
| --- | --- |
| Skill (1) | find-skills |
| Plugin | 无 |
| MCP | 无 |
| CLI | 无 |
| 内容 SHA-256 | 6f3f9f7dd48dd2c017bcd9f202d51d09580ca15124860a56024bf51bc86074c0 |
| 文件数量 | 2 |
| Skill 最后更新 | 2026-08-30 |
<!-- ASSETS:END -->

## 部署与验证

```powershell
& 'D:\桌面\Codex\LIU-Skill-repository\技能管理\创建与同步\codex-skill-governance\scripts\Sync-CodexProjectPackage.ps1' -ProjectName Codex -Mode PlanSkills
& 'D:\桌面\Codex\LIU-Skill-repository\技能管理\创建与同步\codex-skill-governance\scripts\Sync-CodexProjectPackage.ps1' -ProjectName Codex -Mode DeploySkills
& 'D:\桌面\Codex\LIU-Skill-repository\技能管理\创建与同步\codex-skill-governance\scripts\Sync-CodexProjectPackage.ps1' -ProjectName Codex -Mode VerifySkills
```

