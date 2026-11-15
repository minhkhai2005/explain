# Report template

Use these sections in this order. Number headings by hand with a trailing dot (`# 1. ...`, `## 1.1. ...`); References stays unnumbered. A section may be omitted only when it truly does not apply (e.g. no formal/mathematical description exists); say so briefly rather than padding it.

Number figures and tables by hand in order of appearance: captions read "Figure 1: ..." / "Table 1: ..." and go **below** the figure or table, and the text refers to them as "Figure 1" / "Table 1". The same numbers are carried into the DOCX/PDF (see `document-export.md`).

```markdown
<!-- Title block: used for the title page of the DOCX/PDF -->
**Title:** <Term>: <short subtitle>

**Author:** <Author name — confirmed with the user, never guessed>

**Date:** <YYYY-MM-DD>

# List of Abbreviations

| Abbreviation | Full form |
|--------------|-----------|
| <ABC>        | <Full expansion> |

<!-- Unnumbered, alphabetical, every abbreviation used in the report. For a
non-English report add a third column with the meaning in the report's
language, e.g. | Từ viết tắt | Tiếng Anh | Tiếng Việt |. Not a numbered table
and not listed in the List of Tables. -->

# 1. Definition

> "<verbatim formal definition>" [1]

<Paraphrase in plain technical language. One or two paragraphs: what the term
names, and in one sentence why it matters.>

# 2. Background and prerequisites

<Built from reader-profile.md (Step 2). Start at the boundary layer and climb
the concept ladder toward the term, one subsection per layer or per concept
(## 2.1., ## 2.2., ...). Explain in detail every concept the user did not
know at the boundary layer and every concept in the layers above it: what it
is, why it behaves that way, and an example or figure when it helps. Each
explanation may rely only on concepts the user knows or that were explained
just before. Concepts the user knows well get at most a one-sentence reminder.
Define each secondary term at first use.>

# 3. Origin and history

<Who introduced the term, when, in what document, and what problem it solved.
How its meaning evolved, if it did.>

# 4. How it works

<The mechanism, step by step, in prose. Reference the diagram.>

![Figure 1: <Caption describing what the figure shows.>](figures/fig1.png)

As shown in Figure 1, ...

# 5. Formal description

<Equations, models, or formal rules, with every symbol defined and units given.
Derive or cite the source for each equation.>

# 6. Worked example

<A complete example with concrete numbers, carried through to a result. Show
intermediate steps so the reader can reproduce it.>

# 7. Use in practice

<Where and how practitioners encounter the term: products, standards, typical
values, design decisions, a short case study. Cite sources.>

# 8. Related and commonly confused terms

| Term | Definition | Key difference from <term> |
|------|------------|----------------------------|
| ...  | ...        | ...                        |

Table 1: Comparison of <term> with related terms.

# 9. Common misconceptions

<Each misconception, why people hold it, and the correction with a citation.>

# 10. Summary

<One or two paragraphs recapping the definition, mechanism, and significance.>

# References

[1] Author(s), *Title*, Publisher / Standard body, edition or version, year, section/page. URL (accessed YYYY-MM-DD).

[2] ...
```

## Writing rules and why they exist

- **Book-style prose, not bullet points.** Paragraphs force causal links ("because", "therefore") that bullets drop; those links are what make an explanation understandable.
- **Start where the reader's knowledge ends.** A new concept is understood only when it is anchored to something the reader already knows. The knowledge probe finds that point; building upward from it, layer by layer, is what makes the explanation thorough instead of either patronising or opaque.
- **Define jargon at first use.** One undefined term can make a whole paragraph opaque.
- **Numbered citations `[n]`, in order of first appearance**, matching the References list exactly. This makes every claim checkable.
- **Verbatim definition first.** It gives the reader the authoritative wording and protects against drifting paraphrases.
- **Worked example with real numbers.** Abstract descriptions often feel understood until the reader tries to apply them.
- **Target length** 2,000–4,000 words unless the user asked otherwise. Depth comes from mechanism and examples, not repetition.
- **Every figure and table has a caption and is referenced in the text.** An unreferenced figure is usually decoration.
- **Spell out every abbreviation at first use** ("metal–oxide–semiconductor field-effect transistor (MOSFET)") and list it in the List of Abbreviations. Readers jump between sections, and the list lets them look up an acronym without searching for its first use.
- **Flag uncertainty.** If sources disagree or a claim could not be verified, say so explicitly.
