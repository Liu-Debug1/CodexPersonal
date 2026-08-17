# LIU Skill Repository

`LIU-Skill-repository` 是 Codex 已认可扩展资产的个人源库，保存可复用的 Skill、Plugin、MCP、Hook 和 CLI 工具源码、说明及配置模板。

## 资产边界

- 候选资产先进入上级目录的 `Skill待测库/`，完成审计和真实场景试用后才可进入本库。
- 本库只保存已认可的源资产，不保存任何项目 `.codex/skills/` 运行副本。
- 项目使用的资产由 `D:\桌面\Codex\项目包\<项目名>\` 管理；该项目包才是项目运行副本的唯一可编辑来源。
- 不使用符号链接、目录联接或硬链接把本库暴露为任何运行入口。

## 文档入口

| 文件 | 用途 |
| --- | --- |
| `Skill分类索引.md` | 已认可资产的分类、路径、用途和维护规则 |
| `README.md` | 本库定位、资产边界和使用流程 |

## 已认可的通用规范

- `obsidian-skills/obsidian/` 是已认可的通用 Obsidian 笔记整理规范，覆盖标题层级保护、按需编号、图片、公式、列表、表格、Callout、代码块、ASCII 框图和重复笔记合并。
- 项目包可选用该 Skill 的完整副本；Vault 专属的附件目录、Git 和部署约束继续由目标项目的 `AGENTS.md` 定义。
- `写作与表达/文本润色/prompt-optimizer/` 是已认可的通用 Codex 提示词优化规范，将模糊需求整理成具备目标、范围、约束、验收和验证要求的可执行提示词；默认只优化，不替代用户授权直接执行。
- `代码与开发/工程流程/mattpocock-skills/` 是 `mattpocock/skills` 的正式来源包，按上游 Plugin Manifest 保存 22 个稳定工程与生产力 Skill 的完整副本；其用于后续项目选用，不是 Codex 或 Claude 的运行目录。
- `代码与开发/工程流程/addyosmani-agent-skills/` 是 `addyosmani/agent-skills` 的正式来源包，固定上游 `df1edb2`（v0.6.7），保留 24 个工程流程 Skill、共享 references、插件元数据和上游校验资产；项目使用时按需选择，不直接把整包当作项目运行目录。
- `学习与研究/leetcode-review/` 是已认可的 LeetCode C++ 复盘规范：完整复盘同步源码、看板、刷题记录和 Anki；代码推理型知识卡必须同时给出真实源码位置与最小相关 C++ 片段，避免要求复习者先凭记忆还原整段代码。

## 使用流程

1. 在 `Skill待测库/` 审计和试用候选资产。
2. 将已认可资产复制到本库的对应分类，并同步更新 `Skill分类索引.md`。
3. 为实际项目创建或更新 `项目包/<项目名>/`，选择需要的资产。
4. 通过 `scripts/Sync-CodexProjectPackage.ps1` 将项目包中的 Skill 完整部署到项目 `.codex/skills/`。

Plugin、MCP、CLI 的源资产也可收藏于本库，但它们必须按 Codex 的实际安装或配置方式部署，不能视为可直接复制的项目 Skill。
