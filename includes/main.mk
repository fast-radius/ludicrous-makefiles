# The "main" utility functions and helpers useful for the common case. Most
# ludicrous makefiles require this file, so it's sensible to `include` it first.

# Generates help text from specialized comments (lines prefixed with a `#>`).
# Free-standing comments are included in the prologue of the help text, while
# those immediately preceding a recipe will be displayed along with their
# respective target names
#
# Targets: help
# Requires: awk
# Side effects:
#   * .DEFAULT_GOAL is set to to the `help` target from this file
INCLUDES_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
HELP_PROGRAM := $(INCLUDES_DIR)/help.awk

#> displays this message
help: | _program_awk
	@awk -f $(HELP_PROGRAM) $(MAKEFILE_LIST)
.PHONY: help

.DEFAULT_GOAL := help

# Helper target for declaring an external executable as a recipe dependency.
# For example,
#   `my_target: | _program_awk`
# will fail before running the target named `my_target` if the command `awk` is
# not found on the system path.
_program_%: FORCE
	@_=$(or $(shell which $* 2> /dev/null),$(error `$*` command not found. Please install `$*` and try again))

# The defult build dir, if we have only one it'll be easier to cleanup
BUILD_DIR =: build

$(BUILD_DIR):
	mkdir -p $@

# text manipulation helpers
_awk_case = $(shell echo | awk '{ print $(1)("$(2)") }')
lc = $(call _awk_case,tolower,$(1))
uc = $(call _awk_case,toupper,$(1))

# Useful for forcing targets to build when .PHONY doesn't help
FORCE:
.PHONY: FORCE

# Provides two callables, `log` and `_log`, to facilitate consistent
# user-defined output, formatted using tput when available.
#
# Override TPUT_PREFIX to alter the formatting.
TPUT        := $(shell which tput 2> /dev/null)
TPUT_PREFIX := $(TPUT) bold
TPUT_SUFFIX := $(TPUT) sgr0

ifeq (,$(and $(TPUT),$(TERM)))

define _log
echo "===> $(1)"
endef

else

define _log
$(TPUT_PREFIX); echo "===> $(1)"; $(TPUT_SUFFIX)
endef

endif

define log
	@$(_log)
endef

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
clean::
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

# Provides callables `download` and `download_to`.
# * `download`: fetches a url `$(1)` piping it to a command specified in `$(2)`.
#   Usage: `$(call download,$(URL),tar -xf - -C /tmp/dest)`
#
# * `download_to`: fetches a url `$(1)` and writes it to a local path specified in `$(2)`.
#   Usage: `$(call download_to,$(URL),/tmp/dest)`
#
# If the curl command is found on the system path it will be used first, followed by wget.
# If niether curl nor wget is found an error is raised when either of the callables is used.
#
# Additional command line parameters may be passed to curl or wget via CURL_OPTS
# or WGET_OPTS, respectively. For example, `CURL_OPTS += -s`.
#
CURL_OPTS     ?= -L
WGET_OPTS     ?=

ifneq ($(shell which curl 2> /dev/null),)
DOWNLOADER         = curl $(CURL_OPTS)
DOWNLOAD_FLAGS    :=
DOWNLOAD_TO_FLAGS := -o
else
ifneq ($(shell which wget 2> /dev/null),)
DOWNLOADER         = wget $(WGET_OPTS)
DOWNLOAD_FLAGS    := -O -
DOWNLOAD_TO_FLAGS := -O
else
NO_DOWNLOADER_FOUND := Unable to locate a suitable download utility (curl or wget)
endif
endif

define download
	$(if $(NO_DOWNLOADER_FOUND),$(error $(NO_DOWNLOADER_FOUND)),$(DOWNLOADER) $(DOWNLOAD_FLAGS) "$(1)" | $(2))
endef

define download_to
	$(if $(NO_DOWNLOADER_FOUND),$(error $(NO_DOWNLOADER_FOUND)),$(DOWNLOADER) $(DOWNLOAD_TO_FLAGS) $(2) "$(1)")
endef

# Provides variables useful for determining the operating system we're running
# on.
#
# OS_NAME will reflect the name of the operating system: Darwin, Linux or Windows
# OS_CPU will be either x86 (32bit) or amd64 (64bit)
# OS_ARCH will be either i686 (32bit) or x86_64 (64bit)
#
ifeq (Windows_NT,$(OS))
OS_NAME := Windows
OS_CPU  := $(call _lower,$(PROCESSOR_ARCHITECTURE))
OS_ARCH := $(if $(findstring amd64,$(OS_CPU)),x86_64,i686)
else
OS_NAME := $(shell uname -s)
OS_ARCH := $(shell uname -m)
OS_CPU  := $(if $(findstring 64,$(OS_ARCH)),amd64,x86)
endif

ifneq (main.mk,$(findstring main.mk,$(MAKEFILE_LIST)))
include $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/main.mk
endif
