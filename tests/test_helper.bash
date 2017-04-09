#!/bin/bash
export OLD_PATH=$PATH

unset_term() {
  unset TERM
}

fixtures() {
  export FIXTURES_ROOT="$BATS_TEST_DIRNAME/fixtures/$1"
  export PATH=$FIXTURES_ROOT/bin:$PATH
}

cleanup() {
  export PATH=$OLD_PATH
}
