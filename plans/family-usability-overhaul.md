# AusTraits family — README, website & book usability overhaul

> **Where this plan lives:** on approval, the first action is to persist this file to
> `austraits-meta/plans/family-usability-overhaul.md` (that repo already has a `plans/` folder,
> alongside `repos-in-workspace.md`). It becomes the working tracker for the effort.

## Context

The AusTraits website (austraits.org) was recently refreshed. Looking across the 15 family repos
from a **user's / newcomer's** perspective, the READMEs, pkgdown/Quarto sites, and the traits.build
book are uneven: some are excellent (`austraits`, `traits.build-book`), several are thin or broken
(`traits.build-template`, `austraits-api`, `AusFizz`, `APCalign-app`), citations are inconsistent
and in places stale, cross-linking between siblings is patchy, and the book carries dead links,
stub chapters, and stale figures. The goal is a coordinated pass that (1) makes every README
complete, (2) gives every repo a consistent "how to cite" and a shared "AusTraits family" block,
(3) surfaces the family relationships (austraits.org ↔ repos ↔ traits.build book), (4) produces a
single curated list of the family's key papers in `austraits-meta`, and (5) substantially reworks
the traits.build book.

Findings backing this plan came from a four-agent audit (core R packages; data/web/API repos;
refs.bib + relationships; a deep book review). Key conventions already exist and should be reused:
the standard **"AusTraits family"** README block (in `austraits.org/README.md:169-179`,
`traits.build-book/README.md:15-25`, `austraits-meta/README.md`) and the family map in
`austraits-meta/AGENTS.md` + `dependencies.yml`.

**Approach decisions (confirmed with user):** full book restructure; include austraits.org website
edits; add machine-readable citation files (CITATION.cff / inst/CITATION) in addition to README text.

**All work is done on branches → PRs.** Nothing is pushed to `master`/`develop` directly; the
austraits.org production deploy runs on push to `master`, so website changes go via PR preview only.

---

## Deliverable 1 — Central key-papers list in `austraits-meta`

Source of truth: `/Users/z2209343/Library/CloudStorage/OneDrive-UNSW/atelier/7-career/data/refs.bib`.

Create `austraits-meta/references/`:
- **`key-papers.md`** — curated, annotated list grouped as: Tier 1 (the 4 core "must-cite" papers,
  one per pipeline-core output), Tier 2 (related family outputs), Tier 3 (context/comparator DBs).
  Each entry: authors, year, title, journal, DOI, and a one-line "which repos should cite this".
- **`austraits-family.bib`** — a clean BibTeX subset extracted from refs.bib containing exactly the
  Tier 1–2 keys, so every repo can copy citations from one canonical file.

Canonical Tier-1 mapping (BibTeX keys from refs.bib):

| Paper | Key | DOI | Repos that should cite |
|-------|-----|-----|------------------------|
| AusTraits dataset (Falster et al. 2021, *Sci Data*) | `Falster-2021a` | 10.1038/s41597-021-01006-6 | austraits, austraits.build, austraits.org, portal, api |
| traits.build (Wenk et al. 2024, *Ecol. Informatics*) | `Wenk-2024b` | 10.1016/j.ecoinf.2024.102773 | traits.build, traits.build-book, -template, sibling DBs |
| APD (Wenk et al. 2024, *Sci Data*) | `Wenk-2024a` | 10.1038/s41597-024-03368-z | APD, austraits.build |
| APCalign (Wenk et al. 2024, *Aust. J. Bot.*) | `Wenk-2024c` | 10.1071/BT24014 | APCalign, APCalign-app, austraits.build |

Tier 2: `Coleman-2023` (textual-extraction workflow), `Wenk-2024d` (gap-filled growth-form dataset),
`Gallagher-2020` (Open Traits Network vision). Tier 3: `Andrew-2025` (mapping).
**Exclude `Kattge-2020` (TRY)** per maintainer — not part of the family's citation set.

Add a pointer to `references/key-papers.md` from `austraits-meta/README.md` and `AGENTS.md`.

