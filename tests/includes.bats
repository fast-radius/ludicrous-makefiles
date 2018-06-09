#!/usr/bin/env bats
load test_helper

MAKEFILE='
include includes/ludicrous.mk
include includes/_whatever.mk

test1:
	@echo Nothing to see here

plugin_targets:
	@echo "$(PLUGIN_TARGETS)"
'

@test 'ludicrous.mk will define a PLUGIN_TARGETS var' {
  run make -f <(echo "$MAKEFILE") plugin_targets DOWNLOADER=tests/fixtures/bin/curl_200
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
  [[ "${lines[1]}" =~  includes\/%\.mk ]]
}

@test 'ludicrous.mk will attempt to download missing includes' {
  run make -f <(echo "$MAKEFILE") test1 DOWNLOADER=tests/fixtures/bin/curl_200
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
  [[ "${lines[1]}" == "Nothing to see here" ]]
  [[ "${lines[0]}" == *"downloading ludicrous plugin to includes/_whatever.mk"* ]]
}

@test 'ludicrous.mk will error if the include does not exist upstream' {
  run make -f <(echo "$MAKEFILE") test1 DOWNLOADER=tests/fixtures/bin/curl_404
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 2 ]
  [[ "${lines[1]}" =~ _whatever\.mk\ not\ found ]]
  [[ "${lines[3]}" =~ "Error 1" ]]
}

@test 'ludicrous.mk should not attempt to download an already existing include' {
  run make -B -f <(echo "$MAKEFILE") test1 DOWNLOADER=tests/fixtures/bin/curl_200
  __debug "${status}" "${output}" "${lines[@]}"

  [ "${status}" -eq 2 ]
  [[ "${output}" != *"downloading ludicrous plugin to includes/ludicrous.mk"* ]]
  [[ "${output}" == *"downloading ludicrous plugin to includes/_whatever.mk"* ]]
}
