#!/usr/bin/env bats
MAKEFILE="
include includes/main.mk

test1: | _program_whatever
	@echo you should not see this

test2: | _program_make
	@echo you should most definitly see this
"

@test 'main.mk executes without errors' {
  run make -f includes/main.mk
  [ "$status" -eq 0 ]
}

@test 'main.mk _program_% fails when command is not found' {
  run make -f <(echo "$MAKEFILE") test1
  [ "$status" -eq 2 ]
  [[ "${lines[0]}" =~ "`whatever` command not found" ]]
}

@test 'main.mk _program_make should find the make command' {
  run make -f <(echo "$MAKEFILE") test2
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "you should most definitly see this" ]
}
