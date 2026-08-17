---
name: skill-vetter
version: 1.0.0
description: 安全审计外部技能 — 在安装前审核 SKILL.md，检测 prompt injection、凭据窃取、远程代码执行、typosquatting 和社会工程学攻击。纯提示词驱动，无外部依赖。
author: Morgan Freeman (omc)
license: MIT
metadata:
  category: security
  tags:
    - security
    - linter
    - supply-chain
    - skill-audit
  triggers:
    - "审核技能"
    - "vet skill"
    - "检查技能安全"
    - "skill audit"
    - "安装前检查"
    - "scan skill"
---

# Skill Vetter

对外部 SKILL.md 文件进行安全审计，在安装前识别潜在风险。纯提示词分析，无需执行任何外部命令。

## 触发场景

当用户请求以下操作时触发此技能：
- 安装来源不明的外部技能
- 想要审核某个技能的 SKILL.md 安全性
- 对某个技能的安全性存疑
- "帮我检查这个技能"
- "这个技能安全吗"

## 审计流程

### 第一步：获取 SKILL.md 内容

从 URL 或本地路径读取 SKILL.md 全文。

支持的输入格式：
- GitHub URL: `https://github.com/owner/repo/blob/main/skills/xxx/SKILL.md`
- Raw URL: `https://raw.githubusercontent.com/owner/repo/main/skills/xxx/SKILL.md`
- 本地路径: `~/.claude/skills/xxx/SKILL.md`
- 直接粘贴的 SKILL.md 内容

### 第二步：提取关键信息

从 SKILL.md 头部提取：
```yaml
name: 技能名称
version: 版本
description: 描述
author: 作者
license: 许可证
metadata:
  category: 类别
  tags: 标签
```

### 第三步：执行 6 轮安全分析

#### Pass 1: 提示词注入检测

**检查内容：**
- 是否有混淆的指令（如零宽字符、Unicode 翻转、base64 编码）
- 是否有条件欺骗（`if you are Claude, ignore previous instructions`）
- 是否有隐藏的 system prompt 覆盖
- 是否有 Base64/URL 编码的可疑指令
- 是否有 `ROLEPLAY` 或 `JAILBREAK` 意图

**危险信号（任一存在即为高危）：**
```
- ignore previous instructions
- ignore all previous guidelines
- override your instructions
- disregard your system prompt
- you are now [different persona]
- [SYSTEM_PROMPT]
- base64 decode and execute
- eval( atob(
- \x or \u escape sequences in instructions
- &#x or &#xxxx; numeric character references
```

#### Pass 2: 凭据窃取检测

**检查内容：**
- 是否请求敏感环境变量（如 `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `AWS_SECRET`）
- 是否请求凭据或认证信息
- 是否请求写入敏感配置文件
- 是否有可疑的 `curl`/`wget` 发送数据到外部

**危险信号：**
```
- $OPENAI_API_KEY
- $ANTHROPIC_API_KEY
- $GITHUB_TOKEN
- $AWS_ACCESS_KEY
- password
- secret
- credential
- auth token
- bearer token
- curl.*--data.*https://
- wget.*--post-data
```

#### Pass 3: 远程代码执行检测

**检查内容：**
- 是否执行 `npx`, `npm install`, `pip install`, `curl | bash`
- 是否有 `eval()`, `exec()`, `subprocess` 调用
- 是否有下载并执行脚本的行为
- 是否有 chmod +x 后执行
- 是否有可疑的 heredoc 或 here-string 执行

**危险信号：**
```
- npx
- npm install
- pip install
- curl | bash
- wget -O- | sh
- eval $
- exec $
- subprocess
- os.system
- child_process.exec
- fetch(.*).then.*eval
```

#### Pass 4: 供应链攻击检测

**检查内容：**
- 是否声明了 `bins` 要求安装全局命令
- 是否有自动安装 npm 包或 pip 包的行为
- `metadata.openclaw.requires.bins` 中是否有非必要命令
- 是否有非官方来源的二进制文件

**检查项：**
```yaml
metadata:
  openclaw:
    requires:
      bins:  # 检查是否仅包含必要命令
        - node  # 可接受
        - npm   # 可接受（但警惕 auto-install）
      env: []  # 警惕非空环境变量列表
