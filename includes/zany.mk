# Utility functions and helpers useful for the common case.
# Most of those zany makefiles require this file, so it's
# sensible to `include` it first.

# Helper target for declaring an external executable as a recipe dependency.
# For example,
#   `my_target: | _program_awk`
# will fail before running the target named `my_target` if the command `awk` is
# not found on the system path.
_program_%: FORCE
	@_=$(or $(shell which $* 2> /dev/null),$(error `$*` command not found. Please install `$*` and try again))

FORCE:
.PHONY: FORCE
