#!/bin/sh
#
# Test for the datasets manifest (datasets.in/datasets-manifest.yml).
# The manifest is the machine input for the automated download task,
# so every dataset entry must carry a want_download field.
set -eu

DIRECTORY_SCRIPT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPOSITORY_ROOT=$(CDPATH= cd -- "$DIRECTORY_SCRIPT/.." && pwd)
FILE_MANIFEST="$REPOSITORY_ROOT/datasets.in/datasets-manifest.yml"

if [ ! -f "$FILE_MANIFEST" ]; then
    echo "01-datasets-manifest: manifest file missing: $FILE_MANIFEST" >&2
    exit 1
fi

COUNT_ENTRIES=$(grep -c '^  - id:' "$FILE_MANIFEST")
COUNT_WANT=$(grep -c '^    want_download:' "$FILE_MANIFEST")

if [ "$COUNT_ENTRIES" -eq 0 ]; then
    echo '01-datasets-manifest: no dataset entries found' >&2
    exit 1
fi

if [ "$COUNT_ENTRIES" -ne "$COUNT_WANT" ]; then
    echo "01-datasets-manifest: $COUNT_ENTRIES entries but $COUNT_WANT want_download fields" >&2
    exit 1
fi

COUNT_WANT_TRUE=$(grep -c '^    want_download: true$' "$FILE_MANIFEST" || true)

if [ "$COUNT_WANT_TRUE" -eq 0 ]; then
    echo '01-datasets-manifest: no dataset is marked want_download: true' >&2
    exit 1
fi

echo "01-datasets-manifest: ok ($COUNT_ENTRIES entries, $COUNT_WANT_TRUE wanted)"
exit 0
