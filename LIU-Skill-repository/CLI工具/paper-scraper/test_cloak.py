"""测试 CloakBrowser 能否正常访问论文检索站点。

首次运行会自动下载 CloakBrowser 定制 Chromium（约 200MB），请耐心等待。
"""

from cloakbrowser import launch

TEST_SITES = [
    ("arXiv", "https://arxiv.org/search/?query=vehicle+stability+control&searchtype=all"),
    ("Semantic Scholar", "https://api.semanticscholar.org/graph/v1/paper/search?query=steer-by-wire&limit=3"),
    ("IEEE Xplore", "https://ieeexplore.ieee.org/search/searchresult.jsp?queryText=vehicle%20stability"),
    ("Google Scholar", "https://scholar.google.com/scholar?q=automotive+steer-by-wire+control"),
    ("ScienceDirect", "https://www.sciencedirect.com/search?qs=vehicle%20dynamics%20control"),
]

def test():
    print("正在启动 CloakBrowser（首次需下载 Chromium ~200MB）...")
    browser = launch(headless=True)

    page = browser.new_page()

    for name, url in TEST_SITES:
        try:
            print(f"\n[{name}] 访问中...")
            page.goto(url, timeout=30000)
            title = page.title()
            print(f"[{name}] 成功 — 页面标题: {title[:100]}")

            # 检查是否被拦截
            content = page.content()[:500].lower()
            if any(kw in content for kw in ["captcha", "verify", "blocked", "unusual traffic", "are you a robot"]):
                print(f"[{name}] ⚠ 可能被拦截，检测到验证关键词")

        except Exception as e:
            print(f"[{name}] 失败: {str(e)[:200]}")

    page.close()
    browser.close()
    print("\n测试完成。")

if __name__ == "__main__":
    test()
