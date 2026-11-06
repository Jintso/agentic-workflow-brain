# lib.sh — Helpers the cases share. run.sh sources it in each case's empty
# folder, with ROOT set to that folder (also HOME) and SCRIPTS to scripts/.

# run <script> [<arg>...]: run scripts/<script>, then print its exit status.
run() {
  local status=0
  "$SCRIPTS/$1" "${@:2}" 2>&1 || status=$?
  echo "exit $status"
}

# brain [<slug>[=<code>]]...: a brain in brain/ that both checkers pass, with
# one product per argument. A product's Code cell is `~/<slug>` unless =<code>
# gives the cell's text. The brain's CLAUDE.md names one path, which exists.
brain() {
  local p slug code
  mkdir -p brain/company brain/products
  printf '# CLAUDE.md\n\nThe products are listed in `products/README.md`.\n' > brain/CLAUDE.md
  printf '# Brain Index\n\n- [Company](company/README.md)\n- [Products](products/README.md)\n' > brain/BRAIN-INDEX.md
  printf '> Part of [Brain Index](../BRAIN-INDEX.md)\n\n# Company\n' > brain/company/README.md
  printf '> Part of [Brain Index](../BRAIN-INDEX.md)\n\n# Products\n\n| Product | Status | Code |\n|---------|--------|------|\n' \
    > brain/products/README.md
  for p in "$@"; do
    slug="${p%%=*}"
    if [ "$p" = "$slug" ]; then code="\`~/$slug\`"; else code="${p#*=}"; fi
    printf '  - [%s](products/%s/README.md)\n' "$slug" "$slug" >> brain/BRAIN-INDEX.md
    printf '| [%s](%s/README.md) | active | %s |\n' "$slug" "$slug" "$code" >> brain/products/README.md
    mkdir -p "brain/products/$slug"
    printf '> Part of [Products](../README.md)\n\n# %s\n\n- [Execution Plan](Execution-Plan.md)\n' "$slug" \
      > "brain/products/$slug/README.md"
    printf '> Part of [%s](README.md)\n\n# Execution Plan\n' "$slug" > "brain/products/$slug/Execution-Plan.md"
  done
}

# repo <dir>: a code repo with src/main.rs and no memory file yet.
repo() {
  mkdir -p "$1/src"
  echo 'fn main() {}' > "$1/src/main.rs"
}

# rec <kind> <time> [<n>]: append a record to the transcript of session s1,
# ~/.claude/projects/p/s1.jsonl, in the shape Claude Code writes it. <time> is
# HH:MM:SS[.mmm] on 2026-11-06, in UTC.
#   prompt <n>    a prompt that starts turn <n> (turnOrigin, turnPosition)
#   prompt-old    a prompt from before turnPosition: turnOrigin only
#   reply         an assistant message
#   close <ms>    the turn_duration record that closes a turn, durationMs <ms>
#   queued        a queue-operation, written as a prompt is queued
#   snapshot      a file-history snapshot, its timestamp nested in it
rec() {
  local t="2026-11-06T$2" f="$HOME/.claude/projects/p/s1.jsonl"
  case "$t" in *.*) ;; *) t="$t.000" ;; esac
  t="${t}Z"
  mkdir -p "${f%/*}"
  case "$1" in
    prompt)     printf '{"type":"user","message":{"role":"user","content":"Go on."},"timestamp":"%s","turnOrigin":"human","turnPosition":{"promptIndex":%s,"turnIndex":%s},"sessionId":"s1"}\n' "$t" "$3" "$3" ;;
    prompt-old) printf '{"type":"user","message":{"role":"user","content":"Go on."},"timestamp":"%s","turnOrigin":"human","sessionId":"s1"}\n' "$t" ;;
    reply)      printf '{"type":"assistant","message":{"role":"assistant","content":[{"type":"text","text":"Done."}]},"timestamp":"%s","sessionId":"s1"}\n' "$t" ;;
    close)      printf '{"type":"system","subtype":"turn_duration","durationMs":%s,"timestamp":"%s","sessionId":"s1"}\n' "$3" "$t" ;;
    queued)     printf '{"type":"queue-operation","operation":"enqueue","timestamp":"%s","sessionId":"s1"}\n' "$t" ;;
    snapshot)   printf '{"type":"file-history-snapshot","messageId":"m1","snapshot":{"messageId":"m1","trackedFileBackups":{},"timestamp":"%s"},"isSnapshotUpdate":false}\n' "$t" ;;
    *)          echo "rec: unknown kind $1" >&2; return 1 ;;
  esac >> "$f"
}

# tool <version>: a small copy of the tool in tool/, a git repo that gets a
# commit and the tag v<version> per call. The first call copies install.sh and
# gives it one command, one script and two templates; a case changes them
# between calls.
tool() {
  if [ ! -d tool ]; then
    mkdir -p tool/.claude/commands tool/scripts tool/templates
    cp "$SCRIPTS/../install.sh" tool/
    echo '# /resume' > tool/.claude/commands/resume.md
    printf '#!/bin/sh\necho checked\n' > tool/scripts/check-links.sh
    printf '# CLAUDE.md\n\n[PLACEHOLDER]\n' > tool/templates/CLAUDE.md
    printf '# Handoff\n' > tool/templates/Handoff-Template.md
    git -c init.defaultBranch=main init -q tool
  fi
  echo "$1" > tool/VERSION
  git -C tool add -A
  git -C tool -c user.name=Test -c user.email=test@example.com commit -q -m "$1"
  git -C tool -c user.name=Test -c user.email=test@example.com tag -a "v$1" -m "$1"
}

# installer [<brain>]: run tool/install.sh on <brain>, by default brain/, then
# print its exit status.
installer() {
  local status=0
  tool/install.sh "${1:-brain}" 2>&1 || status=$?
  echo "exit $status"
}
