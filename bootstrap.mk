.DEFAULT_GOAL := Makefile

INCLUDES_DIR := .makefiles
DOWNLOAD_URL := https://raw.githubusercontent.com/martinwalsh/ludicrous-makefiles/master/includes/ludicrous.mk

$(INCLUDES_DIR):
	mkdir -p $(INCLUDES_DIR)

$(INCLUDES_DIR)/ludicrous.mk: | $(INCLUDES_DIR)
	curl -Lso $@ $(DOWNLOAD_URL)

Makefile: | $(INCLUDES_DIR)/ludicrous.mk
	@echo 'include $(INCLUDES_DIR)/ludicrous.mk' > Makefile
