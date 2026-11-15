# Diagrams

## Choose the right kind of diagram

Every figure should explain something that is hard to explain in prose. Pick the type that fits:

| Term describes... | Diagram type |
|-------------------|--------------|
| A system or architecture | Block diagram |
| A protocol or interaction over time | Sequence or timing diagram |
| A process or algorithm | Flowchart or state diagram |
| A physical structure | Cross-section or labelled schematic |
| A relationship between quantities | Plot (use matplotlib, not draw.io) |
| A taxonomy or hierarchy | Tree diagram |

At least one figure must show **how the thing works** (the mechanism). Additional figures are optional.

## Style

Simple, professional, scientific, as it would look printed in a textbook:
- Colours: stroke `#333333`, fills `#FFFFFF` and `#F2F2F2`, emphasis fill `#D9D9D9`. Avoid other colours; if one accent is truly needed to separate categories, use a single dark gray `#7F7F7F` with a pattern or dash style rather than hue.
- Font: Helvetica/Arial, 12 pt for labels, 10 pt for annotations, black `#000000`.
- Shapes: rectangles, rounded rectangles, ellipses, straight or orthogonal arrows. No shadows, gradients, 3D, or icons/clip-art.
- Line width 1 pt; arrows with classic or block heads.
- Label every block and arrow that carries meaning; include units on quantities.
- Keep it legible at 85% page width.

## Producing the draw.io file

1. Copy `assets/diagram-template.drawio` to `<term-slug>/figures/figN.drawio`.
2. Edit the XML: add `mxCell` elements inside `<root>` using the styles shown in the template. Every cell needs a unique `id`; vertices have `vertex="1"` and an `mxGeometry` with `x`, `y`, `width`, `height`; edges have `edge="1"`, `source`, `target`.
3. Lay out on a grid (multiples of 10) to keep alignment clean.

## Rendering to PNG

`scripts/render-figures.sh` renders every `figures/*.drawio` automatically. To render one by hand:

```bash
# macOS app bundle
/Applications/draw.io.app/Contents/MacOS/draw.io -x -f png -s 2 -b 10 -o figures/fig1.png figures/fig1.drawio
# Linux / CLI on PATH (prefix with `xvfb-run -a` on a headless server)
drawio -x -f png -s 2 -b 10 -o figures/fig1.png figures/fig1.drawio
# Windows (PowerShell)
& "C:\Program Files\draw.io\draw.io.exe" -x -f png -s 2 -b 10 -o figures\fig1.png figures\fig1.drawio
```

`-s 2` gives 2× scale for crisp print output; `-b 10` adds a 10 px border.

## Fallback when draw.io is not available

Do not silently skip the figure. Ask the user whether to install draw.io; if they decline:
- **Graphviz** (`dot -Tpng -Gdpi=200`) for block, flow, and tree diagrams. Use `node [shape=box, style=filled, fillcolor="#F2F2F2", color="#333333", fontname="Helvetica"]`.
- **matplotlib** for plots and simple schematics (grayscale only: `plt.style.use("grayscale")`).
Keep the source file (`figN.dot` / `figN.py`) next to the PNG so the figure can be edited later.
