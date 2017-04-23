#!/usr/bin/env bats
load test_helper
fixtures help

@test 'ludicrous.mk help target parses a makefile successfully' {
  run make -f ${FIXTURES_ROOT}/Makefile help
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "global help" ]
  [ "${lines[2]}" == "  test1               help for test1" ]
  [ "${lines[3]}" == "  test2               help for test2" ]
}

cleanup