---

## Deliverable 2 — README completeness + citations, per repo

Every README gets, where missing: a one-line description, install/usage or setup, a **How to cite**
section drawn from `austraits-family.bib`, and the shared **AusTraits family** block (Deliverable 3).
Priority order (worst first). Representative fixes:

**High priority (currently broken/stub):**
- `traits.build-template/README.md` — expand from 2-line stub: explain the template's purpose and the
  `config/ data/ R/ remake.yml` layout, link to the traits.build-book tutorial that uses it
  (`tutorial_compilation.html`), install/run steps, family block. Cite `Wenk-2024b`. Note that
  `remake` is unmaintained (see follow-up issue below) — document current usage but don't over-invest
  in remake-specific prose that will change.
- `austraits-api/README.md` — add setup/run, an endpoint reference, license, link to its deploy repo
  `austraits-api-nectar`, family block, cite `Falster-2021a`. Fix "v1"/typos.
- `AusFizz/README.md` — fix broken markdown links, the `AuzFizz`/`database_name` typo, document the
  build branch dependency, add license + citation + family block.
- `APCalign-app/README.md` — fix the broken APC link (`[APC](Australian%20Plant%20Census...)`),
  populate or remove empty badges block, add a screenshot, link back to APCalign + family. **Update
  the live app URL** to the new AWS host `https://app.austraits.org/APCalign-app/` (ShinyApps
  deprecated).

**Medium priority (fix drift / gaps):**
- `APCalign/README.md` — reconcile citation version (README says v1.1.4; DESCRIPTION is 2.0.0), add
  family block situating it in the ecosystem.
- `APD/README.md` — update "in press" → published DOI 10.1038/s41597-024-03368-z; add a short
  consumer "how do I use the APD" pointer to `using_the_APD.qmd` up top; add family block.
- `traits.build/README.md` — resolve the confusing `lifecycle-deprecated` badge (confirm intended
  status with maintainers; likely `stable`/`maturing`), fix the `hhttp://` typo link, finish or
  remove the commented-out video block, clarify CRAN "coming".
- `austraits.build/README.md` — fix the copy-paste install link ("install traits.build" pointing at
  austraits.build URL).
- `ausinvertraits.build/README.md` — add family block; note it points at a different project site.
- `austraits.portal/README.md` — add a **user-facing** "how to use the portal" (vs deploy) section
  and a citation pointer; fill empty badges. **Update the live URL** from `unsw.shinyapps.io` to the
  AWS deployment `https://app.austraits.org/austraits/`; note ShinyApps is deprecated.

**Low priority (already strong):** `austraits`, `austraits-api-nectar` — add family block only.

---

## Deliverable 3 — Family cross-linking (the standard block)

Reuse the existing **"AusTraits family"** block verbatim (from `austraits.org/README.md:169-179`),
adapting the repo name per file. Add it to every family README that lacks it: APCalign, APCalign-app,
APD, austraits, austraits.build, ausinvertraits.build, AusFizz, austraits-api, austraits-api-nectar,
austraits.portal, traits.build, traits.build-template. (austraits.org, traits.build-book,
austraits-meta already have it.)

The block links: austraits.org, board #9, the issue guide, and austraits-meta. Where natural, also add
inline "part of the AusTraits ecosystem" links to the traits.build book and the relevant sibling repos
(e.g. api → api-nectar; template → book tutorial; portal → austraits package).

---

## Deliverable 4 — austraits.org website enhancements

On a branch, PR-preview only (never push to `master` — see `austraits.org/CLAUDE.md`). Edit
`austraits.org/index.qmd`:
- **New dedicated "AusTraits family" page** (`family.qmd`, registered in `_quarto.yml` navbar under
  About or Tools). The front page must stay **minimal** — do NOT expand it into a full ecosystem
  dump. This page explains the family and how the pieces interconnect (APD vocabulary → APCalign
  taxonomy → traits.build engine → austraits.build dataset → austraits access → portal/API), ideally
  with a diagram, and links out to each repo, the traits.build book, and austraits-meta as the
  governance hub. Source the structure from `austraits-meta/AGENTS.md` + `dependencies.yml`. The front
  page gets at most a single concise link/teaser pointing to this page.
