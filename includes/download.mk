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
