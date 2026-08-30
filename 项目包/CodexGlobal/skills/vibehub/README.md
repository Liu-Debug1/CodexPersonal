# VibeHub

## 来源与状态

- 上游仓库：`oil-oil/vibe-hub-skill`
- 上游路径：`skills/vibehub`
- 来源地址：`https://github.com/oil-oil/vibe-hub-skill`
- 导入日期：2026-08-19
- 上游默认分支：`main`
- 固定上游提交：`aa2f2add8397daae06c55f9ca9d75dc7eee6c08d`
- 许可证：MIT
- 状态：已认可并归档为个人源资产；已安装到 Codex 全局 Skill 目录。

## 组成

- `SKILL.md`：触发条件、术语提示和表达规则。
- `agents/openai.yaml`：Skill 元数据。
- `scripts/vibehub.mjs`：VibeHub 术语解析脚本。
- `vibehub.config.json`：默认服务配置。
- `LICENSE`：上游 MIT 许可证副本。

## 文件校验

| 文件 | SHA-256 |
| --- | --- |
| `SKILL.md` | `51587BB757227F9653106D6DB10E77BD12740F4D22DE604759A957F1BC024E86` |
| `vibehub.config.json` | `D1EC9BE8D2037BA1400757FDD732FD9E793757CC51DDC59CFD5C1F2DE3E50457` |
| `agents/openai.yaml` | `18D92BCAC85CC90093638A6835D79836E18DC398C605DF17B8A3BD18D24350AD` |
| `scripts/vibehub.mjs` | `2FA5E50399647F82A8A7837E04669EEF22BE1922A8D749D56E6E85B36EF5926F` |
| `LICENSE` | `D44A3CA218007A85D3BE41A0B76553D746E42336C7A63C6C6687D2619199C3C4` |

## 验收记录

- 已完成静态检查：目录结构完整，Node.js 可加载并输出 `--help`。
- 已完成本机安装检查：`C:\Users\Liuzwei\.codex\skills\vibehub\` 存在完整副本。
- 远程解析待验证：2026-08-19 执行 `resolve --query Tooltip --compact` 返回 `fetch failed`；原因可能是 VibeHub 服务或当前网络可达性，不能据此声称术语查询已通过。

## 依赖与风险

- 依赖 Node.js 20+ 和可访问的 VibeHub 在线服务；无第三方 npm 依赖。
- 查询仅应传入脱敏术语，避免发送代码、密钥、内部地址或用户材料。
- `--site-url` 或 `VIBEHUB_SITE_URL` 可改写远端服务地址；仅应指向受信域名。
- 个人库是源资产，不得通过符号链接或目录联接直接作为运行目录。
