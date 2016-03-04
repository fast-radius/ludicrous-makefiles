#!/usr/bin/env bats

MAKEFILE="
include includes/main.mk
include includes/help.mk

#> global help

#> help for test1
test1:
	@:

#> help for test2
test2:
	@:
"

setup() {
  tempfile=`mktemp /tmp/XXXXXXXX`
  echo "$MAKEFILE" > $tempfile
}

teardown() {
  rm -f $tempfile
}

@test 'help.mk executes without errors' {
  run make -f includes/help.mk
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "Targets:" ]
  [[ "${lines[1]}" =~ "displays this message" ]]
}

@test 'help.mk parses a makefile successfully' {
  run make -f $tempfile help
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "global help" ]
  [ "${lines[2]}" == "  test1        help for test1" ]
  [ "${lines[3]}" == "  test2        help for test2" ]
}
