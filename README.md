# explain

A Claude skill that writes a detailed, textbook-style report on a single technical term from any field. It is meant for readers who already know the basics of that field.

## What it does

Each report includes:

- the formal definition, quoted from its original source (a standard, the paper that introduced it, or a textbook)
- background, history, how it works, and any formulas
- a fully worked example with real numbers, plus real-world uses
- a comparison table with similar terms, and common misconceptions
- at least one gray-and-white diagram, saved as an editable draw.io file and as a PNG
- numbered citations and a reference list (it never invents sources)

The result is saved as Markdown. If you ask, Claude also builds a DOCX or PDF with its built-in `docx` / `pdf` skills, with a title page, table of contents, and numbered figures and tables. Pandoc is not needed.

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
- output format (Markdown, DOCX, or PDF)
- the author name for the title page

### 3. Get the files

They are saved in a folder named after the term:

```
eventual-consistency/
├── report.md           (+ report.docx / report.pdf if requested)
└── figures/
    ├── fig1.drawio
    └── fig1.png
```

Open the `.drawio` file in draw.io to edit a diagram. Then run this to rebuild the PNGs (on Windows, from Git Bash or WSL):

```bash
bash explain/scripts/render-figures.sh <folder>
```

To rebuild the DOCX/PDF after editing, ask Claude, e.g. "rebuild report.docx and report.pdf for eventual-consistency".

## Requirements

| Tool | Needed for | Required? |
|------|------------|-----------|
| Claude's built-in `docx` and `pdf` skills | DOCX/PDF export | Only for DOCX/PDF. Turn them on in Claude's skills settings |
| draw.io desktop | Rendering diagrams to PNG | Recommended |
| Graphviz or matplotlib | Fallback diagrams if draw.io isn't installed | Optional |
| Bash | Running `render-figures.sh` | Built into macOS/Linux; on Windows use Git Bash or WSL |

### Install commands

**macOS** (Homebrew)

```bash
brew install --cask drawio
brew install graphviz          # optional fallback
pip3 install matplotlib        # optional fallback
```

**Windows** (PowerShell, winget)

```powershell
winget install JGraph.Draw
winget install Git.Git              # provides Git Bash for the script
winget install Graphviz.Graphviz    # optional fallback
pip install matplotlib              # optional fallback
```

**Linux** (Debian/Ubuntu)

```bash
sudo snap install drawio            # or the .deb / AppImage from github.com/jgraph/drawio-desktop/releases
sudo apt install xvfb               # only on headless servers (no display)
sudo apt install graphviz           # optional fallback
pip3 install matplotlib             # optional fallback
```

On Fedora use `sudo dnf install graphviz xorg-x11-server-Xvfb`, and on Arch `sudo pacman -S graphviz xorg-server-xvfb`. Install draw.io from the drawio-desktop releases page (`.rpm` or AppImage).

If draw.io isn't installed, the skill falls back to Graphviz or matplotlib, after asking you first.

## Skill layout

```
explain/
├── SKILL.md                      # workflow
├── README.md                     # this file
├── references/
│   ├── report-template.md        # section outline and writing rules
│   ├── source-hierarchy.md       # which sources to trust, per industry
│   ├── diagram-style.md          # diagram types, style, PNG export
│   └── document-export.md        # DOCX/PDF layout for the docx / pdf skills
├── assets/
│   └── diagram-template.drawio   # starter diagram with the house styles
└── scripts/
    └── render-figures.sh         # renders draw.io diagrams to PNG
```
