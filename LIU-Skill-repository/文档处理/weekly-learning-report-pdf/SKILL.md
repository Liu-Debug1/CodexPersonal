---
name: weekly-learning-report-pdf
description: "Merge a weekly learning-report DOCX with a learning-notes PDF into a verified final PDF. Use when the user asks to 合并学习汇报, 整理每周学习内容, 按分点对应 Word 与 PDF, insert numbered report text above matching PDF sections, or combine embedded VS Code screenshots into a compact reusable-function montage."
---

# Weekly Learning Report PDF

把每周学习汇报 DOCX 中的分点原文、内嵌代码截图与学习笔记 PDF 按顺序合并，生成经过结构检查和逐页渲染验证的最终 PDF。

## Workflow

1. 通过工作区依赖加载器取得捆绑 Python 运行时。不要使用系统 Python。
2. 确认用户提供了一个汇报 DOCX 和一个学习内容 PDF；存在多个候选文件时先确认具体路径。
3. 运行 `scripts/inspect_inputs.py`，读取 DOCX 分点、图片数量、PDF 页数和逐页文本摘要。
4. 确定每个分点对应的连续页码范围：
   - 优先采用用户明确给出的范围。
   - 否则按 PDF 的大章节边界和分点顺序判断。
   - 判断不唯一时先向用户确认；禁止静默猜测。
   - 范围必须连续、无重叠、覆盖整个源 PDF。
5. 阅读 `references/layout-rules.md`，然后运行 `scripts/assemble_report.py`。
6. 打开生成的所有联系表图片，并单独检查每个分点起始页及截图拼版页。发现裁切、重叠、空白页或字体问题时修复后重跑。
7. 最终只交付生成的 PDF，并说明采用的页码范围和总页数。不要交付渲染中间文件。

## Commands

使用依赖加载器返回的 Python 路径替换 `$python`：

```powershell
& $python scripts/inspect_inputs.py `
  --docx "D:\path\学习汇报.docx" `
  --pdf "D:\path\学习内容.pdf"

& $python scripts/assemble_report.py `
  --docx "D:\path\学习汇报.docx" `
  --pdf "D:\path\学习内容.pdf" `
  --ranges "1-16,17-26,27-32" `
  --output "D:\path\output\pdf\学习内容_按学习汇报对应整理_最终.pdf" `
  --render-dir "D:\path\tmp\pdfs\weekly-report-render"
```

`assemble_report.py` 会自动：

- 保留 DOCX 分点原文，仅添加 `1.`、`2.`、`3.` 等顺序前缀。
- 将分点文字嵌入对应笔记首个页面顶部，不创建独立分隔页。
- 保持普通源 PDF 页面内容流和页面框不变。
- 将 DOCX 图片按最多三张一组紧密拼版，仅在第一张拼版页显示“复用函数模板”。
- 添加 PDF 书签、生成联系表、验证页数和非空页面。
- 在目标 PDF 被占用时生成带时间戳的新文件，避免破坏已打开文件。

## Failure Rules

- DOCX 分点少于页码范围数量：停止并报告。
- 页码范围不连续、越界或未覆盖全部 PDF：停止并报告。
- 找不到 Poppler `pdftoppm`：停止并说明缺失依赖，不得声称已完成视觉验证。
- 渲染页数与 PDF 页数不一致，或检测到空白页：停止并报告。
- 不改写用户的分点文字，不擅自修正错别字或标点。
