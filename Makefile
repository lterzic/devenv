# Target project root (default: parent directory)
DEST   ?= ..

# Python interpreter used to create a fresh virtualenv
PYTHON ?= python3

# Virtualenv path. Override to reuse an existing env.
VENV   ?= $(DEST)/.venv

# Resolve to absolute paths so cd does not break relative references
_dest      := $(abspath $(DEST))
_venv      := $(abspath $(VENV))
_pip       := $(_venv)/bin/pip
_precommit := $(_venv)/bin/pre-commit

.PHONY: install install-cpp install-python uninstall help

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*##"}; {printf "  %-18s %s\n", $$1, $$2}'

install: $(_precommit) ## Copy core configs and register git hooks in DEST
	cp .editorconfig $(_dest)/.editorconfig
	cp .pre-commit-config.yaml $(_dest)/.pre-commit-config.yaml
	cd $(_dest) && $(_precommit) install
	@echo "Done. Hooks will run automatically on every git commit in $(_dest)."

install-cpp: ## Copy C++ configs (.clang-format, .clang-tidy) to DEST
	cp cpp/.clang-format $(_dest)/.clang-format
	cp cpp/.clang-tidy $(_dest)/.clang-tidy

install-python: ## Copy Python configs to DEST/python/
	cp python/ruff.toml $(_dest)/ruff.toml
	cp python/mypy.ini $(_dest)/mypy.ini
	@echo "Set known-first-party in $(_dest)/ruff.toml to your package name."

uninstall: $(_precommit) ## Uninstall git hooks from DEST (config files are left in place)
	cd $(_dest) && $(_precommit) uninstall

$(_precommit): $(_pip)
	$(_pip) install --quiet pre-commit

$(_pip):
	$(PYTHON) -m venv $(_venv)
