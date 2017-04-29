#!/usr/bin/env bats
load test_helper
fixtures help

@test 'ludicrous.mk help target parses a makefile successfully' {
  run make -f ${FIXTURES_ROOT}/Makefile help
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "global help" ]
  echo $output | grep -q "  test1               help for test1"
  echo $output | grep -q "  test2               help for test2"
}

cleanup
