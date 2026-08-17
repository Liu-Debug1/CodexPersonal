#!/usr/bin/env python3
"""
build_latex.py — Build a compilable IEEEtran LaTeX document with Chinese translation + extracted figures.

Workflow:
  1. Read translated sections from a JSON manifest or individual .tex fragment files
  2. Scan figures/ directory for embedded images and page crops
  3. Generate a single .tex file with all content + figure environments
  4. Optionally compile with xelatex

Usage:
    python3 scripts/build_latex.py --manifest content.json --figures figures/ --output output.tex
    python3 scripts/build_latex.py --manifest content.json --figures figures/ --output output.tex --compile
"""

import sys, os, json, argparse, subprocess, glob


IEEE_PREAMBLE = r"""%!TEX TS-program = xelatex
\documentclass[10pt,a4paper,twocolumn]{IEEEtran}
\usepackage[UTF8,heading=false]{ctex}
\setCJKmainfont{SimSun}
\setCJKsansfont{SimHei}
\setCJKmonofont{FangSong}
\usepackage{amsmath,amssymb}
\usepackage{graphicx}
\usepackage{cite}
\usepackage{hyperref}
\usepackage{float}

\graphicspath{{FIGURES_PATH}}

\hypersetup{
  colorlinks=true,
  linkcolor=blue,
  citecolor=blue,
  urlcolor=blue,
}

\begin{document}
"""

IEEE_POSTAMBLE = r"""\end{document}"""


def scan_figures(figures_dir):
    """Scan figures directory and return dict of {label: filepath}."""
    figs = {}
    if not os.path.isdir(figures_dir):
        return figs

    for f in sorted(os.listdir(figures_dir)):
        full = os.path.join(figures_dir, f)
        if not os.path.isfile(full):
            continue
        # Use filename (without ext) as label
        label = os.path.splitext(f)[0]
        figs[label] = f
    return figs


def build_figure_env(label, filename, caption, placement="ht"):
    """Generate a LaTeX figure environment."""
    width = "\\columnwidth"
    return f"""\\begin{{figure}}[{placement}]
\\centering
\\includegraphics[width={width}]{{{filename}}}
\\caption{{{caption}}}
\\label{{fig:{label}}}
\\end{{figure}}"""


def build_document(manifest_path, figures_dir):
    """Build complete LaTeX document from manifest + figures."""
    with open(manifest_path, "r", encoding="utf-8") as f:
        manifest = json.load(f)

    preamble = IEEE_PREAMBLE.replace("FIGURES_PATH", figures_dir.replace("\\", "/"))

    # Title / authors / abstract
    title = manifest.get("title", "Untitled")
    authors = manifest.get("authors", "")
    abstract = manifest.get("abstract", "")
    keywords = manifest.get("keywords", "")

    title_block = f"""\\title{{\\centering \\LARGE {title}}}
\\author{{{authors}}}
\\maketitle
\\begin{{abstract}}
{abstract}
\\end{{abstract}}
\\begin{{IEEEkeywords}}
{keywords}
\\end{{IEEEkeywords}}"""

    # Sections
    sections = []
    for sec in manifest.get("sections", []):
        heading = sec.get("heading", "")
        level = sec.get("level", "section")  # "section" or "subsection"
        body = sec.get("body", "")
        figures = sec.get("figures", [])  # [{label, file, caption}, ...]

        cmd = "\\" + level + "{" + heading + "}"
        content = cmd + "\n\n" + body + "\n"

        for fig in figures:
            content += "\n" + build_figure_env(
                fig["label"], fig["file"], fig["caption"]
            ) + "\n"

        sections.append(content)

    # References
    refs = manifest.get("references", "")
    if refs:
        refs_block = "\n{\\small\n\\begin{thebibliography}{99}\n" + refs + "\n\\end{thebibliography}}\n"
    else:
        refs_block = ""

    full = preamble + "\n" + title_block + "\n\n"
    full += "\n".join(sections) + "\n\n"
    full += refs_block + "\n"
    full += IEEE_POSTAMBLE

    return full


def compile_latex(tex_path):
    """Compile .tex with xelatex (2 passes for cross-refs)."""
    tex_dir = os.path.dirname(os.path.abspath(tex_path))
    tex_name = os.path.basename(tex_path)

    # Locate xelatex
    xelatex = None
    candidates = [
        "xelatex",
        "C:/Users/Liuzwei/AppData/Local/Programs/MiKTeX/miktex/bin/x64/xelatex.exe",
        "/usr/bin/xelatex",
    ]
    for c in candidates:
        try:
            subprocess.run([c, "--version"], capture_output=True, check=True)
            xelatex = c
            break
        except Exception:
            continue

    if not xelatex:
        print("Warning: xelatex not found, skipping compilation. Install MiKTeX or TeX Live.")
        return False

    for _ in range(2):
        subprocess.run(
            [xelatex, "-interaction=nonstopmode", tex_name],
            cwd=tex_dir, capture_output=True
        )

    pdf_path = tex_path.replace(".tex", ".pdf")
    if os.path.exists(pdf_path):
        size_kb = os.path.getsize(pdf_path) / 1024
        print(f"PDF generated: {pdf_path}  ({size_kb:.0f} KB)")
        return True
    return False


def main():
    parser = argparse.ArgumentParser(description="Build LaTeX document from manifest + figures")
    parser.add_argument("--manifest", required=True, help="JSON manifest with translated content")
    parser.add_argument("--figures", required=True, help="Directory containing extracted figures")
    parser.add_argument("--output", default="output.tex", help="Output .tex file path")
    parser.add_argument("--compile", action="store_true", help="Compile with xelatex after building")
    args = parser.parse_args()

    full_tex = build_document(args.manifest, args.figures)

    with open(args.output, "w", encoding="utf-8") as f:
        f.write(full_tex)

    print(f"LaTeX written: {args.output}  ({len(full_tex)} chars)")

    if args.compile:
        compile_latex(args.output)


if __name__ == "__main__":
    main()
