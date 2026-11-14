# AusTraits family — cross-package orientation

This file is the **single source of truth** for cross-package, organisational knowledge in the
AusTraits family. `CLAUDE.md` defers to this file so the same content serves every agent and tool.

It is authoritative **only for cross-package concerns**. Anything that lives entirely inside one
repo (how a function works, local build quirks) belongs in that repo's own `CLAUDE.md`/`AGENTS.md`,
not here.

> ⚠️ **Drift caveat.** This is hand-maintained prose, not generated from the code. Treat it as a map,
> not as ground truth. Before you rely on a specific file path, function name, artifact version, or
> dependency edge, **verify it in the relevant repo** — the repos move faster than this document.
> If you find drift, fix it here in the same change.

---

## The family (scope)

This document and the governance in `governance/` are scoped to the **AusTraits family**, a subset of
the `traitecoevo` org. The org hosts other, unrelated families (e.g. the `plant` modelling stack) —
nothing here applies to them.

**Pipeline-core packages** (the focus of this repo):

| Repo | Kind | Owns |
|------|------|------|
| `APD` | Quarto compendium | The AusTraits Plant Dictionary — the trait **vocabulary/contract** (definitions, allowed categorical values, units). |
| `APCalign` | R package | Plant **taxonomy alignment** against the Australian Plant Census/APNI; native/introduced status. |
| `traits.build` | R package | The generic **workflow engine** + relational **data model/schema** for harmonising trait data. |
| `austraits.build` | Compendium | The actual **AusTraits dataset compilation** (uses the engine + APD + APCalign). Produces the released `.rds`. |
| `traits.use` | R package (0.1.1, heading for CRAN) | The generic **reader**: the access/wrangle API (load, extract, join, flatten, summarise, plot) for any `traits.build` database. Split out of `austraits` in 2026 ([austraits#188](https://github.com/traitecoevo/austraits/issues/188)). |
| `austraits` | R package (4.0.0) | The thin **AusTraits layer** over `traits.use`: `load_austraits()` / `get_versions()` / `get_version_latest()`, the Australia basemap for `plot_locations()`, the AusTraits vignette; re-exports every `traits.use` function. |
| `austraits-meta` | this repo | Cross-package knowledge + governance (labels, board, playbooks). |

**Other family repos** (in scope for the family/board #9 and for governance, but not pipeline core):
`traits.build-book`, `traits.build-template`, `austraits-api`, `austraits.org`,
`austraits.portal`, `APCalign-app`, the derived species-means product `austraits-means`, and sibling
traits.build databases `AusFizz` and `ausinvertraits.build`.

> **Governance scope (decided 2026-06-28):** the label taxonomy applies to **every git repo in the
> austraits-family folder** — all of the above plus the pipeline core, including `austraits.build`.
> `governance/apply-labels.sh` targets the full explicit list. There are **no `pkg:` labels** — which
> repo an issue concerns is the board's `Repository` field. Still scoped to the family ONLY (never org-wide).

---

## The pipeline (what flows where)

There are **two distinct graphs**: a build/data-flow graph (how the AusTraits dataset is made) and an
R-package install graph (which package `Imports`/`Depends` which). They do **not** point the same way —
this is the single most common source of confusion.

### Data flow (how AusTraits gets built and consumed)

```
   APD ───────────────┐  (trait definitions, allowed values, units)
   (vocabulary/        │
    contract)          ▼
                  austraits.build ──(assembled by)──► traits.build (engine)
   APCalign ──────────▲   │
   (apc/apni parquet,  │   │ produces
    taxonomy)          │   ▼
                       │  austraits-X.Y.Z.rds  ──published──►  Zenodo
                       │                                          │
   raw source datasets─┘                                          │ load_database() / load_austraits()
                                                                  ▼
                                                              traits.use  (generic reader)
                                                                  │
                                                     ┌────────────┴────────────┐
                                                     ▼                         ▼
                                                 austraits              austraits.portal
                                         (AusTraits layer: versions,   (Trait View plots,
                                          basemap, vignette)            data preparation)
```

1. **APD** publishes the trait vocabulary as CSV/RDF (`APD_traits.csv`, `APD_categorical_values.csv`,
   `data/APD_trait_hierarchy.csv`, plus `APD.ttl/.json/.nq/.nt` and `w3id.org/APD/...` URIs).
2. **austraits.build** turns those into its build config (`scripts/build_traits_yml_from_APD.R` →
   `config/traits.yml`), aligns taxonomy with **APCalign** (`apc.*.parquet` / `apni.*.parquet` from
   APCalign's GitHub releases), and runs the **traits.build** engine over raw source datasets.
3. The compiled database is released as `austraits-X.Y.Z.rds` on **Zenodo**.
4. **traits.use** loads any traits.build database from its DOI (`load_database()`) and gives users
   functions to filter/join/flatten/plot it. **austraits** adds `load_austraits()` (AusTraits by
   version number; Zenodo record `3568418`) and re-exports the rest from traits.use.

### R-package install graph (note the reversed edges)

```
austraits.build ───────┐
ausinvertraits.build ──┴──Depends──►  traits.build  ──Depends──►  traits.use
                                                                      ▲
austraits ────────────────────────────Imports─────────────────────────┤
austraits.portal ─────────────────────Imports─────────────────────────┘
```

(The two data repos also list `traits.use` in their own `Depends`.)

- `traits.build` **Depends** on `traits.use (>= 0.1.1)` (since traits.build#321, on `develop`). It
  imports five low-level helpers (`convert_list_to_df1/2`, `convert_df_to_list`, `bind_databases`,
  `flatten_database`) and re-exports the trait plots (`plot_trait_distribution()`,
  `plot_categorical_trait_distribution()`, `plot_trait_distribution_jitter()`; traits.use#21). So at
  install time **traits.build depends on traits.use**, even though in the data flow traits.build is
  "upstream" of it. The released traits.build 2.2.0 (`master`) still Imports `austraits` instead,
  which keeps working because austraits re-exports those functions.
- `traits.use` must **never** depend on traits.build: it is CRAN-bound, and traits.build is not on
  CRAN (+57 recursive dependencies).
- `austraits` (4.0.0) and `austraits.portal` **Import** `traits.use`; both install it from GitHub via
  `Remotes: traitecoevo/traits.use`.
- `austraits.build` **Depends** on `traits.build (>= 2.2.0.9000)` and `traits.use`, with
  `Remotes: traitecoevo/traits.build@develop`. `ausinvertraits.build` Depends on both, unpinned —
  and traits.build's **default branch is `develop`**, so a bare `traitecoevo/traits.build` Remote
  installs develop, not the 2.2.0 release.
- `APD` and `APCalign` have **no** intra-family R-package dependencies (APCalign is a standalone CRAN
  package; APD is a compendium, not an installable library).

The machine-readable version of all of this is in [`dependencies.yml`](dependencies.yml).

---

## Source-of-truth rules

| Concern | Authoritative repo | Everyone else |
|---------|--------------------|---------------|
| Trait definitions, allowed categorical values, units, trait URIs | **APD** | consume; never redefine |
| Taxonomy: current accepted names, synonyms, native/introduced status | **APCalign** (over APC/APNI) | consume the released parquet |
| Relational data model / schema (`traits.build_schema.yml`) | **traits.build** | conform to it |
| The AusTraits dataset itself (which sources, versions, the `.rds`) | **austraits.build** | cite the Zenodo release |
| Access/wrangling API for traits.build databases | **traits.use** | `austraits` re-exports it; add new functions to traits.use first |

---

## Gotchas (the things that bite across boundaries)

- **APD is a contract, so editing it is a breaking change downstream.** A changed trait name, URI,
  allowed value, or unit can invalidate `austraits.build`'s config and any database built against the
  old vocabulary. **Edit with caution, then regenerate dependents** (re-run
  `build_traits_yml_from_APD.R`, rebuild, re-validate). See `governance/release-playbooks.md`.
- **traits.use/austraits assume taxonomy has already been aligned.** The `.rds` they load has already
  been run through APCalign during `austraits.build`. They do **not** re-align names; garbage-in
  taxonomy is an `austraits.build`/APCalign concern, not a reader one.
- **The reversed R dependency (traits.build → traits.use).** When changing the conversion helpers or
  trait plots in `traits.use`, you can break `traits.build`'s build/check. Run traits.build's tests
  after touching `traits.use::convert_*` / `bind_databases` / `flatten_database` /
  `plot_trait_distribution*()`.
- **Adding a traits.use export breaks austraits' tests** until austraits re-exports it
  (`tests/testthat/test-reexports.R` checks austraits re-exports everything).
- **APCalign artifacts are versioned and pinned.** Consumers pin a dated resource version
  (e.g. APCalign tests pin `2024-10-11`). Bumping the released parquet is a downstream-visible event.
- **traits.build/ontology ≠ APD.** `traits.build/ontology/` is the ontology of the *data model*
  (entities/relations); APD is the ontology of *trait definitions*. They are parallel, not the same
  vocabulary. Don't conflate them.
- **`austraits.build` is the glue** that actually wires APD + APCalign + the engine together. If you
  are reasoning about "how does a change ripple to the released database", `austraits.build` is almost
  always the node in the middle.

---

## When you change something — ripple checklist

- **Changing APD** → regenerate `austraits.build` config (`build_traits_yml_from_APD.R`) → rebuild →
  check trait validation; flag a vocabulary version bump. Breaking by default.
- **Changing APCalign output/format/version** → re-release parquet → `austraits.build` re-align →
  re-check taxonomy columns.
- **Changing traits.build schema/engine** → `austraits.build` (Depends) and any other traits.build
  database (`AusFizz`, `ausinvertraits.build`) may need rebuilds; check `traits.use` reads the new
  structure.
- **Changing traits.use conversion helpers or plots** → run `traits.build` tests (it Depends on
  traits.use and re-exports them); a new export → re-export it in `austraits`.
- **Cutting a new AusTraits release in `austraits.build`** → new Zenodo `.rds` → users get it via
  `load_austraits()` / `traits.use::load_database()`; update version references.

See `governance/release-playbooks.md` for the step-by-step versions of these.

---

## Shared assets (in this repo)

- [`references/key-papers.md`](references/key-papers.md) + [`references/austraits-family.bib`](references/austraits-family.bib)
  — the family's canonical citation set. Every repo's "How to cite" should draw from here so citations
  stay consistent; `key-papers.md` says which repos cite which paper.
- [`acknowledgements.md`](acknowledgements.md) — canonical partner + ARDC/NCRIS co-investment wording.
  Propagate this block into repo READMEs rather than re-writing (the wording had drifted).

## Governance (in this repo)

- [`dependencies.yml`](dependencies.yml) — machine-readable package graph + cross-boundary artifacts.
- [`governance/labels.yml`](governance/labels.yml) — the family label taxonomy (single source of truth).
- [`governance/apply-labels.sh`](governance/apply-labels.sh) — idempotent sync of labels to the family
  repos. **Gated**: hard-coded repo list, run only with maintainer go-ahead.
- [`governance/project-board.md`](governance/project-board.md) — structure/conventions of family board
  [#9](https://github.com/orgs/traitecoevo/projects/9); labels-vs-board-fields division of labour.
- [`governance/auto-add-to-board.md`](governance/auto-add-to-board.md) — auto-add new issues to board #9.
- [`governance/issue-guide.md`](governance/issue-guide.md) — contributor guide for filing/labelling issues.
- [`governance/commit-messages.md`](governance/commit-messages.md) — commit/PR-description convention;
  squash merge makes the PR title + body the permanent commit message.
- [`governance/plant-family-handoff.md`](governance/plant-family-handoff.md) — meta-repo pattern + plant-family handoff.
- [`governance/release-playbooks.md`](governance/release-playbooks.md) — cross-repo release sequences.
- [`governance/triage.md`](governance/triage.md) — contribution + triage discipline, plus open scope
  questions for maintainers.
