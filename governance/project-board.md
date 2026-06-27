# Project board #9 — structure & conventions

Documents the **structure and conventions** of the family board, not its live card contents.

- **Board:** AusTraits — https://github.com/orgs/traitecoevo/projects/9
- **Owner:** `traitecoevo` org · **Visibility:** Public
- **Scope (from the board README):** development across the AusTraits project — the AusTraits database
  (`austraits.build`), `traits.build`, the traits.build book, `APD`, the AusTraits API, the `austraits`
  R package, and `APCalign`; plus sibling traits.build databases `AusFizz` and `ausinvertraits.build`.

This is the **single, family-scoped board**. Because it already covers exactly one family, labels stay
family-local (`pkg:*`) and there is no cross-family `family:` axis.

## Fields (as configured)

| Field | Type | Notes |
|-------|------|-------|
| Title, Assignees, Repository, Milestone | built-in | — |
| Linked pull requests, Reviewers, Parent issue, Sub-issues progress | built-in | — |
| Created / Updated / Closed | built-in dates | — |
| **Status** | single-select | options below |
| **Priority** | single-select | options below |
| Labels | built-in (mirrors repo labels) | this is where `governance/labels.yml` surfaces |

### Status options (live, verbatim)
`Backlog`, `In Progress`, `Done`, `On-going`, `-Done`

> ⚠️ `Done` and `-Done` both exist — `-Done` looks like a legacy/archive duplicate. **TODO (maintainer):**
> confirm intended meaning or consolidate.

### Priority options (live, verbatim)
`high priority`, `medium priority`, `low prioirity` *(sic — typo)*, `no plans to implement`

> ⚠️ `low prioirity` is misspelled in the board config. **TODO (maintainer):** fix the typo (renaming a
> single-select option preserves existing assignments).

## Division of labour: labels vs board fields (decided 2026-06-28)

Board single-selects and repo labels are **separate** GitHub primitives — setting a label does NOT
set the board field, and vice versa. Rather than mirror them (which drifts), we split ownership:

| Concern | Owner | Notes |
|---------|-------|-------|
| **Status** (Backlog / In Progress / Done / On-going) | **Board Status field** | The single source of truth. No mirrored `status:` labels for these. |
| **Priority** (high / medium / low / no-plans) | **Board Priority field** | The single source of truth. **No `priority:` labels** (they'd duplicate a field used on only ~27% of items today). |
| Which component | **Board `Repository` field** + `pkg:*` labels | `Repository` is automatic per item; `pkg:*` adds cross-repo filtering and labels issues that *affect* another package. |
| Kind of work | `type:*` labels | `type:epic` pairs with the board's native Parent/Sub-issues fields. |
| Cross-package impact | `cross:*` labels | No board column; the signal this meta repo exists to track. |
| Pre-board / out-of-band states | `status:triage` / `status:blocked` / `status:needs-info` | The only `status:` labels — they express what the board's Status column can't. |

> Because Status/Priority live only on the board, an issue's board card is where you set them; the
> labels never need to be kept in sync with a field.

## Triage workflow (proposed — needs maintainer confirmation)

1. **New issue** → auto-added to board #9 (see [`auto-add-to-board.md`](auto-add-to-board.md)); gets
   `status:triage` + a `pkg:*` + a `type:*` label.
2. **Triaged** → set board **Priority** + board **Status = Backlog**; remove `status:triage`.
3. **Started** → board **Status = In Progress**, assignee set.
4. **Cross-package** → add `cross:ripple` / `cross:breaking` / `cross:contract` and link the issues in
   the other affected repos (see `release-playbooks.md`).
5. **Done** → board **Status = Done**, issue closed.

## TODOs for maintainers to define

- [ ] Confirm/repair the `Done` vs `-Done` and `low prioirity` board options.
- [ ] Confirm the triage workflow above (or replace with the real one).
- [ ] Decide whether label ↔ board-Status syncing should be automated.
- [x] ~~Decide whether `austraits.build` (and the API/book/website repos) carry the same labels~~ —
      **Decided 2026-06-28: yes, the whole family folder.** See `triage.md` → "Scope decisions".
- [ ] Decide a default board view/grouping convention (by Repository? by Status? by Priority?).
