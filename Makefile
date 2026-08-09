DEVENV_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

VENV   ?= .venv
PYTHON ?= python3
REQS   ?= requirements.txt

help: ## Display this help screen
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST)

venv: ## Create a python virtual environment
	$(PYTHON) -m venv $(VENV)

reqs: venv ## Install a requirements file into venv
	$(VENV)/bin/pip install -r $(REQS)

pre-commit: venv ## Install pre-commit into the venv and register the git hook
	$(VENV)/bin/pip install --quiet pre-commit
	$(VENV)/bin/python -m pre_commit install

clang: ## Create a symlink for clang format and tidy
	ln -s $(DEVENV_DIR)cpp/.clang-format
	ln -s $(DEVENV_DIR)cpp/.clang-tidy

clean-venv: ## Fully delete the venv
	rm -rf $(VENV)

.PHONY: help venv reqs pre-commit clang clean-venv
