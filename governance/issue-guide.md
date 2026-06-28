# Filing & labelling issues — AusTraits family

A short contributor guide for issues across the AusTraits family (traits.build, APCalign, austraits,
APD, austraits.build, and the other family repos). The family is tracked on one board,
[#9](https://github.com/orgs/traitecoevo/projects/9); new issues are **auto-added** to it.

## Where to file

File in the repo the issue is *about*. Unsure which? File in the most likely one — maintainers
re-home it. For cross-package work, file in the primary repo and link the others. See
[`../AGENTS.md`](../AGENTS.md) for who owns what (APD = trait definitions, APCalign = taxonomy,
traits.build = engine/schema, austraits.build = the dataset, austraits = access API).

## Title

Write a specific, action-oriented title. For a sub-area within a repo, **prefix with `[area]`** —
the org convention — e.g. `[schema] allow units on categorical traits`, `[taxonomy] handle hybrid
names`. (Which repo the issue is about is the board's `Repository` field — there are no `pkg:` labels.)

## Labels (what to add)

Pick **one work-type**, plus context:

| Label | Use it for |
|-------|------------|
| `bug` | Existing feature not functioning as intended |
| `task` | A discrete piece of work toward a feature |
| `epic` | A new feature/capability spanning multiple tasks (use the board's sub-issues to break it down) |

Then add, as relevant:
- **`cross-package`** — if the change has consequences beyond this repo (e.g. an APD vocabulary change
  that forces rebuilds). Add **`breaking`** too if dependents must change. See
  [`release-playbooks.md`](release-playbooks.md).
- **`blocked` / `needs-info`** — if it's waiting on a dependency or on more information.
- **`question`** — if it's a question rather than a work item.

**Status and Priority are set on the board, not as labels** — leave those to triage. A new issue
starts with **no Status** (the triage queue). See [`project-board.md`](project-board.md).

## What happens next

1. Your issue auto-adds to board #9 with no Status (the triage queue).
2. A maintainer triages: confirms the work-type, sets board **Priority** + **Status = Backlog**.
3. Cross-package issues get `cross-package` (+ `breaking`) and are linked to partner issues in the
   other repos.

## For maintainers
Full triage discipline is in [`triage.md`](triage.md); the taxonomy is [`labels.yml`](labels.yml).
