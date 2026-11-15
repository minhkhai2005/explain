---
name: explain
description: Write an in-depth, book-style explanation of a technical term in any industry, aimed at readers who already know the fundamentals of the field. Includes cited primary sources, worked examples and diagrams, exported as Markdown (or DOCX/PDF on request). Use when the user asks to explain, define, or deep-dive a specific technical term or concept ("what is X in Y", "explain X in detail", "write a report on the term X"). For simplified explanations aimed at non-experts, use eli5 instead.
compatibility: Claude's built-in docx and pdf skills for DOCX/PDF export. draw.io desktop CLI (macOS, Windows or Linux) for diagram PNG export; an SVG converter (rsvg-convert, Inkscape, cairosvg or ImageMagick) for SVG illustrations; Graphviz or matplotlib as fallback. Web access for source research. Install tools only after the user agrees.
---

# explain

Produce a report that explains one technical term the way a good textbook chapter would: rigorous, sourced, illustrated, and readable by someone who knows the basics of the field but not this term.

Bundled files (read them when the step that needs them comes up):
- `references/report-template.md` — the required section outline and writing rules
- `references/source-hierarchy.md` — which sources to trust, per industry
- `references/diagram-style.md` — how to choose between draw.io (default) and SVG, both styles, and PNG rendering
- `assets/diagram-template.drawio` — starter diagram with the house styles
- `references/document-export.md` — how to build DOCX/PDF with the docx / pdf skills: template, required structure, style mapping
- `assets/report-template.docx` — empty default DOCX template that holds only the house styles and page setup; build every DOCX on it unless the user gives their own template
- `assets/report-example.docx` — a finished report built with those styles, to see the expected structure (never copy its content)
- `scripts/check-docx.py` — checks a generated DOCX against the template's styles and required structure
- `scripts/render-figures.sh` — renders `figures/*.drawio` to PNG (macOS, Linux, Windows via Git Bash/WSL)

## Step 1: Clarify scope (one round of questions)

The same term often means different things in different industries (e.g. "bearing" in mechanical engineering vs. navigation), and the right depth depends on the reader. A wrong guess wastes the whole research effort, so settle scope first — but do it in **one** question round, not a back-and-forth.

- If the industry is clear from context, state your assumption and move on. Only ask when it is genuinely ambiguous. When you ask, search for the plausible meanings and offer them as options; the user can always type their own answer.
- In the same round, ask about anything not already given:
  - **Reader level**: student / practitioner / expert (default: practitioner with fundamentals)
  - **Length**: default 2,000–4,000 words
  - **Language** of the report (default: the language the user wrote in)
  - **Output format**: Markdown only, or also DOCX / PDF (and, for DOCX, whether they have their own `.docx` template; if not, the bundled one is used)
  - **Author name** for the title page. Try `git config user.name` first and confirm it; never invent a name.

## Step 2: Gather sources

The most trustworthy explanation of a term is the document that defines it. Read `references/source-hierarchy.md` and work from the top of the hierarchy down: standards and specifications, the original paper that introduced the term, established textbooks, then vendor datasheets and application notes. Blogs and forums are a last resort and any claim taken from them must be cross-checked against at least two independent, more authoritative sources.

Use WebSearch / WebFetch for research; for broad or contested topics, the `deep-research` skill can be used.

Rules that protect the reader's trust in the report:
- **Never fabricate a citation.** Every reference must be something you actually found. If you cannot verify a claim, either drop it or mark it explicitly as unverified in the text.
- **Record citation details while gathering**, not afterwards: authors, title, publisher/standard body, year, edition/version, section or page, URL, access date. Keep a running numbered list — it becomes the References section.
- Prefer quoting the formal definition verbatim from the defining source, then paraphrasing it.
- Note where sources disagree; disagreement is worth explaining, not hiding.

## Step 3: Write the report

Follow the outline in `references/report-template.md`. Write top-down: start from the fundamentals of the field the term lives in, then narrow to the term itself. Write in flowing, book-style paragraphs rather than bullet lists, because the goal is understanding, not a cheat sheet.

Key expectations (details and reasons in the template):
- Define every secondary piece of jargon the first time it appears.
- Support claims with numbered in-text citations `[n]` that match the References list.
- Include at least one fully worked example with concrete values, and real-world usage examples.
- Include at least one diagram that explains the **mechanism** (not decoration). Follow `references/diagram-style.md`. Always try the draw.io grayscale style first (`figures/figN.drawio`). Only when that style cannot show the subject, e.g. anatomy, cell structure or other organic shapes in medicine and biology, draw a soft-coloured SVG instead (`figures/figN.svg`). Render either one to `figures/figN.png` and embed the PNG with a numbered caption.
- Use tables for comparisons (e.g. the term vs. commonly confused terms), each with a numbered caption.

## Step 4: Export

Save everything under `./<term-slug>/` in the current working directory (lowercase, hyphenated slug):

```
<term-slug>/
├── report.md
├── report.docx          # only if requested
├── report.pdf           # only if requested
└── figures/
    ├── fig1.drawio      # default style
    ├── fig1.png
    ├── fig2.svg         # only when draw.io style can't show the subject
    └── fig2.png
```

1. Write `report.md` starting with a title block (title, subtitle, author, date), then the sections from the template. Number headings by hand (`# 1. Definition`, `## 4.1. Signal path`, `### 4.1.1. ...`) and number figures and tables by hand ("Figure 1: ...", "Table 1: ..."), so the numbering is identical in the .md, .docx and .pdf. Leave `# References` unnumbered.
2. Render the diagrams:
   ```bash
   bash <skill-dir>/scripts/render-figures.sh <term-slug>
   ```
   The script renders every `figures/*.drawio` and `figures/*.svg` to PNG, checks that every image referenced in `report.md` exists, and reports what was skipped. On Windows run it from Git Bash or WSL.
3. If DOCX was requested, load Claude's built-in **docx** skill and build `report.docx` from `report.md` following `references/document-export.md`. Use the user's `.docx` template if they gave one; otherwise always build on `assets/report-template.docx`, keeping its `styles.xml` unchanged and using only its style IDs, so every report looks the same. The document must always have, in order: a title page (title, author, date), Table of Contents, List of Figures, List of Tables, each on its own page, then the body and References. If PDF was requested, load the built-in **pdf** skill and build `report.pdf` the same way. Read the skill before writing any code and use the libraries it recommends. Do not install or call Pandoc.
4. If one of those skills is not available in this environment, tell the user (they can enable it in Claude's skills settings), deliver the Markdown, and do not fall back to Pandoc without asking. If a tool needed for diagrams is missing, tell the user what it is and how to install it on their OS (see README), and ask before installing anything.
5. Check the output: for DOCX run `python3 <skill-dir>/scripts/check-docx.py <term-slug>/report.docx` and fix every error; then convert or render the generated file and confirm the title page, Table of Contents, List of Figures and List of Tables are each on a separate page, the body starts on a new page, and every figure and table is listed.
6. Finish by giving the user the paths to the generated files and a short summary of the report (the definition in one or two sentences plus the main sources used). If any figure is SVG, say in one sentence why the draw.io style was not enough.
