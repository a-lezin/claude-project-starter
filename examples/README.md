# examples/

Заповнений приклад на застосунку Spokly. Він показує, який вигляд має проєкт після онбордингу. Публічні факти про продукт справжні; метрики й цілі **змодельовані для демо**.

| Тека | Що там |
|---|---|
| `raw/context_raw.md` | Сирий контекст продукту: документ, який користувач кладе в `raw/` |
| `raw/chatgpt-memory.md` | Експорт пам'яті з ChatGPT: результат промпта з `.claude/skills/onboarding/references/llm-export-prompt.md` |
| `wiki/` | База знань, яку Claude зібрав із цих двох джерел і з відповідей інтерв'ю |

## Що онбординг змінив у `CLAUDE.md`

Факти пішли у wiki. Відповіді на питання про правила роботи і правила поведінки з експорту ChatGPT Claude записав у `CLAUDE.md`:

```markdown
You are my assistant for work on **Spokly**: …

## Language

Reply in Ukrainian. Write wiki pages and results for people in the same language as my replies. …

## Working agreements

- **Answer style:** short. Start with the conclusion in one sentence, then give up to 5 bullets. No long introductions. Never open with filler such as «Звісно!» or «Чудове питання!». Show metrics with one digit after the decimal point; do not round them to whole numbers.
- **Tone:** simple and friendly, informal «ти».
- **Scripts and code:** I am not a developer. Write a script only when a task needs one. Use Python. Write comments inside the script in Ukrainian. Before you run a script, say what it reads and what it changes.
- **Confirm first:** ask for my OK before you send anything outside the project (email, message, post), delete or overwrite files, or publish to GitHub.
- **Sensitive data:** personal data of clients and employees must not leave this project. Do not send it to external services.
- **Other rules:** always write the name Spokly in Latin letters. Write for adults, never for schoolchildren. When you analyze competitors, compare their prices and paywalls.
```

Claude також позначив розбіжності між джерелами: дивіться `⚠️ Conflict` у `wiki/competitors.md`, `wiki/channels.md`, `wiki/audience.md` і `wiki/goals.md`. Усі вони зібрані у `wiki/open-questions.md`.

## Claude цю теку не читає

Правило в `CLAUDE.md` і заборона `Read(/examples/**)` у `.claude/settings.json` закривають теку для Claude. Так контекст чужого продукту не змішується з вашим. Переглядайте приклад самі: у редакторі або на GitHub.

## Як спробувати онбординг на прикладі

Робіть це в окремій копії проєкту, щоб дані Spokly не потрапили у вашу wiki.

1. Самі скопіюйте обидва файли з `examples/raw/` у `raw/`.
2. Запустіть `/onboarding` і відповідайте від імені команди Spokly.
3. Порівняйте отриману `wiki/` з `examples/wiki/`.

## Коли приклад більше не потрібен

Видаліть теку `examples/`. Проєкт працює без неї.
