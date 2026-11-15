# DOCX / PDF export

DOCX and PDF are built from `report.md` with Claude's built-in **docx** and **pdf** skills, not Pandoc. Load the matching skill first and follow its instructions for tools and code; this file says which template to use and what the finished document must look like.

## Which template

- If the user gave a `.docx` template, use that one.
- Otherwise **always use `assets/report-template.docx`**. It is an empty document that contains only the house styles, page setup, header/footer and numbering definitions, so every report looks the same.
- `assets/report-example.docx` is a finished report (Vietnamese, on MOSFET) built with these styles. Open it to see how the structure and styles look in practice. Never copy its text, figures, tables or references.

## How to build the DOCX

The styles Claude produces must be **exactly** the template's styles. So never create a new document from scratch with a library's default styles, and never define new styles. Build on top of the template package:

1. Copy `assets/report-template.docx` to `<term-slug>/report.docx` and unpack it (the docx skill explains how).
2. Keep these parts **byte-for-byte unchanged**: `word/styles.xml`, `word/theme/`, `word/numbering.xml`, `word/fontTable.xml`, the header/footer parts, and the final `<w:sectPr>` of `word/document.xml`.
3. Replace the single empty paragraph in `<w:body>` (everything before the final `<w:sectPr>`) with the report, using **only the style IDs in the tables below** via `<w:pStyle>` / `<w:tblStyle>`. Do not set fonts, sizes, colours, spacing or indentation directly on runs or paragraphs; the styles already define them. Allowed run formatting: bold, italic, subscript/superscript for emphasis and symbols.
4. Add the figure images to `word/media/` with their relationships in `word/_rels/document.xml.rels`.
5. Fill in `docProps/core.xml` (title, creator = author, language, created/modified dates).
6. Add `<w:updateFields w:val="true"/>` to `word/settings.xml` so Word refreshes the TOC and lists (and their page numbers) when the file is opened.
7. Pack, then validate with the docx skill's tools **and** with:
   ```bash
   python3 <skill-dir>/scripts/check-docx.py <term-slug>/report.docx [user-template.docx]
   ```
   Fix every ERROR and rerun until it passes. Warnings about direct formatting should also be fixed unless there is a good reason.

If you use a library (e.g. python-docx or docx-js) instead of writing XML, open the template with it (python-docx: `Document("report-template.docx")`) and assign styles by name; never let it write its own default `styles.xml`. The check script will catch it if it does.

## Required structure (always, in this order)

Each block marked ⏎ ends with a page break: a paragraph containing only `<w:r><w:br w:type="page"/></w:r>`. The title page, Table of Contents, List of Figures and List of Tables **each get their own page**, and the body starts on a new page.

| # | Block | Style ID | Content |
|---|-------|----------|---------|
| 1 | Title page ⏎ | `Title`, `Author`, `Date` | Title, author name, date `YYYY-MM-DD`, one paragraph each |
| 2 | Table of Contents ⏎ | `TOCHeading` + TOC field | Field code `TOC \o "1-2" \h \z \u`, with entries pre-filled in styles `TOC1` / `TOC2` (right tab with dot leader at 9350) |
| 3 | List of Figures ⏎ | `TOCHeading` + TOC field | Field code `TOC \h \z \t "Image Caption,1"`; one `TOC1` entry per figure |
| 4 | List of Tables ⏎ | `TOCHeading` + TOC field | Field code `TOC \h \z \t "Table Caption,1"`; one `TOC1` entry per table |
| 5 | Body | see below | Sections 1 … n of `report.md` |
| 6 | References | `Heading1` (unnumbered) | Entries `[n] ...` |

Never leave out the Table of Contents, List of Figures or List of Tables. Every report has at least one figure and one table (the comparison table), so both lists always have entries.

## Body: Markdown → template styles

