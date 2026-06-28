# Triage & contribution discipline (family-wide)

Uniform conventions across the AusTraits family so an issue/PR behaves the same in any family repo.
The label taxonomy lives in [`labels.yml`](labels.yml); board conventions in
[`project-board.md`](project-board.md).

## Labelling discipline

Every issue should end triage with:

- **work-type** — `bug` / `task` / `epic` (the shared org-wide core; same names as plant-family).
- **Which repo** is the board's `Repository` field (automatic) — there are **no `pkg:` labels**. For a
  sub-area within a repo, prefix the title `[area]` (e.g. `[schema] ...`). See `project-board.md`.
- **Board Priority + Status** — set on the board card, **not** as labels. The board owns these; there
  are no `priority:`/`status:` labels. A new issue with **no Status** *is* the triage queue — there is
  no `triage` label (see [`project-board.md`](project-board.md) → "Division of labour").
- **`blocked` / `needs-info`** — orthogonal flags that can apply at any board Status.

Add cross-package signals whenever work spans repos:

- **`cross-package`** — has consequences beyond this repo: coordinated changes/rebuilds across
  packages (see `release-playbooks.md`).
- **`breaking`** — a breaking change with downstream impact (often paired with `cross-package`).

`question` is the one community label.

## New issue → done (the short version)

1. New issue lands → auto-added to board #9 with **no Status** (= the triage queue); add a work-type
   (`bug`/`task`/`epic`).
2. Triaged → set board **Priority** + board **Status = Backlog**.
3. Started → board **Status = In Progress**.
4. Cross-package? → add `cross-package` (and `breaking` if it breaks dependents) and **link the partner
   issues in the other repos**. Use the relevant playbook in `release-playbooks.md`.
5. Done → board **Status = Done**, close (comment the resolution rather than labelling it).

## PR discipline (family-wide)

- All work goes through a **feature branch + PR**; never commit to a repo's default branch.
- Default branches vary across the family — confirm before branching:
  `traits.build` → `master`, `APCalign` → `master`, `austraits` → `master`, `APD` → `develop`,
  `austraits.build` → `develop`, `austraits-meta` → `main`.
- R packages: PRs must pass `R CMD check` / testthat (see each repo's `.github/workflows/`).
- For cross-package changes, link the PRs to each other and to the tracking issue, and label
  `cross-package` (+ `breaking` if dependents must change).

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
Each is listed explicitly in `apply-labels.sh`. Still family-scoped — never org-wide.

### Resolved

- **No `pkg:` labels** (2026-06-28). "Which repo" = the board's `Repository` field; sub-area = `[prefix]`
  title; cross-package impact = `cross-package`/`breaking`. A `pkg:` label per repo just duplicated `Repository`.
- **Community labels trimmed** — dropped `good first issue` / `help wanted` / `duplicate` / `invalid` /
  `wontfix` (comment on close instead). No `triage` label (no-Status = triage queue).
- **Board Status** — deleted unused `-Done`; kept `Backlog/In Progress/Done/On-going`.

### Done

- Board Priority typo `low prioirity` → `low priority` (fixed 2026-06-28, assignments preserved).
- Leftover labels `documentation` (family-wide), `documentation 📝` and `coming soon! 👀` (austraits)
  deleted. Remaining repo-local customs kept: `new trait suggestion` (APD), `data submissions`
  (austraits.build).
