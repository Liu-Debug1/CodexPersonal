# wechat-article-to-obsidian

候选 Skill：通过用户已安装的 Microsoft Edge Obsidian Web Clipper，将微信公众号文章完整剪藏到 Obsidian，并按用户明确要求做最小 Markdown 排版处理。

## 当前范围

- 入口：mp.weixin.qq.com 公众号文章 URL，或已经被 Web Clipper 保存到 Obsidian 的文章笔记。
- 主流程：Edge Web Clipper → Add to Obsidian → 目标 Vault 文件夹 → 本地 Markdown 校验。
- 默认行为：完整保留原文，不摘要、不改写、不翻译、不删广告或页尾内容。
- 可选处理：去掉冗余空行；把英文段落对应的中文译文包裹为 %%...%% 注释。

## 依赖

- Microsoft Edge
- Obsidian Web Clipper 扩展
- 已打开的 Obsidian Vault
- Codex Computer Use 或 Browser Control

此候选 Skill 不依赖 wechat-article-extractor 的网络抓取代码，也不会自动安装扩展或绕过登录、验证码和权限提示。

