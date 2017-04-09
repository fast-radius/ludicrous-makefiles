#!/usr/bin/env bats

MAKEFILE='
include includes/ludicrous.mk

test1:
	$(call download,http://localhost,cat -)

test2:
	$(call download_to,http://localhost,/tmp/nowhere)
'

@test 'ludicrous.mk download callable attempts a download' {
  run make -f <(echo "$MAKEFILE") test1 DOWNLOADER=tests/fixtures/bin/curl
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "tests/fixtures/bin/curl  \"http://localhost\" | cat -" ]
  [ "${lines[1]}" == "http://localhost" ]
  echo ${output}
}

@test 'ludicrous.mk download_to callable attempts a download' {
  run make -f <(echo "$MAKEFILE") test2 DOWNLOADER=tests/fixtures/bin/curl
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "tests/fixtures/bin/curl --write-out \"%{http_code}\" -o /tmp/nowhere \"http://localhost\"" ]
  [ "${lines[1]}" == "--write-out %{http_code} -o /tmp/nowhere http://localhost" ]
}
