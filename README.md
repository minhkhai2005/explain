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

The result is saved as Markdown. If you ask, it is also exported to DOCX or PDF with a title page, table of contents, and numbered figures and tables.

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
├── metadata.yaml
└── figures/
    ├── fig1.drawio
    └── fig1.png
```

Open the `.drawio` file in draw.io to edit a diagram. Then run this to rebuild the PNGs and documents:

```bash
bash explain/scripts/export.sh <folder> docx pdf
```

## Requirements

| Tool | Needed for | Install |
|------|------------|---------|
| Pandoc | DOCX/PDF export | `brew install pandoc` |
| draw.io desktop | Rendering diagrams to PNG | [drawio.com](https://www.drawio.com) |
| pandoc-crossref (optional) | Numbered figures/tables and their lists | `brew install pandoc-crossref` |
| Typst or LaTeX (optional) | PDF export | `brew install typst` |

If draw.io isn't installed, the skill falls back to Graphviz or matplotlib, after asking you first.

## Skill layout

```
explain/
├── SKILL.md                      # workflow
├── README.md                     # this file
├── references/
│   ├── report-template.md        # section outline and writing rules
│   ├── source-hierarchy.md       # which sources to trust, per industry
│   └── diagram-style.md          # diagram types, style, PNG export
├── assets/
│   ├── diagram-template.drawio   # starter diagram with the house styles
│   ├── metadata.yaml             # title, author, TOC, lists of figures/tables
│   └── reference.docx            # Word style template (edit to restyle exports)
└── scripts/
    └── export.sh                 # renders diagrams and builds DOCX/PDF
```
