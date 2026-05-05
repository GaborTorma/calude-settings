.PHONY: install update sync

install:
	bash "$(CURDIR)/scripts/install.sh"

update:
	bash "$(CURDIR)/scripts/update.sh"

sync:
	bash "$(CURDIR)/scripts/sync.sh"
