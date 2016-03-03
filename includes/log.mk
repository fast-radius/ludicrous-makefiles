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
