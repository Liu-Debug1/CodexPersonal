# OpenCLI

**包名：** `@jackwener/opencli`（v1.8.0，Apache-2.0）
**源码：** [jackwener/OpenCLI](https://github.com/jackwener/OpenCLI)
**安装：** `npm install -g @jackwener/opencli@latest`（已装全局）

将网站、浏览器会话、Electron 应用转化为确定性 CLI 接口。运行时零 LLM 成本，所有命令可脚本化、可放进 CI。

---

## 环境配置

```bash
npm install -g @jackwener/opencli@latest
```

Chrome 扩展：加载 `C:\Users\Liuzwei\.opencli\extension\`（开发者模式 → 加载已解压的扩展程序）

---

## 核心命令

### 内置命令

| 命令 | 说明 |
|------|------|
| `opencli list` | 列出所有可用适配器（按站点分组） |
| `opencli doctor` | 诊断浏览器桥接连接 |
| `opencli completion <shell>` | 输出 bash/zsh/fish 补全脚本 |

### 网站适配器（100+ 站点）

直接 `opencli <site> <command>`，复用已登录 Chrome 会话：

```bash
opencli hackernews top --limit 10
opencli bilibili hot --limit 5
opencli reddit hot --limit 20
opencli github search "rust" --limit 5
opencli arxiv search "transformer"
opencli zhihu hot --limit 5
opencli twitter user elonmusk
opencli spotify search "jazz" --limit 10
```

### 学术论文搜索

```bash
# arXiv（公开 API，无需登录）
opencli arxiv search "steer-by-wire vehicle stability" --limit 10
opencli arxiv paper 2309.01461

# OpenAlex（公开 API，含摘要）
opencli openalex search "vehicle domain control" --limit 10
opencli openalex work W2794784768

# CNKI 知网（需 Chrome 登录知网）
opencli cnki search "线控转向 车辆稳定性" --limit 10

# 万方（需 Chrome 登录）
opencli wanfang search "线控底盘 域控制" --limit 10

# Google Scholar（可能需登录）
opencli google-scholar search "model predictive control vehicle"

# DBLP（CS 论文）
opencli dblp search "autonomous vehicle"

# PubMed
opencli pubmed search "vehicle safety"
```

### 浏览器自动化（AI Agent 底层原语）

```bash
# session 是位置参数，直接跟在 browser 后面
opencli browser work open https://news.ycombinator.com
opencli browser work state              # 获取页面 DOM 快照
opencli browser work find --css ".athing"  # CSS 查找元素
opencli browser work screenshot         # 截屏
opencli browser work network            # 查看网络请求
opencli browser work evaluate "document.title"  # 执行 JS
opencli browser work extract            # 提取页面为 Markdown
opencli browser work close              # 释放会话
```

### 输出格式

```bash
opencli hackernews top -f json    # JSON（适合 jq 管道）
opencli hackernews top -f csv     # CSV
opencli hackernews top -f yaml    # YAML
opencli hackernews top -f md      # Markdown 表格
```

### CLI 中心（调度外部 CLI）

```bash
opencli gh pr list --limit 5
opencli docker ps
opencli obsidian search query="AI"
```

### 下载

```bash
opencli bilibili download BV1xx --output ./videos
opencli xiaohongshu download <url>
opencli twitter download elonmusk --limit 20
```

### 适配器管理

```bash
opencli adapter eject reddit      # 弹出内置适配器到本地修改
opencli adapter reset reddit      # 恢复内置版本
opencli adapter status            # 查看哪些被本地覆盖
```

### Chrome 多 Profile

```bash
opencli profile list                       # 查看已连接 Profile
opencli profile rename <id> work           # 别名
opencli profile use work                   # 设为默认
```

---

## 浏览器自动化子命令完整列表

| 类别 | 子命令 | 说明 |
|------|--------|------|
| 导航 | `open`, `back`, `scroll <up/down>` | 页面导航 |
| 状态 | `state`, `find`, `get title/url/text/value/html/attributes`, `frames`, `screenshot`, `console` | 读取页面状态 |
| 交互 | `click`, `type`, `fill`, `select`, `hover`, `focus`, `dblclick`, `check`, `uncheck`, `drag`, `upload`, `keys` | 操作页面元素 |
| 网络 | `network`, `analyze`, `eval`, `extract` | 网络捕获与分析 |
| 等待 | `wait <type> [value]` | 等待选择器/文本/时间/XHR |
| 标签页 | `tab list/new/select/close` | 多标签页管理 |
| 会话 | `bind`, `unbind`, `close`, `init`, `verify` | 会话与脚手架 |

---

## 五种数据获取策略

| 策略 | 说明 | 需要浏览器 |
|------|------|-----------|
| `PUBLIC` | 公开 API，无需认证 | 否 |
| `LOCAL` | 本地文件/计算 | 否 |
| `COOKIE` | 复用浏览器登录态发 XHR | 是 |
| `INTERCEPT` | 拦截 SPA 网络请求 | 是 |
| `UI` | 浏览器交互提取 DOM 数据 | 是 |

---

## 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `OPENCLI_DAEMON_PORT` | `19825` | 守护进程端口 |
| `OPENCLI_PROFILE` | — | Chrome Profile |
| `OPENCLI_WINDOW` | — | `foreground` / `background` |
| `OPENCLI_BROWSER_COMMAND_TIMEOUT` | `60` | 单命令超时（秒） |
| `OPENCLI_CDP_ENDPOINT` | — | 自定义 CDP WebSocket 端点 |
| `OPENCLI_VERBOSE` | `false` | 详细日志 |
| `OPENCLI_CACHE_DIR` | `~/.opencli/cache` | 缓存目录 |

---

## 退出码（sysexits.h）

| 码 | 含义 |
|----|------|
| 0 | 成功 |
| 1 | 一般错误 |
| 2 | 参数错误 |
| 66 | 空结果 |
| 69 | 服务不可用（浏览器未连接） |
| 75 | 临时故障（超时，可重试） |
| 77 | 需要认证（未登录） |
| 78 | 配置错误 |

---

## 架构

```
CLI 进程 → HTTP → 本地守护进程(localhost:19825) → WebSocket → Chrome 扩展 → Chrome Debugger API → 目标页面
```

- **IPage 接口**三种实现：HTTP 守护进程、CDP WebSocket 直连、测试 Mock
- **管道模式**：适配器可用声明式 YAML（fetch → select → map → limit）替代命令式 JS
- **双重发现**：预构建 manifest 快速启动 + 文件系统扫描开发模式
- **用户适配器**：`~/.opencli/clis/` 下的本地文件覆盖内置适配器
