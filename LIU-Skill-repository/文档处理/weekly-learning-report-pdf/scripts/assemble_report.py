from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
import shutil
import subprocess
from dataclasses import dataclass
from datetime import datetime
from io import BytesIO
from pathlib import Path

from docx import Document
from docx.oxml.ns import qn
from PIL import Image, ImageDraw
from pypdf import PdfReader, PdfWriter, Transformation
from pypdf._page import PageObject
from reportlab.lib.colors import HexColor
from reportlab.lib.pagesizes import A4, landscape
from reportlab.lib.utils import ImageReader
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.cidfonts import UnicodeCIDFont
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen import canvas


INK = HexColor("#1F2933")
RULE = HexColor("#D8E1E7")
PAPER = HexColor("#FFFFFF")


@dataclass(frozen=True)
class ImageAsset:
    name: str
    data: bytes
    width: int
    height: int


def parse_ranges(value: str) -> list[tuple[int, int]]:
    ranges: list[tuple[int, int]] = []
    for item in value.split(","):
        item = item.strip()
        if not item:
            continue
        if "-" in item:
            start_text, end_text = item.split("-", 1)
        else:
            start_text = end_text = item
        start = int(start_text)
        end = int(end_text)
        if start < 1 or end < start:
            raise ValueError(f"Invalid page range: {item}")
        ranges.append((start - 1, end))
    if not ranges:
        raise ValueError("At least one page range is required")
    return ranges


def validate_ranges(ranges: list[tuple[int, int]], page_count: int) -> None:
    cursor = 0
    for start, end in ranges:
        if start != cursor:
            raise ValueError(
                f"Page ranges must be continuous: expected page {cursor + 1}, "
                f"found page {start + 1}"
            )
        if end <= start or end > page_count:
            raise ValueError(f"Page range {start + 1}-{end} is out of bounds")
        cursor = end
    if cursor != page_count:
        raise ValueError(
            f"Page ranges end at page {cursor}, but source PDF has {page_count} pages"
        )


def register_fonts() -> tuple[str, str]:
    regular_path = Path(r"C:\Windows\Fonts\msyh.ttc")
    bold_path = Path(r"C:\Windows\Fonts\msyhbd.ttc")
    if regular_path.exists() and bold_path.exists():
        pdfmetrics.registerFont(
            TTFont("MicrosoftYaHei", str(regular_path), subfontIndex=0)
        )
        pdfmetrics.registerFont(
            TTFont("MicrosoftYaHei-Bold", str(bold_path), subfontIndex=0)
        )
        return "MicrosoftYaHei", "MicrosoftYaHei-Bold"
    pdfmetrics.registerFont(UnicodeCIDFont("STSong-Light"))
    return "STSong-Light", "STSong-Light"


def wrap_text(
    text: str, font_name: str, font_size: float, max_width: float
) -> list[str]:
    lines: list[str] = []
    current = ""
    for character in text:
        if character == "\n":
            lines.append(current)
            current = ""
            continue
        candidate = current + character
        if current and pdfmetrics.stringWidth(
            candidate, font_name, font_size
        ) > max_width:
            lines.append(current)
            current = character
        else:
            current = candidate
    if current or not lines:
        lines.append(current)
    return lines


def page_from_bytes(buffer: BytesIO):
    buffer.seek(0)
    return PdfReader(buffer).pages[0]


def extract_images(document: Document) -> list[ImageAsset]:
    assets: list[ImageAsset] = []
    seen: set[str] = set()
    for blip in document.element.body.xpath(".//a:blip"):
        relationship_id = blip.get(qn("r:embed"))
        if not relationship_id or relationship_id in seen:
            continue
        seen.add(relationship_id)
        relationship = document.part.rels.get(relationship_id)
        if relationship is None or relationship.target_part is None:
            continue
        part = relationship.target_part
        data = part.blob
        with Image.open(BytesIO(data)) as image:
            width, height = image.size
        assets.append(
            ImageAsset(
                name=Path(str(part.partname)).name,
                data=data,
                width=width,
                height=height,
            )
        )
    return assets


