"""arXiv 论文检索 + Obsidian 笔记生成。

arXiv API 国内可直接访问，无需代理。覆盖车辆工程/嵌入式/控制领域。
"""

import urllib.request
import urllib.parse
import xml.etree.ElementTree as ET
import os
import sys
import time
from datetime import datetime

# arXiv API 端点（国内用 export.arxiv.org 而非 api.arxiv.org 更稳定）
API_BASE = "http://export.arxiv.org/api/query"

# 研究方向预设
SEARCH_QUERIES = [
    ("线控转向", 'all:"steer by wire" AND all:vehicle AND all:control'),
    ("线控制动", 'all:"brake by wire" AND (all:EMB OR all:electro-mechanical)'),
    ("车辆稳定性", 'all:vehicle AND all:yaw AND all:stability AND all:control'),
    ("车辆状态估计", 'all:vehicle AND all:"state estimation" AND (all:kalman OR all:observer)'),
    ("域控制器架构", 'all:automotive AND all:"domain controller" AND (all:architecture OR all:gateway)'),
    ("功能安全", 'all:"ISO 26262" AND all:automotive AND all:safety'),
    ("嵌入式汽车系统", 'all:embedded AND all:automotive AND (all:MCU OR all:ECU OR all:AUTOSAR)'),
    ("MPC车辆控制", 'all:MPC AND all:vehicle AND (all:stability OR all:trajectory)'),
    ("自动驾驶决策规划", 'all:autonomous AND all:vehicle AND (all:"decision making" OR all:"motion planning")'),
    ("执行器容错", 'all:"fault tolerant" AND (all:steering OR all:braking OR all:actuator) AND all:vehicle'),
]


def search_arxiv(query, max_results=10, sort_by="relevance"):
    """检索 arXiv 并返回论文列表。"""
    params = {
        "search_query": query,
        "start": 0,
        "max_results": max_results,
        "sortBy": sort_by,
        "sortOrder": "descending",
    }
    url = f"{API_BASE}?{urllib.parse.urlencode(params)}"

    req = urllib.request.Request(url)
    req.add_header("User-Agent", "ObLearning-PaperScraper/1.0")
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            xml_str = r.read().decode()
    except Exception as e:
        print(f"  arXiv API 请求失败: {e}", file=sys.stderr)
        return []

    ns = {
        "atom": "http://www.w3.org/2005/Atom",
        "arxiv": "http://arxiv.org/schemas/atom",
    }

    papers = []
    root = ET.fromstring(xml_str)
    for entry in root.findall("atom:entry", ns):
        title_el = entry.find("atom:title", ns)
        title = title_el.text.strip().replace("\n", " ") if title_el is not None else "Untitled"

        summary_el = entry.find("atom:summary", ns)
        abstract = summary_el.text.strip().replace("\n", " ") if summary_el is not None else ""

        published_el = entry.find("atom:published", ns)
        published = published_el.text if published_el is not None else ""
        year = published[:4] if published else ""

        id_el = entry.find("atom:id", ns)
        arxiv_id = id_el.text.split("/abs/")[-1] if id_el is not None else ""
        arxiv_url = id_el.text if id_el is not None else ""

        authors = []
        for a in entry.findall("atom:author", ns):
            n = a.find("atom:name", ns)
            if n is not None:
                authors.append(n.text)

        # 分类
        cats = [c.get("term", "") for c in entry.findall("atom:category", ns) if c is not None]
        primary_cat = cats[0] if cats else ""
        cs_cats = [c for c in cats if c.startswith("cs.") or c.startswith("eess.")]

        # PDF 链接
        pdf_url = ""
        for link in entry.findall("atom:link", ns):
            if link is not None and link.get("title") == "pdf":
                pdf_url = link.get("href", "")
                break

        # 评论（作者更新说明）
        comment_el = entry.find("arxiv:comment", ns)
        comment = comment_el.text.strip() if comment_el is not None and comment_el.text else ""

        papers.append({
            "title": title,
            "authors": authors,
            "year": year,
            "published": published,
            "abstract": abstract,
            "arxiv_id": arxiv_id,
            "arxiv_url": arxiv_url,
            "pdf_url": pdf_url,
            "categories": cats,
            "primary_category": primary_cat,
            "comment": comment,
            "source": "arXiv",
        })

    return papers


