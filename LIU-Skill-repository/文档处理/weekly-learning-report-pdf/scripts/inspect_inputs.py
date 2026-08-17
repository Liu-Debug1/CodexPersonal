from __future__ import annotations

import argparse
import json
import logging
import re
from pathlib import Path

import pdfplumber
from docx import Document
from docx.oxml.ns import qn
from pypdf import PdfReader


def normalize_text(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip()


def extract_image_parts(document: Document) -> list[str]:
    names: list[str] = []
    seen: set[str] = set()
    for blip in document.element.body.xpath(".//a:blip"):
        relationship_id = blip.get(qn("r:embed"))
        if not relationship_id or relationship_id in seen:
            continue
        seen.add(relationship_id)
        part = document.part.related_parts.get(relationship_id)
        if part is not None:
            names.append(Path(str(part.partname)).name)
    return names


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Inspect a weekly report DOCX and learning-notes PDF."
    )
    parser.add_argument("--docx", type=Path, required=True)
    parser.add_argument("--pdf", type=Path, required=True)
    parser.add_argument("--preview-chars", type=int, default=500)
    args = parser.parse_args()

    if not args.docx.is_file():
        raise FileNotFoundError(args.docx)
    if not args.pdf.is_file():
        raise FileNotFoundError(args.pdf)

    document = Document(str(args.docx))
    points = [p.text for p in document.paragraphs if p.text.strip()]
    image_names = extract_image_parts(document)

    logging.getLogger("pdfminer").setLevel(logging.ERROR)
    reader = PdfReader(str(args.pdf))
    pages: list[dict[str, object]] = []
    with pdfplumber.open(args.pdf) as pdf:
        for page_number, page in enumerate(pdf.pages, 1):
            text = normalize_text(page.extract_text() or "")
            pages.append(
                {
                    "page": page_number,
                    "preview": text[: args.preview_chars],
                    "characters": len(text),
                }
            )

    result = {
        "docx": str(args.docx.resolve()),
        "pdf": str(args.pdf.resolve()),
        "report_points": points,
        "report_point_count": len(points),
        "embedded_images": image_names,
        "embedded_image_count": len(image_names),
        "pdf_page_count": len(reader.pages),
        "pages": pages,
    }
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
