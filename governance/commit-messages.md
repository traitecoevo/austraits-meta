# Commit messages and PR descriptions (family-wide)

Every family repo squash-merges, so **the PR title and body *are* the commit message**. GitHub
copies them verbatim into permanent history and appends ` (#NNN)` to the subject. A PR description
is therefore not a place to think out loud — it is the message someone reads in three years while
bisecting a trait value that changed, with none of the surrounding conversation in view.

The working detail still matters, and it has a home: **post it as the first comment on the PR**, as
soon as you open it. That comment is exactly as permanent as the commit message, and the ` (#NNN)`
in the squashed subject links straight to it. Nothing is lost — the detail is relocated to where a
reader who wants it is already looking.

## Shape

- **Subject** — imperative, sentence case, no full stop, **≤50 characters as typed**. GitHub appends
  ` (#NNN)`; the hard ceiling including that tail is 72. **Don't put the issue number in the title**
  — put `Closes #NNN` in the body instead.
- **Body** — **≤10 lines / ~100 words**, wrapped at 72. Hard ceiling 20 lines. Two short paragraphs
  at most: why the change was needed, then what changed in observable behaviour.
- **Trailers** — `Closes #NNN`, then a single `Co-authored-by:` in that casing.
- **Type prefixes** — `docs:` and `ci:` are the two this family actually uses (`chore:` likewise),
  and only for changes with **no behavioural effect**. Substantive changes get a plain imperative
  subject. The family has **not** adopted conventional commits — there is no `feat:`/`test:`
  convention here, and no repo needs to change to match.
- **But not `refactor stage 0:`** — the ad-hoc `refactor …:` subjects in `traits.build` look like
  type prefixes while carrying plan bookkeeping, and produced the family's longest subject (106
  characters). The stage number belongs in the body, next to `Closes #NNN`.

An `[area]` title prefix is an **issue** convention ([`issue-guide.md`](issue-guide.md)), not a PR
one — the board's `Repository` field and the diff already say where a PR lands, so on a PR the
prefix only spends characters the subject doesn't have.

## What goes where

| In the commit — durable | In the first PR comment — transient |
|---|---|
| What changed in observable behaviour | What you tried first, and in what order |
| Why it was needed | Hypotheses that turned out wrong, and self-corrections |
| What breaks, and how to migrate | Alternatives considered and rejected |
| One line of magnitude if data moved, with a pointer | Benchmark tables, profiling, row-by-row counts |
| `Closes #NNN` | Test counts, pass/fail totals, new test filenames |
| | Per-file changelogs — that is `git diff --stat` |
| | Branch, stack, and rebase bookkeeping |
| | Replies to review comments |
| | Caveats and remaining work — **file issues instead** |
| | Unchecked `- [ ]` template checkboxes |

**The test: would this sentence help someone reading `git log` in three years?** If it only makes
sense relative to the PR conversation — "now targets `develop` directly", "reverses what I wrote
yesterday", "worth reviewer attention" — it belongs in the comment.

Two consequences worth stating plainly, because both have been done the other way here:

