# AusTraits family — acknowledgements (canonical wording)

**Single source of truth** for how the AusTraits family credits its partners and co-investment.
The refreshed [austraits.org](https://austraits.org) footer (`austraits.org/_footer.html`) is the
reference wording; this file mirrors it so every repo can carry a consistent acknowledgement.

Repo acknowledgements had drifted (NCRIS "funded" vs "enabled by"; the old grant-DOI framing vs the
newer Planet RDC framing; several repos with none). Use the block below verbatim, add the per-repo
grant line where one applies, and do **not** re-introduce the older wording.

---

## Standard README block (copy verbatim)

```markdown
## Acknowledgements

AusTraits is made possible by contributions from our partner organisations — the
[University of New South Wales](https://www.unsw.edu.au/),
[Western Sydney University](https://www.westernsydney.edu.au/),
[Botanic Gardens of Sydney](https://www.botanicgardens.org.au/),
[the University of Melbourne](https://www.unimelb.edu.au/),
the [Atlas of Living Australia](https://www.ala.org.au/), and the Australian Government
[Department of Climate Change, Energy, the Environment and Water](https://www.dcceew.gov.au) — and
from our [advisory board, data contributors, and past partners](https://austraits.org/team/team-partners.html).

AusTraits is a co-investment partnership with the
[Australian Research Data Commons](https://ardc.edu.au/) (ARDC) through the Planet Research Data
Commons ([DOI: 10.3565/nyk4-4r91](https://doi.org/10.3565/nyk4-4r91)). The ARDC is enabled by the
Australian Government's [National Collaborative Research Infrastructure Strategy](https://www.education.gov.au/ncris)
(NCRIS).
```

Where a repo was funded by a **specific** ARDC investment, append the matching line(s) from the table
below beneath the block (they credit distinct real grants and should be kept).

---

## Per-repo specific investments

| Grant | DOI | Repos it funded |
|-------|-----|-----------------|
| Transformative Data Collections | [10.47486/TD044](https://doi.org/10.47486/TD044) | `austraits.build` |
| Data Partnerships | [10.47486/DP720](https://doi.org/10.47486/DP720) | `austraits.build`, `traits.build`, `APD`, `traits.build-book`, `austraits.portal` |
| Data Partnerships (extension) | [10.47486/DP720A](https://doi.org/10.47486/DP720A) | `austraits.portal` |
| Data Commons (invertebrates) | [10.47486/DC011](https://doi.org/10.47486/DC011) | `ausinvertraits.build` |

Suggested per-repo line, e.g. for `austraits.build`:

```markdown
This work received investment ([TD044](https://doi.org/10.47486/TD044),
[DP720](https://doi.org/10.47486/DP720)) from the ARDC.
```

---

## Rendered sites (pkgdown / Quarto)

For repos with a rendered site and a footer mechanism (`austraits`, `traits.build`, `APCalign`,
`APD`, `traits.build-book`), also surface the **partner and funder logos** in the site footer
(mirroring austraits.org), not just the README text. Keep logo image assets on the rendered sites —
do **not** copy them into every repo's root.

## Corrections applied when propagating

- AusTraits is **"enabled by"** (not "funded by").
- Full name: **National Collaborative Research Infrastructure Strategy** (fix `austraits.portal`'s
  "Research Investment Strategy").
- Fix the stray-space typo `https:// doi.org` in `austraits.build`.
- Lead with the Planet RDC co-investment framing; list specific grant DOIs beneath.
- The University of Melbourne is a current partner but its logo is not yet in
`austraits.org/images/` (see the TODO in `austraits.org/_footer.html`). Add the logo file to complete
the partner strip on the website.
