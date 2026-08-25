# TODO

## Pending

- [ ] download the ETOPO 2022 dataset into `/datasets/`.
      The task is defined in `prompts/tasks/02-download-etopo-2022.md`.
      ETOPO 2022 is chosen over GEBCO because it downloads over plain HTTPS without a license gate.
- [ ] define and implement automated download of the remaining datasets in `datasets.in/datasets-manifest.yml`.
      The task is defined in `prompts/tasks/01-download-datasets-implement.md`.
- [ ] handle voids in the downloaded datasets by filling them from other datasets.
      Deferred: the ETOPO 2022 dataset has no voids, so void handling is not urgent.

## Recently Completed

- [x] enumerate the possible sources of GDEM datasets that are freely available on the Internet.
    - [x] generate a list of possible sources, and their likely use, into a human-consumable file: `documents/01-dataset-sources.md`
    - [x] describe the meaningful attributes of the different source datasets
- [x] document the suitable datasets and the void-handling strategy in `documents/02-datasets-suitable.md`.
- [x] create the datasets manifest at `datasets.in/datasets-manifest.yml` as input for automated download.
- [x] import into this project the template in `~/work/00-project-skeleton`.
      The README referenced `~/work/00-project-template`, which did not exist;
      `00-project-skeleton` was confirmed as the template source.
      The import defined the rules and conventions for all that follows.
- [x] trim the site-build worked example and the C++ flavor from the imported template.
      A data-gathering project does not need a static-site worked example or C++ naming rules.
