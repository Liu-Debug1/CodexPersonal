# XKWUAI API notes

The skill targets an OpenAI-compatible image-generation request:

- Base URL: `https://www.xkwuai.cn/v1`
- Endpoint: `/v1/images/generations`
- Default model: `gpt-image-2`
- Authentication: `Authorization: Bearer $XKWUAI_API_KEY`
- Request body: `model`, `prompt`, `size`, `quality`, and `n`
- Expected response: JSON with `data[]`, where each item contains either `b64_json` or `url`.

This package intentionally contains no API key. Each deployer must enter their own key locally through `XKWUAI_API_KEY`. Keep credentials outside this file and override the defaults through environment variables when needed.
