.DEFAULT_GOAL := Makefile

INCLUDES_DIR := .makefiles
DOWNLOAD_BRANCH := master
DOWNLOAD_URL := https://raw.githubusercontent.com/martinwalsh/ludicrous-makefiles/$(DOWNLOAD_BRANCH)/includes

$(INCLUDES_DIR):
	mkdir -p $(INCLUDES_DIR)

$(INCLUDES_DIR)/ludicrous.mk $(INCLUDES_DIR)/help.awk: | $(INCLUDES_DIR)
	curl -Lso $@ $(DOWNLOAD_URL)/$(notdir $@)

Makefile: | $(INCLUDES_DIR)/ludicrous.mk $(INCLUDES_DIR)/help.awk
	@echo 'include $(INCLUDES_DIR)/ludicrous.mk' > Makefile