def make_section_start_page(
    section_number: int,
    exact_text: str,
    source_page,
    regular_font: str,
    page_size: tuple[float, float],
):
    width, height = page_size
    scale = min(width / A4[0], height / A4[1])
    margin = 42 * scale
    font_size = 12.5 * scale
    line_height = 22 * scale
    heading = f"{section_number}.{exact_text}"
    lines = wrap_text(heading, regular_font, font_size, width - 2 * margin)
    header_height = 34 * scale + len(lines) * line_height
    content_top = height - header_height
    bottom_margin = 12 * scale
    content_scale = (content_top - bottom_margin) / height
    content_width = width * content_scale
    content_x = (width - content_width) / 2

    page = PageObject.create_blank_page(width=width, height=height)
    page.merge_transformed_page(
        source_page,
        Transformation().scale(content_scale, content_scale).translate(
            content_x, bottom_margin
        ),
    )

    buffer = BytesIO()
    pdf = canvas.Canvas(buffer, pagesize=page_size)
    y = height - 24 * scale
    pdf.setFillColor(INK)
    pdf.setFont(regular_font, font_size)
    for line in lines:
        pdf.drawString(margin, y, line)
        y -= line_height
    pdf.setStrokeColor(RULE)
    pdf.setLineWidth(0.8 * scale)
    pdf.line(margin, content_top + 7 * scale, width - margin, content_top + 7 * scale)
    pdf.save()
    page.merge_page(page_from_bytes(buffer))
    return page


def make_montage_page(
    assets: list[ImageAsset],
    show_label: bool,
    regular_font: str,
    bold_font: str,
    base_page_size: tuple[float, float],
    label: str,
):
    page_size = landscape(base_page_size)
    width, height = page_size
    scale = width / landscape(A4)[0]
    buffer = BytesIO()
    pdf = canvas.Canvas(buffer, pagesize=page_size)
    pdf.setFillColor(PAPER)
    pdf.rect(0, 0, width, height, fill=1, stroke=0)

    margin = 34 * scale
    gap = 18 * scale
    if show_label:
        top = height - 62 * scale
        pdf.setFillColor(INK)
        pdf.setFont(bold_font, 13 * scale)
        pdf.drawString(margin, height - 34 * scale, label)
        pdf.setStrokeColor(RULE)
        pdf.setLineWidth(0.8 * scale)
        pdf.line(margin, height - 48 * scale, width - margin, height - 48 * scale)
    else:
        top = height - 34 * scale
    bottom = 34 * scale
    column_count = len(assets)
    column_width = (width - 2 * margin - (column_count - 1) * gap) / column_count
    available_height = top - bottom

    for index, asset in enumerate(assets):
        draw_scale = min(
            column_width / asset.width, available_height / asset.height
        )
        draw_width = asset.width * draw_scale
        draw_height = asset.height * draw_scale
        column_x = margin + index * (column_width + gap)
        x = column_x + (column_width - draw_width) / 2
        y = top - draw_height
        pdf.drawImage(
            ImageReader(BytesIO(asset.data)),
            x,
            y,
            width=draw_width,
            height=draw_height,
            preserveAspectRatio=True,
            mask="auto",
        )
        pdf.setStrokeColor(RULE)
        pdf.rect(x, y, draw_width, draw_height, fill=0, stroke=1)

    pdf.save()
    return page_from_bytes(buffer)


def bookmark_label(index: int) -> str:
    numerals = [
        "",
        "\u4e00",
        "\u4e8c",
        "\u4e09",
        "\u56db",
        "\u4e94",
        "\u516d",
        "\u4e03",
        "\u516b",
        "\u4e5d",
        "\u5341",
    ]
    if index < len(numerals):
        return f"\u7b2c{numerals[index]}\u70b9"
    return f"\u7b2c{index}\u70b9"


def page_digest(page) -> str:
    contents = page.get_contents()
    data = contents.get_data() if contents is not None else b""
    return hashlib.sha256(data).hexdigest()


