# LIU Skill Repository

Claude Code 个人收藏库，存放 Skill、MCP、CLI 工具、插件的本地源。

## 目录结构

```
├── 代码与开发/          # 开发工作流 skill（code-review、vision、find-skills 等）
├── 文档处理/            # 文档格式 skill（docx、pdf、pptx、xlsx、paper-2-web 等）
├── 图片与视觉/          # 视觉/设计 skill（drawio、frontend-design、manimgl 等）
├── 信息搜取/            # 信息获取 skill（defuddle、notebooklm、browser 等）
├── Obsidian-skill/      # Obsidian 笔记专用 skill
├── CLI工具/             # CLI 工具配置（opencli、paper-scraper）
├── Pluging插件/         # Claude Code 插件（clangd-lsp、claude-md-management、superpowers）
├── MCP/                 # MCP 服务配置
├── scripts/             # 辅助脚本
│
├── bjarne-stroustrup-perspective/   # C++ 视角 skill
├── scott-meyers-perspective/        # C++ 视角 skill
├── huashu-nuwa/                     # 多智能体协作框架
├── obsidian-contentList/            # Obsidian 内容列表
├── skill-vetter/                    # Skill 质量审查
└── 学习秘书团/                      # 学习辅助 skill（出题、批改、复盘）
```

## 部署路径

| 级别 | 路径 | 用途 |
|------|------|------|
| 全局 | `C:\Users\Liuzwei\.claude\skills\` | 所有项目可用 |
| Vault 级 | `E:\桌面\Ob_Learning\.claude\skills\` | Obsidian 专用 |

## 同步规则

- 新增/修改 skill 后同步到全局库 + 本仓库
- 同名 skill 已存在则跳过覆盖
- 变更通过 `ClaudeCode-Extension` 仓库推送到 GitHub
