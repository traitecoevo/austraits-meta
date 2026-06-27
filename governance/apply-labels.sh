#!/usr/bin/env bash
#
# apply-labels.sh — sync governance/labels.yml to the AusTraits FAMILY repos.
#
# SAFETY / SCOPE
#   * Operates ONLY on the explicit, hard-coded list below. It NEVER enumerates the org
#     (no `gh repo list traitecoevo`). This is deliberate: the taxonomy is family-scoped.
#   * Idempotent: uses `gh label create --force`, which creates a label or updates it in place
#     (colour + description) if it already exists. Running twice is a no-op on the second run.
#   * Dry-run by DEFAULT. It prints what it WOULD do and changes nothing unless you pass --apply.
#   * It does not delete labels. Removing the family default labels (bug/enhancement/...) is a
#     manual decision — see the commented note at the bottom.
#
# USAGE
#   ./apply-labels.sh            # dry run: show every label x repo it would sync
#   ./apply-labels.sh --apply    # actually create/update labels (run only after sign-off)
#   ./apply-labels.sh --apply --only traits.build,APD   # restrict to a subset of the list
#
# Requires: gh (authenticated to traitecoevo), python3 with pyyaml.

set -euo pipefail

# --- The hard-coded family repo list (edit deliberately; never auto-generate) ----------------
FAMILY_REPOS=(
  traitecoevo/traits.build
  traitecoevo/APCalign
  traitecoevo/austraits
  traitecoevo/APD
  traitecoevo/austraits-meta
)
# NOTE: austraits.build is the central pipeline node but is intentionally NOT here yet —
# its inclusion is an open governance decision (see governance/triage.md). To add it, append:
#   traitecoevo/austraits.build

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LABELS_YML="${SCRIPT_DIR}/labels.yml"

APPLY=false
ONLY=""
for arg in "$@"; do
  case "$arg" in
    --apply) APPLY=true ;;
    --only) ONLY="__NEXT__" ;;
    *) if [ "$ONLY" = "__NEXT__" ]; then ONLY="$arg"; else echo "Unknown arg: $arg" >&2; exit 2; fi ;;
  esac
done

command -v gh >/dev/null      || { echo "ERROR: gh not found" >&2; exit 1; }
command -v python3 >/dev/null || { echo "ERROR: python3 not found" >&2; exit 1; }
[ -f "$LABELS_YML" ]          || { echo "ERROR: $LABELS_YML not found" >&2; exit 1; }

# Optionally restrict to a comma-separated subset (bare repo names or full owner/name).
REPOS=()
if [ -n "$ONLY" ] && [ "$ONLY" != "__NEXT__" ]; then
  IFS=',' read -ra want <<< "$ONLY"
  for r in "${FAMILY_REPOS[@]}"; do
    for w in "${want[@]}"; do
      [ "$r" = "$w" ] || [ "$r" = "traitecoevo/$w" ] && REPOS+=("$r")
    done
  done
  [ ${#REPOS[@]} -gt 0 ] || { echo "ERROR: --only matched nothing in the family list" >&2; exit 1; }
else
  REPOS=("${FAMILY_REPOS[@]}")
fi

# Emit "name<TAB>color<TAB>description" lines from labels.yml.
read_labels() {
  python3 - "$LABELS_YML" <<'PY'
import sys, yaml
with open(sys.argv[1]) as f:
    doc = yaml.safe_load(f)
for lab in doc.get("labels", []):
    name = lab["name"]; color = str(lab.get("color","")).lstrip("#"); desc = lab.get("description","")
    print(f"{name}\t{color}\t{desc}")
PY
}

# bash 3.2 (macOS default) has no `mapfile`, so stage the parsed labels in a temp file.
LABELS_TSV="$(mktemp)"
trap 'rm -f "$LABELS_TSV"' EXIT
read_labels > "$LABELS_TSV"
LABEL_COUNT=$(grep -c . "$LABELS_TSV" || true)

echo "Loaded ${LABEL_COUNT} labels from $LABELS_YML"
echo "Target repos (${#REPOS[@]}):"; printf '  - %s\n' "${REPOS[@]}"
$APPLY || echo $'\n*** DRY RUN — nothing will change. Re-run with --apply to sync. ***'
echo

for repo in "${REPOS[@]}"; do
  echo "==> $repo"
  while IFS=$'\t' read -r name color desc; do
    [ -n "$name" ] || continue
    if $APPLY; then
      gh label create "$name" --repo "$repo" --color "$color" --description "$desc" --force
    else
      echo "    would sync: $name (#$color) — $desc"
    fi
  done < "$LABELS_TSV"
done

echo
$APPLY && echo "Done. Labels synced to ${#REPOS[@]} repo(s)." \
       || echo "Dry run complete. ${LABEL_COUNT} labels x ${#REPOS[@]} repos would be synced."

# --- Optional cleanup (NOT automated) --------------------------------------------------------
# GitHub seeds new repos with default labels (bug, enhancement, documentation, question, ...).
# This script does not remove them. If maintainers want a clean taxonomy, delete per repo with:
#   gh label delete enhancement --repo traitecoevo/<repo> --yes
# Decide this deliberately; some repos may have existing issues using the defaults.
