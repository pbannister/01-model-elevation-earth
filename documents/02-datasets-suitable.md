# Suitable GDEM Datasets

This document identifies the GDEM datasets this project should download and use, given the project requirements.

Facts reflect public documentation as of 2026-08-24; verify download URLs before use.

## Requirements

The project needs a 1 meter Earth model, with the option to view or 3D print selected areas at larger scale, and larger globes.

Suitable datasets must meet these requirements:

- Resolution: 1 arc-second (~30 m) for land, so larger-scale views and larger globes stay sharp.
- Seafloor: 15 arc-second (~450 m) resolution is sufficient; less resolution is needed under water.
- Access: download must be automatable without manual steps or expensive gates.
- Completeness: voids must be fillable from other datasets without leaving gaps.
- The dataset must be one of the sources enumerated in `documents/01-dataset-sources.md`.

## Recommended Land Datasets (1 arc-second)

| Dataset | Coverage | Access | Automated | License | Role |
| --- | --- | --- | --- | --- | --- |
| Copernicus DEM GLO-30 | Global land | AWS S3 public | Yes, no auth | Free and open | Primary |
| NASADEM | 56 S to 60 N | AWS S3 public | Yes, no auth | Public domain | Secondary, void-fill source |
| SRTM v3 | 56 S to 60 N | AWS S3 public | Yes, no auth | Public domain | Legacy; superseded by NASADEM |
| ALOS World 3D (AW3D30) | Global | JAXA portal | Registration required | Free with agreement | Optional fill source |
| FABDEM | Global | OpenTopography API | Free API key | Free with citation | Optional bare-earth |
| ASTER GDEM v3 | 83 S to 83 N | NASA Earthdata | Earthdata login | Free with registration | Optional fill source |

### Copernicus DEM GLO-30

- The primary land dataset: 1 arc-second (~30 m), global land, near-void-free.
- Public AWS S3 bucket `s3://copernicus-dem-30m` and matching Google Cloud Storage bucket; no authentication.
- Derived from TanDEM-X radar; one of the most accurate global DEMs.
- Heights reference the EGM2008 geoid.
- License is free and open with attribution.

### NASADEM

- The secondary land dataset: 1 arc-second (~30 m) over 56 S to 60 N.
- Public AWS S3 bucket `s3://nasadem`; no authentication.
- Reprocesses SRTM with auxiliary data (ICESat, ASTER GDEM, PRISM) and improves voids.
- Heights reference the EGM96 geoid.
- The natural void-fill source for Copernicus DEM gaps.

### SRTM v3

- The classic 1 arc-second dataset over 56 S to 60 N.
- Public AWS S3 bucket `s3://srtm`; no authentication.
- Version 3 is void-filled; the original void mask is available separately.
- Superseded in quality by NASADEM; kept as legacy and cross-check.

## Recommended Seafloor Datasets (15 arc-second)

| Dataset | Coverage | Access | Automated | License | Role |
| --- | --- | --- | --- | --- | --- |
| ETOPO 2022 | Global land and seafloor | NOAA direct HTTPS | Yes, no auth | Public domain | Primary |
| GEBCO 2024 | Global land and seafloor | GEBCO portal | Click-through license | Free with agreement | Optional |

### ETOPO 2022

- The primary seafloor dataset: 15 arc-second (~450 m), complete global relief including bathymetry.
- Direct HTTPS download from NOAA NCEI; no authentication.
- A blended product, so it has no voids by construction.
- Public domain; ideal fallback when any other dataset has gaps.

### GEBCO 2024

- The reference bathymetry grid: 15 arc-second (~450 m).
- Download requires accepting a click-through license each session, so automation is awkward.
- Optional; ETOPO 2022 covers the seafloor need on its own.

## Supporting Datasets

- MERIT DEM: 3 arc-second (~90 m) error-removed land DEM with a published void mask; useful as a void-fill reference.
- Copernicus DEM GLO-90: 3 arc-second (~90 m) variant of GLO-30; a compact fallback.
- ArcticDEM and REMA: 2 m/8 m polar DEMs; only for high-latitude areas if ever needed.

## Void Handling Strategy

Voids are missing cells in a DEM: radar shadow and layover, cloud cover, water bodies, or sensor dropout.

A complete dataset is built by filling voids from other datasets, as this project intends.

### Principle 1: know where the voids are

- Every DEM has a void mask, either published or derivable as the no-data cells.
- Keep the void mask alongside the filled product so the fill history stays auditable.
- SRTM v3, NASADEM, and MERIT publish void masks or no-data conventions.
- Copernicus DEM is near-void-free; its residual gaps are known and few.

### Principle 2: fill from a better source, not by guessing

