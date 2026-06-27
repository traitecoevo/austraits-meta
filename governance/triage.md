# Triage & contribution discipline (family-wide)

Uniform conventions across the AusTraits family so an issue/PR behaves the same in any family repo.
The label taxonomy lives in [`labels.yml`](labels.yml); board conventions in
[`project-board.md`](project-board.md).

## Labelling discipline

Every issue should end triage with:

- **`pkg:*`** — which package/area. (More than one is fine for cross-cutting issues; pair with `cross:*`.)
- **`type:*`** — bug / feature / docs / refactor / infra / data / epic.
- **Board Priority + Status** — set on the board card, **not** as labels. The board owns these; there
  are deliberately no `priority:*` labels and no `status:` labels for Backlog/In-Progress/Done/On-going
  (see [`project-board.md`](project-board.md) → "Division of labour").
- **`status:*`** — only the out-of-band states the board can't express: `status:triage` (pre-board),
  `status:blocked`, `status:needs-info`.

Add **`cross:*`** whenever the work spans repos:

- `cross:breaking` — downstream-breaking (e.g. an APD vocabulary change). Almost always pair with…
- `cross:contract` — touches a cross-boundary artifact (APD vocab, traits.build schema, APCalign
  parquet, the released `.rds`).
- `cross:ripple` — needs coordinated changes/rebuilds in >1 repo (see `release-playbooks.md`).

Community labels (`good first issue`, `help wanted`, `duplicate`, `wontfix`) are uniform across the
family.

## New issue → done (the short version)

1. New issue lands → `status:triage` + `pkg:*` + `type:*`.
2. Triaged → set board **Priority** + board **Status = Backlog**; drop `status:triage`.
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

## Scope decisions

**Decided 2026-06-28 — governance covers the whole family folder.** The label taxonomy applies to
**every git repo in the austraits-family folder**: pipeline core (`APD`, `APCalign`, `traits.build`,
`austraits.build`, `austraits`, `austraits-meta`), docs/scaffolding (`traits.build-book`,
`traits.build-template`), apps/API/web (`APCalign-app`, `austraits-api`, `austraits-api-nectar`,
`austraits.org`, `austraits.portal`), and sibling databases (`AusFizz`, `ausinvertraits.build`).
Each repo has its own `pkg:*` label and is listed explicitly in `apply-labels.sh`. Still
family-scoped — never org-wide.

### Still open for maintainers

1. **Board config fixes** — `Done` vs `-Done`, and the `low prioirity` typo (see `project-board.md`).
2. **Default labels** — GitHub seeds repos with `bug`/`enhancement`/etc. Decide whether to delete them
   in favour of this taxonomy (the script does NOT delete; see its footer).
3. **`pkg:` granularity** — currently one label per repo (1:1 with the apply list). If that is too noisy
   on peripheral repos, consider grouping (e.g. fold `pkg:austraits-api-nectar` into `pkg:austraits-api`,
   or `pkg:austraits-org`/`pkg:austraits-portal` into a single `pkg:austraits-web`).
