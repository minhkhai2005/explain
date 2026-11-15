#!/usr/bin/env python3
"""Check that a generated report.docx matches the template's styles and structure.

Usage: python3 check-docx.py <report.docx> [template.docx]
       (template defaults to ../assets/report-template.docx)

Errors (exit code 1):
  - styles.xml, page size or margins differ from the template
  - a style ID is used that the template does not define
  - the front matter is not: title page | TOC | List of Figures | List of Tables |
    List of Abbreviations | body, each separated by a page break
  - the List of Abbreviations page has no table (or no 'no abbreviations' line)
  - TOC / List of Figures / List of Tables fields are missing
  - no figure caption or no table caption
Warnings:
  - direct run formatting (font, size, colour) that overrides the styles
  - captions without a _Toc bookmark (they would not link from the lists)
  - updateFields not set in settings.xml
"""
import os
import re
import sys
import zipfile

W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"


def read(z, name):
    try:
        return z.read(name).decode("utf-8")
    except KeyError:
        return ""


def blocks(body):
    """Top-level paragraphs and tables of <w:body>, in order."""
    out, i = [], 0
    pat = re.compile(r"<w:(p|tbl)[ >]")
    while True:
        m = pat.search(body, i)
        if not m:
            break
        tag = m.group(1)
        # find the matching close tag, accounting for nesting
        depth, j = 0, m.start()
        tok = re.compile(r"<w:%s[ >]|<w:%s/>|</w:%s>" % (tag, tag, tag))
        for t in tok.finditer(body, m.start()):
            s = t.group(0)
            if s.startswith("</"):
                depth -= 1
            elif not s.endswith("/>"):
                depth += 1
            if depth == 0:
                j = t.end()
                break
        out.append((tag, body[m.start():j]))
        i = j
    return out


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(2)
    doc_path = sys.argv[1]
    tpl_path = sys.argv[2] if len(sys.argv) > 2 else os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "..", "assets", "report-template.docx")

    errors, warnings = [], []
    d, t = zipfile.ZipFile(doc_path), zipfile.ZipFile(tpl_path)
    doc, styles, tstyles = read(d, "word/document.xml"), read(d, "word/styles.xml"), read(t, "word/styles.xml")

    # 1. Styles and page setup identical to the template
    if styles != tstyles:
        errors.append("word/styles.xml differs from the template: copy it unchanged from the template")
    defined = set(re.findall(r'w:styleId="([^"]+)"', tstyles))

    def sect(xml):
        s = re.findall(r"<w:sectPr.*?</w:sectPr>", xml, re.S)
        s = s[-1] if s else ""
        return re.findall(r"<w:pgSz[^>]*/>|<w:pgMar[^>]*/>", s)

    if sect(doc) != sect(read(t, "word/document.xml")):
        errors.append("page size or margins differ from the template (keep the template's final <w:sectPr>)")

    # 2. Only template style IDs
    used = set(re.findall(r'<w:(?:pStyle|rStyle|tblStyle) w:val="([^"]+)"', doc))
    for s in sorted(used - defined):
        errors.append('style "%s" is not defined in the template' % s)

    # 3. Direct formatting that overrides styles (outside equations)
    no_math = re.sub(r"<m:oMath(Para)?[ >].*?</m:oMath(Para)?>", "", doc, flags=re.S)
    for tag, label in (("rFonts", "font"), ("sz", "font size"), ("color", "colour")):
        n = len(re.findall(r"<w:r>(?:(?!</w:r>).)*?<w:rPr>(?:(?!</w:rPr>).)*?<w:%s " % tag, no_math, re.S))
        if n:
            warnings.append("%d run(s) set the %s directly; let the template styles define it" % (n, label))

    # 4. Front matter structure
    body = doc[doc.find("<w:body>"):]
    seq = []
    for tag, x in blocks(body):
        if tag == "tbl":
            seq.append("TABLE")
            continue
        st = re.search(r'<w:pStyle w:val="([^"]+)"', x)
        if st:
            seq.append(st.group(1))
        if 'w:type="page"' in x or "<w:pageBreakBefore/>" in x:
            seq.append("BREAK")

    def need(style):
        if style not in defined:
            warnings.append('template has no "%s" style; structure check for it skipped' % style)
            return False
        return True

    if need("Title") and need("TOCHeading") and need("Heading1"):
        try:
            first_h1 = seq.index("Heading1")
        except ValueError:
            first_h1 = len(seq)
            errors.append("no Heading1 found in the body")
        front = seq[:first_h1]
        parts, cur = [], []
        for s in front:
            if s == "BREAK":
                if cur:
                    parts.append(cur)
                cur = []
            else:
                cur.append(s)
        if cur:
            parts.append(cur)
        expected = ["Title", "TOCHeading", "TOCHeading", "TOCHeading", "TOCHeading"]
        heads = [p[0] if p else None for p in parts]
        if heads != expected:
            errors.append(
                "front matter must be 5 pages separated by page breaks: "
                "title page | Table of Contents | List of Figures | List of Tables | List of Abbreviations, "
                "then the body on a new page. "
                "Found page starts: %s" % heads)
        elif len(parts[4]) < 2:
            errors.append("List of Abbreviations page is empty: add the abbreviations table "
                          "(or one line saying the report uses none)")
        if parts and parts[0][:1] == ["Title"]:
            for s in ("Author", "Date"):
                if s in defined and s not in parts[0]:
                    errors.append("title page has no %s paragraph" % s)
        if not front or front[-1] != "BREAK":
            errors.append("the body (first Heading1) must start on a new page")

    # 5. Fields for TOC and lists
    instr = " ".join(re.findall(r"<w:instrText[^>]*>([^<]*)", doc)) + " ".join(
        re.findall(r'w:instr="([^"]*)"', doc))
    instr = instr.replace("&quot;", '"')
    if not re.search(r"TOC \\o", instr):
        errors.append('Table of Contents field missing (TOC \\o "1-2" \\h \\z \\u)')
    if "Image Caption" not in instr:
        errors.append('List of Figures field missing (TOC \\h \\z \\t "Image Caption,1")')
    if "Table Caption" not in instr:
        errors.append('List of Tables field missing (TOC \\h \\z \\t "Table Caption,1")')

    # 6. Captions
    for style, what in (("ImageCaption", "figure"), ("TableCaption", "table")):
        caps = [x for _, x in blocks(body) if '<w:pStyle w:val="%s"/>' % style in x]
        if not caps:
            errors.append("no %s caption (style %s)" % (what, style))
        missing = sum(1 for c in caps if "_Toc" not in c)
        if missing:
            warnings.append("%d %s caption(s) have no _Toc bookmark" % (missing, what))

    if "updateFields" not in read(d, "word/settings.xml"):
        warnings.append('settings.xml has no <w:updateFields w:val="true"/>; Word will not refresh the TOC on open')

    print("Checked %s against %s" % (doc_path, os.path.basename(tpl_path)))
    for e in errors:
        print("  ERROR:   " + e)
    for w_ in warnings:
        print("  WARNING: " + w_)
    if not errors and not warnings:
        print("  OK: styles and structure match the template")
    sys.exit(1 if errors else 0)


if __name__ == "__main__":
    main()
