#!/usr/bin/env bats
MAKEFILE="
include includes/ludicrous.mk

test1: | _program_whatever
	@echo you should not see this

test2: | _program_make
	@echo you should most definitly see this
"

@test 'ludicrous.mk executes without errors' {
  run make -f includes/ludicrous.mk
  [ "$status" -eq 0 ]
}

@test 'ludicrous.mk _program_% fails when command is not found' {
  run make -f <(echo "$MAKEFILE") test1
  [ "$status" -eq 2 ]
  [[ "${lines[0]}" =~ "`whatever` command not found" ]]
}

@test 'ludicrous.mk _program_make should find the make command' {
  run make -f <(echo "$MAKEFILE") test2
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "you should most definitly see this" ]
}
