#!/usr/bin/env bash
# Render diagrams and export an explain-skill report.
#
# Usage: export.sh <report-dir> [docx] [pdf]
#   <report-dir> contains report.md, metadata.yaml and figures/*.drawio
#
# Always renders figures/*.drawio -> figures/*.png (if draw.io is available).
# Builds report.docx / report.pdf only when requested.

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIR="${1:?Usage: export.sh <report-dir> [docx] [pdf]}"
shift
FORMATS=("$@")

cd "$DIR"
[[ -f report.md ]] || { echo "ERROR: $DIR/report.md not found" >&2; exit 1; }

warnings=()

# ---------- 1. Render draw.io diagrams ----------
DRAWIO=""
if command -v drawio >/dev/null 2>&1; then
  DRAWIO="drawio"
elif [[ -x "/Applications/draw.io.app/Contents/MacOS/draw.io" ]]; then
  DRAWIO="/Applications/draw.io.app/Contents/MacOS/draw.io"
fi

shopt -s nullglob
drawio_files=(figures/*.drawio)
if (( ${#drawio_files[@]} > 0 )); then
  if [[ -n "$DRAWIO" ]]; then
    for f in "${drawio_files[@]}"; do
      out="${f%.drawio}.png"
      echo "Rendering $f -> $out"
      "$DRAWIO" -x -f png -s 2 -b 10 -o "$out" "$f" >/dev/null 2>&1 \
        || warnings+=("draw.io failed to render $f")
    done
  else
    warnings+=("draw.io not found; .drawio files were NOT rendered to PNG. Install draw.io desktop or use the Graphviz/matplotlib fallback.")
  fi
fi

# Check every image referenced in report.md exists
while IFS= read -r img; do
  [[ -f "$img" ]] || warnings+=("Image referenced in report.md is missing: $img")
done < <(grep -oE '!\[[^]]*\]\([^)]+\)' report.md | sed -E 's/.*\(([^) ]+).*/\1/')

# ---------- 2. Export documents ----------
if (( ${#FORMATS[@]} > 0 )); then
  command -v pandoc >/dev/null 2>&1 || { echo "ERROR: pandoc is required for DOCX/PDF export" >&2; exit 1; }

  META=()
  [[ -f metadata.yaml ]] && META=(--metadata-file=metadata.yaml) \
    || warnings+=("metadata.yaml not found; title/author/TOC settings may be missing")

  FILTERS=()
  if command -v pandoc-crossref >/dev/null 2>&1; then
    FILTERS=(--filter pandoc-crossref)
  else
    warnings+=("pandoc-crossref not found; figures/tables are not auto-numbered and no List of Figures/Tables was generated. Install with: brew install pandoc-crossref")
  fi

  # Headings are numbered by hand in report.md, so --number-sections is not used.
  COMMON=(report.md ${META[@]+"${META[@]}"} ${FILTERS[@]+"${FILTERS[@]}"} --toc --resource-path=.:figures)

  for fmt in ${FORMATS[@]+"${FORMATS[@]}"}; do
    case "$fmt" in
      docx)
        REF=()
        [[ -f "$SKILL_DIR/assets/reference.docx" ]] && REF=(--reference-doc="$SKILL_DIR/assets/reference.docx")
        echo "Building report.docx"
        pandoc "${COMMON[@]}" ${REF[@]+"${REF[@]}"} -o report.docx
        ;;
      pdf)
        ENGINE=""
        for e in typst xelatex lualatex pdflatex; do
          command -v "$e" >/dev/null 2>&1 && { ENGINE="$e"; break; }
        done
        if [[ -z "$ENGINE" ]]; then
          warnings+=("No PDF engine found (typst, xelatex, lualatex, pdflatex); PDF skipped. Install one, e.g. brew install typst")
          continue
        fi
        echo "Building report.pdf with $ENGINE"
        pandoc "${COMMON[@]}" --pdf-engine="$ENGINE" -o report.pdf
        ;;
      *)
        warnings+=("Unknown format '$fmt' ignored (use docx or pdf)")
        ;;
    esac
  done
fi

# ---------- 3. Report ----------
echo
echo "Done. Output in: $(pwd)"
if (( ${#warnings[@]} > 0 )); then
  echo "Warnings:"
  for w in "${warnings[@]}"; do echo "  - $w"; done
fi
