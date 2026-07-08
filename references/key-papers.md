# AusTraits family — key papers

The canonical, curated list of papers that repos in the AusTraits family should cite. The
machine-readable BibTeX for every entry below is in [`austraits-family.bib`](austraits-family.bib) —
**copy from there** into a repo's README / `inst/CITATION` / `CITATION.cff` rather than re-typing, so
citations stay consistent across the family.

Maintained by hand; if you add a family paper, add it here **and** to `austraits-family.bib`.

---

## Tier 1 — core "must-cite" papers

One paper per pipeline-core output. Every repo listed under "Cite in" should carry this reference in
its README "How to cite" section (and `inst/CITATION` / `CITATION.cff` where it is an R package).

### `Falster-2021a` — the AusTraits dataset
Falster D, Gallagher R, Wenk EH, Wright IJ, Indiarto D, Andrew SC, *et al.* (2021) **AusTraits, a
curated plant trait database for the Australian flora.** *Scientific Data* 8:254.
<https://doi.org/10.1038/s41597-021-01006-6>
- **Cite in:** `austraits`, `austraits.build`, `austraits.org`, `austraits.portal`, `austraits-api`.
- The reference for the AusTraits **dataset** itself (as distinct from the tooling). Anyone using
  AusTraits data cites this.

### `Wenk-2024b` — the traits.build workflow
Wenk E, Bal P, Coleman D, Gallagher R, Yang S, Falster DS (2024) **traits.build: A data model,
workflow and R package for building harmonised ecological trait databases.** *Ecological Informatics*
83:102773. <https://doi.org/10.1016/j.ecoinf.2024.102773>
- **Cite in:** `traits.build`, `traits.build-book`, `traits.build-template`, and sibling databases
  built with the engine (`AusFizz`, `ausinvertraits.build`).
- The reference for the **engine / data model / workflow**, independent of any one database.

### `Wenk-2024a` — the AusTraits Plant Dictionary (APD)
Wenk EH, Sauquet H, Gallagher RV, Brownlee R, Boettiger C, Coleman D, *et al.* (2024) **The AusTraits
Plant Dictionary.** *Scientific Data* 11:537. <https://doi.org/10.1038/s41597-024-03368-z>
- **Cite in:** `APD`, `austraits.build`.
- The reference for the trait **vocabulary/contract** (definitions, allowed values, units).
- ⚠️ Previously cited as "in press" / preprint in some repos — always use the **published** DOI above.

### `Wenk-2024c` — APCalign
Wenk EH, Cornwell WK, Fuchs A, Kar F, Monro AM, Sauquet H, Stephens RE, Falster DS (2024) **APCalign:
An R package workflow and app for aligning and updating flora names to the Australian Plant Census.**
*Australian Journal of Botany* 72(4):BT24014. <https://doi.org/10.1071/BT24014>
- **Cite in:** `APCalign`, `APCalign-app`, `austraits.build`.
- The reference for **taxonomy alignment** against the APC/APNI.

---

## Tier 2 — directly related family outputs

Cite where the specific workflow, dataset, or vision is relevant — not required in every repo.

### `Coleman-2023` — textual-extraction workflow
Coleman D, Gallagher RV, Falster DS, Sauquet H, Wenk E (2023) **A workflow to create trait databases
from collections of textual taxonomic descriptions.** *Ecological Informatics* 78:102312.
<https://doi.org/10.1016/j.ecoinf.2023.102312>
- **Cite in:** `austraits.build` (already surfaced on austraits.org) and anywhere the description-mining
  pipeline is discussed.

### `Wenk-2024d` — gap-filled growth-form/woodiness/life-history dataset
Wenk EH, Coleman D, Gallagher RV, Falster DS (2024) **A near-complete dataset of plant growth form,
life history, and woodiness for all Australian plants.** *Australian Journal of Botany* 72(4):BT23111.
<https://doi.org/10.1071/BT23111>
- **Cite in:** `austraits.build`, `austraits.org` data-products, analyses using those core traits.

### `Gallagher-2020` — Open Traits Network vision
Gallagher RV, Falster DS, Maitner BS, Salguero-Gómez R, Vandvik V, Pearse WD, *et al.* (2020) **Open
science principles for accelerating trait-based science across the tree of life.** *Nature Ecology &
Evolution* 4:294–303. <https://doi.org/10.1038/s41559-020-1109-6>
- **Cite in:** the "why" / vision framing (traits.build motivation, austraits.org About). Optional.

---

## Tier 3 — context / applications

### `Andrew-2025` — trait mapping application
Andrew SC, Martín-Forés I, Guerin GR, Coleman D, Falster DS, Wenk E, Wright IJ, Gallagher RV (2025)
**Mapping plant functional traits using gap-filled datasets to inform management and modelling.**
*Global Ecology and Biogeography* 34(10):e70136. <https://doi.org/10.1111/geb.70136>
- Example downstream application; cite when illustrating uses of AusTraits data.

---

## Excluded (deliberately)

- **Kattge et al. 2020, TRY** (*Global Change Biology*) — a peer trait database, not part of the
  AusTraits family's citation set. Do not add it to family repos.

---

## Quick citation map

| Repo | Tier-1 papers to cite |
|------|-----------------------|
| `austraits` | Falster-2021a |
| `austraits.build` | Falster-2021a, Wenk-2024a, Wenk-2024c (+ Tier 2: Coleman-2023, Wenk-2024d) |
| `austraits.org` | Falster-2021a (+ Tier 1 set on the "How to cite" panel) |
| `austraits.portal`, `austraits-api`, `austraits-api-nectar` | Falster-2021a |
| `traits.build`, `traits.build-book`, `traits.build-template` | Wenk-2024b |
| `AusFizz`, `ausinvertraits.build` | Wenk-2024b (+ their own dataset DOI) |
| `APD` | Wenk-2024a |
| `APCalign`, `APCalign-app` | Wenk-2024c |
