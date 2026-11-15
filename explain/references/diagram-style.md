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

## Choose the style: draw.io first, SVG only when needed

There are two styles. **Style A (draw.io, grayscale) is the default and is always tried first.** Style B (hand-drawn SVG, soft colours) is allowed only when Style A cannot show the subject clearly.

Before drawing each figure, ask: *can this be drawn with boxes, ellipses, simple curves and arrows in grayscale without losing what the reader needs to see?*

- **Yes → Style A.** This covers almost every block diagram, flowchart, sequence, state, tree, timing diagram and simple labelled schematic, in every field, including biology and medicine (e.g. a signalling pathway, the stages of the cell cycle as a cycle diagram, a clinical decision flow).
- **No → Style B**, but only if at least one of these is true:
  - The subject's **shape itself is the content**: anatomy (organs, bones, vessels, nerves), cell and organelle structure, tissue layers, embryo stages, molecular or protein structures, plant structures, and similar organic forms that rectangles and ellipses would distort.
  - Several overlapping or adjacent structures must be **told apart at a glance**, and gray shades plus dash patterns are no longer readable (roughly more than 3 distinct structures touching each other).

Do not use Style B to make a figure prettier, for plain flows or block diagrams, or because the field is medicine or biology. A report may mix both styles: e.g. Figure 1 an anatomical SVG, Figure 2 a draw.io flowchart. When you choose Style B, state the reason in one short sentence in your final message to the user (e.g. "Figure 1 is SVG because the layers of the skin can't be shown with draw.io shapes").

## Style A: draw.io (default)

Simple, professional, scientific, as it would look printed in a textbook:
- Colours: stroke `#333333`, fills `#FFFFFF` and `#F2F2F2`, emphasis fill `#D9D9D9`. Avoid other colours; if one accent is truly needed to separate categories, use a single dark gray `#7F7F7F` with a pattern or dash style rather than hue.
- Font: Helvetica/Arial, 12 pt for labels, 10 pt for annotations, black `#000000`.
- Shapes: rectangles, rounded rectangles, ellipses, straight or orthogonal arrows. No shadows, gradients, 3D, or icons/clip-art.
- Line width 1 pt; arrows with classic or block heads.
- Label every block and arrow that carries meaning; include units on quantities.
- Keep it legible at 85% page width.

### Producing the draw.io file

1. Copy `assets/diagram-template.drawio` to `<term-slug>/figures/figN.drawio`.
2. Edit the XML: add `mxCell` elements inside `<root>` using the styles shown in the template. Every cell needs a unique `id`; vertices have `vertex="1"` and an `mxGeometry` with `x`, `y`, `width`, `height`; edges have `edge="1"`, `source`, `target`.
3. Lay out on a grid (multiples of 10) to keep alignment clean.

### Rendering draw.io to PNG

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

## Style B: SVG illustration (only when Style A cannot work)

Calm, simple, textbook-like: a clean medical/biology atlas drawing, not a poster or an infographic.

**Colour**
- Use soft, muted, low-saturation colours. Suggested palette (pick only what you need, **at most 5 fill colours per figure** plus white and grays):

  | Use | Fill | Stroke |
  |-----|------|--------|
  | Soft tissue, muscle | `#E8C9C3` | `#9C6B63` |
  | Arteries, oxygenated | `#D29A94` | `#8E4F49` |
  | Veins, deoxygenated | `#A9BCD3` | `#55708F` |
  | Nerves | `#EEDFA8` | `#9A8540` |
  | Bone, cartilage | `#EDE5D3` | `#8C806A` |
  | Cell membrane, epithelium | `#C9D8BE` | `#66805A` |
  | Fluid, cytoplasm, background | `#EEF2F4` | `#8A9AA3` |
  | Highlight (the structure the figure is about) | `#C7BEDD` | `#5F5584` |

- Follow common conventions where they exist (arteries red, veins blue, nerves yellow) so readers recognise structures instantly.
- **Forbidden:** saturated or neon colours, pure red/green/blue (`#FF0000` etc.), rainbow schemes, gradients for decoration, drop shadows, glow, 3D effects, textures, clip-art, emoji.
- Shading for depth is allowed only as one or two flat, slightly darker tones of the same colour, never as a gradient.
- The figure must still be understandable when printed in grayscale: neighbouring structures differ in lightness, not only hue.

**Drawing**
- Outlines 1–1.5 px in the matching stroke colour; smooth Bézier paths (`<path d="M ... C ...">`) for organic shapes.
- Leave plenty of white space; omit detail that is not needed to explain the term.
- Labels: Helvetica/Arial, black `#000000`, 12 px for labels and 10 px for annotations, placed outside the drawing with thin leader lines (`#333333`, 0.75 px) that end in a small dot on the structure. Never place labels on busy areas.
- Include a scale bar or orientation markers (anterior/posterior, superior/inferior, apical/basal) when they help the reader.

**File rules**
- Write `<term-slug>/figures/figN.svg` by hand: a single self-contained SVG with a `viewBox` (e.g. `0 0 800 600`), a white background `<rect>`, real `<text>` elements, no external images, fonts, CSS files or scripts.
- Group parts with `<g id="...">` named after the structure (e.g. `<g id="epidermis">`) so the figure stays editable.
- Keep the SVG as the source next to the PNG; edit the SVG, never the PNG.

**Rendering to PNG**: `scripts/render-figures.sh` renders every `figures/*.svg` at 2× scale. It uses the first converter it finds: `rsvg-convert`, `inkscape`, `cairosvg` or `magick`. To render one by hand:

```bash
rsvg-convert -z 2 -b white -o figures/fig1.png figures/fig1.svg
```

After rendering, open the PNG and check it: labels readable, nothing clipped, colours calm. Fix the SVG and re-render if not.

## Fallback when draw.io is not available

Do not silently skip the figure. Ask the user whether to install draw.io; if they decline:
- **Graphviz** (`dot -Tpng -Gdpi=200`) for block, flow, and tree diagrams. Use `node [shape=box, style=filled, fillcolor="#F2F2F2", color="#333333", fontname="Helvetica"]`.
- **matplotlib** for plots and simple schematics (grayscale only: `plt.style.use("grayscale")`).
Keep the source file (`figN.dot` / `figN.py`) next to the PNG so the figure can be edited later.
