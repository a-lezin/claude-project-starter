# Where each fact goes

Create a page only when you have facts for it. The names are defaults: write titles in the user's language, keep file names in lowercase Latin letters.

| Facts about | Page | Typical sections |
|---|---|---|
| The big picture: what the project is, for whom, the main goal | `wiki/overview.md` | Product · Audience · Goal · links to all topic pages |
| The product or service: what it does, pricing, platforms | `wiki/product.md` | What it is · How it earns · What is in progress |
| Clients and audience segments | `wiki/audience.md` | One section per segment |
| Competitors and alternatives | `wiki/competitors.md`. Use one page per competitor in `wiki/competitors/` when 3 or more competitors have their own facts | Who · How we differ |
| Goals and metrics | `wiki/goals.md` | Goal · Metric · Current value · Target · Deadline |
| What was tried and did not work, decisions that were made | `wiki/lessons.md` | What · Result · Why |
| The user's role, typical tasks, team | `wiki/team.md` | Role · Tasks · People |
| Tools and places where information lives | `wiki/tools-and-sources.md` | Tool · What it holds · How to get data from it |
| Questions without an answer | `wiki/open-questions.md` | Question · Who can answer |

Not wiki facts:

- How the assistant must answer (tone, format, language, "always", "never"): propose these as rules for `CLAUDE.md`.
- Passwords, keys, tokens: nowhere. Tell the user.
