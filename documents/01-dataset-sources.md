# Global Digital Elevation Model (GDEM) Sources

This document enumerates freely available global digital elevation model (GDEM) datasets on the Internet, their likely use, and their meaningful attributes.

Facts reflect public documentation as of 2026-08-24; verify download URLs before use.

## Scope

A GDEM dataset is a gridded model of the Earth's land (and sometimes seafloor) elevation.

The datasets below are global or near-global, freely accessible, and usable for ingestion by other projects.

Attributes that matter when choosing or comparing datasets:

- Resolution: ground sample spacing, in arc-seconds and meters.
- Coverage: latitude range and completeness.
- Sensing technology: radar interferometry, optical stereo, or other.
- Data type: digital surface model (DSM) versus digital terrain model (DTM).
- Void handling: whether missing cells exist and how they were filled.
- Horizontal datum and vertical reference.
- File format and tiling scheme.
- License and access terms.
- Download mechanism: portal, API, or public cloud bucket.

## Dataset Index

| Dataset | Resolution | Coverage | Technology | Access |
| --- | --- | --- | --- | --- |
| SRTM | 1 arc-sec (~30 m) and 3 arc-sec (~90 m) | 56 S to 60 N | Radar interferometry | USGS EarthExplorer, AWS Open Data |
| NASADEM | 1 arc-sec (~30 m) | 56 S to 60 N | SRTM reprocessed | NASA Earthdata, AWS Open Data |
| ASTER GDEM v3 | 1 arc-sec (~30 m) | 83 S to 83 N | Optical stereo | NASA Earthdata (LP DAAC) |
| Copernicus DEM | 1 arc-sec (~30 m), 3 arc-sec (~90 m) | 90 S to 90 N | TanDEM-X radar | AWS Open Data, Copernicus Data Space |
| ALOS World 3D | 1 arc-sec (~30 m) | 90 S to 90 N | Optical stereo | JAXA EORC |
| TanDEM-X DEM | 3 arc-sec (~90 m) public | Global | Radar interferometry | DLR EOC |
| GMTED2010 | 7.5 to 30 arc-sec (~250 m to ~1 km) | Global | Multi-source mosaic | USGS |
| ETOPO 2022 | 15 arc-sec (~450 m) | Global land and seafloor | Multi-source mosaic | NOAA NCEI |
| GEBCO 2024 | 15 arc-sec (~450 m) | Global land and seafloor | Multi-source mosaic | GEBCO |
| MERIT DEM | 3 arc-sec (~90 m) | 90 S to 90 N | SRTM + AW3D30, error-removed | Hydrodynamics lab |
| FABDEM | 1 arc-sec (~30 m) | 90 S to 90 N | Copernicus DEM, forest removed | OpenTopography |
| ArcticDEM | 2 m strips, 8 m mosaics | North of 60 N | Optical stereo | Polar Geospatial Center |
| HydroSHEDS | 3 to 15 arc-sec (~90 m to ~450 m) | Global, hydrologically conditioned | SRTM derived | WWF / USGS |

## Source Details

### SRTM (Shuttle Radar Topography Mission)

