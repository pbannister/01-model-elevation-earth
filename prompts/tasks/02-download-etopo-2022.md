# Task: Download the ETOPO 2022 dataset

## TASK-DESCRIPTION
- Create: `scripts/datasets-download-etopo-2022.sh`
- Create: `tests/03-datasets-download.sh`
- Modify: `datasets.in/datasets-manifest.yml`

Download the ETOPO 2022 global relief dataset into `/datasets/`.
Check that `/datasets/` exists and is writable before downloading; stop with a clear message if it is missing.
Create the directory `/datasets/dataset-etopo-2022`.
Store the dataset files in that directory.
Record the download in `/datasets/manifest.yml`.
Run `make test` from the repository root.
Commit the completed work.

## TASK-OUTPUT
Report the created files, the size of the downloaded dataset, and the result of `make test`.

## TASK-CONTEXT
ETOPO 2022 is the chosen first dataset because it downloads over plain HTTPS without registration or a license gate.
ETOPO 2022 is a 15 arc-second global relief model covering land and seafloor.
The dataset is described in `documents/02-datasets-suitable.md` and `documents/01-dataset-sources.md`.
The manifest entry for this dataset lives in `datasets.in/datasets-manifest.yml` with id `etopo-2022` and `want_download: true`.
ETOPO 2022 is a blended product, so it has no voids; void handling is deferred to a later task.
The `/datasets/` volume is a precondition and is mounted on both `athena.lan` and `beast.lan`.
The dataset directory name is the semantic-sort name `dataset-etopo-2022`.
The download scripts must skip the download if `etopo-2022` is already recorded in `/datasets/manifest.yml`.
The `/datasets/manifest.yml` entry records: id, purpose, download date, and source.
Download source: NOAA NCEI, `https://www.ncei.noaa.gov/products/etopo-global-relief-model`.
Do not download any other dataset in this task; later datasets are separate later tasks.

## TASK-FILES

| Operation | Path |
|---|---|
| create | `scripts/datasets-download-etopo-2022.sh` |
| create | `tests/03-datasets-download.sh` |
| modify | `datasets.in/datasets-manifest.yml` |

## TASK-VERIFY
- Run: `make test` from the repository root.
- Expected: exit status 0.

OUTPUT: the content of `scripts/datasets-download-etopo-2022.sh`, as TASK-OUTPUT describes, and nothing else.
