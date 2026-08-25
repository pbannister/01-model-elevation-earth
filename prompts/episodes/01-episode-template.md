# Episode Template

- Copy this file into `prompts/episodes/` with the next free number.
- Replace every `<placeholder>` with concrete content.
- Remove the Filled Example section before dispatching the episode.
- Follow `prompts/how-to-write-episodes.md`.

[EPISODE]
<One sentence stating the single goal of the episode.>

[ACCEPTANCE]
- <Is the first criterion satisfied?>
- <Is the second criterion satisfied?>
- <Is the episode reviewable in one sitting?>

[RISK]
- <Riskiest assumption, phrased as a question?>
- <Next riskiest assumption, phrased as a question?>

[SUB-TASKS]
- <One bounded step>.
- <One bounded step>.

[OUTPUT FORMAT]
<The response representation.>

[FILES]
- `<repository-relative path>` — new
- `<repository-relative path>` — existing

[BRANCH]
llm/episode-<number>

## Filled Example

This example shows the sources-survey task as an episode.

It is illustrative; it is not dispatched as-is.

[EPISODE]
Write `documents/00-sources.md`, the list of freely available GDEM dataset sources.

[ACCEPTANCE]
- Does `documents/00-sources.md` list every known free GDEM source?
- Does each entry describe the source's likely use and meaningful attributes?
- Is the diff reviewable in one sitting?

[RISK]
- Are the sources verifiable from the public Internet?
- Does the document avoid invented sources or attributes?

[SUB-TASKS]
- Research freely available GDEM dataset sources.
- Write `documents/00-sources.md`.
- Review the document for accuracy and completeness.
- Run `make test`.

[OUTPUT FORMAT]
Report the created file and the result of `make test`.

[FILES]
- `documents/00-sources.md` — new

[BRANCH]
llm/episode-01