- **A change that moves published trait values must state its blast radius in the commit.** This
  family is a data pipeline, so "observable behaviour" includes the data. One line does it, in the
  units [`NEWS.md`](https://github.com/traitecoevo/austraits.build/blob/develop/NEWS.md) already
  reports — `records`, `taxa`, `traits`, `locations`, `dataset_id`, or rows moving into or out of
  `excluded_data` — plus a pointer to the breakdown: *"restores ~4,000 values wrongly routed to
  `excluded_data`; per-trait breakdown in #1184"*. The full table goes in the comment. A change you
  have confirmed moves nothing earns a clause too (*"confirmed no data excluded"*).
- **Don't correct the record inside a commit body.** `traits.build` `0fb1e6965` devotes a section
  (*"A correction to the issue"*) and a three-row table to reconciling what the issue claimed
  against what the author measured. That belongs on the issue, where it is a reply rather than a
  permanent artefact — and where the person who wrote the original claim will actually see it.

## A worked pair

Both real, both from this family. `austraits.build` `2b11d9ca4` is close to right — it states its
blast radius in the subject, in the units `NEWS.md` reports (re-wrapped at 72 here):

```
NHNSW_2024: add data from 597 additional taxa

David Coleman's trait extractions from 2023 missed 597 taxa in PlantNet.
Data from these profiles have now been extracted and added as NHNSW_2024.

I double checked taxon names x trait combinations and there were only 2
names in both the new & old datasets; these have been filtered out.

For this dataset, I checked 100% of trait values, not just a subset.
```

Those first two paragraphs are the durable pair: why it was needed, and what changed. The last line
is the one that belongs in the comment — it records how the author checked their own work, which is
a fact about the review, not about the data.

Against it, `traits.build` `42e4be8a7` — 183 lines, 1,182 words, nine `##` sections, and at 106
characters the family's longest subject. It carries a rejected alternative argued over ~150 words
(*"On `expect_snapshot_value()` — recommending against, with evidence"*), a suite count (*"820 → 856
passing"*), a table of deliberately-introduced breakages and what caught them, and ~250 words
re-describing five follow-ups **already filed as #232–#236** — duplication that can now go stale
independently of the issues themselves. All of it was worth writing down; none is worth carrying in
`git log` forever. It reduces to about 16 lines without losing anything a bisecting reader needs.

## Why this is written down

Measured across the family on 2026-08-05 — the last 25 commits on each of eleven repos' default
branches, prose lines and words only (trailers stripped):

| | body words median | body lines median | body words max |
|---|---|---|---|
| Squash merges (n=154) | 103 | 13 | 1,340 |
| Hand-typed commits (n=102) | 0 | 0 | 209 |
| Squash merges, pre-2026 (n=119) | 33 | — | 453 |

Squash bodies have roughly **tripled** since 2026, and the split is **entirely** between squash
merges and hand-typed commits — which identifies this as a PR-description habit rather than a
commit-writing one, and makes it fixable by moving text one box down the page.

It is also **concentrated, not family-wide**: median squash body is 398 words in `traits.build` and
389 in `APD`, against 28–107 everywhere else, and those two hold **22 of 24** and **18 of 24**
recent squash commits over the 20-line ceiling (37% family-wide). Most of the family already sits
close to this guideline and needs no change.

## Mechanics

- **Squash defaults** — a repo must use the PR title and body, or GitHub builds the message from the
  individual commit subjects and the description never reaches history. **All family repos are
  already set correctly** (checked 2026-08-05); verify that
  `squash_merge_commit_title`/`squash_merge_commit_message` return `PR_TITLE`/`PR_BODY` via
  `gh api repos/traitecoevo/<repo>`.
- **`.github/PULL_REQUEST_TEMPLATE.md`** — keep it minimal, with prose placeholders rather than
  `<!-- ... -->` guidance. A PR body reaches the commit **including HTML comments**, so a
  commented-out questionnaire lands in permanent history.
- **Post the comment when you open the PR**, not at merge time. Written after the fact it becomes a
  summary; written as you go it is what you would otherwise have padded the description with.

The `---------` line above the `Co-authored-by:` block in older commits is **not** a symptom of any
of this — it is GitHub's own separator, added automatically when it aggregates co-author trailers
from the commits being squashed. Nothing to fix.

---

**Added 2026-08-05.** Prompted by the measurement above, and mirrors
[`plant-meta/governance/commit-messages.md`](https://github.com/traitecoevo/plant-meta/blob/main/governance/commit-messages.md)
— see [`plant-family-handoff.md`](plant-family-handoff.md) for that relationship. The rest of the PR
discipline is in [`triage.md`](triage.md); issue titles and labels in
[`issue-guide.md`](issue-guide.md).
