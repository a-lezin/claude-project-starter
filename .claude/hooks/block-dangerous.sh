#!/usr/bin/env bash
# block-dangerous.sh - runs before every shell command (PreToolUse hook, Bash tool).
# Blocks a short list of commands that destroy work, change raw/ or reveal secrets.
# Exit code 2 = block the command; the text sent to stderr is shown to Claude.

export LC_ALL=C          # treat text as plain bytes: safe for any language
shopt -s nocasematch     # patterns ignore upper/lower case

# 1. Take "command" out of the JSON on stdin (no jq needed) and undo JSON escaping.
cmd=$(sed -nE 's/.*"command"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p')
cmd=${cmd//\\\\/$'\001'}; cmd=${cmd//\\n/$'\n'}; cmd=${cmd//\\t/ }
cmd=${cmd//\\\"/\"}; cmd=${cmd//$'\001'/\\}

# 2. Make paths inside the project relative: /Users/me/project/raw/a.pdf -> raw/a.pdf
root=$(cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null && pwd)
for r in "$root" "$CLAUDE_PROJECT_DIR" "${CLAUDE_PROJECT_DIR//\\//}"; do
  [ -n "$r" ] && cmd=${cmd//"$r"[\/\\]/}
done
cmd=${cmd//.env.example/}            # the template has no real keys: ignore it
cmd=${cmd//[;&|()\`]/$'\n'}          # split "a && b | c" into one command per line

# 3. Building blocks for the patterns below.
RAW='(.* )?(\.[/\\])?raw([/\\]| |$)'          # a path that points into raw/
ENV='(.*[^a-z0-9_])?\.env(\.[a-z0-9_-]+)*'    # .env, .env.local, ...
SKIP='^(sudo|then|do|else|time|exec|command) '
WRITE='rm|rmdir|mv|unlink|truncate|shred|touch|mkdir|chmod|chown|ln|tee|curl|wget|remove-item|move-item|rename-item|set-content|add-content|out-file|del|ren'
SHOW='cat|less|more|head|tail|nl|tac|bat|strings|xxd|od|base64|type|get-content|gc|curl|wget|nc|scp|sftp|rsync|ftp|iwr|irm|git add'
M_RAW="this command would change raw/, which holds the user's original sources and is read-only for Claude. Read from raw/ and write results to wiki/ or artifacts/; only the user adds, renames or deletes files in raw/."
M_ENV="this command would show, send or overwrite secrets (.env, API keys, tokens). Never print secrets into the chat: load them with 'set -a; source .env; set +a', or ask the user to check the value."

deny() { if [[ $c =~ $1 ]]; then echo "Blocked: $2" >&2; exit 2; fi; }   # deny PATTERN MESSAGE

# 4. Test every simple command against the rules.
while IFS= read -r line; do
  line=${line//[\"\']/}                             # drop quotes
  read -r -a words <<< "$line"; c="${words[*]}"     # trim and squeeze spaces
  while [[ $c =~ $SKIP ]]; do c=${c#* }; done       # skip "sudo", "then", "do" ...
  deny '^rm (.* )?(-[a-z]*r[a-z]*|--recursive)( .*)? (/|~|\$home|\$\{home\}|\.\.[^ ]*|\.|\*|\.git)/?\*?( |$)' "'rm -r' on /, ~, .., .git or the whole current folder deletes far more than one task needs and cannot be undone. Delete one specific folder or file inside the project instead, for example: rm -rf artifacts/tmp"
  deny '^git push( .*)? (--force|-f)( |$)' "'git push --force' overwrites the history on GitHub and cannot be undone. Use 'git pull' and merge instead; if history really must be rewritten, ask the user first and use --force-with-lease."
  deny '^git reset( .*)? --hard( |$)' "'git reset --hard' throws away all uncommitted changes and cannot be undone. Use 'git stash' to set them aside, or ask the user which files to restore."
  deny '^git clean( .*)? (-[a-z]*f[a-z]*|--force)( |$)' "'git clean -f' permanently deletes files that are not in git yet, such as new sources in raw/. Run 'git clean -n' to list them and let the user decide."
  deny '^chmod( -[a-z]+)* 0?777( |$)' "'chmod 777' lets any user or program change these files. Use 644 for documents and 755 for folders or scripts."
  deny "^($WRITE) $RAW" "$M_RAW"
  [[ $c != *--cached* ]] && deny "^git (rm|mv) $RAW" "$M_RAW"
  deny '^(cp|rsync|install|copy-item|copy|xcopy) .* (\.[/\\])?raw([/\\][^ ]*)?$' "$M_RAW"
  deny '>>? ?(\.[/\\])?raw[/\\]' "$M_RAW"
  deny '^(sed|perl) (.* )?(-[a-z]*i[^ ]*|--in-place[^ ]*) (.* )?(\.[/\\])?raw[/\\]' "$M_RAW"
  deny "^($SHOW) $ENV([^a-z0-9_.-]|\$)" "$M_ENV"
  deny "^(grep|egrep|fgrep|rg|awk|sed|cut|sort|select-string) $ENV\$" "$M_ENV"
  deny ">>? ?([^ ]*[^a-z0-9_ ])?\.env(\.[a-z0-9_-]+)*( |\$)" "$M_ENV"
  deny '^(echo|printf|write-host|write-output) .*\$\{?(env:)?[a-z0-9_]*(_key|_token|_secret|_password|_passwd|apikey)\}?([^a-z0-9_]|$)' "$M_ENV"
  deny '^(printenv|env)( [a-z0-9_]*(key|token|secret|passw)[a-z0-9_]*)?$' "$M_ENV"
done <<< "$cmd"
exit 0
