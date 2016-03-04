# Provides a dependecy, `bundle`, which runs bundle install when necessary.
# Override bundle install options by setting BUNDLE_INSTALL_OPTS.
BE := bundle exec
BUNDLE_INSTALL_OPTS ?=

Gemfile.lock: Gemfile | _program_bundle
	@bundle check &> /dev/null && \
		$(call _log,rubygems up-to-date) || \
		( $(call _log,installing rubygems); \
		  bundle install $(BUNDLE_INSTALL_OPTS) )

#> installs rubygems
bundle: Gemfile.lock

.PHONY: bundle Gemfile.lock

ifneq (main.mk,$(findstring main.mk,$(MAKEFILE_LIST)))
include $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/main.mk
endif
