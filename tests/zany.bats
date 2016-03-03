#!/usr/bin/env bats
MAKEFILE="
include includes/zany.mk

test1: | _program_whatever
	@echo you should not see this

test2: | _program_make
	@echo you should most definitly see this
"

@test 'zany.mk executes without errors' {
  run make -f includes/zany.mk
  [ "$status" -eq 0 ]
}

@test 'zany.mk _program_% fails when command is not found' {
  run make -f <(echo "$MAKEFILE") test1
  [ "$status" -eq 2 ]
  [[ "${lines[0]}" =~ "`whatever` command not found" ]]
}

@test 'zany.mk _program_make should find the make command' {
  run make -f <(echo "$MAKEFILE") test2
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "you should most definitly see this" ]
}
