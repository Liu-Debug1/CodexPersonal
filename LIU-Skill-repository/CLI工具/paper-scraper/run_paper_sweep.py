#!/usr/bin/env python3
"""论文采集主控脚本 — 一键运行所有数据源，生成 Obsidian 笔记。

用法:
  python run_paper_sweep.py                          # 默认全源采集
  python run_paper_sweep.py --arxiv-only             # 仅 arXiv
  python run_paper_sweep.py --per-query 3            # 每个关键词取 3 篇
  python run_paper_sweep.py --query "my search"      # 自定义搜索
  python run_paper_sweep.py --dry-run                # 仅检索，不生成笔记

数据源:
  - arXiv API (免费，国内直连) — 主力
  - Google Scholar (CloakBrowser) — 补充
"""

import argparse
import os
import sys
import time
from datetime import datetime

# 工具路径
TOOL_DIR = os.path.dirname(os.path.abspath(__file__))

sys.path.insert(0, TOOL_DIR)
from arxiv_scraper import batch_search_and_save as arxiv_sweep, SEARCH_QUERIES as ARXIV_QUERIES


def scholar_sweep(vault_path, per_query):
    """Google Scholar 采集（需要 CloakBrowser）。"""
    from scholar_scraper import batch_scholar_search
    return batch_scholar_search(vault_path, per_query=per_query)


def main():
    parser = argparse.ArgumentParser(description="论文采集 → Obsidian 笔记管线")
    parser.add_argument("--vault", default=r"D:\桌面\Ob_Learning", help="Obsidian vault 路径")
    parser.add_argument("--per-query", type=int, default=5, help="每个关键词取几篇")
    parser.add_argument("--arxiv-only", action="store_true", help="仅运行 arXiv")
    parser.add_argument("--scholar-only", action="store_true", help="仅运行 Google Scholar")
    parser.add_argument("--query", action="append", help="自定义关键词 (可多次使用)")
    parser.add_argument("--dry-run", action="store_true", help="仅检索，不保存笔记")
    parser.add_argument("--no-scholar", action="store_true", help="跳过 Scholar")
    args = parser.parse_args()

    vault_path = args.vault
    if not os.path.isdir(vault_path):
        print(f"错误: vault 路径不存在: {vault_path}")
        sys.exit(1)

    start_time = time.time()
    print("=" * 60)
    print(f"论文采集任务 — {datetime.now().strftime('%Y-%m-%d %H:%M')}")
    print(f"Vault: {vault_path}")
    print(f"每关键词篇数: {args.per_query}")
    print("=" * 60)

    total_saved = 0
    total_found = 0

    # --- arXiv ---
    if not args.scholar_only:
        print("\n" + "=" * 40)
        print("[1/2] arXiv API 检索")
        print("=" * 40)

        queries = None
        if args.query:
            queries = [(f"custom:{q[:30]}", q) for q in args.query]

        if args.dry_run:
            from arxiv_scraper import search_arxiv
            qs = queries or ARXIV_QUERIES
            for tag, q in qs:
                papers = search_arxiv(q, max_results=args.per_query)
                total_found += len(papers)
                print(f"  [{tag}] 找到 {len(papers)} 篇")
        else:
            saved, found = arxiv_sweep(vault_path, queries=queries, per_query=args.per_query)
            total_saved += saved
            total_found += found

    # --- Google Scholar ---
    if not args.arxiv_only and not args.no_scholar:
        print("\n" + "=" * 40)
        print("[2/2] Google Scholar 检索 (CloakBrowser)")
        print("=" * 40)

        try:
            from scholar_scraper import batch_scholar_search as sch_sweep

            queries = None
            if args.query:
                queries = [(f"scholar:{q[:30]}", q) for q in args.query]

            if args.dry_run:
                print("  (dry-run 模式，跳过 Scholar 实际调用)")
            else:
                saved = sch_sweep(vault_path, queries=queries, per_query=min(args.per_query, 3))
                total_saved += saved
        except ImportError as e:
            print(f"  Scholar 采集器不可用: {e}")
            print("  可能需要先运行 download_binary.py 下载 CloakBrowser 二进制")

    elapsed = time.time() - start_time
    print("\n" + "=" * 60)
    print(f"采集完成 — 耗时 {elapsed:.0f}s — 找到 {total_found} 篇, 保存 {total_saved} 篇")
    print(f"笔记位置: {os.path.join(vault_path, '论文笔记')}")
    print("=" * 60)


if __name__ == "__main__":
    main()
