.PHONY: install update

install:
	bash "$(CURDIR)/scripts/install.sh"

update:
	git pull --ff-only
