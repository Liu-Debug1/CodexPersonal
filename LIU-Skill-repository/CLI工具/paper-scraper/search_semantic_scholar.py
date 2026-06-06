"""通过 Semantic Scholar API 检索论文（免费，无需浏览器）。

Semantic Scholar 覆盖 CS/工程领域论文，提供标题、作者、摘要、DOI、引用量等元数据。
API 文档: https://api.semanticscholar.org/api-docs/
"""

import urllib.request
import urllib.parse
import json
import time
import sys
import os

API_BASE = "https://api.semanticscholar.org/graph/v1"

# 检索参数覆盖你的研究方向
DEFAULT_QUERIES = [
    "steer-by-wire vehicle stability control",
    "vehicle dynamics state estimation",
    "automotive domain controller architecture",
    "embedded system functional safety ISO 26262",
    "brake-by-wire electro mechanical brake EMB",
]


def search_papers(query, limit=10, fields=None):
    """搜索论文并返回元数据列表。"""
    if fields is None:
        fields = [
            "title", "authors", "year", "abstract", "venue",
            "externalIds", "citationCount", "url", "publicationTypes",
            "openAccessPdf", "fieldsOfStudy", "referenceCount",
        ]

    params = {
        "query": query,
        "limit": limit,
        "fields": ",".join(fields),
    }
    url = f"{API_BASE}/paper/search?{urllib.parse.urlencode(params)}"

    try:
        req = urllib.request.Request(url)
        req.add_header("User-Agent", "ObLearning-PaperScraper/1.0")
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = json.loads(resp.read().decode())
        return data.get("data", [])
    except Exception as e:
        print(f"  搜索失败 [{query[:50]}...]: {e}", file=sys.stderr)
        return []


def format_authors(authors):
    """格式化作者列表为人名串。"""
    if not authors:
        return ""
    names = [a.get("name", "") for a in authors[:8]]
    if len(authors) > 8:
        names.append("et al.")
    return ", ".join(names)


def paper_to_frontmatter(p):
    """将论文元数据转为 Obsidian YAML frontmatter 字符串。"""
    ext = p.get("externalIds", {}) or {}
    doi = ext.get("DOI", "")
    arxiv_id = ext.get("ArXiv", "")

    lines = ["---"]
    lines.append(f"title: \"{p.get('title', '').replace(chr(34), chr(39))}\"")
    lines.append(f"authors: \"{format_authors(p.get('authors'))}\"")
    lines.append(f"year: {p.get('year', '')}")
    lines.append(f"venue: \"{p.get('venue', '')}\"")
    lines.append(f"citations: {p.get('citationCount', 0)}")
    if doi:
        lines.append(f"doi: \"{doi}\"")
    if arxiv_id:
        lines.append(f"arxiv: \"{arxiv_id}\"")
    topics = p.get("fieldsOfStudy", []) or []
    lines.append(f"topics: {json.dumps(topics, ensure_ascii=False)}")
    lines.append(f"paper_type: {json.dumps(p.get('publicationTypes', []), ensure_ascii=False)}")

    # 开放获取 PDF 链接
    oa = p.get("openAccessPdf")
    if oa and oa.get("url"):
        lines.append(f"pdf_url: \"{oa['url']}\"")

    lines.append("tags: [paper, to-read]")
    lines.append("---")
    return "\n".join(lines)


def paper_to_obsidian_note(p, vault_path):
    """生成一篇 Obisidian 笔记文件。

    文件命名: {第一作者姓氏}{年份}-{标题关键词}.md
    存放位置: vault_path/论文笔记/
    """
    title = p.get("title", "Untitled")
    first_author = ""
    if p.get("authors"):
        first_author = p["authors"][0].get("name", "").split()[-1]
    year = p.get("year", "0000")
    # 取标题前 8 个词做关键词
    keywords = "-".join(title.split()[:8]).rstrip(",.")
    safe_kw = "".join(c if c.isalnum() or c in "-_" else "-" for c in keywords)[:60]
    filename = f"{first_author}{year}-{safe_kw}.md"

    notes_dir = os.path.join(vault_path, "论文笔记")
    os.makedirs(notes_dir, exist_ok=True)
    filepath = os.path.join(notes_dir, filename)

    abstract = p.get("abstract", "无摘要") or "无摘要"
    authors = format_authors(p.get("authors"))
    venue = p.get("venue", "")
    citation_count = p.get("citationCount", 0)
    ext = p.get("externalIds", {}) or {}
    doi = ext.get("DOI", "")
    url = p.get("url", f"https://doi.org/{doi}" if doi else "")

    content = f"""{paper_to_frontmatter(p)}

# {title}

**{authors}** ({year}) — *{venue}*

> [!NOTE] 引用: {citation_count} | [链接]({url})

## 摘要

{abstract}

## 笔记

<!-- 在此记录阅读笔记 -->

## 关键发现

<!-- 论文的核心贡献、方法、结论 -->

## 与我研究的关联

<!-- 与线控底盘/车辆稳定性/域控制/嵌入式系统的关联 -->
"""
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)
    return filepath


def batch_search_and_save(queries, vault_path, limit=5):
    """批量检索多组关键词，生成 Obsidian 笔记。"""
    total = 0
    for query in queries:
        print(f"\n🔍 检索: {query}")
        papers = search_papers(query, limit=limit)
        print(f"  找到 {len(papers)} 篇")

        for p in papers:
            filepath = paper_to_obsidian_note(p, vault_path)
            title = p.get("title", "Untitled")[:80]
            print(f"  ✓ {title}")
            total += 1
            time.sleep(1)  # API rate limit: 1 req/s

    print(f"\n=== 共生成 {total} 篇论文笔记 ===")
    return total


if __name__ == "__main__":
    vault = sys.argv[1] if len(sys.argv) > 1 else r"D:\桌面\Ob_Learning"

    limit = int(sys.argv[2]) if len(sys.argv) > 2 else 5

    # 可自定义检索关键词
    extra_queries = sys.argv[3:] if len(sys.argv) > 3 else []
    queries = extra_queries if extra_queries else DEFAULT_QUERIES

    batch_search_and_save(queries, vault, limit=limit)