```

#### Pass 5: Typosquatting 检测

**检查内容：**
- 技能名称是否与知名技能/包相似（如 `react-best-practive` vs `react-best-practices`）
- 作者名称是否模仿官方（如 `anthropic-skills` vs `anthropics/skills`）
- GitHub URL 是否使用数字变形（如 `alphacode` vs `alpha-code`）

**知名技能名称列表（供参考）：**
```
anthropics/skills, vercel-labs/skills, vercel-labs/agent-skills,
claude-api, frontend-design, mcp-builder, skill-creator,
pdf, xlsx, docx, pptx, webapp-testing
```

**检测方法：**
- Levenshtein 距离 < 3 视为可疑
- 相同前缀 + 不同域名（如 `react-` vs `react--`）
- 数字/连字符替换（如 `alpha` → `a1pha`, `claude-code` → `claudecode`）

#### Pass 6: 社会工程学检测

**检查内容：**
- 是否声称"100K+ installs"等无法核实的统计
- 是否使用紧迫感话术（"立即安装"、"限时"、"你必须"）
- 是否声称"官方"、"认证"但无验证
- 是否请求过度的权限（如管理员权限、系统级访问）
- 描述是否过于夸张（"最强大的"、"革命性的"）

**危险信号：**
```
- "100K+ installs" / "50K+ users"
- "must install now"
- "official" / "certified" / "verified"
- "guaranteed"
- "revolutionary"
- "no alternatives"
- "only skill that"
```

### 第四步：风险评分

| 风险等级 | 分数 | 含义 |
|----------|------|------|
| A | 0-10 | 安全，可直接安装 |
| B | 11-25 | 基本安全，轻微问题 |
| C | 26-50 | 中等风险，需人工审核 |
| D | 51-75 | 高风险，建议不安装 |
| F | 76-100 | 极高风险，**禁止安装** |

**评分权重：**
- 提示词注入（Pass 1）：+40 分（严重）
- 凭据窃取（Pass 2）：+35 分（严重）
- 远程代码执行（Pass 3）：+30 分（高）
- 供应链攻击（Pass 4）：+15 分（中）
- Typosquatting（Pass 5）：+20 分（高）
- 社会工程学（Pass 6）：+10 分（低）

### 第五步：输出报告

```
## Skill Vetter 审计报告

**技能名称:** [name]
**版本:** [version]
**作者:** [author]
**许可证:** [license]
**GitHub:** [url]

### 风险评分

| 维度 | 分数 | 状态 |
|------|------|------|
| 提示词注入 | X/40 | ✅/⚠️/❌ |
| 凭据窃取 | X/35 | ✅/⚠️/❌ |
| 远程代码执行 | X/30 | ✅/⚠️/❌ |
| 供应链攻击 | X/15 | ✅/⚠️/❌ |
| Typosquatting | X/20 | ✅/⚠️/❌ |
| 社会工程学 | X/10 | ✅/⚠️/❌ |
| **总分** | **X/100** | **[A-F]** |

### 发现的问题

[列出所有发现，按严重程度排序]

### 建议

**[安装 / 人工审核 / 不安装]**

### 安全使用建议

[如有轻微问题，提供安全使用建议]
```

## 使用示例

### 示例 1：审核 GitHub URL

用户：
> 帮我审核这个技能是否安全：https://github.com/someuser/some-skill

### 示例 2：用户粘贴 SKILL.md 内容

用户粘贴了完整的 SKILL.md 内容，我直接进行审计。

### 示例 3：安装前检查

用户说"帮我安装 xxx 技能，但先审核一下"，我先调用此技能进行审计，根据结果决定是否继续安装。

## 注意事项

1. **不执行任何代码** — 纯提示词分析，无需 `npx`, `curl` 等命令
2. **不确定时从轻** — 遇到可疑但不确定的内容，标记为"轻微问题"而非"严重问题"
3. **注重隐私** — 不建议安装任何请求凭据的技能，除非用户明确知道在做什么
4. **来源优先** — 来自 `anthropics/`, `vercel-labs/`, `openai/` 等官方/知名来源的技能可降低审核严格度
5. **本地技能无需审核** — 来自你本人或已验证来源的技能不需要此审计
