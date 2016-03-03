#!/usr/bin/env bats

MAKEFILE="
include includes/clean.mk

CLEAN += /tmp/__one__.clean /tmp/__two__.clean
"

setup() {
  export PATH=tests/fixtures/bin:$PATH
  export SKIP_CLEAN_PROMPT=yes
}

@test 'clean.mk executes default target with nothing to do' {
  run make -f includes/clean.mk
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ "Nothing to be done for \`clean'." ]]
}

@test 'clean.mk clean attempts to cleanup the contents of CLEAN' {
  run make -f <(echo "$MAKEFILE") clean
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "rm -rf /tmp/__one__.clean /tmp/__two__.clean" ]
  [ "${lines[1]}" == "mock-rm -rf /tmp/__one__.clean /tmp/__two__.clean" ]
}