def write_pdf(writer: PdfWriter, output: Path) -> Path:
    output.parent.mkdir(parents=True, exist_ok=True)
    temporary = output.with_name(f".{output.stem}.tmp{output.suffix}")
    with temporary.open("wb") as output_file:
        writer.write(output_file)
    try:
        os.replace(temporary, output)
        return output
    except PermissionError:
        timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        fallback = output.with_name(f"{output.stem}_{timestamp}{output.suffix}")
        os.replace(temporary, fallback)
        return fallback


def find_pdftoppm() -> Path:
    bundled = (
        Path.home()
        / ".cache"
        / "codex-runtimes"
        / "codex-primary-runtime"
        / "dependencies"
        / "native"
        / "poppler"
        / "Library"
        / "bin"
        / "pdftoppm.exe"
    )
    if bundled.is_file():
        return bundled
    for command in ("pdftoppm.exe", "pdftoppm"):
        resolved = shutil.which(command)
        if resolved:
            return Path(resolved)
    raise FileNotFoundError("Poppler pdftoppm was not found")


def make_contact_sheets(page_images: list[Path], render_dir: Path) -> list[Path]:
    contact_dir = render_dir / "contact"
    contact_dir.mkdir(parents=True, exist_ok=True)
    for old_file in contact_dir.glob("contact-*.png"):
        old_file.unlink()

    thumb_width, thumb_height = 480, 680
    cell_width, cell_height = 500, 720
    outputs: list[Path] = []
    for start in range(0, len(page_images), 4):
        sheet = Image.new("RGB", (cell_width * 2, cell_height * 2), "white")
        draw = ImageDraw.Draw(sheet)
        for slot, path in enumerate(page_images[start : start + 4]):
            with Image.open(path).convert("RGB") as image:
                image.thumbnail(
                    (thumb_width, thumb_height), Image.Resampling.LANCZOS
                )
                x = (slot % 2) * cell_width + (cell_width - image.width) // 2
                y = (
                    (slot // 2) * cell_height
                    + 28
                    + (thumb_height - image.height) // 2
                )
                sheet.paste(image, (x, y))
            draw.text(
                (slot % 2 * cell_width + 10, slot // 2 * cell_height + 8),
                path.stem,
                fill="black",
            )
        output = contact_dir / (
            f"contact-{start + 1:02d}-{min(start + 4, len(page_images)):02d}.png"
        )
        sheet.save(output)
        outputs.append(output)
    return outputs


def render_and_validate(pdf_path: Path, render_dir: Path) -> dict[str, object]:
    render_dir.mkdir(parents=True, exist_ok=True)
    for old_file in render_dir.glob("page-*.png"):
        old_file.unlink()
    pdftoppm = find_pdftoppm()
    prefix = render_dir / "page"
    process = subprocess.run(
        [str(pdftoppm), "-png", "-r", "120", str(pdf_path), str(prefix)],
        capture_output=True,
        text=True,
        check=False,
    )
    if process.returncode != 0:
        raise RuntimeError(process.stderr.strip() or "pdftoppm failed")

    page_images = sorted(render_dir.glob("page-*.png"))
    page_count = len(PdfReader(str(pdf_path)).pages)
    if len(page_images) != page_count:
        raise RuntimeError(
            f"Rendered {len(page_images)} pages, expected {page_count}"
        )

    nonwhite_ratios: list[float] = []
    dimensions: set[tuple[int, int]] = set()
    for path in page_images:
        with Image.open(path).convert("RGB") as image:
            dimensions.add(image.size)
            histogram = image.convert("L").histogram()
            ratio = sum(histogram[:245]) / (image.width * image.height)
            nonwhite_ratios.append(ratio)
    blank_pages = [
        index + 1 for index, ratio in enumerate(nonwhite_ratios) if ratio < 0.001
    ]
    if blank_pages:
        raise RuntimeError(f"Blank rendered pages detected: {blank_pages}")

    contact_sheets = make_contact_sheets(page_images, render_dir)
    return {
        "rendered_pages": len(page_images),
        "minimum_nonwhite_ratio": min(nonwhite_ratios),
        "rendered_dimensions": sorted(dimensions),
        "contact_sheets": [str(path.resolve()) for path in contact_sheets],
    }


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Build and validate a weekly learning-report PDF."
    )
    parser.add_argument("--docx", type=Path, required=True)
    parser.add_argument("--pdf", type=Path, required=True)
    parser.add_argument("--ranges", required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--render-dir", type=Path, required=True)
    parser.add_argument(
        "--image-label", default="\u590d\u7528\u51fd\u6570\u6a21\u677f"
    )
    args = parser.parse_args()

    if not args.docx.is_file():
        raise FileNotFoundError(args.docx)
    if not args.pdf.is_file():
        raise FileNotFoundError(args.pdf)

    ranges = parse_ranges(args.ranges)
    source = PdfReader(str(args.pdf))
    validate_ranges(ranges, len(source.pages))
    document = Document(str(args.docx))
    all_points = [p.text for p in document.paragraphs if p.text.strip()]
    if len(all_points) < len(ranges):
        raise ValueError(
            f"DOCX has {len(all_points)} report points, but {len(ranges)} ranges were given"
        )
    points = all_points[: len(ranges)]
    images = extract_images(document)
    regular_font, bold_font = register_fonts()

    page_size = (
        float(source.pages[0].mediabox.width),
        float(source.pages[0].mediabox.height),
    )
    if any(
        float(page.mediabox.width) != page_size[0]
        or float(page.mediabox.height) != page_size[1]
        for page in source.pages
    ):
        raise ValueError("Source PDF pages do not share one page size")

    writer = PdfWriter()
    section_starts: list[int] = []
    modified_source_pages: set[int] = set()
    for section_number, (start, end) in enumerate(ranges, 1):
        section_starts.append(len(writer.pages))
        modified_source_pages.add(start)
        writer.add_page(
            make_section_start_page(
                section_number,
                points[section_number - 1],
                source.pages[start],
                regular_font,
                page_size,
            )
        )
        for page_index in range(start + 1, end):
            writer.add_page(source.pages[page_index])

    montage_start = len(writer.pages)
    montage_page_count = 0
    for group_start in range(0, len(images), 3):
        group = images[group_start : group_start + 3]
        writer.add_page(
            make_montage_page(
                group,
                show_label=group_start == 0,
                regular_font=regular_font,
                bold_font=bold_font,
                base_page_size=page_size,
                label=args.image_label,
            )
        )
        montage_page_count += 1

    for section_number, page_number in enumerate(section_starts, 1):
        writer.add_outline_item(bookmark_label(section_number), page_number)
    if images:
        writer.add_outline_item(args.image_label, montage_start)
    writer.add_metadata(
        {
            "/Title": f"{args.pdf.stem}_weekly_learning_report",
            "/Subject": "Weekly learning report and notes assembly",
        }
    )

    actual_output = write_pdf(writer, args.output)
    final = PdfReader(str(actual_output))
    expected_pages = len(source.pages) + montage_page_count
    if len(final.pages) != expected_pages:
        raise RuntimeError(
            f"Final PDF has {len(final.pages)} pages, expected {expected_pages}"
        )

    unchanged_match = True
    for page_index in range(len(source.pages)):
        if page_index in modified_source_pages:
            continue
        unchanged_match = unchanged_match and (
            page_digest(source.pages[page_index]) == page_digest(final.pages[page_index])
            and source.pages[page_index].mediabox == final.pages[page_index].mediabox
        )
    if not unchanged_match:
        raise RuntimeError("An unmodified source PDF page changed unexpectedly")

    render_summary = render_and_validate(actual_output, args.render_dir)
    result = {
        "output": str(actual_output.resolve()),
        "source_pages": len(source.pages),
        "final_pages": len(final.pages),
        "ranges": [f"{start + 1}-{end}" for start, end in ranges],
        "report_points": points,
        "embedded_images": len(images),
        "montage_pages": montage_page_count,
        "unchanged_source_pages_match": unchanged_match,
        **render_summary,
    }
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
