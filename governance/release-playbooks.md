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

1. **APD** — make the change in the `*_input.csv` source files (not the generated outputs); rebuild via
   `build.qmd` so `APD_traits.csv`, `APD_categorical_values.csv`, `APD.ttl/.json/...` regenerate.
2. Decide whether this warrants an **APD version bump** (it usually does if URIs/definitions change).
3. **austraits.build** — re-run `scripts/build_traits_yml_from_APD.R` to regenerate `config/traits.yml`
   from the new APD outputs.
4. **austraits.build** — rebuild the database; resolve any trait-validation failures (records using a
   removed/renamed trait or disallowed value will surface here).
5. Sibling traits.build databases (`AusFizz`, `ausinvertraits.build`) that pin APD — repeat steps 3–4.
6. Cut the affected issues with `cross:breaking` + `cross:contract`; link across repos.

---

## 2. Taxonomy resource change (APCalign) → re-align

1. **APCalign** — regenerate `apc.<date>.parquet` / `apni.<date>.parquet` (`R/release.R`) and publish a
   new GitHub release.
2. Consumers pin a dated version — bump the pinned version in **austraits.build** (and APCalign's own
   tests/benchmarks, e.g. the `2024-10-11` pin) deliberately.
3. **austraits.build** — re-align taxonomy and rebuild; check taxonomic columns / native-introduced
   status for diffs.
4. Label `cross:contract` (the parquet is a cross-boundary artifact).

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
