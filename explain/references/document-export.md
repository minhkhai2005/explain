# DOCX / PDF export

DOCX and PDF are built from `report.md` with Claude's built-in **docx** and **pdf** skills, not Pandoc. Load the matching skill first and follow its instructions for libraries and code; this file only says what the finished document must contain and how it should look.

## Content, in order

1. **Title page**: title, subtitle, author, date from the title block at the top of `report.md`. Nothing else on the page.
2. **Table of contents**: headings to level 3, with page numbers. In DOCX use a real TOC field so Word can update it; in PDF add bookmarks/outline entries for every heading too.
3. **List of Figures** and **List of Tables**, if the report has any.
4. **Body**: every section of `report.md`, keeping the hand-written heading numbers exactly ("4.1 Signal path"). Do not let the generator add its own numbering on top.
5. **References**: unnumbered heading, entries kept as `[n] ...` in the same order.

## Mapping Markdown to the document

| Markdown | Document |
|----------|----------|
| `#`, `##`, `###` | Heading 1, 2, 3 styles (so they appear in the TOC) |
| Paragraphs, *italic*, **bold**, `code` | Same formatting; code in a monospace font |
| `> "definition" [1]` | Indented block quote, italic |
| `![Figure N: caption](figures/figN.png)` | Image centered at about 85% of the text width, caption "Figure N: ..." below it |
| Table with "Table N: ..." line | Real table, caption "Table N: ..." above it, header row shaded `#F2F2F2` |
| Equations (`$...$`, `$$...$$`) | Native equations in DOCX if the skill supports it; otherwise render them cleanly as images or typeset text. Never leave raw LaTeX in the output |
| `[n]` citations | Kept as plain text `[n]` |

## Page layout

- A4, margins 2.5 cm, body text 11 pt serif or clean sans (e.g. Times New Roman / Calibri), line spacing about 1.15.
- Headings in the same family, bold, black; no colour.
- Page numbers in the footer, starting after the title page.
- Grayscale only, matching the diagram style.

## Language

Use the report's language for the fixed labels: e.g. English "Table of Contents / List of Figures / List of Tables / Figure / Table / References", Vietnamese "Mục lục / Danh mục hình / Danh mục bảng / Hình / Bảng / Tài liệu tham khảo". Pick a font that has every character the language needs.
