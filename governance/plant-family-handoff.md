# Handoff: applying the org labelling/board convention to the plant-family

**Audience:** an agent (or maintainer) setting up labels, boards, and issue conventions for the
**plant-family** (board [#5 "Plant model development"](https://github.com/orgs/traitecoevo/projects/5);
repos `plant`, `overstorey`, `plant.assembly`, and others as it goes multi-repo).

**Why this exists:** the AusTraits-family just adopted a labelling + board convention deliberately
aligned to plant-family's existing `bug`/`task`/`epic` core, so the two families stay consistent as
the org grows. This document hands the *same* convention back to plant-family, plus the few changes
plant should make to fully converge. Decisions here were made with Daniel Falster (2026-06-28).

The reference implementation lives in `traitecoevo/austraits-meta`:
- [`governance/labels.yml`](labels.yml) — the taxonomy (source of truth)
- [`governance/apply-labels.sh`](apply-labels.sh) — idempotent, gated sync (rename-then-create)
- [`governance/project-board.md`](project-board.md) — board fields, division of labour, grouping
- [`governance/auto-add-to-board.md`](auto-add-to-board.md) — auto-add issues to the board
- [`governance/triage.md`](triage.md) — triage discipline

---

## The shared org convention (applies to BOTH families)

### Work-type core (identical names + descriptions across families)

| Label | Description | Colour |
|-------|-------------|--------|
| `bug`  | Existing feature not functioning as intended | `#d73a4a` (red) |
| `task` | A discrete task needed for a feature | `#0075ca` (blue) |
| `epic` | A new feature or capability | `#6f42c1` (purple) |

> **Plant action — recolour the 3 core labels.** Names/descriptions already match; only the colours
> differ. plant's current colours (`bug #fc2929`, `task #84b6eb`, `epic #0052cc`) aren't intuitive
> (task & epic are both blue). Converge to the palette above:
> ```bash
> for r in plant overstorey plant.assembly; do
>   gh label edit bug  --repo traitecoevo/$r --color d73a4a
>   gh label edit task --repo traitecoevo/$r --color 0075ca
>   gh label edit epic --repo traitecoevo/$r --color 6f42c1
> done
> ```
> Add `--repo` lines for any new plant repos.

### Orthogonal flags (board owns the workflow itself)
`blocked`, `needs-info` — bare labels for states that coexist with any board Status. Do **not** create
labels mirroring board Status (Backlog/In Progress/Done) or Priority; those live on the board (labels
and board fields don't auto-sync → drift). **There is no `triage` label** — a new issue with no board
Status *is* the triage queue (filter a "🔍 Triage" view on Status = empty).

### Community
`question` only. We deliberately **dropped** `good first issue`, `help wanted`, `duplicate`, `invalid`,
and `wontfix` (comment on close instead of labelling) — don't reintroduce them.

### Grouping (the multi-repo pattern)
- **Repo axis:** the board's **`Repository`** field (automatic). **Do NOT add `pkg:` labels** —
  austraits tried one-per-repo and removed them; they just duplicated `Repository` and cluttered every
  repo's label picker. (Reach for `cross-package` when an issue is *about* a different repo.)
- **Sub-area within a repo:** the **`[prefix]` issue-title convention** plant already uses
  (`[env drivers] ...`). Keep it — it's now the org-wide convention for the finer grain.
- **Cross-cutting cut (e.g. dev/data):** a board **`Area`** single-select field (austraits added
  `Area = dev|data`). plant's board already has an `Area` field — populate/extend it if a similar cut
  becomes relevant.
- **Cross-package impact:** `cross-package` (+ `breaking` if dependents must change) — add these to
  plant only once it has genuine cross-repo dependencies.

### Auto-add issues to the board
Use a per-repo `.github/workflows/add-to-project.yml` with `actions/add-to-project`, pointing at board
#5, authenticated by an org secret (`ADD_TO_PROJECT`, Projects read/write). See
[`auto-add-to-board.md`](auto-add-to-board.md) for the exact workflow and token setup. (The built-in
project "Auto-add" workflow is UI-only and repo-count-limited.)

---

## Recommended plant rollout (in order)

1. **Recolour** `bug`/`task`/`epic` to the shared palette (snippet above). *Lowest-effort consistency
   win; do this first.*
2. **Decide how much of the shared set plant wants.** Minimal = just the recoloured core + the board.
   Fuller = also add `blocked`/`needs-info`, `question`, and `cross-package`/`breaking` if plant gains
   cross-repo dependencies. (No `pkg:` labels, no `triage`/`invalid`/`wontfix` — see above.)
3. If fuller: **adapt `apply-labels.sh`** — copy it and swap `FAMILY_REPOS` for plant's repos. The
   whole taxonomy (core + status + community + cross) is family-agnostic, so `labels.yml` can be reused
   as-is. Keep it gated (dry-run by default; `--apply` to run).
4. **Board #5 fields:** plant already has Status (Backlog/In Progress/Done) and an `Area` field — good.
   No Priority field today (fine; austraits uses one, plant needn't). Confirm whether plant wants
   `On-going` like austraits #9.
5. **Auto-add workflow** to each plant repo (draft PRs), after setting `ADD_TO_PROJECT`.
6. Create a **`plant-meta`** repo mirroring `austraits-meta` (see next section) to hold plant's
   cross-repo knowledge + governance as plant becomes multi-repo.

---

## The meta-repo pattern (recommended: create `plant-meta`)

`austraits-meta` is the model. A **family meta-repo** is a small, mostly-prose repo that holds the
knowledge and governance that belong to *no single package because they span them*. It becomes the one
place agents and contributors look for "how does this family fit together", and the single source of
truth for labels/board conventions. Strongly recommended once a family is multi-repo.

### What it contains
```
plant-meta/
  README.md                # what this repo is, who maintains it, the drift caveat
  AGENTS.md                # authoritative cross-repo orientation (the real content)
  .claude/CLAUDE.md        # one-liner that defers to AGENTS.md (so it stays in sync by reference)
  dependencies.yml         # machine-readable repo graph + cross-boundary artifacts
  governance/
    labels.yml             # the label taxonomy (single source of truth)
    apply-labels.sh        # idempotent, gated sync of labels to a HARD-CODED repo list
    project-board.md       # board fields, label-vs-field division of labour, grouping conventions
    auto-add-to-board.md   # auto-add issues workflow + token secret
    triage.md              # triage discipline
    issue-guide.md         # contributor-facing "how to file/label an issue" (repos point here)
    release-playbooks.md   # cross-repo release sequences (if the family has them)
```

### How it works
1. **AGENTS.md is the content; CLAUDE.md defers to it.** Keep cross-repo orientation in `AGENTS.md`
   (pipeline/structure, who owns what, dependency direction, cross-boundary artifacts, gotchas).
   `.claude/CLAUDE.md` is a stub that says "read AGENTS.md" — so the same text serves every tool and
   never drifts between the two files.
2. **Each family repo points back.** Add a short *Cross-package context* section to each repo's
   `.claude/CLAUDE.md` (create a stub if none) linking to `plant-meta` — repos don't restate
   family-wide concerns, they link to them. (We did this for austraits via one draft PR per repo.)
3. **Governance is authored here, applied outward.** `labels.yml` is edited here and pushed to repos by
   `apply-labels.sh`; the board conventions and issue guide live here and repos link to them. One edit,
   one place.
4. **Drift caveat.** It's hand-maintained prose, not generated — treat it as a map, and verify specific
   paths/names against the real repos before relying on them. Fix drift in the same change.
5. **Scope discipline.** A family meta-repo is scoped to *its* family only — never org-wide, never the
   org `.github` repo, and apply scripts hard-code the family's repo list (never enumerate the org).

### Fastest way to bootstrap `plant-meta`
Copy `austraits-meta`'s structure, then: rewrite `AGENTS.md`/`dependencies.yml` for plant's repos;
reuse `labels.yml` as-is (it's family-agnostic); point `apply-labels.sh`'s `FAMILY_REPOS` and the
board URLs at plant/board #5. The `governance/*.md` docs are 80% reusable — adjust names and repo lists.

## Open questions for the plant maintainer
- How minimal vs full should plant's label set be (step 2)?
- Keep board #5's `Area` field, and with which options?
- Want a `plant-meta` repo (step 6)?

## What NOT to do
- Don't mirror board Status/Priority as labels.
- Don't reintroduce `good first issue`/`help wanted`/`duplicate`/`invalid`/`wontfix`, or a `triage`
  label, or `pkg:` labels.
- Don't enumerate the whole org in any apply script — hard-code plant's repo list.
- Don't touch the org `.github` repo or other families' repos.
