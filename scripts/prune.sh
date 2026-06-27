#!/usr/bin/env bash
# scripts/prune.sh — prune the APT pool to the latest N versions of each package.
#
# Usage:
#   ./scripts/prune.sh         # keep latest 3 versions per package
#   ./scripts/prune.sh 5       # keep latest 5 versions per package
#
# The package name is parsed from the filename before the first `_`:
#   trance_2.1.1-1_amd64.deb → package "trance"
#   trance-plugins-all_0.3.4-1_amd64.deb → package "trance-plugins-all"
#
# Versions are sorted using `sort -V` (version-aware sort) so that
# `0.10.0` correctly sorts after `0.9.9`.
#
# After pruning, regenerate the APT index:
#   ./update.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
POOL="$REPO_ROOT/apt/pool/main"

KEEP="${1:-3}"

if ! [[ "$KEEP" =~ ^[0-9]+$ ]] || [[ "$KEEP" -lt 1 ]]; then
    echo "ERROR: KEEP must be a positive integer (got: $KEEP)" >&2
    exit 1
fi

echo "Pruning $POOL — keeping latest $KEEP versions of each package..."

# Collect all .deb files, grouped by package name.
declare -A PACKAGES
while IFS= read -r -d '' deb; do
    base="$(basename "$deb")"
    pkg="${base%%_*}"
    PACKAGES["$pkg"]+="${deb}"$'\n'
done < <(find "$POOL" -maxdepth 1 -type f -name '*.deb' -print0)

removed=0
kept=0
for pkg in "${!PACKAGES[@]}"; do
    mapfile -t versions < <(printf '%s\n' "${PACKAGES[$pkg]}" | grep -v '^$')

    # Version-aware sort.
    mapfile -t sorted < <(printf '%s\n' "${versions[@]}" | sort -V)

    count=${#sorted[@]}
    if (( count <= KEEP )); then
        kept=$((kept + count))
        continue
    fi

    # Keep the LAST $KEEP (the newest). Delete the rest.
    delete_count=$((count - KEEP))
    for ((i = 0; i < delete_count; i++)); do
        echo "  rm ${sorted[$i]##*/}"
        rm -- "${sorted[$i]}"
        removed=$((removed + 1))
    done
    kept=$((kept + KEEP))
done

echo ""
echo "Pruned $removed .deb files; kept $kept"
echo ""
echo "Next: regenerate the APT index:"
echo "    ./update.sh"
echo ""
echo "Or, if you've made the working tree dirty:"
echo "    git status    # review what will be committed"
echo "    git add apt/pool/main/"
echo "    git commit -m 'chore(apt): prune pool to latest \$KEEP versions per package'"
