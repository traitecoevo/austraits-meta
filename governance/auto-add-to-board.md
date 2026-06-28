# Auto-add new issues to board #9

Goal: every new issue (and optionally PR) in **any** AusTraits-family repo is automatically added to
[board #9](https://github.com/orgs/traitecoevo/projects/9), so triage starts from one place.

## Why the GitHub Actions approach (not the built-in workflow)

Board #9 already has GitHub's **built-in "Auto-add to project"** workflow enabled. But:

- It is configured **per-repository in the project UI** and has historically been limited to a small
  number of repos.
- There is **no public API** to read which repos it covers or to add the family's 15 repos
  programmatically.

So for guaranteed, version-controlled coverage across all family repos we use a small
[`actions/add-to-project`](https://github.com/actions/add-to-project) workflow committed to each repo.
(If you would rather rely on the built-in workflow, add each repo to it in the project's
**Settings → Workflows → Auto-add to project** — but then this doc and the per-repo workflows are
redundant.)

## Prerequisite (do this BEFORE merging the workflow PRs)

The default `GITHUB_TOKEN` cannot write to an **org** project, so the workflow needs a token with
project write access, stored as a secret:

1. Create a token with project scope:
   - **Fine-grained PAT** (recommended): organization permissions → *Projects: Read and write*; or
   - **Classic PAT**: `project` scope; or
   - a **GitHub App** installation token with Projects read/write.
2. Add it as an **organization secret** named `ADD_TO_PROJECT`, scoped to the family repos
   (Org → Settings → Secrets and variables → Actions → New organization secret). An org secret means
   you set the token **once** for all repos instead of per-repo.

> Until the secret exists, the workflow run on a new issue will fail (visible only in the repo's
> Actions tab; it blocks nothing). Set the secret first.

## The workflow (committed as `.github/workflows/add-to-project.yml` in each repo)

```yaml
name: Add new issues to AusTraits board #9
on:
  issues:
    types: [opened]
jobs:
  add-to-project:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/add-to-project@v1.0.2
        with:
          project-url: https://github.com/orgs/traitecoevo/projects/9
          github-token: ${{ secrets.ADD_TO_PROJECT }}
```

Notes:
- Triggers on `issues: opened` only — it does **not** run on the workflow's own PR, so the PRs adding
  it show no failing checks.
- To also auto-add opened PRs, add `pull_request: {types: [opened]}` to `on:` (left off by default to
  keep the board issue-focused).
- `actions/add-to-project` is pinned to a release tag; bump deliberately.

## Rollout

Added to all 15 family repos via draft PRs on branch `ci/auto-add-to-board` (see the meta-repo
bootstrap summary for links). **Set `ADD_TO_PROJECT` first, then merge.**
