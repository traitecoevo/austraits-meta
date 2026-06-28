# Project board #9 — structure & conventions

Documents the **structure and conventions** of the family board, not its live card contents.

- **Board:** AusTraits — https://github.com/orgs/traitecoevo/projects/9
- **Owner:** `traitecoevo` org · **Visibility:** Public
- **Scope (from the board README):** development across the AusTraits project — the AusTraits database
  (`austraits.build`), `traits.build`, the traits.build book, `APD`, the AusTraits API, the `austraits`
  R package, and `APCalign`; plus sibling traits.build databases `AusFizz` and `ausinvertraits.build`.

This is the **single, family-scoped board**. Because it already covers exactly one family, labels stay
family-local and there is no cross-family `family:` axis.

## Fields (as configured)

| Field | Type | Notes |
|-------|------|-------|
| Title, Assignees, Repository, Milestone | built-in | — |
| Linked pull requests, Reviewers, Parent issue, Sub-issues progress | built-in | — |
| Created / Updated / Closed | built-in dates | — |
| **Status** | single-select | options below |
| **Priority** | single-select | options below |
| Labels | built-in (mirrors repo labels) | this is where `governance/labels.yml` surfaces |

### Status options
`Backlog`, `In Progress`, `Done`, `On-going` — matches plant #5 plus `On-going`. (The legacy `-Done`
option was deleted 2026-06-28.) New issues land with **no Status** = the triage queue.

### Priority options
`high priority`, `medium priority`, `low priority`, `no plans to implement`
(The `low prioirity` typo was fixed 2026-06-28, preserving assignments.)

## Division of labour: labels vs board fields (decided 2026-06-28)

Board single-selects and repo labels are **separate** GitHub primitives — setting a label does NOT
set the board field, and vice versa. Rather than mirror them (which drifts), we split ownership:

| Concern | Owner | Notes |
|---------|-------|-------|
| **Status** (Backlog / In Progress / Done / On-going) | **Board Status field** | The single source of truth. No mirrored `status:` labels for these. |
| **Priority** (high / medium / low / no-plans) | **Board Priority field** | The single source of truth. **No `priority:` labels** (they'd duplicate a field used on only ~27% of items today). |
| Which **repo** | **Board `Repository` field** | Automatic per item. **No `pkg:` labels** — they just duplicated this and cluttered every repo's picker. |
| Which **sub-area within a repo** | **`[prefix]` in the issue title** | Org convention from plant #5 (e.g. `[env drivers] ...`, `[schema] ...`). Lightweight; good for modules inside one repo. |
| Kind of work | **`bug` / `task` / `epic` labels** | Shared org-wide core (== plant #5). `epic` pairs with the board's native Parent/Sub-issues fields. |
| Triage queue | **no board Status** | A new issue with no Status set *is* the triage queue. No `triage` label. A saved "🔍 Triage" view filters Status = empty. |
| Orthogonal flags | `blocked` / `needs-info` | Bare labels (not `status:`) — they coexist with any board Status. |
| Cross-package impact | `cross-package` / `breaking` | No board column. `cross-package` = ripples beyond this repo; `breaking` = dependents must change. |

### Grouping — `Repository` + `[prefix]` titles (both families)

Both families group the same way, just at different granularities for now:

- **Which repo** → the board's **`Repository`** field (automatic). No `pkg:` labels in either family.
- **Sub-area within a repo** → a **`[prefix]` in the issue title** (`[env drivers] ...`, `[schema] ...`).
  plant-family relies on this heavily (it's mostly one big `plant` repo); austraits uses it for modules
  inside a repo (e.g. `[taxonomy]` within traits.build).
- **Cross-cutting cut (dev/data)** → the board **`Area`** field (below).

> **Converging:** plant-family is going multi-repo too, so both families share one pattern —
> `Repository` for the repo axis, `[prefix]` titles for sub-areas, `Area` for cross-cutting cuts, and
> `cross:*` labels for cross-package impact. No per-repo `pkg:` labels in either.

### Dev vs data — the `Area` field (decided 2026-06-28)

One board, sliced by an **`Area` single-select field** (`dev` / `data`) — mirroring plant #5's `Area`
field — rather than a second board. Note much of the split already falls out of `Repository`
(`austraits.build` ≈ data; the R packages ≈ dev), so the `Area` field mainly helps when data work
shows up in other repos (e.g. APD content). Create it on the board, then add saved **views**
"Dev" (`Area = dev`) and "Data" (`Area = data`). The field is a board object, not a label.

> Because Status/Priority live only on the board, an issue's board card is where you set them; the
> labels never need to be kept in sync with a field.

## Triage workflow (proposed — needs maintainer confirmation)

1. **New issue** → auto-added to board #9 (see [`auto-add-to-board.md`](auto-add-to-board.md)) with
   **no Status** (= triage queue); add a work-type (`bug` / `task` / `epic`) label.
2. **Triaged** → set board **Priority** + board **Status = Backlog**.
3. **Started** → board **Status = In Progress**, assignee set.
4. **Cross-package** → add `cross-package` (+ `breaking` if dependents must change) and link the issues
   in the other affected repos (see `release-playbooks.md`).
5. **Done** → board **Status = Done**, issue closed (comment the resolution rather than labelling it).

## TODOs for maintainers to define

- [ ] Add a saved **"🔍 Triage"** board view (filter: Status is empty).
- [x] ~~Fix the `low prioirity` Priority option typo~~ — done 2026-06-28.
- [ ] Confirm the triage workflow above (or replace with the real one).
- [x] ~~Decide whether `austraits.build` (and the API/book/website repos) carry the same labels~~ —
      **Decided 2026-06-28: yes, the whole family folder.** See `triage.md` → "Scope decisions".
- [x] ~~Decide a default board view/grouping convention~~ — **add `Area` field (dev/data) + saved
      "Dev"/"Data" views; group by `Repository`; `[prefix]` titles for sub-areas** (above).
