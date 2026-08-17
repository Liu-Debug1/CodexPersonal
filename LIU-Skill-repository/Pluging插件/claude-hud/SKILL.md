---
name: claude-hud
description: 实时状态栏 HUD 插件（[jarrodwatts/claude-hud](https://github.com/jarrodwatts/claude-hud)）。显示上下文使用率、工具活动、Agent 追踪、Todo 进度、Git 状态，支持中文。
type: plugin
---

# Claude HUD

> 这是一个 **Claude Code 插件**（非 skill），安装位置：`C:\Users\Liuzwei\.claude\plugins\cache\claude-hud\`

## 安装方式

```
/plugin marketplace add jarrodwatts/claude-hud
/plugin install claude-hud
/claude-hud:setup
```

## 配置

- 配置文件：`~/.claude/plugins/claude-hud/config.json`
- 交互式配置：`/claude-hud:configure`
- 语言：中文 (`"language": "zh"`)
- 当前预设：`expanded` + 工具/Agent/Todo 全部启用

## 功能

| 功能 | 说明 |
|------|------|
| 上下文监控 | 绿色→黄色→红色进度条 |
| Git 状态 | 分支、脏标记、领先/落后 |
| 工具活动 | 实时显示在读/写/搜索的文件 |
| Agent 追踪 | 后台 Agent 状态 |
| Todo 进度 | 任务完成情况 |
