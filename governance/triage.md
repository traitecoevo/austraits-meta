# Triage & contribution discipline (family-wide)

Uniform conventions across the AusTraits family so an issue/PR behaves the same in any family repo.
The label taxonomy lives in [`labels.yml`](labels.yml); board conventions in
[`project-board.md`](project-board.md).

## Labelling discipline

Every issue should end triage with **at least one of each** of these axes:

- **`pkg:*`** — which package/area. (More than one is fine for cross-cutting issues; pair with `cross:*`.)
- **`type:*`** — bug / feature / docs / refactor / infra / data.
- **`priority:*`** — set when triaged (aligns to board #9's Priority field).
- **`status:*`** — workflow state (aligns to board #9's Status field).

Add **`cross:*`** whenever the work spans repos:

- `cross:breaking` — downstream-breaking (e.g. an APD vocabulary change). Almost always pair with…
- `cross:contract` — touches a cross-boundary artifact (APD vocab, traits.build schema, APCalign
  parquet, the released `.rds`).
- `cross:ripple` — needs coordinated changes/rebuilds in >1 repo (see `release-playbooks.md`).

Community labels (`good first issue`, `help wanted`, `duplicate`, `wontfix`) are uniform across the
family.

## New issue → done (the short version)

1. New issue lands → `status:triage` + `pkg:*` + `type:*`.
2. Triaged → add `priority:*`, set board **Status = Backlog**, add to board #9.
3. Started → board **Status = In Progress**.
4. Cross-package? → add `cross:*` and **link the partner issues in the other repos**. Use the
   relevant playbook in `release-playbooks.md`.
5. Done → board **Status = Done**, close.

## PR discipline (family-wide)

- All work goes through a **feature branch + PR**; never commit to a repo's default branch.
- Default branches vary across the family — confirm before branching:
  `traits.build` → `master`, `APCalign` → `master`, `austraits` → `master`, `APD` → `develop`,
  `austraits.build` → `develop`, `austraits-meta` → `main`.
- R packages: PRs must pass `R CMD check` / testthat (see each repo's `.github/workflows/`).
- For cross-package changes, link the PRs to each other and to the tracking issue, and label `cross:*`.

## Source-of-truth reminders (don't fight the pipeline)

- Trait definitions/values/units → **APD**. Don't redefine them downstream.
- Taxonomy/name resolution/status → **APCalign**. Downstream consumes the released parquet.
- Data model/schema → **traits.build**. Conform to it.
- The dataset itself → **austraits.build** (released on Zenodo).
- See [`../AGENTS.md`](../AGENTS.md) for the full rules and gotchas.

---

## Scope decisions still needed (open questions for maintainers)

These are flagged rather than guessed — please decide:

1. **Does the label taxonomy apply to `austraits.build`?** It is the **central pipeline node** (the glue
   that wires APD + APCalign + the engine and produces the released `.rds`), but the task-defined core
   list — and therefore `apply-labels.sh` and `labels.yml`'s `pkg:*` set — currently treats it as a
   separate concern. A `pkg:austraits-build` label **exists** in `labels.yml`, but `austraits.build` is
   **not** in `apply-labels.sh`'s target list. Recommendation: **add it.** To do so, append
   `traitecoevo/austraits.build` to `FAMILY_REPOS` in `apply-labels.sh`.

2. **Do the API / book / website / app repos get the family labels?** Board #9 covers `austraits-api`,
   `traits.build-book`, `austraits.org`, `austraits.portal`, `APCalign-app`. They are family members but
   not pipeline-core. Decide whether they should carry the same taxonomy (and gain `pkg:*` entries).

3. **Sibling traits.build databases** (`AusFizz`, `ausinvertraits.build`) are on board #9 and depend on
   the `traits.build` engine + APD. Do they get `pkg:*` labels, or a generic `pkg:traits-build-db`?

4. **Board config fixes** — `Done` vs `-Done`, and the `low prioirity` typo (see `project-board.md`).

5. **Default labels** — GitHub seeds repos with `bug`/`enhancement`/etc. Decide whether to delete them
   in favour of this taxonomy (the script does NOT delete; see its footer).
