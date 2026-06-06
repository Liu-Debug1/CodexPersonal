"""Google Scholar 论文采集器（CloakBrowser 驱动）。

用于搜索被 arXiv / Semantic Scholar 覆盖不全的论文。
依赖 CloakBrowser 绕过 Google Scholar 的反爬检测。
首次运行会自动启动无头浏览器，速度较慢但成功率高。

注意：Google Scholar 在国内需要代理/VPN。如果直接不可达，
本脚本会自动尝试无代理直连（CloakBrowser 自带一些网络层优化）。
"""

import sys
import os
import time
import re

# CloakBrowser 仅在导入时自动检查二进制
try:
    from cloakbrowser import launch
except Exception as e:
    print(f"CloakBrowser 不可用: {e}")
    print("请先运行 download_binary.py 下载 Chromium 二进制")
    sys.exit(1)


SCHOLAR_QUERIES = [
    ("线控转向SBW", "steer-by-wire vehicle stability control"),
    ("线控制动EMB", "electro-mechanical brake EMB vehicle"),
    ("域控制器", "automotive domain controller architecture ECU"),
    ("ISO 26262", "ISO 26262 functional safety automotive embedded"),
    ("车辆状态估计", "vehicle state estimation kalman observer"),
    ("MPC底盘控制", "model predictive control chassis vehicle dynam"),
]


def search_google_scholar(query, max_results=10, headless=True):
    """使用 CloakBrowser 搜索 Google Scholar。

    Returns:
        list[dict]: 论文信息列表，每项包含 title, authors, year, citations, snippet, url
    """
    search_url = f"https://scholar.google.com/scholar?q={query.replace(' ', '+')}&hl=en&as_sdt=0,5"

    papers = []
    browser = None

    try:
        print(f"  启动 CloakBrowser...", end="", flush=True)
        browser = launch(headless=headless, humanize=True)
        print(" 完成")

        page = browser.new_page()
        page.goto(search_url, timeout=45000)

        # 等结果加载
        page.wait_for_selector(".gs_r", timeout=30000)

        # 提取搜索结果
        results = page.query_selector_all(".gs_r")
        for i, result in enumerate(results[:max_results]):
            try:
                title_el = result.query_selector(".gs_rt a")
                title = title_el.inner_text().strip() if title_el else ""
                url = title_el.get_attribute("href") if title_el else ""

                # 作者和出版物
                meta_el = result.query_selector(".gs_a")
                meta_text = meta_el.inner_text().strip() if meta_el else ""

                # 解析作者、年份、出版物
                authors = ""
                year = ""
                venue = ""
                # 格式: "A Author, B Author - Venue, Year - Publisher"
                # 或: "A Author, ... - Year - Venue"
                year_match = re.search(r"\b(19|20)\d{2}\b", meta_text)
                if year_match:
                    year = year_match.group()
                    parts = meta_text.split(" - ")
                    if len(parts) >= 1:
                        authors = parts[0].strip()
                    if len(parts) >= 2:
                        venue = parts[1].replace(year, "").strip(", ")

                # 被引次数
                citations = 0
                cite_el = result.query_selector(".gs_fl a[href*='cites=']")
                if cite_el:
                    cite_text = cite_el.inner_text()
                    cite_match = re.search(r"\d+", cite_text)
                    if cite_match:
                        citations = int(cite_match.group())

                # 摘要片段
                snippet_el = result.query_selector(".gs_rs")
                snippet = snippet_el.inner_text().strip() if snippet_el else ""

                if title:
                    papers.append({
                        "title": title,
                        "authors": authors,
                        "year": year,
                        "venue": venue,
                        "citations": citations,
                        "snippet": snippet,
                        "url": url,
                        "source": "Google Scholar",
                    })

            except Exception as inner_e:
                print(f"  解析第 {i+1} 条结果失败: {inner_e}")
                continue

            if i >= max_results - 1:
                break

        page.close()

    except Exception as e:
        print(f"\n  Scholar 搜索失败 [{query[:50]}...]: {str(e)[:200]}")
    finally:
        if browser:
            try:
                browser.close()
            except Exception:
                pass

    return papers


def scholar_paper_to_obsidian(paper, vault_path, seed_tag=""):
    """将 Google Scholar 结果转为 Obsidian 笔记。"""
    # 文件名安全处理
    safe_title = "".join(c if c.isalnum() or c in "-_" else "-" for c in paper["title"][:60]).strip("-")
    first_author = paper["authors"].split(",")[0].split()[-1] if paper["authors"] else "Unknown"
    year = paper["year"] or "0000"
    filename = f"GScholar-{first_author}{year}-{safe_title[:40]}.md"

    notes_dir = os.path.join(vault_path, "论文笔记", "scholar")
    os.makedirs(notes_dir, exist_ok=True)
    filepath = os.path.join(notes_dir, filename)

    title = paper["title"].replace('"', "'")
    authors = paper["authors"]
    venue = paper["venue"]
    citations = paper["citations"]
    snippet = paper["snippet"]
    url = paper["url"]

    note = f"""---
title: "{title}"
authors: "{authors}"
year: {year}
venue: "{venue}"
citations: {citations}
scholar_url: "{url}"
seed: "{seed_tag}"
source: "Google Scholar"
tags: [paper, to-read, scholar]
---

# {title}

**{authors}** ({year}) — *{venue}*

> [!NOTE] 引用: {citations} | [Scholar]({url})

## 摘要片段

{snippet}

## 笔记

<!-- 在此记录阅读笔记 -->

## 关键贡献

<!-- 核心方法、创新点 -->

## 与我研究的关联

<!-- 与线控底盘 / 车辆稳定性 / 域控制 / 嵌入式系统 的关联 -->
"""
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(note)
    return filepath


def batch_scholar_search(vault_path, queries=None, per_query=5):
    """批量搜索 Google Scholar 并生成笔记。"""
    if queries is None:
        queries = SCHOLAR_QUERIES

    total_saved = 0
    for tag, query in queries:
        print(f"\n[Scholar: {tag}] 搜索...")
        papers = search_google_scholar(query, max_results=per_query)
        print(f"  找到 {len(papers)} 条结果")

        for p in papers:
            fp = scholar_paper_to_obsidian(p, vault_path, seed_tag=tag)
            if fp:
                print(f"  + {p['title'][:80]}")
                total_saved += 1
            time.sleep(2)  # Google Scholar 反爬间隔

    print(f"\n=== Scholar 保存 {total_saved} 篇 ===")
    return total_saved


if __name__ == "__main__":
    vault = sys.argv[1] if len(sys.argv) > 1 else r"D:\桌面\Ob_Learning"
    per_query = int(sys.argv[2]) if len(sys.argv) > 2 else 3
    batch_scholar_search(vault, per_query=per_query)
