#!/bin/sh
#
# datasets-download-etopo-2022.sh: download the ETOPO 2022 15-arc-second
# relief model into the /datasets/ volume.
#
# The dataset is the official GeoTIFF tile set of the two relief layers:
#   - ice surface (288 tiles, global)
#   - bedrock (62 tiles, ice-sheet regions only)
# NOAA ships bed tiles only where the bedrock differs from the ice surface;
# elsewhere the two layers are identical.
# The geoid and sid layers are auxiliary and outside this task's scope.
#
# Behaviour:
#   - Skips the download when etopo-2022 is already recorded in
#     /datasets/manifest.yml.
#   - Verifies the /datasets/ volume exists and is writable; stops with a
#     clear message when it is missing.
#   - Creates /datasets/dataset-etopo-2022 and downloads the tiles there.
#   - Records the download in /datasets/manifest.yml only after every tile
#     succeeded, so an interrupted run resumes and re-records cleanly.
#   - Downloads nothing but this dataset; other datasets are separate tasks.
#
# The tile list is enumerated from the official directory listing at run
# time, so the script adapts to the tiles NOAA actually ships.
#
# DATASETS_VOLUME overrides the volume path, which the tests use to run
# the skip and missing-volume paths without touching the live volume.
set -eu

DIRECTORY_VOLUME=${DATASETS_VOLUME:-/datasets}
ID_DATASET=etopo-2022
DIRECTORY_DATASET="$DIRECTORY_VOLUME/dataset-etopo-2022"
FILE_MANIFEST="$DIRECTORY_VOLUME/manifest.yml"
URL_SOURCE=https://www.ncei.noaa.gov/products/etopo-global-relief-model
URL_BASE=https://www.ngdc.noaa.gov/mgg/global/relief/ETOPO2022/data/15s
URL_LAYER_SURFACE="$URL_BASE/15s_surface_elev_gtif/"
URL_LAYER_BED="$URL_BASE/15s_bed_elev_gtif/"
PATTERN_TILE_SURFACE='ETOPO_2022_v1_15s_[A-Z0-9]+_surface\.tif'
PATTERN_TILE_BED='ETOPO_2022_v1_15s_[A-Z0-9]+_bed\.tif'

download_layer() {
    url_layer=$1
    pattern_tile=$2
    echo "datasets-download-etopo-2022: listing $url_layer"
    listing=$(curl -fsSL --max-time 120 "$url_layer")
    names_tile=$(printf '%s\n' "$listing" | grep -oE "$pattern_tile" | sort -u)
    count_tile=0
    for name_tile in $names_tile; do
        if curl -fsSL -C - --max-time 600 -o "$DIRECTORY_DATASET/$name_tile" "$url_layer$name_tile"; then
            count_tile=$((count_tile + 1))
        else
            echo "datasets-download-etopo-2022: failed: $name_tile" >&2
            exit 1
        fi
    done
    echo "datasets-download-etopo-2022: downloaded $count_tile tiles from $url_layer"
}

if [ -f "$FILE_MANIFEST" ] && grep -q "^  - id: $ID_DATASET$" "$FILE_MANIFEST"; then
    echo "datasets-download-etopo-2022: $ID_DATASET already recorded in $FILE_MANIFEST; skipping"
    exit 0
fi

if [ ! -d "$DIRECTORY_VOLUME" ]; then
    echo "datasets-download-etopo-2022: error: datasets volume missing: $DIRECTORY_VOLUME" >&2
    exit 1
fi

if [ ! -w "$DIRECTORY_VOLUME" ]; then
    echo "datasets-download-etopo-2022: error: datasets volume not writable: $DIRECTORY_VOLUME" >&2
    exit 1
fi

mkdir -p "$DIRECTORY_DATASET"

download_layer "$URL_LAYER_SURFACE" "$PATTERN_TILE_SURFACE"
download_layer "$URL_LAYER_BED" "$PATTERN_TILE_BED"

if [ ! -f "$FILE_MANIFEST" ]; then
    {
        echo '# Datasets downloaded to the /datasets/ volume.'
        echo '# Each entry records: id, purpose, download date, and source.'
        echo 'datasets:'
    } > "$FILE_MANIFEST"
fi

{
    echo "  - id: $ID_DATASET"
    echo "    purpose: global relief model of land elevation and seafloor bathymetry"
    echo "    download_date: $(date +%Y-%m-%d)"
    echo "    source: $URL_SOURCE"
} >> "$FILE_MANIFEST"

echo "datasets-download-etopo-2022: complete; recorded $ID_DATASET in $FILE_MANIFEST"
exit 0