- Fill large voids from a higher-quality auxiliary DEM rather than by interpolation.
- Interpolation invents plausible terrain; a second DEM provides real terrain.
- The recommended fill hierarchy is: Copernicus DEM GLO-30 first, NASADEM second, ETOPO 2022 as the always-complete last resort.
- Use interpolation only for residual single-cell gaps after data-driven filling.

### Principle 3: remove mismatch before blending

- Vertical reference mismatch is the main risk: SRTM and NASADEM use EGM96, Copernicus DEM uses EGM2008.
- Convert every source to one common vertical reference (for example EGM2008) before filling, using a geoid height model.
- Without conversion, seams of up to a meter or more can appear at fill boundaries.
- Horizontal datum is WGS84 for all recommended sources; verify and co-register anyway.
- Resample the fill source to the target grid so cell edges align exactly.
- Use a consistent water mask so land fill never spills into the ocean and vice versa.

### Principle 4: record the fill history

- Keep a fill-source raster: for each cell, which dataset supplied the value.
- Keep the original void mask.
- Downstream consumers can then judge data provenance per cell.

### Principle 5: validate the result

- Confirm zero residual voids after filling.
- Check the histogram of filled cells against the histogram of the source cells.
- Inspect fill seams for steps, spikes, or datum jumps.
- Verify coastline continuity where land meets seafloor data.

### The recommended pipeline

- Start from Copernicus DEM GLO-30 as the primary land layer.
- Fill its residual voids from NASADEM after converting both to a common vertical reference.
- Fill any remaining gaps from ETOPO 2022, which is complete by construction.
- Merge the seafloor from ETOPO 2022 at the coastline with a consistent water mask.
- Produce the void mask and fill-source raster as side products.
- Validate as described above before the data leaves this project.

## Manifest

The machine-readable selection lives in `datasets.in/datasets-manifest.yml`.

The manifest is the input for automated download; each listed dataset carries a `want_download` field.

Only datasets with `want_download: true` are fetched by the download task.

## Dataset Sizes

Sizes below are rough estimates for storage planning, to the nearest gigabyte.

The two Copernicus figures were measured directly from the public AWS S3 buckets on 2026-08-25.

The remaining figures are computed from grid dimensions and published file counts; the as-shipped size depends on format and compression.

### Measured sizes

| Dataset | Size | How determined |
| --- | --- | --- |
| Copernicus DEM GLO-30 | ~590 GB | Sum of 26,450 DEM tile objects in `s3://copernicus-dem-30m` |
| Copernicus DEM GLO-90 | ~80 GB | Sampled tile sizes times the 26,475-tile official list |

### Estimated sizes

| Dataset | Raw size | As shipped |
| --- | --- | --- |
| SRTM v3 (1 arc-sec) | ~371 GB | ~65 GB GeoTIFF |
| NASADEM (1 arc-sec) | ~370 GB | ~130 GB incl. aux layers |
| ALOS World 3D (30 m) | ~635 GB | ~110 GB |
| FABDEM (30 m) | ~1,245 GB | ~150-300 GB |
| MERIT DEM (90 m) | ~40 GB | ~15-40 GB |
| ETOPO 2022 (15 arc-sec) | ~7 GB | ~5-8 GB |
| GEBCO 2024 (15 arc-sec) | ~15 GB | ~9 GB |

### Sizing guidance

- The smaller seafloor datasets (ETOPO 2022, GEBCO 2024) need only ~5-9 GB each.
- The larger land datasets need ~65-590 GB each; GLO-30 dominates at ~590 GB.
- The current wanted set (GLO-30, NASADEM, ETOPO 2022) is roughly 730 GB.
- A full 1-arc-second land ambition (adding SRTM, AW3D30, FABDEM) is roughly 1.1-1.7 TB.
- The recommended initial `/datasets/` volume size is 2 TB.
- A 1.5 TB volume fits the wanted set plus one extra dataset; 1 TB fits the wanted set with almost no headroom.
- The 2 m polar datasets (ArcticDEM, REMA) are excluded from this math; they run to multiple TB.

## Storage

Large datasets are stored on the dedicated `/datasets/` volume, mounted on both `athena.lan` and `beast.lan`.

The `/datasets/` volume is a precondition: the download scripts verify it exists before downloading.

Each dataset is stored in a distinct semantic-sort directory named `/datasets/dataset-<semantic-sort-source-name>`.

The `storage_dir` field in the manifest names the directory for each dataset.

A `/datasets/manifest.yml` file records the datasets downloaded: id, purpose, download date, and source.

The download scripts skip a dataset already recorded there, so nothing downloads twice.

The homelab project keeps the two hosts' `/datasets/` volumes synchronized.
