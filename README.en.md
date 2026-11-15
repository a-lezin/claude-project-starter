# Claude Project Starter

[Українська версія](README.md)

A clean starter project for working with Claude Code without programming. Inside: a knowledge base that Claude maintains (an LLM Wiki), an onboarding flow, file protection and an example MCP connection. Clone the project, run `/onboarding` and start working on your product.

## The idea: LLM Wiki

You add sources and ask questions. Claude writes the knowledge base pages, links them and keeps the index current. Knowledge accumulates: a new source updates the pages that already exist. Andrej Karpathy described the pattern: [LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).

| Folder or file | Owner | Content |
|---|---|---|
| `raw/` | you | Sources: documents, reports, exports. Claude only reads them |
| `wiki/` | Claude | Knowledge base pages, `index.md` (catalog), `log.md` (journal) |
| `CLAUDE.md` | shared | Rules: how Claude reads, writes and checks the wiki |
| `artifacts/` | for people | One-pagers, dashboards, reports. Built from the wiki |

## What is inside

```
CLAUDE.md              rules for Claude in this project
AGENTS.md              the same for Codex and other agents: points to CLAUDE.md
raw/                   your sources, read-only
wiki/                  the knowledge base: index.md, log.md, pages
artifacts/             results for people
examples/              a filled example (the Spokly app, in Ukrainian); safe to delete
.claude/
  settings.json        permissions and hooks
  hooks/               3 protection scripts
  skills/onboarding/   the first-run skill
  agents/              the context-sorter agent: sorts sources for the wiki
.mcp.json              project MCP servers (example: Ukrainian legislation)
.gitignore             what stays out of git: secrets, video, archives
.env.example           template for keys
```

## Requirements

- [Claude Code](https://code.claude.com/docs/en/overview).
- Git. On Windows you need [Git for Windows](https://git-scm.com/download/win): without it the hooks cannot start and they block every action.
- [GitHub CLI](https://cli.github.com/) (`gh`), if you keep the project on GitHub.

## Start

### 1. Copy the project

Open Claude Code in the folder where you keep projects and write:

```text
Clone https://github.com/a-lezin/claude-project-starter into the folder my-project and detach the copy from the original repository. Then create a private repository my-project on my GitHub and publish the project there. Show me the list of files first and wait for my OK.
```

The same by hand:

```bash
git clone https://github.com/a-lezin/claude-project-starter.git my-project
cd my-project
git remote remove origin
gh repo create my-project --private --source=. --push
```

Another way: the **Use this template** button on the repository page.

> ⚠️ Your repository must be **private**: `raw/` and `wiki/` will hold your working context.

### 2. Open the project in Claude Code

Run `claude` in the `my-project` folder.

- Confirm that you trust the folder. The hooks do not work without it.
- Claude Code asks about the MCP server `sviy-laws` from `.mcp.json`. Allow it if you need Ukrainian legislation.

### 3. Run the onboarding

```text
/onboarding
```

In 10–15 minutes Claude:

1. Asks 6 questions about the product, your role, goals, competitors and the answer format you prefer.
2. Asks which AI tools you already use and where your information lives.
3. Helps you bring the context in: gives a prompt for the export from ChatGPT, Gemini or claude.ai and asks you to put files into `raw/`.
4. Shows the takeaways, the list of pages and the changes to `CLAUDE.md`. Read them and say "OK".
5. Writes the pages to `wiki/`.

No product of your own? Copy the two files from `examples/raw/` into `raw/` and run `/onboarding` on them.

## Daily work

| What | When | Prompt |
|---|---|---|
| **Question** (query) | any time | `Who is our main audience?` |
| **New source** (ingest) | you put a file into `raw/` | `ingest raw/october-report.pdf` |
| **Keep an answer** | Claude gave a good answer | `Save this answer to the wiki as a page` |
| **Health check** (lint) | weekly | `lint` |

Claude shows the takeaways first and waits for your OK, then writes to the wiki. If the wiki has no answer, Claude says so.

[Obsidian](https://obsidian.md) is a convenient reader for the wiki: open the `wiki/` folder as a vault and look at the Graph view.

## Protection

The project has four safeguards. They need no setup.

| Safeguard | What it does |
|---|---|
| Permissions in `.claude/settings.json` | Forbid Claude to change `raw/` and to read `.env`, key files and the `secrets/` folder |
| Hook `protect-files.sh` | Repeats these bans and explains the reason to Claude |
| Hook `block-dangerous.sh` | Blocks dangerous commands: `rm -rf` on `/`, `~`, `..`, `.git`; `git push --force`; `git reset --hard`; `git clean -f`; `chmod 777`; changes to `raw/` from the terminal; showing or sending secrets |
| Hook `check-large-files.sh` | Stops files over 10 MB before `git add` and `git commit` |

What the protection does **not** cover:

- It is a guardrail, not a sandbox. A Python or Node script, or a `bash -c '…'` command, can get around it.
- The limits apply to Claude only. Finder, Obsidian and git in your own terminal work as usual.
- Secrets are recognized by file name. A key pasted into the chat is not protected: keep keys only in `.env`.
- Bypass permissions mode turns off all confirmations. Do not enable it.

If a hook is broken and blocks everything, run `claude --settings '{"disableAllHooks": true}'` and ask Claude to restore the `.claude/hooks/` folder from git.

## MCP: services at the project level

The `.mcp.json` file connects MCP servers for everyone who works with this project. It is a separate mechanism, not claude.ai connectors.

The example in the file is `sviy-laws`, a reference database of Ukrainian legislation.

1. In Claude Code, type `/mcp`, choose `sviy-laws` and sign in with Google.
2. Ask a question about a law.

If you already have the same connector in claude.ai, the tools appear twice. In that case remove the server from `.mcp.json`.

Add your own server:

```bash
claude mcp add --transport http <name> <url> --scope project
```

Do not put tokens into `.mcp.json`: the file goes to git. Add only servers that you trust.

## The skill and the agent

- **Skill `onboarding`** (`.claude/skills/onboarding/`): the first-run instruction. Call it with `/onboarding` or with the words "collect my context". Run it again when you want to add context from another LLM or new sources.
- **Agent `context-sorter`** (`.claude/agents/context-sorter.md`): a separate worker with its own context. It reads one source and returns a sorting plan: rules, facts by page, open questions. Claude starts one agent per file, in parallel. The agent writes nothing.

They are also samples for your own skills and agents:

```text
/skill-creator create a skill locally in this project: [what it does and when]
Create an agent in this project that [what it does]. It reads data from: [where], read-only.
```

## Git

- `.gitignore` keeps out of git: secrets (`.env`, keys), video, audio, archives, generated PDFs in `artifacts/` and Obsidian settings.
- Images (`png`, `jpg`) do go to git: one-pagers embed them.
- Keep files over 10 MB in cloud storage, or add them to `.gitignore`.
- You do not need to learn git commands. Use plain words: `Save and publish my changes`, `Get my colleagues' changes`.

## Other

- **Codex and other agents** read `AGENTS.md`, which points to `CLAUDE.md`.
- **Plans** from Plan mode are saved in the `plans/` folder.
- **`examples/`** holds a filled example. Delete the folder when you no longer need it.
- **`CLAUDE.md`** is yours: change the rules to fit your work. Keep the file short and free of product facts.

## License

[MIT](LICENSE)
