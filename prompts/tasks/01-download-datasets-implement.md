# Task: Define and implement automated dataset download

## TASK-DESCRIPTION
- Create: `scripts/datasets-download.sh`
- Create: `scripts/datasets-download-<dataset-id>.sh`
- Create: `tests/03-datasets-download.sh`
- Modify: `datasets.in/datasets-manifest.yml`

Define the automated download mechanism for the datasets listed in `datasets.in/datasets-manifest.yml`.
Implement the download for every dataset whose `want_download` field is `true`.
Check that `/datasets/` exists and is writable before downloading anything; stop with a clear message if it is missing.
Create the download scripts in `scripts/`.
Download the datasets into `/datasets/`, one directory per dataset.
Add tests for the download scripts in `tests/`.
Run `make test` from the repository root.
Commit the completed work.

## TASK-OUTPUT
Report the created files and the result of `make test`.

## TASK-CONTEXT
The manifest is the input for this task.
The manifest lives at `datasets.in/datasets-manifest.yml`.
Each entry carries the fields an automated downloader needs: id, access method, access location, and file format.
Only entries with `want_download: true` are in scope for this task.
The datasets selected for download are described in `documents/02-datasets-suitable.md`.
All recommended download sources are publicly accessible without registration or paid access.
The large datasets must not live on the same storage volume as `/home/`; the `/datasets/` volume exists for this purpose.
The `/datasets/` volume is a precondition: the download scripts must verify it before any download starts.
Each dataset is stored in a distinct semantic-sort directory named `/datasets/dataset-<semantic-sort-source-name>`.
A `/datasets/manifest.yml` file records the datasets already downloaded: id, purpose, download date, and source.
The download scripts must skip a dataset already recorded in `/datasets/manifest.yml` so nothing is downloaded twice.
The `/datasets/` volume is shared with `athena.lan` and `beast.lan`; a homelab task keeps both hosts synchronized.
Generated output must not be committed.

## TASK-FILES

| Operation | Path |
|---|---|
| create | `scripts/datasets-download.sh` |
| create | `scripts/datasets-download-<dataset-id>.sh` |
| create | `tests/03-datasets-download.sh` |
| modify | `datasets.in/datasets-manifest.yml` |

## TASK-VERIFY
- Run: `make test` from the repository root.
- Expected: exit status 0.

OUTPUT: the content of `scripts/datasets-download.sh`, as TASK-OUTPUT describes, and nothing else.
