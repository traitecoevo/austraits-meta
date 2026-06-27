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

## Label → board mapping (proposed)

The label taxonomy in [`labels.yml`](labels.yml) is designed to line up with the board fields so the
two don't drift:

| Label axis | Board field | Mapping |
|------------|-------------|---------|
| `priority:high` / `priority:medium` / `priority:low` / `priority:no-plans` | **Priority** | 1:1 with `high/medium/low priority` and `no plans to implement` |
| `status:backlog` / `status:in-progress` / `status:ongoing` | **Status** | 1:1 with `Backlog` / `In Progress` / `On-going` |
| `status:triage` | **Status** | pre-board state: issue exists but not yet placed/assessed |
| `status:blocked`, `status:needs-info` | (no board column) | label-only signals; board Status stays as-is |
| `pkg:*` | **Repository** + Labels | the `Repository` field already says which repo; `pkg:*` lets you filter/group across repos and on issues that span repos |
| `cross:*` | Labels | the cross-package signals this meta repo exists to track; no board column |

> Note: board single-selects and repo labels are **separate** GitHub primitives — setting a label does
> not auto-set the board Status, and vice versa. The mapping above is a **convention** for humans/agents
> to keep them consistent, not an automation. **TODO (maintainer):** decide whether to add a GitHub
> Actions workflow to sync label ↔ Status automatically, or keep it manual.

## Triage workflow (proposed — needs maintainer confirmation)

1. **New issue** → gets `status:triage` + a `pkg:*` + a `type:*` label. Not yet on the board.
2. **Triaged** → assign `priority:*`, set board **Status = Backlog** (`status:backlog`), add to board #9.
3. **Started** → board **Status = In Progress** (`status:in-progress`), assignee set.
4. **Cross-package** → add `cross:ripple` / `cross:breaking` / `cross:contract` and link the issues in
   the other affected repos (see `release-playbooks.md`).
5. **Done** → board **Status = Done**, issue closed.

## TODOs for maintainers to define

- [ ] Confirm/repair the `Done` vs `-Done` and `low prioirity` board options.
- [ ] Confirm the triage workflow above (or replace with the real one).
- [ ] Decide whether label ↔ board-Status syncing should be automated.
- [ ] Decide whether `austraits.build` (and the API/book/website repos) carry the same labels — see
      `triage.md` → "Scope decisions still needed".
- [ ] Decide a default board view/grouping convention (by Repository? by Status? by Priority?).
