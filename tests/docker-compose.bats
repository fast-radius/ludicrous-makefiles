#!/usr/bin/env bats
load test_helper

MAKEFILE="
include ${PWD}/includes/ludicrous.mk
include ${PWD}/includes/docker-compose.mk
"

REQUIREMENTS=""

setup() {
  unset TERM
  export OLDPATH=$PATH
  tempdir=`mktemp /tmp/XXXXXXXX`
  rm -f $tempdir && mkdir $tempdir
  echo "$MAKEFILE" > ${tempdir}/Makefile
}

teardown() {
  export PATH=$OLDPATH
  # __debug "tempdir: $tempdir"
  rm -rf $tempdir
}

@test 'docker-compose.mk build should run docker-compose' {
  export PATH=${PWD}/tests/fixtures/bin:$PATH
  cd $tempdir && run make build
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "mock-touch .docker-compose-build-complete" ]
  [ "${lines[1]}" == "===> building from docker-compose.yml" ]
  [ "${lines[2]}" == "docker-compose -f docker-compose.yml build --pull" ]
  [ "${lines[3]}" == "mock-docker-compose -f docker-compose.yml build --pull" ]
}

@test 'docker-compose.mk build can override docker-compose.yml' {
  export PATH=${PWD}/tests/fixtures/bin:$PATH
  export DOCKER_COMPOSE_FILE=whatever-compose.yml
  cd $tempdir && run make build
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "mock-touch .docker-compose-build-complete" ]
  [ "${lines[1]}" == "===> building from whatever-compose.yml" ]
  [ "${lines[2]}" == "docker-compose -f whatever-compose.yml build --pull" ]
  [ "${lines[3]}" == "mock-docker-compose -f whatever-compose.yml build --pull" ]
}

@test 'docker-compose.mk build can disable --pull' {
  export PATH=${PWD}/tests/fixtures/bin:$PATH
  export DOCKER_COMPOSE_PULL=no
  cd $tempdir && run make build
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
  [ "${lines[2]}" == "docker-compose -f docker-compose.yml build " ]  # trailing whitespace intentional
}

@test 'docker-compose.mk up should run docker-compose' {
  export PATH=${PWD}/tests/fixtures/bin:$PATH
  cd $tempdir && run make up
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
  [ "${lines[5]}" == "docker-compose -f docker-compose.yml up -d" ]
}

@test 'docker-compose.mk up should run docker-compose without -d' {
  export PATH=${PWD}/tests/fixtures/bin:$PATH
  export DOCKER_COMPOSE_DAEMON=no
  cd $tempdir && run make up
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
  [ "${lines[5]}" == "docker-compose -f docker-compose.yml up " ]  # trailing whitespace intentional
}

@test 'docker-compose.mk down should run docker-compose' {
  export PATH=${PWD}/tests/fixtures/bin:$PATH
  cd $tempdir && run make down
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
  [ "${lines[1]}" == "docker-compose -f docker-compose.yml down" ]
}

@test 'docker-compose.mk clean should run docker-compose' {
  export PATH=${PWD}/tests/fixtures/bin:$PATH
  cd $tempdir && run make clean
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
  [ "${lines[1]}" == "docker-compose -f docker-compose.yml down --rmi all --volumes --remove-orphans" ]
  [ "${lines[3]}" == "rm -f .docker-compose-build-complete" ]
}

@test 'docker-compose.mk build should warn about .gitignore' {
  export PATH=${PWD}/tests/fixtures/bin:$PATH
  echo '' > ${tempdir}/.gitignore
  cd $tempdir && run make build
  __debug "${status}" "${output}" "${lines[@]}"

  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "===> WARNING: .docker-compose-build-complete not found in .gitignore" ]
}