| Markdown | Style ID | Notes |
|----------|----------|-------|
| `# 1. Heading` | `Heading1` | Number written by hand, "1." with a trailing dot; no automatic list numbering |
| `## 2.1. Heading` | `Heading2` | "2.1." |
| `### 2.1.1. Heading` | `Heading3` | Shown in the body, not in the TOC (TOC levels 1–2) |
| First paragraph after a heading, figure or table | `FirstParagraph` | |
| Other paragraphs | `BodyText` | *italic*, **bold**, sub/superscript as character formatting |
| `> "definition" [1]` | `BlockText` | Indented quote |
| Figure | `CaptionedFigure` | One inline picture, centred, about 75–85% of the text width (text width 6.5 in) |
| Figure caption | `ImageCaption` | **Below** the figure: "Hình N: ..." / "Figure N: ...". Wrap it in a `_Toc…` bookmark that the List of Figures entry links to |
| Table | table style `Table` | Full width (`w:tblW w:w="5000" w:type="pct"`), single 4-size borders on all sides and inside, header row repeated (`w:tblHeader`), cell paragraphs in `Compact` |
| Table caption | `TableCaption` | **Below** the table: "Bảng N: ..." / "Table N: ...", with a `_Toc…` bookmark for the List of Tables |
| Equations | native Word math (`m:oMath` / `m:oMathPara`) | Never leave raw LaTeX in the document |
| Display equation | `BodyText` paragraph containing `m:oMathPara` | |
| Reference entries | `FirstParagraph`, then `BodyText` | Plain `[n]` numbering |

## Style reference (what the template defines)

Use this to match the look in the PDF, which cannot reuse `styles.xml`.

| Style ID (name) | Font, size | Paragraph |
|-----------------|-----------|-----------|
| `Normal` | Times New Roman 12 pt, black | spacing after 10 pt |
| `Title` | 20 pt | centred, after 4 pt |
| `Author`, `Date` | 12 pt | centred, keep with next |
| `TOCHeading` (TOC Heading) | 18 pt bold | before 12 pt, not in the TOC |
| `TOC1` / `TOC2` (toc 1 / toc 2) | 12 pt; TOC1 bold | TOC2 indented 0.31 in; right tab with dot leader |
| `Heading1` | 18 pt bold | before 18 pt, after 4 pt, keep with next |
| `Heading2` | 16 pt bold | before 8 pt, after 4 pt |
| `Heading3` | 14 pt | before 8 pt, after 4 pt |
| `BodyText` (Body Text), `FirstParagraph` | 12 pt | before 9 pt, after 9 pt |
| `BlockText` (Block Text) | 12 pt | indented 0.33 in left and right, before/after 5 pt |
| `Compact` | 12 pt | before/after 1.8 pt (table cells) |
| `CaptionedFigure` (Captioned Figure) | | keep with next (the caption) |
| `ImageCaption`, `TableCaption` | 12 pt italic | after 6 pt; TableCaption keep with next |
| `Table` (table style) | Times New Roman | cell margins 0.075 in left/right |

## Page setup (from the template, do not change)

US Letter (8.5 × 11 in), 1 in margins, empty header and footer.

## Fixed labels by language

| Language | TOC | List of figures | List of tables | Figure | Table | References |
|----------|-----|-----------------|----------------|--------|-------|------------|
| Vietnamese | Mục lục | Danh mục hình | Danh mục bảng | Hình | Bảng | Tài liệu tham khảo |
| English | Table of Contents | List of Figures | List of Tables | Figure | Table | References |

For other languages translate the labels the same way.

## PDF

Build the PDF with the pdf skill, matching the same structure, page setup and look: title page, then Table of Contents, List of Figures and List of Tables each on its own page with page numbers, then the body, plus PDF bookmarks for every heading. If a DOCX was also built and the pdf/docx skill offers a DOCX→PDF conversion (e.g. LibreOffice), converting that DOCX is the most faithful way to get an identical PDF.

## Check before delivering

Run `scripts/check-docx.py` (above). Then convert the result to PDF (or render it) and look at the first pages: the title page, Table of Contents, List of Figures and List of Tables must each be on a separate page, and the body must start on a new page. Check that every figure and table appears in its list and that the styles match the template.
