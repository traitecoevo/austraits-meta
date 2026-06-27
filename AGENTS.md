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
| `austraits` | R package | The user-facing **access/wrangle API** for `traits.build`-format databases (incl. AusTraits). |
| `austraits-meta` | this repo | Cross-package knowledge + governance (labels, board, playbooks). |

**Other family repos** (in scope for the family/board #9 and for governance, but not pipeline core):
`traits.build-book`, `traits.build-template`, `austraits-api`, `austraits-api-nectar`, `austraits.org`,
`austraits.portal`, `APCalign-app`, and sibling traits.build databases `AusFizz` and
`ausinvertraits.build`.

> **Governance scope (decided 2026-06-28):** the label taxonomy applies to **every git repo in the
> austraits-family folder** — all of the above plus the pipeline core, including `austraits.build`.
> `governance/labels.yml` carries a `pkg:` label per repo and `governance/apply-labels.sh` targets the
> full explicit list. It is still scoped to the family ONLY (never org-wide).

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
   raw source datasets─┘                                          │ load_austraits()
                                                                  ▼
                                                              austraits
                                                          (access / wrangle)
```

1. **APD** publishes the trait vocabulary as CSV/RDF (`APD_traits.csv`, `APD_categorical_values.csv`,
   `data/APD_trait_hierarchy.csv`, plus `APD.ttl/.json/.nq/.nt` and `w3id.org/APD/...` URIs).
2. **austraits.build** turns those into its build config (`scripts/build_traits_yml_from_APD.R` →
   `config/traits.yml`), aligns taxonomy with **APCalign** (`apc.*.parquet` / `apni.*.parquet` from
   APCalign's GitHub releases), and runs the **traits.build** engine over raw source datasets.
3. The compiled database is released as `austraits-X.Y.Z.rds` on **Zenodo**.
4. **austraits** downloads that `.rds` (`load_austraits()`, Zenodo record `3568418`) and gives users
   functions to filter/join/flatten/plot it.

### R-package install graph (note the reversed edges)

```
austraits.build  ──Depends──►  traits.build  ──Imports──►  austraits
```

- `traits.build` **Imports** five low-level helpers from `austraits`
  (`convert_list_to_df1/2`, `convert_df_to_list`, `bind_databases`, `flatten_database`;
  see `traits.build/NAMESPACE` + `traits.build/R/utils.R`). So at install time **traits.build depends
  on austraits**, even though in the data flow traits.build is "upstream" of austraits. The
  list↔data-frame conversion helpers were moved into `austraits` and traits.build re-exports them
  (deprecated aliases).
- `austraits.build` **Depends** on `traits.build (>= 2.1.0)`.
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
| Access/wrangling API for traits.build databases | **austraits** | — |

---

## Gotchas (the things that bite across boundaries)

- **APD is a contract, so editing it is a breaking change downstream.** A changed trait name, URI,
  allowed value, or unit can invalidate `austraits.build`'s config and any database built against the
  old vocabulary. **Edit with caution, then regenerate dependents** (re-run
  `build_traits_yml_from_APD.R`, rebuild, re-validate). See `governance/release-playbooks.md`.
- **austraits assumes taxonomy has already been aligned.** The `.rds` austraits loads has already been
  run through APCalign during `austraits.build`. austraits does **not** re-align names; garbage-in
  taxonomy is an `austraits.build`/APCalign concern, not an austraits one.
- **The reversed R dependency (traits.build → austraits).** When changing the conversion helpers in
  `austraits`, you can break `traits.build`'s build/check. Run traits.build's tests after touching
  `austraits::convert_*` / `bind_databases` / `flatten_database`.
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
  database (`AusFizz`, `ausinvertraits.build`) may need rebuilds; check `austraits` reads the new
  structure.
- **Changing austraits conversion helpers** → run `traits.build` tests (it Imports them).
- **Cutting a new AusTraits release in `austraits.build`** → new Zenodo `.rds` → `austraits` users get
  it via `load_austraits()`; update version references.

See `governance/release-playbooks.md` for the step-by-step versions of these.

---

## Governance (in this repo)

- [`dependencies.yml`](dependencies.yml) — machine-readable package graph + cross-boundary artifacts.
- [`governance/labels.yml`](governance/labels.yml) — the family label taxonomy (single source of truth).
- [`governance/apply-labels.sh`](governance/apply-labels.sh) — idempotent sync of labels to the family
  repos. **Gated**: hard-coded repo list, run only with maintainer go-ahead.
- [`governance/project-board.md`](governance/project-board.md) — structure/conventions of family board
  [#9](https://github.com/orgs/traitecoevo/projects/9); labels-vs-board-fields division of labour.
- [`governance/auto-add-to-board.md`](governance/auto-add-to-board.md) — auto-add new issues to board #9.
- [`governance/release-playbooks.md`](governance/release-playbooks.md) — cross-repo release sequences.
- [`governance/triage.md`](governance/triage.md) — contribution + triage discipline, plus open scope
  questions for maintainers.
