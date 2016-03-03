# Removes build artifacts contained in the CLEAN env var. Makefiles that include
# this file can simply append to the CLEAN variable, and have their clean-able
# artifacts deleted when `make clean` is run.
#
# By default, the user is prompted to confirm the deletion of files. To disable
# this behavior, set SKIP_CLEAN_PROMPT to yes.
#
# Targets: clean
#
SKIP_CLEAN_PROMPT ?= no

#> remove build artifacts
clean:
ifeq (no,$(SKIP_CLEAN_PROMPT))
	${if $(CLEAN),@echo "The following will be removed: $(CLEAN)"}
	${if $(CLEAN),@read -p "Continue (y/N)? " ANSWER; \
		[ -n "$$(echo $$ANSWER | grep -Ei '^y')" ] && \
		( echo rm -rf $(CLEAN); rm -rf $(CLEAN) ) || \
		  echo "aborted by user"}
else
	$(if $(CLEAN),rm -rf $(CLEAN))
endif

.PHONY: clean
