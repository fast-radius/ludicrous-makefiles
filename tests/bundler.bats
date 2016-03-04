#!/usr/bin/env bats
MAKEFILE="
include ${PWD}/includes/main.mk
include ${PWD}/includes/log.mk
include ${PWD}/includes/bundler.mk

test1: bundle
	@echo bundle target finished
"

GEMFILE="
source 'https://rubygems.org'
gem 'gems', '~> 0.8.3'
"

setup() {
  unset TERM
  export OLDPATH=$PATH
  tempdir=`mktemp /tmp/XXXXXXXX`
  rm -f $tempdir &&  mkdir $tempdir
  echo "$MAKEFILE" > ${tempdir}/Makefile
  echo "$GEMFILE" > ${tempdir}/Gemfile
}

teardown() {
  export PATH=$OLDPATH
  rm -rf $tempdir
}

@test 'bundler.mk fails without a Gemfile' {
  run make -f includes/bundler.mk
  [ "$status" -eq 2 ]
  [[ "${lines[0]}" =~ "No rule to make target \`Gemfile', needed by \`Gemfile.lock'" ]]
}

@test 'bundler.mk skips install if bundle check succeeds' {
  export PATH=${PWD}/tests/fixtures/bin:$PATH
  cd $tempdir && run make test1
  cat -vet <(echo ${lines[1]})
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "===> rubygems up-to-date" ]
  [ "${lines[1]}" == "bundle target finished" ]
}

@test 'bundler.mk installs a rubygem if bundle check fails' {
  export PATH=${PWD}/tests/fixtures/bin:$PATH
  export BUNDLE_CHECK_ALWAYS_FAILS=yes
  cd $tempdir && run make test1
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "===> installing rubygems" ]
  [ "${lines[1]}" == "bundle install" ]
  [ "${lines[2]}" == "bundle target finished" ]
}

@test 'bundler.mk installs with options when provided' {
  export PATH=${PWD}/tests/fixtures/bin:$PATH
  export BUNDLE_CHECK_ALWAYS_FAILS=yes
  cd $tempdir && run make test1 BUNDLE_INSTALL_OPTS="--deployment"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "===> installing rubygems" ]
  [ "${lines[1]}" == "bundle install --deployment" ]
  [ "${lines[2]}" == "bundle target finished" ]
}

@test 'bundler.mk runs bundle target even if Gemfile.lock exists' {
  export PATH=${PWD}/tests/fixtures/bin:$PATH
  cd $tempdir && touch Gemfile.lock && run make test1
  echo $status
  echo $output
  [ "$status" -eq 0 ]
  [ -f "${tempdir}/check" ]
}