- **Keep the Tools section minimal** (`index.qmd:155-196`, currently 4 cards) — leave it as the short
  curated set of user-facing tools; the fuller family map lives on the new `family.qmd` page.
- **Make the data portal live and embedded (in scope for this work).** The portal is now deployed on
  **AWS at `https://app.austraits.org/austraits/`** (ShinyApps is being deprecated — do NOT use the
  old `unsw.shinyapps.io` URL). Embed it directly in the site via an **iframe** and provide a
  link-out, following the pattern in `/Users/z2209343/Desktop/sort/transfer/portal/austraits_iframe_test.html`:
  a responsive `.iframe-container` (100% width, ~800px, 600px on mobile) wrapping
  `<iframe src="https://app.austraits.org/austraits/" loading="lazy" allowfullscreen>`. Likely a new
  `portal.qmd` page (registered in `_quarto.yml` navbar) plus the resource card on `index.qmd`
  (replace the commented-out `index.qmd:131-137` block). Note the same AWS host serves
  `app.austraits.org/APCalign-app/` and `app.austraits.org/infinitylists/` — the APCalign card can
  link there too.
- **Add a "How to cite" block** presenting the Tier-1 papers (currently the site has only two inline
  DOIs and no citation panel). Consider a new `cite.qmd` page or a section on `index.qmd`; if a new
  page, register it in `_quarto.yml` navbar.
- Optionally link austraits-meta from an "About"/contribute context as the governance hub.

---

## Deliverable 5 — traits.build book: full restructure

> **Model:** run the book restructure with **Fable** where possible — the new-prose authoring
> (5c), the merge/de-duplication judgement calls (5d), and the ecosystem narrative benefit from the
> stronger model; the mechanical link/typo fixes (5a) can be delegated to cheaper agents.

**Coordinate with open PR #25 first.** PR #25 ("Minor edits", ehwenk, branch `minor-edits` → `master`)
already fixes typos/small edits in `workflow.qmd`, `tutorial_datasets.qmd`, `tutorial_dataset_4.qmd`,
`tutorial_compilation.qmd`, `long_wide.qmd`, `create_dictionary.qmd`, `file_organisation.qmd`,
`adding_data_brief.qmd`, and `.github/workflows/render.yaml`. **Get PR #25 merged (or rebase our work
on top of it) before starting**, so we don't re-fix the same typos or create conflicts on those 8
files. Our book branch should branch from post-#25 `master`.

**5a. Fix broken/wrong cross-references (highest user impact):**
- `help.qmd:73-74` — replace the leftover `ropensci/targets` & `ropensci/tarchetypes` contact links
  with the correct traits.build / austraits repos.
- `help.qmd:7` — `troubleshooting.html` link → create the page (5c) or repoint.
- `adding_data_long.qmd:38-42` — links to non-existent `overview.html`, `contributing_data.html`,
  `file_structure.html`; repoint to real chapters.
- `adding_data_brief.qmd:48` (`tutorial_data_long.html` → `adding_data_long.html`),
  `motivation.qmd:24` / `traits_build.qmd` malformed `traits.build.html` + bad anchors,
  `tutorial_compilation.qmd:28` placeholder URL, `traits_build.qmd` `austraits.org` missing `https://`.
- Fix `CONTRIBUTING.md` stray backtick + `main`→`master` branch links.

**5b. Wire up citations:** `references.bib` currently holds only a stray `knuth84` entry. Replace with
the real family `.bib` (from Deliverable 1) and add a **How to cite** page/box citing `Wenk-2024b`
(traits.build), `Wenk-2024a` (APD), `Falster-2021a` (AusTraits); register in `_quarto.yml`.

