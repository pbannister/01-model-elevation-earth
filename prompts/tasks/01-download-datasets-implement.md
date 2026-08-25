# Task: Define and implement automated dataset download

[TASK]
Define the automated download mechanism for the datasets listed in `datasets.in/datasets-manifest.yml`.
Implement the download for every dataset whose `want_download` field is `true`.
Create the download scripts in `scripts/`.
Download the datasets into `dataflow.in/`.
Add tests for the download scripts in `tests/`.
Run `make test` from the repository root.
Commit the completed work.

[OUTPUT FORMAT]
Report the created files and the result of `make test`.

[CONTEXT]
The manifest is the input for this task.
The manifest lives at `datasets.in/datasets-manifest.yml`.
Each entry carries the fields an automated downloader needs: id, access method, access location, and file format.
Only entries with `want_download: true` are in scope for this task.
The datasets selected for download are described in `documents/02-datasets-suitable.md`.
All recommended download sources are publicly accessible without registration or paid access.
The download scripts must place data under `dataflow.in/`.
Generated output must not be committed; `dataflow.in/` content is input data and may be committed or ignored as the task decides.

[FILES]
- `scripts/datasets-download.sh` — new
- `scripts/datasets-download-<dataset-id>.sh` — new, one per wanted dataset
- `tests/03-datasets-download.sh` — new
- `datasets.in/datasets-manifest.yml` — existing, read-only for this task
- `dataflow.in/` — populated by the download scripts
