#!/usr/bin/env bats

MAKEFILE="
include includes/zany.mk
include includes/help.mk

#> global help

#> help for test1
test1:
	@:

#> help for test2
test2:
	@:
"

@test 'help.mk executes without errors' {
  run make -f includes/help.mk
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "Targets:" ]
  [[ "${lines[1]}" =~ "displays this message" ]]
}

