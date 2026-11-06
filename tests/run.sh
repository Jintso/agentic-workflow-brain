#!/usr/bin/env bash
# run.sh — Regression cases for the scripts in scripts/.
#
# A case is a pair of files in tests/<script>/: <case>.sh builds a fixture and
# runs the script on it, and <case>.expected holds what it prints, ending with
# its exit status, with the case's folder written as @ROOT@. The first line of
# <case>.sh says what the case checks.
#
# Each case runs in its own empty temporary folder, which is removed after it,
# with the helpers of tests/lib.sh. Only PATH and TMPDIR are kept from this
# environment: HOME is the case's folder, so ~/ resolves there and git reads no
# configuration of this machine; TZ=UTC and LC_ALL=C. A case reads nothing
# outside its folder and the repo, and needs no network.
#
# Usage:
#   tests/run.sh                        # every case
#   tests/run.sh check-links            # one script's cases
#   tests/run.sh check-links/broken     # one case
#   tests/run.sh --update [<case>...]   # write the .expected files; review with git diff
#
# Exit status: 0 every case passed, 1 a case failed, 2 no case matched.
# Needs bash, diff, find, mktemp, sed, sort, and what the scripts need.

set -u

tests="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
scripts="$(dirname "$tests")/scripts"

update=0
if [ "${1:-}" = --update ]; then update=1; shift; fi

cases=()
while IFS= read -r c; do
  if [ $# -eq 0 ]; then cases+=("$c"); continue; fi
  for sel in "$@"; do
    sel="${sel#tests/}"; sel="${sel%/}"; sel="${sel%.sh}"; sel="${sel%.expected}"
    if [ "$c" = "$sel" ] || [ "${c%%/*}" = "$sel" ]; then cases+=("$c"); break; fi
  done
done < <(cd "$tests" && find . -mindepth 2 -maxdepth 2 -name '*.sh' | sed 's#^\./##; s#\.sh$##' | sort)

if [ ${#cases[@]} -eq 0 ]; then
  echo "No case matches: $*" >&2
  exit 2
fi

run_case() {  # $1 case: print its output, with its folder as @ROOT@
  local dir real out
  dir="$(mktemp -d)" || return 1
  real="$(cd "$dir" && pwd -P)"
  out="$(cd "$dir" && env -i PATH="$PATH" ${TMPDIR:+TMPDIR="$TMPDIR"} HOME="$dir" TZ=UTC LC_ALL=C \
           ROOT="$dir" SCRIPTS="$scripts" \
           bash -euc '. "$1"; . "$2"' case "$tests/lib.sh" "$tests/$1.sh" 2>&1)"
  rm -rf "$dir"
  out="${out//"$real"/@ROOT@}"
  printf '%s\n' "${out//"$dir"/@ROOT@}"
}

pass=0
fail=0
for c in "${cases[@]}"; do
  expected="$tests/$c.expected"
  out="$(run_case "$c")"
  if [ "$update" = 1 ]; then
    printf '%s\n' "$out" > "$expected"
    echo "WROTE  $c"
    continue
  fi
  if [ ! -f "$expected" ]; then
    echo "FAIL   $c: no $c.expected (tests/run.sh --update $c writes it)"
    fail=$((fail + 1))
  elif d="$(diff -u --label expected --label actual "$expected" - <<<"$out")"; then
    echo "PASS   $c"
    pass=$((pass + 1))
  else
    echo "FAIL   $c"
    sed 's/^/       /' <<<"$d"
    fail=$((fail + 1))
  fi
done

[ "$update" = 1 ] && exit 0
echo "$pass passed, $fail failed."
[ "$fail" -eq 0 ]