- The SRTM mission flew in 2000 and produced the first high-quality near-global DEM.
- The 1 arc-second product (~30 m) is available globally between 56 S and 60 N.
- The 3 arc-second product (~90 m) covers the same range at lower resolution.
- Data is delivered as HGT tiles or GeoTIFF, in WGS84.
- The current release is SRTM v3 (also called SRTMGL1) with void filling.
- Likely use: baseline terrain elevation for global and regional analysis.
- Download: [USGS EarthExplorer](https://earthexplorer.usgs.gov/) and [AWS Open Data](https://registry.opendata.aws/srtm/).

### NASADEM

- NASADEM reprocesses the original SRTM radar signal to improve accuracy and fill voids.
- Resolution is 1 arc-second (~30 m) over the same 56 S to 60 N range.
- It is distributed as HGT tiles and on cloud buckets.
- Likely use: improved SRTM alternative when accuracy matters.
- Download: [NASA Earthdata](https://earthdata.nasa.gov/) (LP DAAC) and AWS Open Data.
- Also available as an analysis-ready dataset in [Google Earth Engine](https://developers.google.com/earth-engine/datasets/catalog/NASA_NASADEM_HGT_001).

### ASTER GDEM v3

- The ASTER GDEM is produced from optical stereo pairs of the ASTER instrument on Terra.
- Version 3 has 1 arc-second (~30 m) resolution and covers 83 S to 83 N.
- It is a digital surface model (DSM): it includes vegetation and building tops.
- Known artifacts over some water and low-contrast terrain; v3 reduced them.
- Likely use: global DSM where canopy or structure tops are acceptable.
- Download: [NASA Earthdata LP DAAC](https://earthdata.nasa.gov/) and the Japan Space Systems ASTER site.

### Copernicus DEM

- The Copernicus DEM is derived from the TanDEM-X radar mission.
- GLO-30 is 1 arc-second (~30 m); GLO-90 is 3 arc-second (~90 m).
- Coverage is near-global, 90 S to 90 N.
- It is widely regarded as one of the most accurate global DEMs.
- Delivered as GeoTIFF tiles in WGS84.
- Likely use: high-accuracy global terrain for hydrology, flood, and visualization work.
- Download: [AWS Open Data](https://registry.opendata.aws/copernicus-dem/) and the [Copernicus Data Space Ecosystem](https://dataspace.copernicus.eu/).

### ALOS World 3D (AW3D30)

- AW3D30 is produced from PRISM optical stereo on the ALOS satellite.
- The free version is 1 arc-second (~30 m); a commercial 5 m product also exists.
- Coverage is 90 S to 90 N, released in 5-degree tiles.
- It is a DSM and is often used where SRTM has voids or artifacts.
- Likely use: global DSM complement or substitute for SRTM.
- Download: [JAXA EORC](https://www.eorc.jaxa.jp/ALOS/en/dataset/aw3d30/aw3d30_e.htm).

### TanDEM-X DEM

- The TanDEM-X mission mapped the world with radar interferometry at high accuracy.
- A 90 m (3 arc-second) global DEM is available for scientific use through DLR.
- The 12 m and 30 m products are commercial.
- Likely use: reference-grade elevation where DLR's terms permit.
- Download: [DLR EOC](https://geoservice.dlr.de/web/datasets/tandem_x_dem/).

### GMTED2010 (Global Multi-resolution Terrain Elevation Data 2010)

- GMTED2010 is a multi-source mosaic assembled by USGS and NGA.
- It offers 7.5, 15, and 30 arc-second products (~250 m, ~500 m, ~1 km).
- Coverage is global; the 30 arc-second product is complete for the world.
- It is a successor to GTOPO30.
- Likely use: low-resolution global terrain for small-scale maps and modeling.
- Download: [USGS EarthExplorer](https://earthexplorer.usgs.gov/).

### ETOPO 2022

- ETOPO 2022 is a global relief model that includes both land elevation and seafloor bathymetry.
- Resolution is 15 arc-seconds (~450 m).
- It is maintained by NOAA NCEI and updated regularly.
- Likely use: global relief where land and ocean must be consistent.
- Download: [NOAA NCEI](https://www.ncei.noaa.gov/products/etopo-global-relief-model).

### GEBCO

- GEBCO publishes global gridded bathymetry with land elevation from SRTM-derived data.
- The current GEBCO 2024 grid is 15 arc-seconds (~450 m).
- It is the standard reference for seafloor terrain.
- Likely use: ocean-focused projects that also need coastal land.
- Download: [GEBCO](https://www.gebco.net/data_and_products/gridded_bathymetry_data/).

### MERIT DEM

- MERIT DEM removes major errors from SRTM and AW3D30: stripe noise, speckle, and absolute bias.
- Resolution is 3 arc-seconds (~90 m).
- It is a DTM-like product that preserves terrain rather than canopy.
- Likely use: hydrology and terrain analysis where artifacts would distort results.
- Download: [MERIT DEM](https://global-hydrodynamics.github.io/MERIT_DEM/).

### FABDEM

- FABDEM removes forests and buildings from the Copernicus GLO-30 DEM.
- Resolution is 1 arc-second (~30 m).
- It is a DTM-like product suited to flood modeling and bare-earth analysis.
- Likely use: terrain with vegetation and structures removed.
- Download: [OpenTopography](https://portal.opentopography.org/datasetMetadata?otCollectionID=OT.122023.4326.1).

### ArcticDEM and REMA

- ArcticDEM covers all land north of 60 N with 2 m strips and 8 m mosaics.
- REMA (Reference Elevation Model of Antarctica) covers Antarctica at the same scale.
- Both are derived from optical stereo imagery and are produced by the Polar Geospatial Center.
- Likely use: high-resolution polar terrain, ice-sheet and permafrost studies.
- Download: [Polar Geospatial Center](https://www.pgc.umn.edu/guides/stereo-derived-elevation-models/pgc-dem-products-arcticdem-rema-and-earthdem/).

### HydroSHEDS

- HydroSHEDS provides hydrologically conditioned elevation derived from SRTM.
- Products range from 3 arc-seconds (~90 m) to 30 arc-seconds.
- Drainage direction and accumulation layers are included.
- Likely use: watershed delineation and hydrological modeling.
- Download: [HydroSHEDS](https://www.hydrosheds.org/) (WWF).

## Aggregators and Platforms

These services do not create datasets but host, search, and serve many of the above.

- [USGS EarthExplorer](https://earthexplorer.usgs.gov/) — portal for USGS-hosted DEMs.
- [NASA Earthdata Search](https://search.earthdata.nasa.gov/) — portal for NASA-hosted DEMs.
- [OpenTopography](https://opentopography.org/) — high-performance portal and API for many DEMs.
- [AWS Open Data Registry](https://registry.opendata.aws/) — public S3 buckets for SRTM, NASADEM, Copernicus DEM, and others.
- [Google Earth Engine](https://developers.google.com/earth-engine/datasets/) — analysis-ready catalog for NASADEM, SRTM, AW3D30, and more.

## Notes and Caveats

- Arc-second spacing is angular, so ground spacing varies with latitude (smaller at high latitudes).
- DSM versus DTM: SRTM, Copernicus DEM, and AW3D30 are DSMs; bare-earth products like FABDEM and MERIT are DTM-oriented.
- Void handling differs: SRTM v3 fills voids, NASADEM improves them, MERIT masks them.
- All listed datasets use WGS84 horizontal datum; vertical references differ (EGM96 for SRTM/NASADEM, EGM2008 for Copernicus DEM).
- License terms vary and some require registration or a short-form agreement; verify before redistribution.
- This list is not exhaustive; newer or regional datasets may suit specific needs better.
