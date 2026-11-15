# Wiki log

Append-only journal of wiki operations. New entries go at the bottom.

Entry format: `## [YYYY-MM-DD] ingest|query|lint | Title`, then the list of created and updated pages.

Show the last 5 entries: `grep "^## \[" wiki/log.md | tail -5`
