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
  [[ "${output}" ==  *"includes/%.mk"* ]]
}

@test 'ludicrous.mk will attempt to download missing includes' {
  run make -f <(echo "$MAKEFILE") test1 DOWNLOADER=tests/fixtures/bin/curl_200
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
  [[ "${output}" == *"downloading ludicrous plugin to includes/_whatever.mk"* ]]
  [[ "${output}" == *"Nothing to see here"* ]]
}

@test 'ludicrous.mk will error if the include does not exist upstream' {
  run make -f <(echo "$MAKEFILE") test1 DOWNLOADER=tests/fixtures/bin/curl_404
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 2 ]
  [[ "${output}" == *"_whatever.mk not found"* ]]
  [[ "${output}" == *"includes/_whatever.mk] Error 1"* ]]
}

@test 'ludicrous.mk should not attempt to download an already existing include' {
  run make -B -f <(echo "$MAKEFILE") test1 DOWNLOADER=tests/fixtures/bin/curl_200
  __debug "${status}" "${output}" "${lines[@]}"

  [ "${status}" -eq 2 ]
  [[ "${output}" != *"downloading ludicrous plugin to includes/ludicrous.mk"* ]]
  [[ "${output}" == *"downloading ludicrous plugin to includes/_whatever.mk"* ]]
}