def format_authors(authors, max_show=5):
    """作者列表格式化为字符串。"""
    if not authors:
        return ""
    shown = authors[:max_show]
    suffix = " et al." if len(authors) > max_show else ""
    return ", ".join(shown) + suffix


def first_author_surname(authors):
    """提取第一作者姓氏。"""
    if not authors:
        return "Unknown"
    return authors[0].split()[-1]


def paper_to_obsidian_note(paper, vault_path):
    """生成 Obsidian 笔记文件。

    文件命名: {第一作者姓氏}{年份}-{arxiv_id}.md
    存放位置: vault_path/论文笔记/{分类}/
    """
    title = paper["title"]
    # 文件名安全处理
    safe_title = "".join(c if c.isalnum() or c in "-_" else "-" for c in title[:60]).strip("-")
    arxiv_id = paper["arxiv_id"]
    surname = first_author_surname(paper["authors"])
    year = paper["year"]
    filename = f"{surname}{year}-{arxiv_id}-{safe_title[:40]}.md"

    # 按 arXiv 分类建子目录
    cat = paper["primary_category"].split(".")[0] if paper["primary_category"] else "other"
    notes_dir = os.path.join(vault_path, "论文笔记", cat)
    os.makedirs(notes_dir, exist_ok=True)
    filepath = os.path.join(notes_dir, filename)

    # 查找是否有对应中文搜索词标注
    seed_tag = paper.get("seed_tag", "")

    # 生成 frontmatter
    frontmatter_lines = [
        "---",
        f"title: \"{title.replace(chr(34), chr(39))}\"",
        f"authors: \"{format_authors(paper['authors'])}\"",
        f"year: {year}",
        f"arxiv_id: \"{arxiv_id}\"",
        f"arxiv_url: \"{paper['arxiv_url']}\"",
        f"pdf_url: \"{paper['pdf_url']}\"",
        f"categories: {str(paper['categories'])}",
        f"seed: \"{seed_tag}\"",
        "tags: [paper, to-read]",
        "---",
    ]
    frontmatter = "\n".join(frontmatter_lines)

    # 生成笔记正文
    authors_str = format_authors(paper["authors"])
    note = f"""{frontmatter}

# {title}

**{authors_str}** ({year})

> [!info] arXiv: [{arxiv_id}]({paper['arxiv_url']}) | [PDF]({paper['pdf_url']})

## 摘要

{paper['abstract']}

## 笔记

<!-- 在此记录阅读笔记 -->

## 关键贡献

<!-- 核心方法、创新点 -->

## 与我研究的关联

<!-- 与线控底盘 / 车辆稳定性 / 域控制 / 嵌入式系统 的关联点 -->

## 参考文献追溯

<!-- 论文引用的重要文献，后续可能拓展阅读 -->
"""
    try:
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(note)
        return filepath
    except OSError as e:
        print(f"  写入失败 [{filepath}]: {e}", file=sys.stderr)
        return None


def batch_search_and_save(vault_path, queries=None, per_query=5):
    """批量检索并保存论文笔记。

    Args:
        vault_path: Obsidian vault 根目录
        queries: [(标签, arXiv查询字符串), ...]
        per_query: 每个查询最多获取几篇论文
    """
    if queries is None:
        queries = SEARCH_QUERIES

    total = 0
    saved = 0

    for tag, query in queries:
        print(f"\n[{tag}] 检索: {query[:80]}...")
        papers = search_arxiv(query, max_results=per_query)
        total += len(papers)
        print(f"  找到 {len(papers)} 篇")

        for p in papers:
            p["seed_tag"] = tag
            filepath = paper_to_obsidian_note(p, vault_path)
            if filepath:
                title_short = p["title"][:80]
                print(f"  + {title_short}")
                saved += 1
            time.sleep(0.3)  # arXiv API 礼貌节流

        time.sleep(1)  # 每个查询间休息

    print(f"\n=== 检索 {total} 篇，保存 {saved} 篇 ===")
    return saved, total


if __name__ == "__main__":
    vault = sys.argv[1] if len(sys.argv) > 1 else r"D:\桌面\Ob_Learning"
    per_query = int(sys.argv[2]) if len(sys.argv) > 2 else 5

    batch_search_and_save(vault, per_query=per_query)
