# Episode Template

- Copy this file into `prompts/episodes/` with the next free number.
- Replace every `<placeholder>` with concrete content.
- Remove the Filled Example section before dispatching the episode.
- Follow `prompts/how-to-write-episodes.md`.

## EPISODE-GOAL
* One sentence stating the single goal of the episode.

## EPISODE-ACCEPTANCE
- Is the first criterion satisfied?
- Is the second criterion satisfied?
- Is the episode reviewable in one sitting?

## EPISODE-RISKS
- Riskiest assumption, phrased as a question?
- Next riskiest assumption, phrased as a question?

## EPISODE-TASKS
- One bounded step.
- One bounded step.

## EPISODE-OUTPUT
* The response representation.

## EPISODE-FILES
- `<repository-relative path>` — new
- `<repository-relative path>` — existing

## EPISODE-BRANCH
llm/episode-{number}

# Filled Example

This example shows the sources-survey task as an episode.

It is illustrative; it is not dispatched as-is.

## EPISODE-GOAL
Write `documents/01-dataset-sources.md`, the list of freely available GDEM dataset sources.

## EPISODE-ACCEPTANCE
- Does `documents/01-dataset-sources.md` list every known free GDEM source?
- Does each entry describe the source's likely use and meaningful attributes?
- Is the diff reviewable in one sitting?

## EPISODE-RISKS
- Are the sources verifiable from the public Internet?
- Does the document avoid invented sources or attributes?

## EPISODE-TASKS
- Research freely available GDEM dataset sources.
- Write `documents/01-dataset-sources.md`.
- Review the document for accuracy and completeness.
- Run `make test`.

## EPISODE-OUTPUT
Report the created file and the result of `make test`.

## EPISODE-FILES
- `documents/01-dataset-sources.md` — new

## EPISODE-BRANCH
llm/episode-01
