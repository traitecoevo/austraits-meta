# Handoff seed — traits.build book restructure (Deliverable 5c/5d)

**Mission.** Continue the usability overhaul of the **traits.build book**
(`/Users/z2209343/GitHub/austraits-family/traits.build-book`, a Quarto book published at
<https://traitecoevo.github.io/traits.build-book/>). The mechanical fixes are done; what remains is
the heavy content work: **author the missing chapters (5c)** and **restructure/de-duplicate (5d)**.
Run this with **Fable** — it is prose authoring and structural judgement, not mechanical edits.

## Context & state

- The book is a Quarto book (`_quarto.yml` defines the chapter order; theme `cosmo`, HTML only —
  the pdf block is commented out). Render with `quarto render` (whole book executes R across many
  chapters and needs the `austraits`/`traits.build` packages + a pinned `austraits_5.0.0_lite`
  dataset; individual prose chapters render fine with `quarto render <file>.qmd`).
- **Already shipped — PR #28 `book-usability`** (base `master`; may be merged by the time you read
  this — check). It did: fixed dead/wrong cross-references (the `ropensci/targets` &
  `ropensci/tarchetypes` links in `help.qmd`, missing-chapter links in `adding_data_long.qmd` /
  `motivation.qmd` / `traits_build.qmd`, the `tutorial_compilation.qmd` placeholder URL); added a
  **How to cite** section + real `references.bib` (family citation set); de-staled the "October 2023 /
  3 tutorials" claims; fixed the acknowledgement to NCRIS "enabled by" / Planet RDC framing; fixed
  intro-page typos.
- **Coordinate with PR #25** (`minor-edits`, ehwenk): open, based on a March-2025 master, so partly
  stale. Its remaining unique changes are typo fixes in `adding_data_brief.qmd`, `austraits_package.qmd`,
  `create_dictionary.qmd`, `file_organisation.qmd`, `long_wide.qmd`, `spatial_data_example.qmd`,
  `tutorial_datasets.qmd`, `workflow.qmd`, plus `DESCRIPTION`/`render.yaml`. **Do not re-fix those
  typos.** Branch new work off `master` (post-#28). Watch `file_organisation.qmd` and
  `austraits_package.qmd` — both are in #25 AND are 5d restructure targets; rebase/coordinate there.

## 5c — new / rewritten chapters (author real prose, register in `_quarto.yml`)

1. **Quick-start / installation** — new chapter placed FIRST in the Introduction part (before
   `motivation.qmd`). Install `traits.build`, clone `traits.build-template`, build the example
   database in ~5 minutes. Today install exists only as an external link in `index.qmd`. Source
   material: `tutorial_compilation.qmd`, the template repo README.
2. **Troubleshooting** — new `troubleshooting.qmd` (or finish `data_common_issues.qmd`, which is
   flagged "work in progress" and has a `TBC`). `help.qmd:3` links "detailed troubleshooting" →
   `data_common_issues.html`; make that page actually comprehensive. Pull recurring errors from
   `check_dataset_functions.qmd` and the tutorials.
3. **Glossary** — new chapter defining the identifier zoo (`observation_id`, `population_id`,
   `individual_id`, `entity_context_id`, `temporal_context_id`, `plot_context_id`,
   `treatment_context_id`, `method_context_id`) and core terms. `workflow.qmd:43` itself admits the
   identifiers are "overwhelming"; `check_dataset_functions.qmd` shifts between "11 fields" and "17
   columns" — reconcile.
4. **`publishing.qmd`** — currently only restates principles; write actual publish/archive/DOI steps
   (versioned release → Zenodo). Source: `versioned_releases.qmd`, `github.qmd`.
5. Finish `check_dataset_functions.qmd:~243-250` — `dataset_check_duplicates_across_datasets` is
   marked "This function still needs to be written / TO BE WRITTEN"; document it or remove the stub.

## 5d — restructure / de-duplicate

- **Merge duplicated file-structure content.** `file_structure_data_metadata.qmd` (~21 KB, richer) is
  an ORPHAN (not in `_quarto.yml`); `file_organisation.qmd` (in the book) covers the same ground. Keep
  one, wire it in, delete/redirect the other. (`file_organisation.qmd` is also in PR #25 — coordinate.)
- **De-duplicate** the heavy overlap between `austraits_package.qmd` and `AusTraits_tutorial.qmd`.
- **Wire in or delete** the empty `using_data.qmd` stub.
- **Add one ecosystem-placement section/diagram** (where traits.build sits vs APD, APCalign,
  austraits, austraits.build) instead of the scattered mentions in `motivation.qmd`/`usage_examples.qmd`.
  Reuse/point to the new austraits.org **family page** (`family.qmd`) rather than duplicating it.
- **Reorder** the Introduction so quick-start/install precedes the deep concept chapters.

## 5e leftovers (small, not done in #28)

- Reconcile version references across chapters: `austraits_database.qmd` uses `5.0.0`,
  `austraits_package.qmd` mentions `6.0.0`, several chapters load `austraits:::austraits_5.0.0_lite`.
  Pick one current version story.
- Terminology: the product is variously called "manual"/"book"/"vignette"; `adding_data_long.qmd`
  calls itself "this vignette". Standardise.
- `CONTRIBUTING.md`: stray backtick ("targets`` package") and `main`→`master` branch links (default
  branch is `master`).

## Conventions & verification

- Match existing chapter style. Register every new chapter in `_quarto.yml` under the right part.
- New chapters should be prose + minimal/no executed R where possible (heavy R execution makes the
  book fragile — many chapters already depend on the pinned `austraits_5.0.0_lite` internal object).
- **Verify:** `quarto render` the whole book with no errors; run a link checker over `_book/` for zero
  dead internal links; confirm new chapters appear in the sidebar and the bibliography/How-to-cite
  renders. Rebase clean vs PR #25 first.
- Canonical citation + acknowledgement wording: `austraits-meta/references/` and
  `austraits-meta/acknowledgements.md`.
- Full source review with exact line numbers: see the audit summarised in
  `plans/family-usability-overhaul.md` (Deliverable 5).
