---
name: vision
description: 火山引擎豆包视觉模型识图。当底层模型不具备原生识图能力时，用 vision.js 调用豆包视觉 API 识别图片内容并返回文字描述。触发：用户发图片、要求分析/描述图片。
---

你使用的模型不具备原生识图能力。遇到图片时，**不要用 Read 工具**，改用 vision.js：

```
node "C:\Users\Liuzwei\.claude\skills\vision\vision.js" "<图片绝对路径>" "用中文描述这张图片"
```

## 触发场景

- 用户分享图片路径（本地或网络 URL）
- 消息中出现 "Saved attachments:" 并列出图片
- 用户要求分析、描述、识别图片内容
- 图片标记为 `[Unsupported Image]`

## 用法

对每张图片依次执行 vision.js，拿到文字描述后再回复用户。这是强制规则，不可跳过。

脚本位置：`C:\Users\Liuzwei\.claude\skills\vision\vision.js`
API：火山引擎 方舟 / 豆包视觉模型 `doubao-seed-2-0-mini-260428`
