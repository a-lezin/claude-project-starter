#!/usr/bin/env bash
# protect-files.sh - runs before every Edit and Write (PreToolUse hook).
# Blocks changes to raw/ (the original sources) and to files that hold secrets.
# Exit code 2 = block the action; the text sent to stderr is shown to Claude.

export LC_ALL=C          # treat text as plain bytes: safe for any language in paths
shopt -s nocasematch     # compare names ignoring upper/lower case

# 1. Take "file_path" out of the JSON that Claude Code sends on stdin (no jq needed).
path=$(sed -nE 's/.*"file_path"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p')

# 2. Spell every path the same way: C:\Users\me\x and C:/Users/me/x -> /C/Users/me/x
norm() {
  local p=${1//\\\\//}                  # JSON-escaped backslashes -> /
  p=${p//\\//}                          # single backslashes -> /
  if [[ $p =~ ^([A-Za-z]):(/.*)$ ]]; then p="/${BASH_REMATCH[1]}${BASH_REMATCH[2]}"; fi
  printf '%s' "${p%/}"
}
path=$(norm "$path")
root=$(norm "${CLAUDE_PROJECT_DIR:-$PWD}")    # the project folder
name=${path##*/}                              # file name without folders

# 3. raw/ is read-only: sources are only read, never edited.
if [[ $path == "$root"/raw/* ]]; then
  echo "Blocked: raw/ holds the user's original sources and is read-only for Claude. Write notes and summaries to wiki/ instead; only the user adds or changes files in raw/." >&2
  exit 2
fi

# 4. Files with secrets: .env, keys, credentials (.env.example is a safe template).
secret=no
case "$name" in
  .env.example) ;;
  .env|.env.*|*.pem|*.p12|*.pfx|id_rsa*|id_ed25519*|credentials.json|client_secret*.json|service-account*.json|token.json) secret=yes ;;
esac
if [[ $path == "$root"/secrets/* ]]; then secret=yes; fi
if [ "$secret" = yes ]; then
  echo "Blocked: $name holds secrets (API keys, passwords), so Claude must not read or change it. Ask the user to edit it by hand; placeholder names without real values belong in .env.example." >&2
  exit 2
fi
exit 0
