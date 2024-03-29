#!make
NAME       ?= $(shell basename $(CURDIR))
VERSION		 ?= $(shell cat $(PWD)/.version 2> /dev/null || echo v0)

# Deno commands
DENO    = deno
RUN     = $(DENO) run
TEST    = $(DENO) test
FMT     = $(DENO) fmt
LINT    = $(DENO) lint
DEPS    = $(DENO) info
DOCS    = $(DENO) doc main.ts --json
INSPECT = $(DENO) run --inspect-brk

DENOVERSION = 1.31.1

.PHONY: help clean deno-install install deno-version deno-upgrade check fmt dev env test inspect doc all release

default: help

# show this help
help:
	@make env
	@echo ''
	@echo 'usage: make [target] ...'
	@echo ''
	@echo 'targets:'
	@grep -E '^[a-z.A-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

env: ## environment project
	@echo $(CURDIR)
	@echo $(NAME)
	@echo $(VERSION)

deno-install: ## install deno version
	@$(DENO) upgrade --version $(DENOVERSION)

deno-version: ## deno version
	@$(DENO) --version

deno-upgrade: ## deno upgrade
	@$(DENO) upgrade

check: ## deno check files
	@$(DEPS)
	@$(FMT) --check
	@$(LINT) --unstable

fmt: ## deno format files
	@$(FMT)

dev: ## deno run dev maine
	@$(RUN) --allow-all --unstable --watch main.ts 

test: ## deno run test
	@$(TEST) --coverage=cov_profile

install:
	@$(DENO) install .
	
clean: ## clean bundle and binary
	rm -f main.bundle.js
	rm -fr bin

inspect: ## deno inspect 
	@echo "Open chrome & chrome://inspect"
	$(INSPECT) --allow-all --unstable main.ts

doc: ## deno doc
	@$(DOCS) > docs.json
  
release:
	git tag $(VERSION)
	git push --tags
