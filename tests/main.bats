#!/usr/bin/env bats
load test_helper

MAKEFILE="
include includes/ludicrous.mk

test1: | _program_whatever
	@echo you should not see this

test2: | _program_make
	@echo you should most definitly see this

test3: | _var_WHATEVER
	@echo you should not see this

test4: | _var_USER
	@echo you should most definitely see this
"

@test 'ludicrous.mk executes without errors' {
  run make -f includes/ludicrous.mk
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
}

@test 'ludicrous.mk _program_% fails when command is not found' {
  run make -f <(echo "$MAKEFILE") test1
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 2 ]
  [[ "${lines[0]}" =~ "`whatever` command not found" ]]
}

@test 'ludicrous.mk _program_make should find the make command' {
  run make -f <(echo "$MAKEFILE") test2
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "you should most definitly see this" ]
}

@test 'ludicrous.mk _var_% fails when the env var is not defined' {
  run make -f <(echo "$MAKEFILE") test3
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 2 ]
  [[ "${lines[0]}" =~ "`WHATEVER` is a required parameter" ]]
}

@test 'ludicrous.mk _var_USER should not fail' {
  run make -f <(echo "$MAKEFILE") test4
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "you should most definitely see this" ]
}
