# Skill 分类索引

本索引用于维护已认可的个人扩展源库 `D:\桌面\Codex\LIU-Skill-repository\`。Skill、Plugin、MCP、Hook 和 CLI 工具的源资产保存在这里；待测资产位于上级 `Skill待测库\`，项目运行副本由上级 `项目包\<项目名>\` 管理。

> 最后核对：2026-08-17。普通 Skill 以本库中包含 `SKILL.md` 的目录为准；项目 `.codex/skills/` 运行副本不计入本索引。来源包内部的示例 Skill 与插件内置 Skill 仅在相应说明中汇总。部署时必须完整复制，不得使用符号链接、目录联接或硬链接。

## 分类规则

| 一级目录 | 二级目录 | 放置内容 |
| --- | --- | --- |
| `技能管理/` | `发现与审计/`、`创建与同步/` | 查找、审计、创建、同步、安装前检查 skill |
| `代码与开发/` | `代码审查/`、`编码规范/`、`工程流程/`、`源码讲解/` | 编程、代码质量、工程流程、源码学习与开发辅助 |
| `obsidian-skills/` | 按 skill 独立目录 | Obsidian 笔记、Bases、Canvas、Markdown、OCR 整理 |
| `文档处理/` | `Office文档/`、`PDF处理/`、`知识转网页/`、`weekly-learning-report-pdf/` | 文档输入输出、翻译、排版、学习汇报合并与格式转换 |
| `写作与表达/` | `文本润色/`、`人物视角/` | humanizer、人物视角、话术蒸馏、表达风格 |
| `图片与视觉/` | `图像生成/`、`图像识别/`、`图表绘制/`、`界面设计/`、`动画视频/` | 视觉资产、图表、前端视觉、动画和视频 |
| `信息搜取/` | `网页抽取/`、`浏览器自动化/`、`视频字幕/`、`资料库问答/` | 网页抽取、浏览器操作、视频字幕提取、资料库查询 |
| `学习与研究/` | 按 skill 独立目录 | 学习秘书、批改、复盘、出题、研究辅助 |
| `生活记录/` | 按 skill 独立目录 | 饮食、习惯等日常记录辅助 |
| `系统工具/` | 按 skill 独立目录 | 磁盘清理、系统维护、本机环境工具 |
| `Pluging插件/` | 按插件原始结构 | Codex 插件源资产及插件内置 skill，不拆散 |
| `MCP/` | 按 MCP 独立目录 | MCP 配置或服务资产，不装进 skill 全局目录 |
| `钩子/` | 按 Hook 独立目录 | Hook 脚本、配置模板和说明；不得跨 agent 共用运行配置 |
| `CLI工具/` | 按 CLI 独立目录 | CLI 工具源码或脚本，不装进 skill 全局目录 |
| `scripts/` | 维护脚本 | 仓库维护脚本，不是 skill |

## 当前分类

### 技能管理

| Skill | 路径 | 用途 |
| --- | --- | --- |
| `find-skills` | `技能管理/发现与审计/find-skills/` | 查找、发现、推荐可安装 skill |
| `skill-vetter` | `技能管理/发现与审计/skill-vetter/` | 安装前安全审计外部 skill |
| `skill-creator` | `技能管理/创建与同步/skill-creator/` | 创建、修改、评测 skill |
| `skill-sync-repo` | `技能管理/创建与同步/skill-sync-repo/` | 同步 Skill 到个人库；部署时遵循分类索引和完整复制规则 |
| `setup-codex` | `技能管理/创建与同步/setup-codex/` | Codex 初始化与工作方式配置 |
| `writing-great-skills` | `技能管理/创建与同步/writing-great-skills/` | 编写和维护高质量 skill 的原则与参考 |

### 代码与开发

| Skill | 路径 | 用途 |
| --- | --- | --- |
| `code-review-cpp` | `代码与开发/代码审查/code-review-cpp/` | 按用户 C/C++ 嵌入式代码规范审查代码 |
| `karpathy-guidelines` | `代码与开发/编码规范/karpathy-guidelines/` | 降低 LLM 编码常见错误，强调简洁和小改动 |
| `karpathy-guidelines` 来源包 | `代码与开发/编码规范/andrej-karpathy-skills/` | Karpathy 编码规范来源包，内部含同名 skill |
| `planning-with-files` | `代码与开发/工程流程/planning-with-files/` | 文件化计划和进度跟踪 |
| `grill-me` | `代码与开发/工程流程/grill-me/` | 通过严格追问检验方案或设计 |
| `grilling` | `代码与开发/工程流程/grilling/` | 针对计划或设计进行多轮质询 |
| `handoff` | `代码与开发/工程流程/handoff/` | 记录并交接跨会话或跨人员的工作上下文 |
| `source-code-explainer` | `代码与开发/源码讲解/source-code-explainer/` | 面向 C/C++、ROS、嵌入式等真实源码与工程原理的讲解 |
| `mattpocock-skills` 正式来源包 | `代码与开发/工程流程/mattpocock-skills/` | 按上游 Plugin Manifest 收录 22 个正式工程与生产力 Skill；来源提交 `9603c1c`，MIT；不覆盖本库既有同名 Skill |
| `addyosmani-agent-skills` 正式来源包 | `代码与开发/工程流程/addyosmani-agent-skills/` | 按上游仓库完整收录 24 个工程流程 Skill、references、Codex 插件元数据和校验资产；来源提交 `df1edb2`，v0.6.7，MIT；项目按需选取，不直接部署 Claude 专用 Hook/命令/agent |

### Obsidian

| Skill | 路径 | 用途 |
| --- | --- | --- |
| `obsidian` | `obsidian-skills/obsidian/` | 已认可的通用 Obsidian 整理规范：保护标题层级，按需统一编号，并规范图片、公式、列表、表格、Callout、代码块、ASCII 框图和重复笔记合并 |
| `obsidian-cli` | `obsidian-skills/obsidian-cli/` | 通过 Obsidian CLI 读写、搜索、管理笔记 |
| `obsidian-markdown` | `obsidian-skills/obsidian-markdown/` | Obsidian Flavored Markdown 语法 |
| `wechat-article-to-obsidian` | `obsidian-skills/wechat-article-to-obsidian/` | 通过 Edge Obsidian Web Clipper 完整剪藏微信公众号文章，并按要求做最小 Markdown 排版 |
| `obsidian-bases` | `obsidian-skills/obsidian-bases/` | Obsidian Bases 表格、卡片、公式、过滤 |
| `json-canvas` | `obsidian-skills/json-canvas/` | `.canvas` 文件、节点和连线 |

### 文档处理

| Skill | 路径 | 用途 |
| --- | --- | --- |
| `docx` | `文档处理/Office文档/docx/` | Word 文档创建、编辑、批注、修订 |
| `pptx` | `文档处理/Office文档/anthropics-skills-pptx/` | PPTX 读写和生成 |
| `xlsx` | `文档处理/Office文档/xlsx/` | 表格创建、分析、公式和图表 |
| `pdf` | `文档处理/PDF处理/pdf/` | PDF 提取、合并、拆分、表单等 |
| `pdf-translate` | `文档处理/PDF处理/openclaw-skills-pdf-translate/` | PDF 翻译为中文 Markdown/PDF |
| `weekly-learning-report-pdf` | `文档处理/weekly-learning-report-pdf/` | 合并周学习汇报 DOCX 与学习笔记 PDF，并完成结构和渲染验证 |
| `knowledge-2-web` | `文档处理/知识转网页/knowledge-2-web/` | 知识文章转交互式网页 |
| `paper-2-web` | `文档处理/知识转网页/paper-2-web/` | 学术论文转网页、视频、海报等展示形态 |

### 写作与表达

| Skill | 路径 | 用途 |
| --- | --- | --- |
| `prompt-optimizer` | `写作与表达/文本润色/prompt-optimizer/` | 将模糊需求或原始提示词整理为可执行的 Codex 提示词，补齐范围、约束、验收和验证要求 |

### 图片与视觉

| Skill | 路径 | 用途 |
| --- | --- | --- |
| `article-illustration-generator` | `图片与视觉/图像生成/article-illustration-generator/` | 文章插图生成 |
| `vision` | `图片与视觉/图像识别/vision/` | 外部来源视觉识图资产，当前未部署到 Codex |
| `baoyu-infographic` | `图片与视觉/图表绘制/baoyu-infographic/` | 基于多种版式和视觉风格生成专业信息图 |
| `drawio-skill` | `图片与视觉/图表绘制/drawio-skill/` | 生成 draw.io 流程图、架构图、可视化图 |
| `frontend-design` | `图片与视觉/界面设计/frontend-design/` | 高质量前端界面设计 |
| `manimgl-best-practices` | `图片与视觉/动画视频/manimgl-best-practices/` | ManimGL 最佳实践 |
| `remotion` | `图片与视觉/动画视频/remotion/` | Remotion 视频与动画制作 |

### 信息搜取

| Skill | 路径 | 用途 |
| --- | --- | --- |
| `defuddle` | `信息搜取/网页抽取/defuddle/` | 网页正文抽取为干净 Markdown |
| `agent-browser` | `信息搜取/浏览器自动化/vercel-labs-agent-browser-agent-browser/` | 浏览器自动化、网页交互、截图和抓取 |
| `bilibili-subtitle` | `信息搜取/视频字幕/bilibili-subtitle/` | 提取 Bilibili 视频已有字幕并输出转录文本或 SRT/VTT |
| `notebooklm` | `信息搜取/资料库问答/notebooklm/` | 通过 NotebookLM 查询资料库 |

### 学习与研究

| Skill | 路径 | 用途 |
| --- | --- | --- |
| `学习秘书团` | `学习与研究/学习秘书团/` | 批改、复盘、出题等学习辅助流程 |
| `leetcode-review` | `学习与研究/leetcode-review/` | 复盘 Ob_Learning 中的 LeetCode C++ 题解，维护看板、刷题记录与 Anki；代码推理卡附源码上下文 |
| `teach` | `学习与研究/teach/` | 面向多会话学习目标的课程与学习记录工作流 |

### 生活记录

| Skill | 路径 | 用途 |
| --- | --- | --- |
| `mubu-diet-recorder` | `生活记录/mubu-diet-recorder/` | 计算饮食热量和宏量营养素，并按需写入幕布每日记录 |

### 系统工具

| Skill | 路径 | 用途 |
| --- | --- | --- |
| `disk-cleaner` | `系统工具/disk-cleaner-skills/` | Windows/macOS 磁盘扫描、报告和清理辅助 |

### 插件资产

`Pluging插件/` 保留插件原始结构。插件内置 skill 不拆散到普通分类里。

| 插件 | 内容 |
| --- | --- |
| `claude-hud` | 历史 HUD 插件资产记录，当前不部署到 Codex |
| `claude-md-management` | `claude-md-improver` |
| `superpowers` | `brainstorming`、`dispatching-parallel-agents`、`executing-plans`、`finishing-a-development-branch`、`receiving-code-review`、`requesting-code-review`、`subagent-driven-development`、`systematic-debugging`、`test-driven-development`、`using-git-worktrees`、`using-superpowers`、`verification-before-completion`、`writing-plans`、`writing-skills` |
| `clangd-lsp` | clangd LSP 插件资产，按需分别部署到目标 agent |

### MCP 资产

| MCP | 路径 | 用途 |
| --- | --- | --- |
| `mcp 配置` | `MCP/.mcp.json` | MCP 配置源资产；项目使用时提取受管配置片段并写入对应项目配置 |

### Hook 资产

当前无 Hook 资产。新增 Hook 时，在 `钩子/<hook-name>/` 保存脚本、配置模板和说明，并在此处登记适用 agent。

### CLI 工具资产

| CLI 工具 | 路径 | 用途 |
| --- | --- | --- |
| `opencli` | `CLI工具/opencli/` | OpenCLI 工具源资产 |
| `paper-scraper` | `CLI工具/paper-scraper/` | 论文资料抓取工具源资产 |

## 后续维护建议

1. 新增资产先放入 `Skill待测库/`，完成安全审计和实际试用后才可进入本库。
2. 入库时放入最贴近的二级分类，更新本索引并保留来源、版本或提交信息。
3. 项目资产只在 `D:\桌面\Codex\项目包\<项目名>\` 维护；项目 `.codex/skills/` 只能由项目包完整部署。
4. 修改项目包内 Skill 后，先询问用户改动是项目专属还是应同步为通用个人资产。
5. 插件、MCP、Hook、CLI 工具不要混入普通 Skill 分类，继续留在 `Pluging插件/`、`MCP/`、`钩子/`、`CLI工具/`，并按各自的 Codex 安装或配置机制处理。
