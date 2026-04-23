#!/usr/bin/env python3
"""Convert chap3.tex (beamer) into an editable .pptx via pandoc.

Strategy:
  - Preprocess: expand custom macros (\Blue, \Red, \chap, etc.),
    replace \input{../figure/*.pstex_t} with \includegraphics{figures/*.png}
  - Wrap content in minimal beamer preamble
  - Call pandoc to produce .pptx (math becomes editable OMML)
"""
import re, subprocess, sys, pathlib, pypandoc

ROOT = pathlib.Path(__file__).parent
SRC  = ROOT.parent / "chap3.tex"
OUT  = ROOT / "chap3.pptx"
WRAP = ROOT / "_chap3_wrapped.tex"

tex = SRC.read_text(encoding="utf-8")

# --- Expand custom macros from custom.sty ---
tex = re.sub(r"\\Blue\{", r"\\textcolor{blue}{", tex)
tex = re.sub(r"\\Red\{",  r"\\textcolor{red}{",  tex)

# Replace figure \input blocks (pstex_t) with an image placeholder.
# Matches: \scalebox{...}{ \input{../figure/NAME.pstex_t} }  OR plain \input{...pstex_t}
def fig_sub(m):
    name = pathlib.Path(m.group(1)).stem
    return r"\includegraphics[width=6cm]{figures/" + name + ".png}"
tex = re.sub(r"\\input\{([^}]+\.pstex_t)\}", fig_sub, tex)

# Brace-aware strip of \scalebox{...}{ ... }: keep inner content only.
def strip_scalebox(s):
    out = []
    i = 0
    while i < len(s):
        if s.startswith(r"\scalebox{", i):
            # skip first arg
            j = i + len(r"\scalebox{")
            depth = 1
            while j < len(s) and depth:
                if s[j] == "{": depth += 1
                elif s[j] == "}": depth -= 1
                j += 1
            # skip whitespace/comments to second arg
            while j < len(s) and s[j] in " \t\n": j += 1
            if j < len(s) and s[j] == "{":
                j += 1
                depth = 1
                start = j
                while j < len(s) and depth:
                    if s[j] == "{": depth += 1
                    elif s[j] == "}": depth -= 1
                    j += 1
                out.append(s[start:j-1])  # inner content without closing brace
                i = j
                continue
        out.append(s[i]); i += 1
    return "".join(out)

tex = strip_scalebox(tex)

# Drop \tag{\ref{...}} — the referenced label lives in another chapter
tex = re.sub(r"\\tag\{\\ref\{[^}]+\}\}", "", tex)


# Drop \label / \tag reference artifacts that confuse pandoc (keep math otherwise)
# (keep these: pandoc handles them fine in most cases)

preamble = r"""
\documentclass[10pt]{beamer}
\usepackage[utf8]{inputenc}
\usepackage{amsmath,amssymb,bm,graphicx,xcolor}
\graphicspath{{./}}
\newcommand{\chap}[1]{}
\setcounter{chapter}{3}
\setcounter{equation}{0}
\renewcommand{\theequation}{3.\arabic{equation}}
\title{第3章 連続システムの離散化}
\begin{document}
\frame{\titlepage}
"""
postamble = r"\end{document}" + "\n"

WRAP.write_text(preamble + tex + "\n" + postamble, encoding="utf-8")
print(f"wrote wrapper: {WRAP}")

# tex → markdown (intermediate) so we can normalize frame breaks
md = pypandoc.convert_file(str(WRAP), to="markdown", format="latex",
                           extra_args=[f"--resource-path={ROOT}"])
# Drop pandoc's ::: frame / ::: columns / ::: column div wrappers so that
# each "### frametitle" actually starts a new slide under slide-level=2.
md = re.sub(r"^:::+.*$", "", md, flags=re.M)
# Promote frame title (level-3) to level-2 for pptx slide break
md = re.sub(r"^### ", "## ", md, flags=re.M)
# Replace HTML <figure> blocks with plain markdown image syntax so pandoc
# embeds the picture into the pptx.
def _figrepl(m):
    img = re.search(r'<img\s+src="([^"]+)"', m.group(0))
    cap = re.search(r'<figcaption>(.*?)</figcaption>', m.group(0), re.S)
    if not img: return ""
    return f"![{cap.group(1) if cap else ''}]({img.group(1)})"
md = re.sub(r"<figure[^>]*>.*?</figure>", _figrepl, md, flags=re.S)
(ROOT / "chap3.md").write_text(md, encoding="utf-8")

pypandoc.convert_file(str(ROOT / "chap3.md"), to="pptx", format="markdown",
                      outputfile=str(OUT),
                      extra_args=["--slide-level=2", f"--resource-path={ROOT}"])
print(f"wrote pptx: {OUT}")
