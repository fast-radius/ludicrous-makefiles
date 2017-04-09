.DEFAULT_GOAL := Makefile

INCLUDES_DIR := .makefiles
LUDICROUS_BRANCH := master
LUDICROUS_DOWNLOAD_URL := https://raw.githubusercontent.com/martinwalsh/ludicrous-makefiles/$(LUDICROUS_BRANCH)/includes

$(INCLUDES_DIR):
	mkdir -p $(INCLUDES_DIR)

$(INCLUDES_DIR)/ludicrous.mk $(INCLUDES_DIR)/help.awk: | $(INCLUDES_DIR)
	curl -Lso $@ $(LUDICROUS_DOWNLOAD_URL)/$(notdir $@)

Makefile: | $(INCLUDES_DIR)/ludicrous.mk $(INCLUDES_DIR)/help.awk
	@echo 'include $(INCLUDES_DIR)/ludicrous.mk' > Makefile
