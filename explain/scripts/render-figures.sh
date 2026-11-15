#!/usr/bin/env bash
# Render the diagrams of an explain-skill report to PNG.
#
# Usage: render-figures.sh <report-dir>
#   <report-dir> contains report.md and figures/*.drawio
#
# Works on macOS, Linux and Windows (Git Bash or WSL).
# DOCX/PDF are NOT built here: Claude builds them with its built-in docx / pdf skills.

set -euo pipefail

DIR="${1:?Usage: render-figures.sh <report-dir>}"
cd "$DIR"
[[ -f report.md ]] || { echo "ERROR: $DIR/report.md not found" >&2; exit 1; }

warnings=()

# ---------- 1. Find draw.io ----------
DRAWIO=()
if command -v drawio >/dev/null 2>&1; then
  DRAWIO=(drawio)                                                   # Linux (deb/snap), Homebrew
elif command -v draw.io >/dev/null 2>&1; then
  DRAWIO=(draw.io)
elif [[ -x "/Applications/draw.io.app/Contents/MacOS/draw.io" ]]; then
  DRAWIO=("/Applications/draw.io.app/Contents/MacOS/draw.io")       # macOS app bundle
else
  for p in "/c/Program Files/draw.io/draw.io.exe" \
           "/mnt/c/Program Files/draw.io/draw.io.exe" \
           "${LOCALAPPDATA:-}/Programs/draw.io/draw.io.exe"; do         # Windows (Git Bash / WSL)
    [[ -n "$p" && -x "$p" ]] && { DRAWIO=("$p"); break; }
  done
fi

# Headless Linux: draw.io (Electron) needs a display; use xvfb-run if available.
if (( ${#DRAWIO[@]} > 0 )) && [[ "$(uname -s)" == Linux && -z "${DISPLAY:-}" ]] \
   && command -v xvfb-run >/dev/null 2>&1; then
  DRAWIO=(xvfb-run -a "${DRAWIO[@]}")
fi

# ---------- 2. Render ----------
shopt -s nullglob
drawio_files=(figures/*.drawio)
if (( ${#drawio_files[@]} > 0 )); then
  if (( ${#DRAWIO[@]} > 0 )); then
    for f in "${drawio_files[@]}"; do
      out="${f%.drawio}.png"
      echo "Rendering $f -> $out"
      "${DRAWIO[@]}" -x -f png -s 2 -b 10 -o "$out" "$f" >/dev/null 2>&1 \
        || warnings+=("draw.io failed to render $f")
    done
  else
    warnings+=("draw.io not found; .drawio files were NOT rendered to PNG. Install draw.io desktop or use the Graphviz/matplotlib fallback.")
  fi
fi

# ---------- 3. Check every image referenced in report.md exists ----------
while IFS= read -r img; do
  [[ -f "$img" ]] || warnings+=("Image referenced in report.md is missing: $img")
done < <(grep -oE '!\[[^]]*\]\([^)]+\)' report.md | sed -E 's/.*\(([^) ]+).*/\1/')

echo
echo "Done. Output in: $(pwd)"
if (( ${#warnings[@]} > 0 )); then
  echo "Warnings:"
  for w in "${warnings[@]}"; do echo "  - $w"; done
fi
