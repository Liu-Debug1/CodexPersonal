---
name: xkwuai-image-generation
description: Generate new raster images through the XKWUAI OpenAI-compatible Images API using model gpt-image-2. Use when the user asks to create, illustrate, visualize, or render an image via XKWUAI, including requests for prompt-based image generation, size/quality selection, or saving generated image files.
---

# XKWUAI Image Generation

Generate images through the bundled `scripts/generate_image.py` client. Keep the API key in the environment; never write it into this skill, source files, shell history, or user-facing output.

## Configuration

This skill is distributed without an API key. Each person who deploys it must enter and configure their own key locally before generating an image. Never put the key into `SKILL.md`, `openai.yaml`, scripts, ZIP files, prompts, or chat messages.

Set these environment variables before calling the script:

- `XKWUAI_API_KEY` — required; enter your own XKWUAI API key locally.
- `XKWUAI_BASE_URL` — optional base URL; defaults to `https://www.xkwuai.cn/v1`.
- `XKWUAI_ENDPOINT` — optional endpoint; defaults to `/v1/images/generations`.
- `XKWUAI_MODEL` — optional model; defaults to `gpt-image-2`.

For macOS/Linux:

```bash
export XKWUAI_API_KEY='your-own-key'
```

For Windows PowerShell:

```powershell
$env:XKWUAI_API_KEY = 'your-own-key'
```

If the key is not configured, ask the user to set it in their local environment and retry; do not ask them to paste it into a public prompt or store it in the skill package. The client normalizes `/v1` so a base URL ending in `/v1` can safely be used with the full `/v1/images/generations` endpoint.

## Generate an image

Run:

```bash
python3 /Users/liyong/.codex/skills/xkwuai-image-generation/scripts/generate_image.py \
  --prompt "A concise visual description" \
  --output "/absolute/path/to/output.png" \
  --size 1024x1024 \
  --quality medium
```

The script accepts `--prompt`, `--output`, `--size`, `--quality`, `--n`, and `--timeout`. It accepts either a base64 image response (`b64_json`) or an image URL (`url`). For URL responses, it downloads the image before saving it. If the API returns an error, print the HTTP status and sanitized response body without exposing the API key.

## Prompting guidance

- Translate vague requests into a concrete subject, composition, visual style, lighting, palette, aspect ratio, and intended use.
- Preserve user-specified text exactly, but keep text short and use a clean layout.
- For a first draft, use `1024x1024` and `quality=medium`; use `quality=high` for a final asset or dense text.
- Do not claim an image was generated until the output file exists and can be inspected.

## Example

```bash
export XKWUAI_API_KEY='your-own-key'
python3 /Users/liyong/.codex/skills/xkwuai-image-generation/scripts/generate_image.py \
  --prompt "Editorial illustration of a red fox reading beside a rainy window, warm lamp light, textured gouache, square composition" \
  --output "./outputs/fox-reading.png"
```
