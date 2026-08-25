#!/bin/sh
#
# Test for the ETOPO 2022 dataset download script
# (scripts/datasets-download-etopo-2022.sh).
#
# The test covers:
#   - the script exists, is executable, and carries the required guards.
#   - the skip path: with etopo-2022 already recorded in the manifest, the
#     script must not download anything.
#   - the missing-volume path: without the datasets volume, the script must
#     stop with a clear message.
#   - live-state: when the /datasets/ volume exists, the downloaded dataset
#     and the manifest record are verified.
#
# Live-state tier: verifies the recorded download on the /datasets/ volume.
# Prerequisite: this repository lives on a host with the /datasets/ volume
# mounted (athena.lan or beast.lan). When the volume is absent, or the
# download is not yet recorded, this test reports WARN and still passes.
set -eu

DIRECTORY_SCRIPT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPOSITORY_ROOT=$(CDPATH= cd -- "$DIRECTORY_SCRIPT/.." && pwd)
FILE_SCRIPT="$REPOSITORY_ROOT/scripts/datasets-download-etopo-2022.sh"
DIRECTORY_VOLUME_LIVE=/datasets
DIRECTORY_DATASET_LIVE="$DIRECTORY_VOLUME_LIVE/dataset-etopo-2022"
FILE_MANIFEST_LIVE="$DIRECTORY_VOLUME_LIVE/manifest.yml"
ID_DATASET=etopo-2022

fail() {
    echo "03-datasets-download: FAIL: $1" >&2
    exit 1
}

if [ ! -f "$FILE_SCRIPT" ]; then
    fail "download script missing: $FILE_SCRIPT"
fi

if [ ! -x "$FILE_SCRIPT" ]; then
    fail "download script not executable: $FILE_SCRIPT"
fi

if ! grep -q "$ID_DATASET" "$FILE_SCRIPT"; then
    fail "download script lacks the dataset id: $ID_DATASET"
fi

if ! grep -q 'manifest.yml' "$FILE_SCRIPT"; then
    fail "download script lacks a manifest reference"
fi

if ! grep -q 'datasets volume missing' "$FILE_SCRIPT"; then
    fail "download script lacks the missing-volume guard"
fi

# Behaviour checks run in a scratch volume, without touching the network or
# the live /datasets/ volume.
DIRECTORY_SCRATCH=$(mktemp -d "${TMPDIR:-/tmp}/datasets-download-test.XXXXXX")
trap 'rm -rf "$DIRECTORY_SCRATCH"' EXIT

# Skip path: a recorded id must stop the script before any download.
FILE_MANIFEST_SCRATCH="$DIRECTORY_SCRATCH/manifest.yml"
printf 'datasets:\n  - id: %s\n' "$ID_DATASET" > "$FILE_MANIFEST_SCRATCH"

if output_run=$(DATASETS_VOLUME="$DIRECTORY_SCRATCH" sh "$FILE_SCRIPT" 2>&1); then
    status_run=0
else
    status_run=$?
fi

if [ "$status_run" -ne 0 ]; then
    fail "skip path: script exited $status_run"
fi

if ! printf '%s\n' "$output_run" | grep -qi 'skip'; then
    fail "skip path: script did not report skipping"
fi

if [ -d "$DIRECTORY_SCRATCH/dataset-etopo-2022" ]; then
    fail "skip path: script downloaded despite the recorded id"
fi

# Missing-volume path: the script must stop with a clear message.
DIRECTORY_MISSING="$DIRECTORY_SCRATCH/not-mounted"

if output_run=$(DATASETS_VOLUME="$DIRECTORY_MISSING" sh "$FILE_SCRIPT" 2>&1); then
    status_run=0
else
    status_run=$?
fi

if [ "$status_run" -eq 0 ]; then
    fail "missing-volume path: script exited 0"
fi

if ! printf '%s\n' "$output_run" | grep -qi 'datasets volume missing'; then
    fail "missing-volume path: script did not report the missing volume"
fi

# Live-state: verify the recorded download on the /datasets/ volume.
if [ ! -d "$DIRECTORY_VOLUME_LIVE" ]; then
    echo '03-datasets-download: WARN: /datasets volume absent; live-state checks skipped'
    exit 0
fi

if [ ! -f "$FILE_MANIFEST_LIVE" ] || ! grep -q "^  - id: $ID_DATASET$" "$FILE_MANIFEST_LIVE"; then
    echo '03-datasets-download: WARN: etopo-2022 not recorded in /datasets/manifest.yml; download not verified'
    exit 0
fi

if [ ! -d "$DIRECTORY_DATASET_LIVE" ]; then
    fail "dataset directory missing: $DIRECTORY_DATASET_LIVE"
fi

COUNT_TILES=$(find "$DIRECTORY_DATASET_LIVE" -name '*.tif' | wc -l)

if [ "$COUNT_TILES" -eq 0 ]; then
    fail "dataset directory empty: $DIRECTORY_DATASET_LIVE"
fi

COUNT_SURFACE=$(find "$DIRECTORY_DATASET_LIVE" -name '*_surface.tif' | wc -l)
COUNT_BED=$(find "$DIRECTORY_DATASET_LIVE" -name '*_bed.tif' | wc -l)

if [ "$COUNT_SURFACE" -eq 0 ]; then
    fail "no surface tiles in: $DIRECTORY_DATASET_LIVE"
fi

if [ "$COUNT_BED" -eq 0 ]; then
    fail "no bed tiles in: $DIRECTORY_DATASET_LIVE"
fi

echo "03-datasets-download: ok (guards, skip path, missing-volume path, live dataset: $COUNT_TILES tiles)"
exit 0
