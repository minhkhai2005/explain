# Knowledge probe

A complex term is built from simpler concepts, which are built from simpler ones still. Those layers form a ladder from the basics of the field up to the target term. The report must start at the rung where the reader's knowledge ends: everything below it is known and only needs a reminder, everything from it upward must be explained in detail. Reader level (Step 1) is only a guess at where that rung is. The probe finds it by asking the user directly.

## 1. Build the concept ladder

Before asking anything, list the concepts the target depends on and sort them into layers:

- **Layer 0**: the most basic concepts of the field.
- **Each higher layer**: concepts built from the layer below.
- **Top layer**: the target term itself.

Usually 4–6 layers. Use a standard textbook of the field (its chapter order) or quick research to get the dependencies right. Each layer should hold enough concepts for a question set (at least 5).

Example, target **MOSFET** (structure and operation):

| Layer | Concepts |
|-------|----------|
| 0 | Electric charge, current, voltage, Ohm's law, resistance, capacitance, electric field |
| 1 | Conductor / insulator / semiconductor, energy bands and band gap, electrons and holes, doping, n-type and p-type |
| 2 | p-n junction, depletion region, diode forward and reverse bias, built-in potential, capacitor with a dielectric |
| 3 | MOS capacitor, accumulation / depletion / inversion, threshold voltage, field effect, bipolar transistor (for contrast) |
| 4 | **MOSFET**: channel, triode and saturation regions, pinch-off, body effect |

Keep the ladder in your working notes; do not show it to the user as a lecture.

## 2. Pick the starting layer from the reader level

Start at the layer the user is **most likely to know well**, so the first set is mostly "yes" and the probe climbs from there:

| Reader level | Start at |
|--------------|----------|
| Student | Layer 0–1: the basics of the field (for MOSFET: Ohm's law, diode structure, p-n junction) |
| Practitioner / engineer | A middle layer, about two below the target (for MOSFET: layer 2) |
| Expert | The layer directly below the target |

## 3. Build and ask a question set

- **At least 5 questions per set.** Use more (up to about 10) when the target pulls in many terms or the term is complex.
- **One concept per question**, named concretely with a few words of context so the user can judge it, e.g. "p-n junction: what happens at the boundary where p-type and n-type silicon meet".
- Ask about **familiarity, not a quiz**: no trick questions, nothing to calculate.
- Three answers for every question:
  - **Know it well**
  - **Heard of it, not sure**
  - **Don't know**
- Write the questions in the report's language.
- Before the first set, tell the user in one sentence why: a few quick questions about related concepts so the report starts at the right level.

How to ask:
- If a question tool is available (e.g. AskUserQuestion), use it. It takes at most 4 questions per call, so split a set across calls (5 questions = one call of 4 + one call of 1; 8 questions = two calls of 4).
- Otherwise ask the whole set in one message as a numbered list and let the user reply briefly (e.g. "1a 2a 3c 4b 5a").

## 4. Climb until the user stops knowing

- **Every answer is "Know it well"** → build the next set from the layer above and ask again.
- **Any answer is "Not sure" or "Don't know"** → stop. This is the **boundary layer**.
- Never ask about the target term itself. If the user knows the whole layer directly below the target, the boundary is the target: the report goes straight to the term, with only short reminders of the prerequisites.
- If the user wants to skip the probe, or stops answering, use the starting layer from Section 2 as the boundary and say so.

## 5. Record the result

Save `<term-slug>/reader-profile.md` with:
- the concept ladder,
- each set that was asked, with the user's answers,
- the boundary layer,
- the list of concepts that must be explained in detail (from the next section).

## 6. How the result shapes the report

- **Unknown concepts at the boundary layer** ("Not sure" or "Don't know"): explain each one in detail in the Background section: definition, intuition, and an example or figure when it helps.
- **Every concept in the layers above the boundary, up to the target**: explain each one in detail too, layer by layer from the bottom up, so each explanation rests only on what the reader already knows or what was explained just before.
- **Concepts the user marked "Know it well", and everything below the boundary**: do not re-teach them. At most a one-sentence reminder where they are used.
- **The result shapes the content, never the voice.** The report is written for a general readership so it can be shared. It must not say "you" / "bạn", must not mention what the reader knows or does not know, and must not mention the probe, its questions, its answers or `reader-profile.md`. Do not explain the selection either ("X is explained in detail because…"). Known prerequisites appear only as natural reminders in passing or a neutral line such as "This chapter assumes familiarity with …". `reader-profile.md` is a working file: never copy it into the report, DOCX or PDF.
- If the detailed prerequisites push the report well past the agreed length, tell the user and offer the next length option up (see Length options in `report-template.md`) or say which parts would be shortened. Never silently drop a prerequisite.
