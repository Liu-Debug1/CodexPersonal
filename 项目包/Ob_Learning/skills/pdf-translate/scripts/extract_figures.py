#!/usr/bin/env python3
"""
extract_figures.py — Extract figures from original PDF for embedding in translated output.

Two extraction methods:
  1. Embedded images: extract raster/vector images stored inside the PDF
  2. Page-region crops: render page regions for figures not stored as separate objects

Usage:
    python3 scripts/extract_figures.py <input.pdf> <output_dir>

Output:
    <output_dir>/embedded_p{page}_{idx}.{ext}   — embedded images
    <output_dir>/page_{page:02d}.png            — full-page renders (300 DPI)
    <output_dir>/crop_*.png                     — cropped regions (if --crop used)
"""

import sys, os, argparse
import fitz  # PyMuPDF


def extract_embedded(doc, out_dir):
    """Extract raster/vector images embedded in the PDF."""
    count = 0
    for i in range(doc.page_count):
        for idx, img in enumerate(doc[i].get_images()):
            xref = img[0]
            base = doc.extract_image(xref)
            ext = base["ext"]
            fname = f"embedded_p{i+1}_{idx}.{ext}"
            path = os.path.join(out_dir, fname)
            with open(path, "wb") as f:
                f.write(base["image"])
            size_kb = len(base["image"]) / 1024
            print(f"  [embedded] {fname}  ({base['width']}x{base['height']}, {size_kb:.0f} KB)")
            count += 1
    return count


def render_pages(doc, out_dir, dpi=300):
    """Render every page as a high-resolution PNG (fallback for missing figures)."""
    scale = dpi / 72.0
    mat = fitz.Matrix(scale, scale)
    for i in range(doc.page_count):
        pix = doc[i].get_pixmap(matrix=mat)
        fname = f"page_{i+1:02d}.png"
        pix.save(os.path.join(out_dir, fname))
        print(f"  [page] {fname}  ({pix.width}x{pix.height})")


def crop_region(doc, page_idx, y0, y1, out_dir, name, dpi=300):
    """Crop a vertical region from a page and save as PNG."""
    scale = dpi / 72.0
    mat = fitz.Matrix(scale, scale)
    page = doc[page_idx]  # 0-indexed
    rect = fitz.Rect(page.rect.x0, y0, page.rect.x1, y1)
    pix = page.get_pixmap(matrix=mat, clip=rect)
    fname = f"crop_{name}.png"
    pix.save(os.path.join(out_dir, fname))
    print(f"  [crop] {fname}  ({pix.width}x{pix.height})")
    return fname


def main():
    parser = argparse.ArgumentParser(description="Extract figures from PDF")
    parser.add_argument("input", help="Input PDF file")
    parser.add_argument("out_dir", help="Output directory for extracted figures")
    parser.add_argument("--no-pages", action="store_true", help="Skip full-page renders")
    parser.add_argument("--dpi", type=int, default=300, help="Render DPI (default: 300)")
    args = parser.parse_args()

    os.makedirs(args.out_dir, exist_ok=True)
    doc = fitz.open(args.input)
    print(f"PDF: {args.input}  ({doc.page_count} pages)")

    n_embedded = extract_embedded(doc, args.out_dir)
    print(f"\nExtracted {n_embedded} embedded images")

    if not args.no_pages:
        render_pages(doc, args.out_dir, args.dpi)
        print(f"Rendered {doc.page_count} full-page images")

    doc.close()
    print(f"\nDone — {args.out_dir}")


if __name__ == "__main__":
    main()
