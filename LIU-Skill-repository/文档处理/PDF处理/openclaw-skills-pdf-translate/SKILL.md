---
name: pdf-translate
description: Translates PDF documents to Chinese with professional typography. Extracts text, translates section-by-section into well-structured Markdown, then generates PDF via weasyprint with full CJK support. Use when user asks to translate a PDF, says "翻译PDF", "translate this document", or "pdf translate".
---

# PDF Translation Skill

翻译 PDF 文档并生成排版精美的中文文档。支持 **Markdown + weasyprint**（快速单栏）和 **LaTeX + IEEEtran**（学术双栏 + 原图嵌入）两种输出路径。

## 版本信息

**当前版本**: v5.0.0
**发布日期**: 2026-06-04

### v5.0.0 变更

- **新增**：`scripts/extract_figures.py` — 从原 PDF 提取内嵌图片 + 全页渲染
- **新增**：`scripts/build_latex.py` — 生成 IEEEtran LaTeX 源码并编译含图 PDF
- **新增**：Step 0（图片提取）和 Path B（LaTeX 学术双栏路径）
- Markdown-first 工作流保留为 Path A（快速预览）

---

## 路径选择

| 场景 | 推荐路径 | 输出 |
|------|---------|------|
| 快速预览、笔记整理 | **Path A**: Markdown + weasyprint | 单栏 PDF |
| 学术论文、需要保留原图 | **Path B**: LaTeX + IEEEtran | 双栏 PDF（含原图） |
| 仅需 Markdown | Path A 跳过 Step 5 | `.md` 文件 |

---

## Path A: Markdown + weasyprint（快速路径）

### Step 0: 提取原文图片（可选，为 Path B 准备）

```bash
python3 ${SKILL_DIR}/scripts/extract_figures.py "输入.pdf" "figures/"
```

> 此步骤提取原 PDF 中内嵌的图片和全页渲染，供后续 Path B 使用。如仅需 Path A 可跳过。

### Step 1: 提取 PDF 文本

```python
import pdfplumber

pdf = pdfplumber.open("输入文件.pdf")
for i, page in enumerate(pdf.pages):
    text = page.extract_text()
    if text:
        print(f"--- Page {i+1} ---")
        print(text)
```

长文档（>20 页）先提取前几页了解结构，再分批提取。

### Step 2: 分析文档结构

通读全文，识别以下元素并规划 Markdown 映射：

| 原文元素 | Markdown 映射 |
|---------|-------------|
| 文档标题 | `#` |
| 章节（Chapter） | `##` |
| 小节（Section） | `###` |
| 子小节（Subsection） | `####` |
| 目录 | 链接列表 `- [章节名](#锚点)` |
| 正文段落 | 段落（空行分隔） |
| 代码块 | ` ``` ` 围栏（**不翻译**内容） |
| 表格 | `| 列1 | 列2 |` 语法 |
| 有序列表 | `1. ` 开头 |
| 无序列表 | `- ` 开头 |
| 引用/提示框 | `> ` 语法 |
| 页脚/页码 | 丢弃 |

### Step 3: 逐章节翻译为中文 Markdown

**必须逐章节翻译**，不要一次输出全文。每完成一个章节就追加写入文件。

#### 翻译规则

1. **专有名词保留英文**：首次出现时括号附英文，如"渐进式披露（Progressive Disclosure）"
2. **代码块不翻译**：` ``` ` 内代码保持原文，只翻译围栏外说明文字
3. **行内代码不翻译**：反引号内标识符、命令、文件名保持英文
4. **保持层级结构**：`#` → `##` → `###` → `####` 不跳级
5. **段落间必须空行**：每个段落、列表、代码块、表格前后都要有空行
6. **列表格式**：`- ` 或 `1. ` 开头，嵌套用 2 空格缩进
7. **表格格式**：`| 列1 | 列2 |` 语法，必须有 `|---|---|` 分隔行
8. **引用格式**：`> ` 开头

#### 翻译质量标准

参见 [translation-standards.md](references/translation-standards.md)

- 三步翻译工作流：重写初稿 → 问题诊断 → 润色定稿
- 四大语言转换策略：形合→意合、被动→主动、抽象→具体、精简冗余
- 杜绝"欧化表达"和"翻译腔"

#### 必须避免的格式错误

- ❌ 段落之间没有空行 → 文字挤在一起
- ❌ 列表项前没有空行 → 不被识别为列表
- ❌ 表格前后没有空行 → 表格无法渲染
- ❌ 代码块 ` ``` ` 前后没有空行 → 代码块不显示
- ❌ 标题 `##` 前后没有空行 → 标题不识别
- ❌ 翻译代码块内的代码
- ❌ 一次性输出全部内容导致截断

### Step 4: 输出 Markdown 文件

写入 `.md` 文件，路径与原 PDF 同目录，文件名：`原文件名_中文翻译.md`

### Step 5: 生成 PDF

使用 `scripts/md2pdf.py` 将 Markdown 转为排版精美的 PDF：

```bash
python3 ${SKILL_DIR}/scripts/md2pdf.py "输入.md" "输出.pdf"
```

macOS 上如果报 gobject 找不到：

```bash
DYLD_FALLBACK_LIBRARY_PATH="/opt/homebrew/lib" python3 ${SKILL_DIR}/scripts/md2pdf.py "输入.md" "输出.pdf"
```

Windows 上需要 GTK3 运行时（见 [troubleshooting.md](references/troubleshooting.md)）。

---

## Path B: LaTeX + IEEEtran（学术双栏 + 原图嵌入）

适用场景：学术论文翻译，需要保留原文插图、双栏排版、数学公式。

### Step 0: 提取原文图片

