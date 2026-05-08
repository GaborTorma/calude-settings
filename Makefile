.PHONY: install link update sync

install:
	bash "$(CURDIR)/scripts/install.sh"

link:
	bash "$(CURDIR)/scripts/install.sh" --no-hook

update:
	bash "$(CURDIR)/scripts/update.sh"

sync:
	bash "$(CURDIR)/scripts/sync.sh"
