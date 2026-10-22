# Record: Adopt the shared rules

## Outcome

This project now pins the shared rules at `2026-10-22.12`. `rules.lock` holds the
version and a SHA-256 per vendored file, `scripts/rules-check.sh` verifies the
copy, and `tests/06-rules-pin.sh` runs it in the suite.

The adoption was `breaking`: the contract gains a non-overridable safety
precedence level, modification becomes authorization-based, and nine capability
conventions apply. Conformance cleared 33 findings, which is the smallest of the
adoptions so far because this project's corpus is small.

## Decisions

- **Host paths left `TASK-FILES`, and that is the significant one.** Two tasks
  authorize downloads into `/datasets/`, a mount point outside the repository
  because the datasets cannot live on the same volume as `/home/`. The validator
  refuses a `TASK-FILES` path that is not repository-relative, and it is right to:
  that table describes the repository's structure, and a table that can name any
  absolute path is not a boundary. The operations are stated in prose in
  `TASK-DESCRIPTION` — "Download the datasets into `/datasets/`", "Create the
  directory `/datasets/dataset-etopo-2022`", "Record the download in
  `/datasets/manifest.yml`" — and contract §3 authorizes a modification the task
  states. The table lost the two rows; the instruction did not lose a word.
- **`datasets.in/` is declared** in `prompts/10-project.md`, with `PHASES.md`. The
  datasets *volume* is deliberately not declared: that mechanism is for repository
  structure, and using it to bless `/datasets/` would defeat the rule above.
- **The feature needed identifiers only.** It already carried `## Purpose`,
  `## Requirements`, `## Behavior` and `## Dependencies`; its 17 existing
  requirement sentences became `SITE-BUILD-R001`–`R017`, unchanged.
- **Two tasks were conformed** to the current format. Neither references a
  feature, so neither gained `TASK-FEATURES`.
- **Deleted `prompts/common/00-overview.md`, `01-requirements.md` and the stale
  `02-universal-rules.md`.** The third is superseded by `01-universal-rules.md`;
  `--prune` cannot remove it on a first adoption, because there is no previous
  lock to compare against.
- **The glossary states the DELTA term and points at contract section 6.**

## Verification

- `rules-conform`: nothing to conform.
- `rules-check`: ok (v2026-10-22.12, 39 files, 0 deviations).
- `make test`: 10 tests, all passed.

## Behavioral evidence

**Not run.** Five of the six eval cases need `scripts/status.sh` or
`scripts/site-state-fetch.sh`; this project has neither, so only
`01-malformed-task-refusal` applies. That is the portability gap recorded in
`00-project-rules/documents/eval-portability.md`, not a defect of this project.

## What this adoption cost the library

**Nothing.** It is the first adopter to require no change to the shared rules:
`00-llm-integration` needed three releases, this one needed none. The portability
work in `.10`–`.12` — the examples, the dependency, the corpus fixture — is what
made this a conformance exercise instead of a library investigation, which is the
signal that the design has stopped moving under the adoptions.

## Commits

- Adoption commit — the vendored rules, conformance, and this record.
