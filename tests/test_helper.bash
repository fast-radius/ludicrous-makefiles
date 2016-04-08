#!/bin/bash
export OLD_PATH=$PATH

unset_term() {
  unset TERM
}

fixtures() {
  export PATH=$PWD/tests/fixtures/$1/bin:$PATH
}

setup() {
  LM_TEMPDIR=$(mktemp -d "${BATS_TMPDIR}/XXXXXXXX")
}

teardown() {
  [ -d $LM_TEMPDIR ] && rm -r $LM_TEMPDIR
  export PATH=$OLD_PATH
}
