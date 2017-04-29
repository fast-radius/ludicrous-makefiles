include includes/ludicrous.mk
include tests/test.mk

#> An exploration of ludicrous makefiles.

#> runs the bats test suite
test:
	$(MAKE) --no-print-directory _test
.PHONY: test
