include includes/ludicrous.mk
include tests/test.mk

#> An exploration of ludicrous makefiles.

#> runs the bats test suite
test:
	$(MAKE) --no-print-directory _test
.PHONY: test


BOOTSTRAP_URL := https://raw.githubusercontent.com/martinwalsh/ludicrous-makefiles/$(VERSION)/bootstrap.mk

ifeq (Darwin,$(OS_NAME))
INPLACE := -i ''
else
INPLACE := -i''
endif


README.md: | _var_VERSION
	CODE=$$(curl -s -i https://git.io -F "url=$(BOOTSTRAP_URL)" | grep Location | cut -d'/' -f4 | tr -d '\r'); \
		 sed $(INPLACE) -E -e "s/git.io\/([a-zA-Z0-9]+)\)/git.io\/$${CODE})  # release: $(VERSION)/g" README.md


_tag: | _var_VERSION
	make --no-print-directory -B README.md
	git commit -am "Tagging release $(VERSION)"
	git tag -a $(VERSION) $(if $(NOTES),-m '$(NOTES)',-m $(VERSION))
.PHONY: _tag


_push: | _var_VERSION
	git push origin $(VERSION)
	git push origin master
.PHONY: _push


#> tag and release to github
release: | _var_VERSION
	@if ! git diff --quiet HEAD; then \
		( $(call _error,refusing to release with uncommitted changes) ; exit 1 ); \
	fi
	make --no-print-directory _tag VERSION=$(VERSION)
	make --no-print-directory _push VERSION=$(VERSION)