**5c. Fill stubs / missing chapters (new prose — for your review):**
- `publishing.qmd` — currently only restates principles; write actual publish/archive/DOI steps.
- New `troubleshooting.qmd` (or complete `data_common_issues.qmd`, remove its "work in progress").
- New **glossary** chapter for the identifier zoo (`observation_id`, `population_id`,
  `entity_context_id`, …) that `workflow.qmd:43` admits is "overwhelming".
- **Quick-start / installation** landing chapter (install + build the template in ~5 min) before the
  concept chapters; install currently exists only as an external link in `index.qmd`.
- Finish `check_dataset_functions.qmd:243-250` "TO BE WRITTEN" duplicate-check function docs.

**5d. Restructure (the "full" option):**
- Merge the duplicated raw-file-structure content: the orphaned, richer
  `file_structure_data_metadata.qmd` (21 KB, not in `_quarto.yml`) vs the in-book
  `file_organisation.qmd`. Keep one, wire it in, delete/redirect the other.
- De-duplicate the heavy overlap between `austraits_package.qmd` and `AusTraits_tutorial.qmd`.
- Wire in or delete the empty `using_data.qmd` stub.
- Add a single **ecosystem-placement** section/diagram (where traits.build sits vs APD, APCalign,
  austraits, austraits.build) instead of the scattered mentions in
  `motivation.qmd`/`usage_examples.qmd`.
- Reorder Introduction so install/quick-start precedes deep concepts.

**5e. De-stale:**
- `tutorial_compilation.qmd:30` "3 tutorials … by October 2023" → 7 tutorials, drop the date promise.
- `austraits_database.qmd:7` static "as of October 2023 … 370+ datasets" figures → generate live or
  soften/date-stamp.
- Reconcile version references across chapters (`5.0.0` vs `6.0.0` vs internal `austraits_5.0.0_lite`).
- Fix the "five tutorials"/"seven tutorials" and "manual/book/vignette" terminology inconsistencies.

---

## Deliverable 6 — Consistent acknowledgement of co-investment & partners

Acknowledgements are inconsistent and drifted. The refreshed website footer
(`austraits.org/_footer.html`) is the most current wording; the repos lag behind. Establish a single
source of truth and propagate.

**Drift found (all to be reconciled):**
- NCRIS "**enabled** by" (website) vs "**funded** by" (`APD`, `traits.build`, `traits.build-book`,
  `austraits.build`). `austraits.portal:48` typo: "Research **Investment** Strategy" → **Infrastructure**.
- Website's newer framing — "co-investment partnership with the ARDC through the **Planet Research
  Data Commons** (DOI 10.3565/nyk4-4r91)" — vs repos citing older grant DOIs (TD044, DP720, DP720A;
  `ausinvertraits.build` uses DC011).
- **No acknowledgement at all:** `APCalign`, `APCalign-app`, `austraits`, `AusFizz`, `austraits-api`,
  `austraits-api-nectar`, `traits.build-template`.
- Only the website credits **partner orgs** (UNSW, WSU, Botanic Gardens of Sydney, ALA, DCCEEW,
  Melbourne pending) and links the team/partners pages; no repo README does.
- Minor: stray-space typo `https:// doi.org` in `austraits.build`.

**Plan:**
1. **Canonical `austraits-meta/acknowledgements.md`** — single source of truth, matching the website
   footer. Two parts: (a) **partners** paragraph with org links + links to austraits.org team and
   `#advisory-board`/`#data-contributors`/`#past-partners`; (b) **co-investment** statement: ARDC /
   Planet RDC (DOI 10.3565/nyk4-4r91) / NCRIS **"enabled by"**.
2. **Standard README "Acknowledgements" block** derived from it, added to every repo — priority to the
   seven with none. Keep an optional per-repo line naming the **specific grant** that funded that repo
   (TD044 / DP720 / DP720A / DC011) beneath the unified Planet-RDC sentence.
3. **Text + links in READMEs; logos only on rendered sites.** Do NOT copy logo image assets into 15
   repos (maintenance trap). Surface partner **logos** in the pkgdown/Quarto site footers that already
   have a footer mechanism (`austraits`, `traits.build`, `APCalign`, `APD`, `traits.build-book`).
