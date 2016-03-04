# The "main" utility functions and helpers useful for the common case. Most
# ludicrous makefiles require this file, so it's sensible to `include` it first.

# Helper target for declaring an external executable as a recipe dependency.
# For example,
#   `my_target: | _program_awk`
# will fail before running the target named `my_target` if the command `awk` is
# not found on the system path.
_program_%: FORCE
	@_=$(or $(shell which $* 2> /dev/null),$(error `$*` command not found. Please install `$*` and try again))

# Helper for safely including other ludicrous makefiles, which must be eval'ed.
# For example,
#   `$(eval $(call import,ludicrous.mk))`
# NOTE: This helper is not intended for external use.
define import
ifneq ($(1),$$(findstring $(1),$$(MAKEFILE_LIST)))
include $$(dir $$(realpath $$(lastword $$(MAKEFILE_LIST))))/$(1).mk
endif
endef

FORCE:
.PHONY: FORCE

# These are particularly useful in most makefiles
$(eval $(call import,log))
$(eval $(call import,help))
