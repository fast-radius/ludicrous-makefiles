# Generates help text from specialized comments (lines prefixed with a `#>`).
# Free-standing comments are included in the prologue of the help text, while
# those immeditately preceeding a recipe will be displayed along with thier
# respective target names.
#
# Targets: help
#
# Requires: awk
#
# Side effects:
#   * .DEFAULT_GOAL is set to to the `help` target from this file
#
INCLUDES_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
HELP_PROGRAM := $(INCLUDES_DIR)/help.awk

#> displays this message
help: | _program_awk
	@awk -f $(HELP_PROGRAM) $(MAKEFILE_LIST)
.PHONY: help

.DEFAULT_GOAL := help

ifneq (main.mk,$(findstring main.mk,$(MAKEFILE_LIST)))
include $(INCLUDES_DIR)/main.mk
endif