4. **Fix drift while propagating:** "funded"→"enabled by"; portal "Investment"→"Infrastructure";
   the `https:// doi` space; align grant DOIs.
5. **To confirm with maintainers (non-blocking):** adopt the Planet-RDC/co-investment framing as the
   headline across repos (recommended), with specific grant DOIs listed beneath — vs keeping the older
   grant-DOI-led wording. Also: add the pending University of Melbourne partner logo
   (`austraits.org/_footer.html:17-21` TODO).

## Deliverable 7 — Machine-readable citations

For each installable R package, add/refresh so GitHub's "Cite this repository" works:
- `CITATION.cff` at repo root for: `austraits`, `traits.build`, `APCalign`, `austraits.build`,
  `ausinvertraits.build`, `austraits.portal`. Populate from `austraits-family.bib`.
- Verify/refresh existing `inst/CITATION` in `APCalign`, `austraits`, `APD` (align versions/DOIs with
  Deliverable 1; fix APCalign version drift, APD published DOI).
- `AusFizz` (no DESCRIPTION) and infra repos (`austraits-api-nectar`) get README citation text only.

---

## Files / conventions to reuse (do not reinvent)

- Standard family block: `austraits.org/README.md:169-179` (verbatim template).
- Family map & source-of-truth rules: `austraits-meta/AGENTS.md`, `austraits-meta/dependencies.yml`.
- Papers: `.../7-career/data/refs.bib` (keys listed above).
- Website build/deploy rules & guardrail: `austraits.org/CLAUDE.md` (no `pull_request` trigger on
  `quarto-publish.yaml`; PR preview only).
- Book build: Quarto book, `traits.build-book/_quarto.yml`; render via the `render` GitHub Action.

## Follow-up issues to file (not implemented here)

- **Migrate off `remake` → `targets`.** `remake` is no longer maintained. File a tracking issue on
  board #9 to plan replacing `remake.yml`-driven builds with a `targets` pipeline in the affected
  repos (`traits.build-template`, `ausinvertraits.build`, and any other remake user). Out of scope for
  this documentation pass — this plan only documents current usage and flags the intended shift.

## Verification

- **Papers list:** every DOI resolves; every BibTeX key in `austraits-family.bib` exists in refs.bib
  and every Tier-1 key is cited by at least the mapped repos.
- **READMEs:** render each on GitHub (or `grip`/preview) — no broken links (`lychee`/`markdown-link-check`
  over every README), family block present, "How to cite" present. Spot-check the previously broken
  links (APCalign-app APC link, AusFizz links, traits.build `hhttp://`).
- **CITATION.cff:** validate with `cffconvert --validate` (or GitHub's citation widget renders).
- **austraits.org:** `quarto render` locally; confirm Tools section shows the broadened family, the
  portal card renders, the How-to-cite block appears; open the Netlify **deploy-preview** (never push
  to `master`).
- **traits.build book:** `quarto render` the whole book with no errors; run a link checker over
  `_book/` to confirm zero dead internal links (specifically the former `troubleshooting.html`,
  `overview.html`, `targets`/`tarchetypes` links); confirm new chapters appear in the sidebar and the
  bibliography renders. Rebase/confirm clean vs PR #25 first.

## Sequencing (suggested PRs)

1. `austraits-meta`: papers list + `.bib` + canonical `acknowledgements.md` + save this plan
   (foundation everything else cites).
2. Ensure book PR #25 merged; then book branch (with **Fable**): 5a/5b (fixes+citations) →
   5c/5d/5e (content) — split into 2 PRs if 5c/5d gets large.
3. Per-repo README PRs — batch the family-block + acknowledgement + citation additions together
   (they all touch the same file); separate PRs for the heavy rewrites (template, api, AusFizz, portal).
4. `austraits.org` website PR (preview-only): Tools/portal/how-to-cite + partner-logo/Melbourne tidy.
5. CITATION.cff PRs (ride along with each repo's README PR).
