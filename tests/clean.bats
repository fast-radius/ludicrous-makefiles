#!/usr/bin/env bats
load test_helper

MAKEFILE="
include includes/ludicrous.mk

clean::
	rm -rf /tmp/__one__.clean /tmp/__two__.clean
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
  __debug "${status}" "${output}" "${lines[@]}"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "rm -rf /tmp/__one__.clean /tmp/__two__.clean" ]
  [ "${lines[1]}" == "mock-rm -rf /tmp/__one__.clean /tmp/__two__.clean" ]
}
