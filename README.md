# austraits-meta

Cross-package organisational knowledge, dependency map, and governance for the **AusTraits family** of
repositories in the [`traitecoevo`](https://github.com/traitecoevo) org.

This repo holds the knowledge that doesn't belong to any single package because it spans them: the
pipeline order, which package is the source of truth for what, which artifacts cross repo boundaries,
and the shared label/triage/release conventions.

## What's here

| File | Purpose |
|------|---------|
| [`AGENTS.md`](AGENTS.md) | **Start here.** Authoritative cross-package orientation (pipeline, dependency direction, source-of-truth rules, gotchas). |
| [`.claude/CLAUDE.md`](.claude/CLAUDE.md) | Defers to `AGENTS.md` (kept in sync by reference, not duplication). |
| [`dependencies.yml`](dependencies.yml) | Machine-readable package graph + cross-boundary artifacts. |
| [`governance/labels.yml`](governance/labels.yml) | Family label taxonomy — single source of truth. |
| [`governance/apply-labels.sh`](governance/apply-labels.sh) | Idempotent sync of labels to family repos (**gated**; hard-coded repo list). |
| [`governance/project-board.md`](governance/project-board.md) | Structure & conventions of family board [#9](https://github.com/orgs/traitecoevo/projects/9). |
| [`governance/auto-add-to-board.md`](governance/auto-add-to-board.md) | How new issues from all repos auto-add to board #9 (workflow + token secret). |
| [`governance/release-playbooks.md`](governance/release-playbooks.md) | Cross-repo release sequences (e.g. "dictionary change → rebuild X then Y"). |
| [`governance/triage.md`](governance/triage.md) | Contribution + triage discipline; open scope questions. |

## Scope

The **AusTraits family only** — a subset of the `traitecoevo` org. Nothing here applies org-wide or to
other families (e.g. the `plant` modelling stack). Pipeline-core repos: `APD`, `APCalign`,
`traits.build`, `austraits.build`, `austraits`, and this repo. See `AGENTS.md` for the full list.

## Maintainers

Maintained by the AusTraits team (lead: Daniel Falster, `daniel.falster@unsw.edu.au`). Trait-vocabulary
ownership (APD): Elizabeth Wenk.

## ⚠️ Drift caveat

This repo is **hand-maintained prose, not generated from the code**. It is a map, not ground truth.
Before relying on a specific path, function, artifact version, or dependency edge, verify it in the
relevant repo — the packages move faster than this documentation. Found drift? Fix it here in the same
change.
