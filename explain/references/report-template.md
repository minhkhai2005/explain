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
just before. Concepts the user knows well get at most a one-sentence reminder,
woven in naturally. Write it as a book section for any reader: never mention
the reader, the probe, or why a concept is or is not explained (see the
"general readership" rule below).
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

## Length options

The user picks one of these in Step 1. Every option keeps **all** sections of the outline and explains every prerequisite the knowledge probe finds; the options differ in how much each section contains. Word counts are for the body (sections 1 to Summary) and are approximate; page counts are for the DOCX with figures (about 350–400 words per page), not counting the front matter.

| | **Concise** | **Standard** (default) | **In-depth** |
|---|---|---|---|
| Length | ~1,500–2,500 words, ~5–8 pages | ~3,000–5,000 words, ~10–15 pages | ~6,000–10,000 words, ~20–30 pages |
| Best for | Getting the core idea quickly, a quick reference, a short briefing | Understanding the term properly, a study or internal report | Mastering the term, designing with it, teaching it, a thesis or literature chapter |
| Background (prerequisites from the probe) | Each concept explained in one or two paragraphs | Each concept gets its own subsection with an explanation and a short example | Each concept gets its own subsection with an example and, where useful, a figure |
| Definition and history | Formal definition; history in one paragraph | Formal definition with paraphrase; history in 2–3 paragraphs (origin, key milestones) | Definition compared across several standards or sources; detailed history with a timeline |
| How it works | Main mechanism, step by step | Full mechanism, including the main operating modes or cases | Full mechanism plus variants, edge cases and second-order effects |
| Formal description | Key equations only, symbols defined, no derivation | Main equations with short derivations or reasoning | Full derivations, model assumptions and where the model breaks down |
| Worked examples | 1 short example | 1 complete multi-step example | 2 or more: a textbook example and a realistic one with real parameters |
| Use in practice | 2–3 applications in a paragraph each | 3–5 applications plus 1 short case study | Many applications, 2 or more case studies, typical values and design trade-offs |
| Comparison and misconceptions | Table of 2–3 related terms; 2–3 misconceptions | Table of 4–6 related terms; 4–5 misconceptions | Extended comparison table; 5 or more misconceptions; open questions and current research directions |
| Figures and tables | 1 figure (the mechanism), 1 table | 2–3 figures, 1–2 tables | 4 or more figures, 3 or more tables |
| Sources | ~6–10 | ~10–20 | 20 or more |

When asking, show each option with its length **and** a one-line summary of what it contains, in the user's language, so the options can be compared at a glance. For example (Vietnamese):

- **Ngắn gọn** (~1.500–2.500 từ, ~5–8 trang): ý chính và cơ chế hoạt động, phương trình cốt lõi không chứng minh, 1 ví dụ ngắn, 1 hình, ~6–10 nguồn.
- **Tiêu chuẩn** (~3.000–5.000 từ, ~10–15 trang; mặc định): đầy đủ cơ chế và các chế độ hoạt động, phương trình có suy luận ngắn, 1 ví dụ tính toán hoàn chỉnh, 1 tình huống thực tế, 2–3 hình, ~10–20 nguồn.
- **Chuyên sâu** (~6.000–10.000 từ, ~20–30 trang): thêm biến thể, hiệu ứng bậc hai, chứng minh đầy đủ và giới hạn của mô hình, từ 2 ví dụ, nhiều tình huống thực tế, từ 4 hình, từ 20 nguồn.

If the user gives their own word or page count instead, use the closest option as the guide for what to include.

## Writing rules and why they exist

- **Book-style prose, not bullet points.** Paragraphs force causal links ("because", "therefore") that bullets drop; those links are what make an explanation understandable.
- **Start where the reader's knowledge ends.** A new concept is understood only when it is anchored to something the reader already knows. The knowledge probe finds that point; building upward from it, layer by layer, is what makes the explanation thorough instead of either patronising or opaque.
- **Write for a general readership, never for one person.** The report must read like a chapter of a technical book that anyone in the field can pick up, so it can be shared. The knowledge probe only decides *where the explanation starts and how deep it goes*; it must leave no trace in the text. Never address the reader as "you" / "bạn", never mention what someone knows or does not know, never mention the probe, the questions, the answers or the reader profile, and never explain why a concept is or is not covered. Prerequisites that are not re-taught are woven in naturally as shared background (a short reminder in passing, or a neutral book-style statement such as "This chapter assumes familiarity with UART framing and baud rate"). Use the impersonal or "we" voice of textbooks ("Consider…", "As in UART, …", "Ta xét…").

  | Avoid (personal) | Prefer (book voice) |
  |------------------|---------------------|
  | "Bạn đã nắm vững UART và baud rate, … nên các ý đó chỉ được nhắc lại khi cần." | "Phần này giả định người đọc đã quen với khung truyền UART và khái niệm baud rate; hai ý này chỉ được nhắc lại khi cần." or simply start the section and recall UART in passing where it is used. |
  | "Ở lớp nền, hai khái niệm sẽ được giải thích kỹ là mã hóa NRZ và mã kiểm lỗi CRC." (because the reader didn't know them) | "Hai nền tảng của tầng vật lý CAN là mã hóa NRZ và mã kiểm lỗi CRC." then explain them. |
  | "Since you already know p-n junctions, …" | "Recall that a p-n junction …" |
- **Define jargon at first use.** One undefined term can make a whole paragraph opaque.
- **Numbered citations `[n]`, in order of first appearance**, matching the References list exactly. This makes every claim checkable.
- **Verbatim definition first.** It gives the reader the authoritative wording and protects against drifting paraphrases.
- **Worked example with real numbers.** Abstract descriptions often feel understood until the reader tries to apply them.
- **Stay within the chosen length option** (see Length options above). Depth comes from mechanism and examples, not repetition.
- **Every figure and table has a caption and is referenced in the text.** An unreferenced figure is usually decoration.
- **Spell out every abbreviation at first use** ("metal–oxide–semiconductor field-effect transistor (MOSFET)") and list it in the List of Abbreviations. Readers jump between sections, and the list lets them look up an acronym without searching for its first use.
- **Flag uncertainty.** If sources disagree or a claim could not be verified, say so explicitly.
