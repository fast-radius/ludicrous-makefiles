BATS_VERSION ?= 0.4.0
BATS_TESTS   ?= tests
BATS_OPTS    ?=
BATS_DIR     ?= $(BATS_TESTS)/.bats

BATS_URL     := https://github.com/sstephenson/bats/archive/v$(BATS_VERSION).tar.gz
BATS         := $(BATS_DIR)/bin/bats

_test: $(BATS)
	$(BATS) $(BATS_OPTS) $(BATS_TESTS)
.PHONY: _test

$(BATS_DIR):
	@mkdir -p $@

$(BATS): | $(BATS_DIR)
	$(call download,$(BATS_URL),tar zxf - -C $(BATS_DIR) --strip-components 1)
	@touch $(BATS)

clean::
	rm -rf $(BATS_DIR)
