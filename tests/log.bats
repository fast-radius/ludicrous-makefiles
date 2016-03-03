#!/usr/bin/env bats

MAKEFILE='
include includes/log.mk

test1:
	$(call log,the test1 target)

test2:
	$(call _log,the test2 target)
'

@test 'log.mk executes and has no targets' {
  run make -f includes/log.mk
  [ "$status" -eq 2 ]
  [[ "${lines[0]}" =~ "No targets." ]]
}

@test 'log.mk log callable produces sensible output with TERM set' {
  export TERM=xterm
  run make -f <(echo "$MAKEFILE") test1
  [ "$status" -eq 0 ]
  [ "$(cat -vet <(echo $output))" == "^[[1m===> the test1 target ^[(B^[[m$" ]
}

@test 'log.mk _log callable produces sensible output with TERM set' {
  export TERM=xterm
  run make -f <(echo "$MAKEFILE") test2
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "/usr/bin/tput bold; echo \"===> the test2 target\"; /usr/bin/tput sgr0" ]
  [ "$(cat -vet <(echo ${lines[1]}))" == "^[[1m===> the test2 target$" ]
  [ "$(cat -vet <(echo ${lines[2]}))" == "^[(B^[[m$" ]
}

@test 'log.mk log callable produces sensible output without TERM' {
  unset TERM
  run make -f <(echo "$MAKEFILE") test1
  [ "$status" -eq 0 ]
  [ "$(cat -vet <(echo ${lines[0]}))" == "===> the test1 target$" ]
}

@test 'log.mk _log callable produces sensible output without TERM' {
  unset TERM
  run make -f <(echo "$MAKEFILE") test2
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "echo \"===> the test2 target\"" ]
  [ "$(cat -vet <(echo ${lines[1]}))" == "===> the test2 target$" ]
  [ "${lines[2]}" == "" ]
}

