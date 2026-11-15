# Working rules for CLAUDE.md

Ask these questions with AskUserQuestion in two sets, 4 questions per call. The user chooses an option or types an answer through "Other". Translate the questions and the options into the user's language.

## Set 1. Language and style

| # | Question | Options | Select |
|---|---|---|---|
| 1 | In which language should I reply? | Ukrainian · English · The language of each message | one |
| 2 | In which language should I write the wiki and the results for people? | The same as my replies · English · I will name the language for each result | one |
| 3 | What answer style do you want? | Short: the conclusion first, then up to 5 bullets · Detailed: with reasoning and examples · Tables and lists where possible · Explain terms: I am new to the topic | several |
| 4 | What tone do you want? | Businesslike, formal «ви» · Simple and friendly, informal «ти» · The same tone as my messages | one |

## Set 2. Scripts and policies

| # | Question | Options | Select |
|---|---|---|---|
| 5 | When a task needs a script, which programming language should I use? | Python (Recommended) · JavaScript (Node.js) · You choose what is already installed · No scripts without asking me first | one |
| 6 | How should I explain scripts? | Comments inside the script in my language · Before the run: what the script reads and what it changes · After the run: what happened, in plain words · I read code: keep explanations short | several |
| 7 | Which actions need your OK every time? | Sending anything outside: email, message, post · Deleting or overwriting files · Installing software or packages · Publishing to GitHub | several |
| 8 | What must not leave this project? | Personal data of clients or employees · Financial figures · Internal documents and contracts · Nothing special | several |

Then ask one open question in plain text: "Is there any other rule that I must always follow? For example a company policy, a brand rule or a forbidden topic." Continue if the user says no.

## How to write the answers into CLAUDE.md

- Questions 1 and 2: rewrite the `## Language` section. Keep the sentence about English technical terms.
- Questions 3–8 and the open question: rewrite the bullets of the `## Working agreements` section. Keep one bullet per topic:

```markdown
## Working agreements

- **Answer style:** <from question 3>
- **Tone:** <from question 4>
- **Scripts and code:** <language from question 5>. <explanation rules from question 6>
- **Confirm first:** <actions from question 7>
- **Sensitive data:** <from question 8>
- **Other rules:** <from the open question; omit this bullet if there are none>
```

- Write the rules in English, as short imperative sentences. Keep the user's own terms and names as they are.
- A skipped question keeps the default text that is already in the section.
- If a rule from a source (for example an export from another LLM) disagrees with an answer here, the answer here wins. Show the difference to the user in the review step.
- Do not put product facts here. Facts go to the wiki.
