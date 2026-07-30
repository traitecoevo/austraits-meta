# Release playbooks — cross-repo sequences

Cross-package change sequences. The ordering matters because the family is a pipeline: APD (vocabulary)
and APCalign (taxonomy) feed `austraits.build`, which uses the `traits.build` engine to produce the
released `.rds` that `austraits` reads. See [`../AGENTS.md`](../AGENTS.md) and
[`../dependencies.yml`](../dependencies.yml) for the graph.

> ⚠️ These are templates, not verified runbooks. Confirm exact commands/scripts in each repo before
> executing. **TODO (maintainer):** replace bracketed steps with the real commands.

---

## 1. Dictionary change (APD) → rebuild dependents

**APD is a contract.** Changing a trait name, URI, allowed categorical value, or unit is a **breaking
change** for everything built against the old vocabulary. Default to treating it as breaking.

1. **APD** — edit the inputs in `data/`, then `make data`. Trait definitions live in
   `APD_traits_input.yml`, which is the source of truth; `make export-csv` / `make import-csv` give you
   a spreadsheet view if you want one. The other inputs are still CSVs. `make check` validates.
   APD has its own [`CONTRIBUTING.md`](https://github.com/traitecoevo/APD/blob/develop/CONTRIBUTING.md)
   — follow that rather than this summary.
2. Decide whether this warrants an **APD version bump** (it usually does if URIs/definitions change),
   and cut the release per
   [`RELEASING.md`](https://github.com/traitecoevo/APD/blob/develop/RELEASING.md). **Downstream reads
   published releases, not a branch**, so nothing below sees the change until a release exists.
3. **APD, hand-off** — the ARDC RVA and Zenodo deposits are **manual uploads owned by Elizabeth Wenk**,
   not automatic. Nothing in APD's CI or its GitHub Releases deposits anything. So a dictionary release
   is not finished when the tag is pushed; it needs her, and it is the step most likely to stall.
   APD 2.1.1 and 2.1.2 both shipped unarchived because the checklist wrongly said an integration
   handled it. Track it as an issue with an assignee rather than a checkbox.
4. **austraits.build** — bump `apd_version` in `scripts/build_traits_yml_from_APD.R` to the new
   release, then re-run it to regenerate `config/traits.yml`. The script reads the release **over
   HTTP**, so this cannot run until APD's deploy has finished and
   `traitecoevo.github.io/APD/release/<X.Y.Z>/APD_traits.csv` returns 200.
5. **austraits.build** — rebuild the database; resolve any trait-validation failures (records using a
   removed/renamed trait or disallowed value will surface here). A regenerated `config/traits.yml` with
   **no diff** means no rebuild is implied — that is the signal the APD change touched nothing this
   database validates against.
6. Sibling traits.build databases (`AusFizz`, `ausinvertraits.build`) that pin APD — repeat steps 4–5.
7. Cut the affected issues with `cross-package` + `breaking`; link across repos.

> **What this section got wrong, twice.** Step 1 used to say edit `*_input.csv` and rebuild via
> `build.qmd`; neither has existed since 2026 — the trait CSV is a gitignored spreadsheet checkout and
> `build.qmd` became a `Makefile`. Step 4 used to omit the version bump, which is the step that actually
> gets missed: `austraits.build` sat on APD 2.1.0 while APD reached 2.1.2 (fixed in
> [austraits.build#852](https://github.com/traitecoevo/austraits.build/pull/852)). And the archive
> hand-off in step 3 was not mentioned at all, which is how two releases went undeposited.
>
> The general lesson, worth applying to the other playbooks here: **a step that depends on an external
> service or another person is the one that silently does not happen.** Give it an owner and an issue,
> and verify the external state rather than assuming a mechanism handled it.

---

## 2. Taxonomy resource change (APCalign) → re-align

1. **APCalign** — regenerate `apc.<date>.parquet` / `apni.<date>.parquet` (`R/release.R`) and publish a
   new GitHub release.
2. Consumers pin a dated version — bump the pinned version in **austraits.build** (and APCalign's own
   tests/benchmarks, e.g. the `2024-10-11` pin) deliberately.
3. **austraits.build** — re-align taxonomy and rebuild; check taxonomic columns / native-introduced
   status for diffs.
4. Label `cross-package` (the parquet is a cross-boundary artifact).

---

## 3. Engine/schema change (traits.build) → rebuild databases

1. **traits.build** — make the change; if `inst/support/traits.build_schema.yml` changed, this is a data
   model change that affects every traits.build database.
2. Run traits.build's own tests/`R CMD check`.
3. **austraits.build** (Depends `traits.build >= x`) and sibling databases — rebuild against the new
   engine; verify the produced structure.
4. **austraits** — confirm it still reads the new structure (load + flatten/join smoke test).
5. If the change touches `austraits::convert_*` / `bind_databases` / `flatten_database` (which
   traits.build Imports), run traits.build's tests **because of the reversed dependency**.

---

## 4. Cutting a new AusTraits dataset release (austraits.build) → Zenodo → austraits

1. **austraits.build** — build the database with the intended APD + APCalign + source-data versions.
2. Validate; update `NEWS.md` and the compendium version.
3. Publish the `austraits-<X.Y.Z>.rds` to **Zenodo** (record `3568418`).
4. **austraits** — users pick it up via `load_austraits()`. Update any pinned/default version references
   and the package's docs/tests if the default changes.

---

## 5. Releasing the `austraits` access package (CRAN)

> **TODO (maintainer):** document the actual CRAN release steps (R CMD check, win/mac builders,
> `cran-comments`, version bump, tag). Same for `APCalign` (it is on CRAN with `cran-comments.md` and a
> `CRAN-SUBMISSION` file).

---

## Quick ripple reference

| You changed… | Must rebuild/check… |
|--------------|----------------------|
| APD vocabulary | austraits.build config + rebuild; sibling DBs; (breaking) |
| APCalign parquet/format | bump pins; austraits.build re-align |
| traits.build schema/engine | austraits.build + sibling DBs; austraits reads |
| austraits conversion helpers | traits.build tests (reversed dep) |
| austraits.build sources/version | new Zenodo .rds; austraits version refs |
