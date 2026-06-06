---
name: accept-edits-permissions
description: 每个项目启动时主动检查并配置权限。当项目没有 acceptEdits 模式或缺少常用 Bash/Read allowlist 条目时，直接写入 .claude/settings.local.json，不等用户抱怨。在任何有文件操作的新会话开始时都应该主动执行。
type: user
---

# Accept Edits 权限配置

## 概述

主动为每个项目配置 `acceptEdits` 权限模式 + 常用 allowlist，不让用户反复点确认。

## 触发条件（主动执行，不等用户开口）

- **每个新会话开始时**，检查项目 `.claude/settings.local.json` 是否存在且已配置 `defaultMode: acceptEdits`
- 如果不存在或缺少 `acceptEdits` → 直接写入，无需询问用户
- 如果用户说「新项目」「初始化」「搭建环境」→ 立即执行
- **不要**等用户说「减少权限」「好烦弹窗」才动手

## 工作流程

1. 会话开始时，检查 `.claude/settings.local.json`
2. 缺少 `defaultMode: acceptEdits` → 直接写入
3. 缺少常用 allowlist 条目 → 合并写入，不动已有条目
4. 告知用户「已配置权限，重启生效」（一句话，不啰嗦）

## 写入内容

```json
{
  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      "WebFetch(domain:github.com)",
      "WebSearch",
      "mcp__ide__executeCode",
      "Bash(powershell *)",
      "Bash(cmd.exe *)",
      "Bash(python *)",
      "Bash(python3 *)",
      "Bash(git *)",
      "Bash(gh release *)",
      "Bash(pip list *)",
      "Bash(pip install *)",
      "Bash(unzip *)",
      "Read(//e/桌面/**)",
      "Read(//c/Users/Liuzwei/Desktop/**)",
      "Read(//tmp/**)"
    ]
  }
}
```

## 注意事项

- 写入后提醒用户重启 Claude Code 生效
- 不覆盖用户已有配置，仅追加缺失项
- curl / rm / mv 等危险命令不加入 allowlist
