#!/usr/bin/env bats
load test_helper
unset_term
fixtures bundler

@test 'bundler.mk fails without a Gemfile' {
  run make -f includes/bundler.mk bundle
  [ "$status" -eq 2 ]
  [[ "${lines[0]}" =~ "No rule to make target \`Gemfile', needed by \`Gemfile.lock'" ]]
}

@test 'bundler.mk skips install if bundle check succeeds' {
  cd $FIXTURES_ROOT && run make test1
  cat -vet <(echo ${lines[1]})
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "===> rubygems up-to-date" ]
  [ "${lines[1]}" == "bundle target finished" ]
}

@test 'bundler.mk installs a rubygem if bundle check fails' {
  export BUNDLE_CHECK_ALWAYS_FAILS=yes
  cd $FIXTURES_ROOT && run make test1
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "===> installing rubygems" ]
  [ "${lines[1]}" == "bundle install" ]
  [ "${lines[2]}" == "bundle target finished" ]
}

@test 'bundler.mk installs with options when provided' {
  export BUNDLE_CHECK_ALWAYS_FAILS=yes
  cd $FIXTURES_ROOT && run make test1 BUNDLE_INSTALL_OPTS="--deployment"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "===> installing rubygems" ]
  [ "${lines[1]}" == "bundle install --deployment" ]
  [ "${lines[2]}" == "bundle target finished" ]
}

teardown() {
  cd $FIXTURES_ROOT && rm -f check Gemfile.lock
}

@test 'bundler.mk runs bundle target even if Gemfile.lock exists' {
  cd $FIXTURES_ROOT && touch Gemfile.lock && run make test1
  echo $status
  echo $output
  [ "$status" -eq 0 ]
  [ -f "${FIXTURES_ROOT}/check" ]
}
