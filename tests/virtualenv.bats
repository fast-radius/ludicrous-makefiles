#!/usr/bin/env bats
load test_helper

MAKEFILE="
include ${PWD}/includes/ludicrous.mk
include ${PWD}/includes/virtualenv.mk

test1: virtualenv
	@echo virtualenv target finished
"

REQUIREMENTS=""

setup() {
  unset TERM
  export OLDPATH=$PATH
  tempdir=`mktemp /tmp/XXXXXXXX`
  rm -f $tempdir &&  mkdir $tempdir
  echo "$MAKEFILE" > ${tempdir}/Makefile
  echo "$REQUIREMENTS" > ${tempdir}/requirements.txt
}

teardown() {
  export PATH=$OLDPATH
  #rm -rf $tempdir
  echo $tempdir
}

@test 'virtualenv.mk virtualenv should fail without requirements' {
  run make -f includes/virtualenv.mk virtualenv
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 2 ]
  [[ "${lines[0]}" =~ No\ rule\ to\ make\ target\ [\`\']requirements.txt\' ]]
}

@test 'virtualenv.mk virtualenv' {
  export PATH=${PWD}/tests/fixtures/bin:$PATH
  cd $tempdir && run make test1
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "===> creating virtualenv at .env" ]
  [ "${lines[3]}" == "===> install python dependencies from requirements.txt" ]
}
