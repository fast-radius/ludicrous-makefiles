#!/usr/bin/env bats

MAKEFILE="
include includes/ludicrous.mk

CLEAN += /tmp/__one__.clean /tmp/__two__.clean
"

setup() {
  export OLDPATH=$PATH
  export PATH=tests/fixtures/bin:$PATH
  export SKIP_CLEAN_PROMPT=yes
}

teardown() {
  export PATH=$OLDPATH
}

@test 'ludicrous.mk clean attempts to cleanup the contents of CLEAN' {
  run make -f <(echo "$MAKEFILE") clean
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "rm -rf /tmp/__one__.clean /tmp/__two__.clean" ]
  [ "${lines[1]}" == "mock-rm -rf /tmp/__one__.clean /tmp/__two__.clean" ]
}
