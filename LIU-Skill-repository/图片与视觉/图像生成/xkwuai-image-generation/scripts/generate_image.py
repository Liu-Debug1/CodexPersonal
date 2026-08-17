#!/usr/bin/env python3
"""Generate one or more images through an OpenAI-compatible XKWUAI endpoint."""

from __future__ import annotations

import argparse
import base64
import json
import os
import pathlib
import sys
import urllib.error
import urllib.parse
import urllib.request


MAX_RESPONSE_BYTES = 50 * 1024 * 1024


def build_url(base_url: str, endpoint: str) -> str:
    """Join URL parts while avoiding a duplicated /v1 path segment."""
    base = base_url.rstrip("/")
    path = "/" + endpoint.lstrip("/")
    if base.endswith("/v1") and path.startswith("/v1/"):
        path = path[3:]
    return base + path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prompt", required=True, help="Image prompt")
    parser.add_argument("--output", required=True, help="Output file path")
    parser.add_argument("--size", default="1024x1024", help="Image size, e.g. 1024x1024")
    parser.add_argument("--quality", default="medium", choices=("low", "medium", "high", "auto"))
    parser.add_argument("--n", type=int, default=1, help="Number of images to request")
    parser.add_argument("--timeout", type=float, default=180.0, help="HTTP timeout in seconds")
    return parser.parse_args()


def require_https_url(value: object) -> str:
    """Return a response image URL only when it is an absolute HTTPS URL."""
    if not isinstance(value, str):
        raise RuntimeError("API response image URL is not a string")

    parsed = urllib.parse.urlparse(value)
    if parsed.scheme != "https" or not parsed.netloc:
        raise RuntimeError("API response image URL must be an absolute HTTPS URL")
    return value


def sanitize_error_detail(value: str, api_key: str) -> str:
    """Limit error output and prevent a server echo from exposing the configured key."""
    return value.replace(api_key, "[REDACTED]")[:2000]


class HTTPSOnlyRedirectHandler(urllib.request.HTTPRedirectHandler):
    """Reject redirects that leave HTTPS while retrieving API output."""

    def redirect_request(
        self, req: urllib.request.Request, fp: object, code: int, msg: str, headers: object, newurl: str
    ) -> urllib.request.Request | None:
        require_https_url(newurl)
        return super().redirect_request(req, fp, code, msg, headers, newurl)


def open_https(request: urllib.request.Request | str, timeout: float):
    """Open an HTTPS request while keeping every redirect on HTTPS."""
    return urllib.request.build_opener(HTTPSOnlyRedirectHandler()).open(request, timeout=timeout)


def read_limited(response: object) -> bytes:
    """Read a response within the fixed download limit."""
    content_length = response.headers.get("Content-Length")
    if content_length and int(content_length) > MAX_RESPONSE_BYTES:
        raise RuntimeError(f"response exceeds the {MAX_RESPONSE_BYTES} byte limit")

    data = response.read(MAX_RESPONSE_BYTES + 1)
    if len(data) > MAX_RESPONSE_BYTES:
        raise RuntimeError(f"response exceeds the {MAX_RESPONSE_BYTES} byte limit")
    return data


def save_item(
    item: dict, output_path: pathlib.Path, index: int, total: int, timeout: float
) -> pathlib.Path:
    """Save one API image item, adding an index when multiple images were requested."""
    path = output_path
    if total > 1:
        path = output_path.with_name(f"{output_path.stem}-{index + 1}{output_path.suffix or '.png'}")

    if item.get("b64_json"):
        data = base64.b64decode(item["b64_json"])
    elif item.get("url"):
        image_url = require_https_url(item["url"])
        with open_https(image_url, timeout=timeout) as response:
            data = read_limited(response)
    else:
        raise RuntimeError("API response item contained neither b64_json nor url")

    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)
    return path


def main() -> int:
    args = parse_args()
    api_key = os.environ.get("XKWUAI_API_KEY")
    if not api_key:
        print("Missing XKWUAI_API_KEY. Set it in the environment and retry.", file=sys.stderr)
        return 2
    if args.n < 1:
        print("--n must be at least 1", file=sys.stderr)
        return 2
    if args.timeout <= 0:
        print("--timeout must be greater than 0", file=sys.stderr)
        return 2

    base_url = os.environ.get("XKWUAI_BASE_URL", "https://www.xkwuai.cn/v1")
    endpoint = os.environ.get("XKWUAI_ENDPOINT", "/v1/images/generations")
    model = os.environ.get("XKWUAI_MODEL", "gpt-image-2")
    try:
        require_https_url(base_url)
    except RuntimeError as exc:
        print(f"Invalid XKWUAI_BASE_URL: {exc}", file=sys.stderr)
        return 2
    url = build_url(base_url, endpoint)
    payload = {
        "model": model,
        "prompt": args.prompt,
        "size": args.size,
        "quality": args.quality,
        "n": args.n,
    }
    request = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
            "Accept": "application/json",
        },
        method="POST",
    )

    try:
        with open_https(request, timeout=args.timeout) as response:
            body = read_limited(response)
            status = response.status
    except urllib.error.HTTPError as exc:
        try:
            body = read_limited(exc)
        except RuntimeError as read_error:
            print(f"XKWUAI request failed with HTTP {exc.code}: {read_error}", file=sys.stderr)
            return 1
        try:
            detail = json.loads(body.decode("utf-8", errors="replace"))
            detail_text = json.dumps(detail, ensure_ascii=False)
        except json.JSONDecodeError:
            detail_text = body.decode("utf-8", errors="replace")[:2000]
        detail_text = sanitize_error_detail(detail_text, api_key)
        print(f"XKWUAI request failed with HTTP {exc.code}: {detail_text}", file=sys.stderr)
        return 1
    except (urllib.error.URLError, TimeoutError) as exc:
        print(f"XKWUAI request failed: {exc}", file=sys.stderr)
        return 1

    try:
        result = json.loads(body.decode("utf-8"))
        items = result["data"]
        if not isinstance(items, list) or not items:
            raise ValueError("response data is empty or not a list")
        saved = [
            save_item(item, pathlib.Path(args.output), i, len(items), args.timeout)
            for i, item in enumerate(items)
        ]
    except (json.JSONDecodeError, KeyError, TypeError, ValueError, RuntimeError, base64.binascii.Error) as exc:
        print(f"Received HTTP {status}, but could not save the image: {exc}", file=sys.stderr)
        return 1

    for path in saved:
        print(path.resolve())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
