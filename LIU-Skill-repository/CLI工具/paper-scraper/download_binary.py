"""手动下载 CloakBrowser Chromium 二进制文件并解压。

解决 httpx 在 Windows 上的 SSL 证书问题。
"""

import urllib.request
import ssl
import os
import zipfile
import sys
import time

DOWNLOAD_URL = "https://github.com/CloakHQ/cloakbrowser/releases/download/chromium-v146.0.7680.177.5/cloakbrowser-windows-x64.zip"
CACHE_DIR = os.path.expanduser("~/.cloakbrowser")
VERSION = "chromium-146.0.7680.177.5"
TARGET_DIR = os.path.join(CACHE_DIR, VERSION)
ZIP_PATH = os.path.join(CACHE_DIR, "cloakbrowser-windows-x64.zip")


def download():
    os.makedirs(CACHE_DIR, exist_ok=True)

    ssl_ctx = ssl.create_default_context()
    ssl_ctx.check_hostname = False
    ssl_ctx.verify_mode = ssl.CERT_NONE

    print(f"下载 CloakBrowser Chromium...")
    print(f"URL: {DOWNLOAD_URL}")
    print(f"保存到: {ZIP_PATH}")

    req = urllib.request.Request(DOWNLOAD_URL)
    req.add_header("User-Agent", "Mozilla/5.0")

    with urllib.request.urlopen(req, context=ssl_ctx, timeout=60) as resp:
        total = int(resp.headers.get("Content-Length", 0))
        downloaded = 0
        chunk_size = 1024 * 1024  # 1MB

        with open(ZIP_PATH, "wb") as f:
            while True:
                chunk = resp.read(chunk_size)
                if not chunk:
                    break
                f.write(chunk)
                downloaded += len(chunk)
                pct = downloaded / total * 100 if total else 0
                mb = downloaded / (1024 * 1024)
                total_mb = total / (1024 * 1024)
                print(f"\r  进度: {mb:.0f}/{total_mb:.0f} MB ({pct:.1f}%)", end="")
                sys.stdout.flush()

    print("\n下载完成，解压中...")
    os.makedirs(TARGET_DIR, exist_ok=True)

    with zipfile.ZipFile(ZIP_PATH, "r") as zf:
        # 检查是否有子目录包裹
        names = zf.namelist()
        # 提取所有文件
        zf.extractall(TARGET_DIR)

    print(f"解压完成: {TARGET_DIR}")

    # 删除 zip 以节省空间
    os.remove(ZIP_PATH)
    print(f"已删除临时文件: {ZIP_PATH}")

    # 写版本标记文件
    marker = os.path.join(TARGET_DIR, ".cloakbrowser-version")
    with open(marker, "w") as f:
        f.write(VERSION)

    print("安装完成!")


if __name__ == "__main__":
    start = time.time()
    download()
    elapsed = time.time() - start
    print(f"总耗时: {elapsed:.0f}s")
