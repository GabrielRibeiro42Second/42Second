.PHONY: install uninstall doctor lint help

SHELL := /bin/bash

TERMOS_HOME ?= $(HOME)/.config/termos

help: ## Show this help
	@echo ""
	@echo "  TermOS"
	@echo "  ──────"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[0;36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

install: ## Install TermOS
	@bash install.sh

uninstall: ## Uninstall TermOS
	@bash uninstall.sh

doctor: ## Check dependencies
	@$(TERMOS_HOME)/bin/termos doctor 2>/dev/null || echo "Run 'make install' first"

lint: ## Run shellcheck on all scripts
	@echo "Running shellcheck..."
	@find src/ bin/ -name "*.sh" -o -name "termos" | xargs shellcheck --severity=warning || true
	@echo "Done."


.PHONY: test test-workspace test-scanner test-filesystem

LUA_PATH := ./src/lua/?.lua;./src/lua/?/init.lua;;

test:
	@LUA_PATH="$(LUA_PATH)" lua tests/run.lua
