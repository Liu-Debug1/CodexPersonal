---
name: skill-sync-repo
description: Sync skills to the user's personal skill repository. Use when the user asks to sync a skill, backup skills, copy a skill to their repository, or says 同步skill/备份skill/添加到仓库/存到skill库. Also use proactively after creating or modifying any skill — ask the user if they want to sync.
---

# Skill 同步到个人仓库

将 Claude Code 技能同步到个人 Skill 仓库，便于备份、版本管理和跨项目复用。

## 仓库路径

```
源目录: C:\Users\Liuzwei\.claude\skills\<skill-name>\
目标仓库: D:\桌面\ClaudeCode\LIU-Skill-repository\
```

## 同步规则

1. 从源目录复制整个 skill 文件夹到目标仓库根目录
2. 如果目标已存在同名文件夹，跳过该 skill 并提示"已存在"
3. 不创建分类子目录（用户自行分类整理）
4. 同步完成后列出被同步的 skill 名称和目标路径

## skill 修改后的三方检查

在别处（其他项目、外部目录）修改了某 skill 后，执行以下检查：

1. **检查个人库** — `D:\桌面\ClaudeCode\LIU-Skill-repository\<skill-name>\` 是否存在
2. **检查全局库** — `C:\Users\Liuzwei\.claude\skills\<skill-name>\` 是否存在
3. 对每个找到的同名 skill，询问用户："**\<skill-name\> 在 \<路径\> 也有副本，是否需要同步更新？**"
4. 用户确认后才执行复制，绝不自动覆盖

## 执行命令

单 skill 同步：

```powershell
if (Test-Path "D:\桌面\ClaudeCode\LIU-Skill-repository\<skill-name>") { Write-Host "<skill-name> 已存在，跳过" } else { Copy-Item -Recurse "C:\Users\Liuzwei\.claude\skills\<skill-name>" "D:\桌面\ClaudeCode\LIU-Skill-repository\<skill-name>\" }
```

全部 skill 同步：

```powershell
Get-ChildItem "C:\Users\Liuzwei\.claude\skills" -Directory | ForEach-Object {
    if (Test-Path "D:\桌面\ClaudeCode\LIU-Skill-repository\$($_.Name)") { Write-Host "$($_.Name) 已存在，跳过" } else { Copy-Item -Recurse $_.FullName "D:\桌面\ClaudeCode\LIU-Skill-repository\$($_.Name)\" }
}
```

## 操作流程

1. 确认要同步的 skill 名称（单个或全部）
2. 检查源目录中 skill 是否存在
3. 执行复制（已存在则跳过）
4. 列出同步结果

## 注意事项

- 已存在的同名 skill 自动跳过，不会覆盖。如需更新请先手动删除目标中的旧版本
- 源路径不在 C 盘时需相应调整——默认从全局 skills 目录同步，如果 skill 位于项目的 `.claude\skills\` 下，则从对应路径复制
