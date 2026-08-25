# Feature: Site Build

## Purpose

The project contains a static-site input directory (`site.in/`) and a generated static-site output directory (`site.out/`).

The Site Build feature provides the scripts that convert `site.in/` into `site.out/` and publish it.

The generated site is a project status and dataset dashboard for the global elevation model dataset.
It is deployed at `https://labs.bannister.us/projects/model-elevation-earth/` following the homelab publishing conventions.

## Requirements

- `scripts/site-build.sh` must generate the static site in `site.out/` from the input in `site.in/`.
- Each `site.in/*.txt` input file must produce `site.out/<name>.html`.
- Generated output must be identified as generated.
- The script must accept optional input and output directory arguments.
- When no arguments are given, the script must use `site.in/` and `site.out/` relative to the repository root.
- The script must be a POSIX shell script.
- The HTML page structure must live in `site.in/template.html`, not in the build script.
- `site.in/template.html` must contain the marker line `<!-- SITE-CONTENT -->` where page content is inserted.
- The site must include a summary page (`index.html`) and a dashboard page (`dashboard.html`).
- The dashboard page may contain `__TOKEN__` placeholders for live state.
- Live state comes from a generated model file written by `scripts/site-state-fetch.sh`.
- The default state file is `dataflow.out/site-state.txt`, overridable with a `SITE_STATE_FILE` environment variable.
- When the state file is present, the build must substitute its `KEY=value` lines for matching `__KEY__` placeholders.
- When the state file is absent, remaining `__KEY__` placeholders must render as `unavailable`, so the build stays portable.
- The site build must not depend on the live system.
- `scripts/site-deploy.sh` must publish `site.out/` to `~/labs.bannister.us/projects/model-elevation-earth/` on the Dreamhost web server using the `bannister.us` SSH alias.
- `scripts/site-deploy.sh` must abort when the site output contains sensitive content: MAC addresses, private LAN IPs, usernames, home paths, or private-key material.

## Behavior

- Running the build script recreates `site.out/` from `site.in/`.
- Re-running the build script overwrites existing output deterministically.
- The summary page renders without any state file.
- Running the deploy script after a build publishes the pages at `https://labs.bannister.us/projects/model-elevation-earth/`.

## Dependencies

- None.
