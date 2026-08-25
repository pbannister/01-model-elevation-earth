#!/bin/sh
#
# site-state-fetch.sh: gather live dataset state and write it as KEY=value
# lines to the site state file.
#
# Feature: prompts/features/01-site-build.md
#
# The state file is generated output and must not be edited by hand.
# The site build (scripts/site-build.sh) substitutes these values for
# __KEY__ placeholders in site.in/dashboard.txt.
#
# Reads the datasets volume manifest and the ETOPO 2022 dataset directory,
# plus repository git state and volume usage.
#
# Usage: site-state-fetch.sh [OUTPUT_FILE]
# The default OUTPUT_FILE is dataflow.out/site-state.txt relative to the
# repository root.
set -eu

DIRECTORY_SCRIPT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPOSITORY_ROOT=$(CDPATH= cd -- "$DIRECTORY_SCRIPT/.." && pwd)
OUTPUT_FILE=${1:-"$REPOSITORY_ROOT/dataflow.out/site-state.txt"}

DIRECTORY_VOLUME=/datasets
DIRECTORY_DATASET_ETOPO="$DIRECTORY_VOLUME/dataset-etopo-2022"
FILE_MANIFEST="$DIRECTORY_VOLUME/manifest.yml"
ID_ETOPO=etopo-2022

fetched=$(date -Is 2>/dev/null || date)
branch=$(git -C "$REPOSITORY_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)
commit=$(git -C "$REPOSITORY_ROOT" rev-parse --short HEAD 2>/dev/null || echo unknown)

manifest_count=0
if [ -f "$FILE_MANIFEST" ]; then
    manifest_count=$(grep -c '^  - id:' "$FILE_MANIFEST" 2>/dev/null || true)
fi

etopo_date=unknown
etopo_files=0
etopo_size=unknown
if [ -d "$DIRECTORY_DATASET_ETOPO" ]; then
    etopo_date=$(awk -v id="$ID_ETOPO" '
        $0 == "  - id: " id { found = 1 }
        found && /download_date:/ { print $2; exit }
    ' "$FILE_MANIFEST" 2>/dev/null || echo unknown)
    etopo_files=$(find "$DIRECTORY_DATASET_ETOPO" -name '*.tif' | wc -l)
    etopo_size=$(du -sh "$DIRECTORY_DATASET_ETOPO" 2>/dev/null | cut -f1 || echo unknown)
fi

volume_total=unknown
volume_used=unknown
volume_free=unknown
if [ -d "$DIRECTORY_VOLUME" ]; then
    volume_total=$(df -h "$DIRECTORY_VOLUME" 2>/dev/null | awk 'NR == 2 { print $2 }')
    volume_used=$(df -h "$DIRECTORY_VOLUME" 2>/dev/null | awk 'NR == 2 { print $3 }')
    volume_free=$(df -h "$DIRECTORY_VOLUME" 2>/dev/null | awk 'NR == 2 { print $4 }')
fi

mkdir -p "$(dirname "$OUTPUT_FILE")"

cat > "$OUTPUT_FILE" <<EOF
FETCHED=$fetched
BRANCH=$branch
COMMIT=$commit
MANIFEST_COUNT=$manifest_count
VOLUME_TOTAL=$volume_total
VOLUME_USED=$volume_used
VOLUME_FREE=$volume_free
ETOPO_DATE=$etopo_date
ETOPO_FILES=$etopo_files
ETOPO_SIZE=$etopo_size
EOF

echo "site-state-fetch: wrote $OUTPUT_FILE"
exit 0
