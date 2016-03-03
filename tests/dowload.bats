#!/usr/bin/env bats

MAKEFILE='
include includes/download.mk

test1:
	$(call download,http://localhost,cat -)

test2:
	$(call download_to,http://localhost,/tmp/nowhere)
'

@test 'download.mk executes without errors' {
  run make -f includes/download.mk
  [ "$status" -eq 2 ]
  [[ "${lines[0]}" =~ "No targets." ]]
}

@test 'download.mk download callable attempts a download' {
  run make -f <(echo "$MAKEFILE") test1 DOWNLOADER=tests/fixtures/bin/curl
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "tests/fixtures/bin/curl  \"http://localhost\" | cat -" ]
  [ "${lines[1]}" == "http://localhost" ]
}

@test 'download.mk download_to callable attempts a download' {
  run make -f <(echo "$MAKEFILE") test2 DOWNLOADER=tests/fixtures/bin/curl
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "tests/fixtures/bin/curl -o /tmp/nowhere \"http://localhost\"" ]
  [ "${lines[1]}" == "-o /tmp/nowhere http://localhost" ]
}
