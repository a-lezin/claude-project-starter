#!/usr/bin/env bash
# check-large-files.sh - runs before every shell command (PreToolUse hook, Bash tool).
# .gitignore cannot filter by size, so before "git add" or "git commit" this hook
# looks for large files that are about to get into git history.
# Exit code 2 = block the command; the text sent to stderr is shown to Claude.

LIMIT_MB=10              # files above this size stay out of git
export LC_ALL=C          # treat text as plain bytes: safe for any language in names

# 1. Take "command" out of the JSON on stdin; only "git add" / "git commit" matter.
cmd=$(sed -nE 's/.*"command"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p')
GIT='git[[:space:]]+(add|commit)([^a-z-]|$)'
[[ $cmd =~ $GIT ]] || exit 0

# 2. In the project folder, measure files that are staged, changed or new
#    (ignored files are skipped, so .gitignore is the way to let a file stay).
cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0
limit=$((LIMIT_MB * 1024 * 1024))
big=$(
  { git diff --cached --name-only --diff-filter=AM --relative -z
    git ls-files --modified --others --exclude-standard -z
  } 2>/dev/null | xargs -0 wc -c -- 2>/dev/null |
  while read -r size name; do
    if [ "$name" != total ] && [ "$size" -gt "$limit" ] 2>/dev/null; then
      echo "  $name ($((size / 1024 / 1024)) MB)"
    fi
  done
)

# 3. Block and say what to do instead.
if [ -n "$big" ]; then
  echo "Blocked: these files are larger than $LIMIT_MB MB and git would keep them in its history forever:" >&2
  echo "$big" >&2
  echo "Keep large files in cloud storage (for example Google Drive), or add them to .gitignore and stop tracking them with 'git rm --cached <file>', then commit again." >&2
  exit 2
fi
exit 0