```bash
python3 ${SKILL_DIR}/scripts/extract_figures.py "输入.pdf" "figures/"
```

输出：
- `figures/embedded_p{页码}_{序号}.{png|jpeg}` — 内嵌图片（原图直接提取）
- `figures/page_{页码}.png` — 全页渲染（300 DPI，用于裁剪缺失图）

**关键原则**：优先使用 `embedded_*` 图片（原图质量最高）。如果某张图未出现在内嵌列表中，则从 `page_*.png` 全页渲染中用 `fitz.Rect` 裁剪对应区域。

裁剪缺失图示例：

```python
import fitz
doc = fitz.open("输入.pdf")
mat = fitz.Matrix(300/72, 300/72)      # 300 DPI
page = doc[6]                           # 0-indexed: page 7
clip = fitz.Rect(50, 400, 545, 760)    # (x0, y0, x1, y1) in PDF points
pix = page.get_pixmap(matrix=mat, clip=clip)
pix.save("figures/crop_fig7.png")
```

### Step 1-3: 提取文本 + 分析结构 + 翻译

同 Path A 的 Step 1-3。

### Step 4: 生成 LaTeX 源码并编译

使用 `scripts/build_latex.py` 生成含图的 IEEEtran .tex 文件并编译：

```bash
python3 ${SKILL_DIR}/scripts/build_latex.py \
  --manifest content.json \
  --figures figures/ \
  --output output.tex \
  --compile
```

`content.json` 结构：

```json
{
  "title": "中文论文标题",
  "authors": "作者列表",
  "abstract": "中文摘要...",
  "keywords": "关键词1，关键词2",
  "sections": [
    {
      "heading": "一、引言",
      "level": "section",
      "body": "正文段落... \\cite{ref1}...",
      "figures": [
        {"label": "fig1", "file": "embedded_p2_0.jpeg", "caption": "图1 通信拓扑"}
      ]
    }
  ],
  "references": "\\bibitem{ref1} ..."
}
```

> 如果不需要自动编译（手动调试 .tex），去掉 `--compile`。

也可直接手写 .tex 文件（更灵活），模板：

```latex
\documentclass[10pt,a4paper,twocolumn]{IEEEtran}
\usepackage[UTF8,heading=false]{ctex}
\setCJKmainfont{SimSun}
\usepackage{graphicx}
\graphicspath{{./figures/}}

\begin{document}
\title{中文标题}
\author{作者}
\maketitle
\begin{abstract}摘要...\end{abstract}

\section{引言}
正文... \cite{ref1}

\begin{figure}[ht]
\centering
\includegraphics[width=\columnwidth]{embedded_p2_0}
\caption{图1 通信拓扑}
\label{fig:topology}
\end{figure}

{\small
\begin{thebibliography}{99}
\bibitem{ref1} ...
\end{thebibliography}}
\end{document}
```

编译（需要 xelatex）：

```bash
xelatex -interaction=nonstopmode output.tex   # 运行 2-3 次
```

**系统要求**：
- Windows: `winget install MiKTeX.MiKTeX`
- macOS: `brew install --cask mactex`
- Linux: `sudo apt install texlive-xetex texlive-lang-chinese`

### Step 5: 确认输出

翻译完成后告知用户 `.pdf` 路径和页数。

---

## 依赖安装

```bash
# Python 依赖
pip3 install pdfplumber markdown weasyprint PyMuPDF

# LaTeX（Path B）
# Windows:  winget install MiKTeX.MiKTeX
# macOS:    brew install --cask mactex
# Linux:    sudo apt install texlive-xetex texlive-lang-chinese

# weasyprint 系统依赖（Path A）
# macOS:    brew install pango
# Linux:    sudo apt install libpango1.0-dev
# Windows:  winget install tschoonj.GTKForWindows
```

## 脚本目录

| 脚本 | 用途 | 路径 |
|------|------|------|
| `extract_figures.py` | **v5.0 新增** 从原 PDF 提取内嵌图片 + 全页渲染 | Path B Step 0 |
| `build_latex.py` | **v5.0 新增** 生成含图 IEEEtran LaTeX 并编译 | Path B Step 4 |
| `md2pdf.py` | Markdown → PDF（weasyprint 引擎） | Path A Step 5 |
| `translate_pdf.py` | 旧版：基础 PDF 提取和生成（reportlab） | Legacy |
| `generate_complete_pdf.py` | 旧版：完整工作流示例（reportlab） | Legacy |

## 故障排除

| 问题 | 解决方案 |
|------|---------|
| 代码块中文乱码 | 使用 `md2pdf.py`（v4.0，已修复 CJK font fallback） |
| weasyprint 报 gobject 找不到 | macOS: `DYLD_FALLBACK_LIBRARY_PATH="/opt/homebrew/lib"`；Windows: 安装 GTK3 运行时 |
| 中文字体不显示 | 确认系统有苹方/黑体/宋体 |
| Markdown 格式错乱 | 检查块级元素前后是否有空行 |
| xelatex 找不到 | 安装 MiKTeX / TeX Live，确认 bin 在 PATH |
| LaTeX 缺包（IEEEtran/ctex） | MiKTeX 会自动安装，或手动 `mpm --install=ieeetran` |
| 图片未嵌入 | 先运行 `extract_figures.py`，确认 `figures/` 目录存在 |
| 内嵌图片缺失某张图 | 用 PyMuPDF Rect 裁剪 `page_*.png` 对应区域 |

更多问题参见 [troubleshooting.md](references/troubleshooting.md)

---

**参考文档**：
- [翻译标准](references/translation-standards.md)
- [字体配置](references/font-configuration.md)
- [故障排除](references/troubleshooting.md)
- [完整示例](references/complete-example.md)
