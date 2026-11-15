# explain

A Claude skill that writes a detailed, textbook-style report on a single technical term from any field. Before writing, it asks you a few short questions to find out which related concepts you already know, and starts the explanation exactly where your knowledge ends.

## What it does

Each report includes:

- the formal definition, quoted from its original source (a standard, the paper that introduced it, or a textbook)
- background, history, how it works, and any formulas
- a fully worked example with real numbers, plus real-world uses
- a comparison table with similar terms, and common misconceptions
- at least one diagram, saved as an editable source file and as a PNG. By default it's a gray-and-white draw.io diagram. Only when that style can't show the subject (e.g. anatomy or cell structure in medicine and biology) does Claude draw an SVG illustration in soft, muted colours
- numbered citations and a reference list (it never invents sources)

The result is saved as Markdown. If you ask, Claude also builds a DOCX or PDF with its built-in `docx` / `pdf` skills. Pandoc is not needed. Every DOCX follows the same structure, each part on its own page: title page (title, author, date), table of contents, list of figures, list of tables, list of abbreviations, then the body and references. Styles come from the empty template `explain/assets/report-template.docx` unless you give Claude your own `.docx` template, and `explain/scripts/check-docx.py` checks that the result uses exactly those styles. `explain/assets/report-example.docx` shows a finished report in that style.

## How to use it

### 1. Ask for an explanation

Phrases like these load the skill:

> Explain *eventual consistency* in distributed databases in detail
> What is *threshold voltage* in MOSFETs?
> Write a report on the term *EBITDA*

You can also call it directly with `/explain <term>`.

### 2. Answer one round of questions

It only asks about what it can't work out from your request:

- which field you mean, if the term is ambiguous (e.g. "bearing")
- reader level, length, and language
- output format (Markdown, DOCX, or PDF), and for DOCX whether you have your own template
- the author name for the title page

### 3. Answer a few questions about what you already know

Complex terms are built from simpler concepts in layers. Claude asks short sets of questions (at least 5 each) about whether you know specific related concepts, starting at the layer your reader level suggests (e.g. Ohm's law, diodes and p-n junctions for a student asking about MOSFETs). If you know everything in a set, the next set goes one layer higher. The first layer with concepts you don't know is where the report starts: those concepts, and everything between them and the term, are explained in detail. The result is saved as `reader-profile.md`.

### 4. Get the files

They are saved in a folder named after the term:

```
eventual-consistency/
├── report.md           (+ report.docx / report.pdf if requested)
├── reader-profile.md   (what the knowledge probe found)
└── figures/
    ├── fig1.drawio     (default style)
    ├── fig1.png
    ├── fig2.svg        (only for figures draw.io can't handle)
    └── fig2.png
```

To edit a diagram, open the `.drawio` file in draw.io, or the `.svg` file in any SVG editor (e.g. Inkscape) or text editor. Then run this to rebuild the PNGs (on Windows, from Git Bash or WSL):

```bash
bash explain/scripts/render-figures.sh <folder>
```

To rebuild the DOCX/PDF after editing, ask Claude, e.g. "rebuild report.docx and report.pdf for eventual-consistency".

## Requirements

| Tool | Needed for | Required? |
|------|------------|-----------|
| Claude's built-in `docx` and `pdf` skills | DOCX/PDF export | Only for DOCX/PDF. Turn them on in Claude's skills settings |
| draw.io desktop | Rendering diagrams to PNG | Recommended |
| An SVG converter: `rsvg-convert` (librsvg), Inkscape, `cairosvg` or ImageMagick | Rendering SVG illustrations to PNG | Only if a figure is SVG |
| Graphviz or matplotlib | Fallback diagrams if draw.io isn't installed | Optional |
| Bash | Running `render-figures.sh` | Built into macOS/Linux; on Windows use Git Bash or WSL |

### Install commands

**macOS** (Homebrew)

```bash
brew install --cask drawio
brew install librsvg           # SVG -> PNG (rsvg-convert)
brew install graphviz          # optional fallback
pip3 install matplotlib        # optional fallback
```

**Windows** (PowerShell, winget)

```powershell
winget install JGraph.Draw
winget install Inkscape.Inkscape    # SVG -> PNG (or: pip install cairosvg)
winget install Git.Git              # provides Git Bash for the script
winget install Graphviz.Graphviz    # optional fallback
pip install matplotlib              # optional fallback
```

**Linux** (Debian/Ubuntu)

```bash
sudo snap install drawio            # or the .deb / AppImage from github.com/jgraph/drawio-desktop/releases
sudo apt install librsvg2-bin       # SVG -> PNG (rsvg-convert)
sudo apt install xvfb               # only on headless servers (no display)
sudo apt install graphviz           # optional fallback
pip3 install matplotlib             # optional fallback
```

On Fedora use `sudo dnf install librsvg2-tools graphviz xorg-x11-server-Xvfb`, and on Arch `sudo pacman -S librsvg graphviz xorg-server-xvfb`. Install draw.io from the drawio-desktop releases page (`.rpm` or AppImage).

If draw.io isn't installed, the skill falls back to Graphviz or matplotlib, after asking you first.

## Skill layout

```
explain/
├── SKILL.md                      # workflow
├── README.md                     # this file
├── references/
│   ├── knowledge-probe.md        # how to probe the reader's prior knowledge
│   ├── report-template.md        # section outline and writing rules
│   ├── source-hierarchy.md       # which sources to trust, per industry
│   ├── diagram-style.md          # when to use draw.io vs SVG, both styles, PNG export
│   └── document-export.md        # DOCX/PDF layout for the docx / pdf skills
├── assets/
│   ├── diagram-template.drawio   # starter diagram with the house styles
│   ├── report-template.docx      # empty DOCX template with only the styles (replace it to restyle every report)
│   └── report-example.docx       # finished example report in that style
└── scripts/
    ├── render-figures.sh         # renders draw.io and SVG figures to PNG
    └── check-docx.py             # checks a DOCX against the template's styles and structure
```
