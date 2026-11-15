# examples/

Заповнений приклад на застосунку Spokly. Він показує, який вигляд має проєкт після онбордингу. Публічні факти про продукт справжні; метрики й цілі **змодельовані для демо**.

| Тека | Що там |
|---|---|
| `raw/context_raw.md` | Сирий контекст продукту: документ, який користувач кладе в `raw/` |
| `raw/chatgpt-memory.md` | Експорт пам'яті з ChatGPT: результат промпта з `.claude/skills/onboarding/references/llm-export-prompt.md` |
| `wiki/` | База знань, яку Claude зібрав із цих двох джерел і з відповідей інтерв'ю |

## Що онбординг змінив у `CLAUDE.md`

Факти пішли у wiki, а правила поведінки з джерел Claude запропонував додати в `CLAUDE.md`:

```markdown
You are my assistant for work on **Spokly**: …

## Answer style

- Start with the conclusion in one sentence. Then give at most 5 bullets. No long introductions.
- Do not open with filler phrases such as «Звісно!» or «Чудове питання!». Go straight to the point.
- Show metrics with one digit after the decimal point. Do not round them to whole numbers.
- Write for adults. Do not write for schoolchildren.
- When you analyze competitors, compare their prices and paywalls.
```

Claude також позначив розбіжності між джерелами: дивіться `⚠️ Conflict` у `wiki/competitors.md`, `wiki/audience.md` і `wiki/goals.md`.

## Як спробувати

1. Скопіюйте обидва файли з `examples/raw/` у `raw/`.
2. Запустіть `/onboarding` і відповідайте від імені команди Spokly.
3. Порівняйте свою `wiki/` з `examples/wiki/`.

## Коли приклад більше не потрібен

Видаліть теку `examples/`. Claude не використовує її як джерело: це записано в `CLAUDE.md`.
