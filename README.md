# devenv

Shared linter and formatter configurations for C++, Python, CMake, shell, and general editor hygiene. Drop these files into any project to get consistent style enforcement on every commit.

## Prerequisites

- [pre-commit](https://pre-commit.com/) ≥ 3 (`pip install pre-commit`)
- Python ≥ 3.11 (required by the mypy hook)
- LLVM 18 (`clang-format`, `clang-tidy` — required for C++ hooks)

## Setup

Clone or add this repository as a subdirectory/submodule of your project, then copy the files you need and install the hooks.

### Base setup (all projects)

1. Copy `.pre-commit-config.yaml` and `.editorconfig` to your project root.
2. Install the hooks:

```sh
pip install pre-commit
pre-commit install
```

Hooks will run automatically on every `git commit`.

### C++

1. Copy `cpp/.clang-format` and `cpp/.clang-tidy` to your project root.
2. Generate a compilation database (required by `clang-tidy`):

```sh
cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

The hook expects the file at `build/compile_commands.json`.

#### Excluding files and directories

Git submodules are excluded automatically — pre-commit only runs on files tracked in the current repository.

For checked-in third-party directories (e.g. `third_party/`, `vendor/`), add an `exclude` regex to the clang-tidy hook in `.pre-commit-config.yaml`:

```yaml
- id: clang-tidy
  exclude: ^(third_party|extern|generated)/
```

As a fallback, place a `.clang-tidy` file inside any subdirectory with all checks disabled:

```yaml
# third_party/.clang-tidy
Checks: "-*"
InheritParentConfig: false
```

### Python

1. Copy `python/ruff.toml` and `python/mypy.ini` to your project root.
2. Open `ruff.toml` and set your package name so import ordering works correctly:

```toml
[lint.isort]
known-first-party = ["your_package_name"]
```

### Shell and CMake

No extra files needed — these are handled entirely by `.pre-commit-config.yaml`.

### Venv + pre-commit hook via Makefile

The `Makefile` sets up a project virtualenv and registers the pre-commit git
hook. It works for any project, CMake or not, in two ways:

**Included** from your own Makefile (devenv checked out as a subdirectory or
submodule):

```make
include devenv/Makefile
```

This exposes the `venv` and `pre-commit-install` targets, plus
`$(VENV_PYTHON)`/`$(VENV_PIP)` for your own targets to depend on.

**Called directly**, no Makefile of your own required:

```sh
make -f devenv/Makefile pre-commit-install
```

Either way, `pre-commit-install` creates `.venv` (installing
`requirements.txt` or `python/requirements.txt` if present), installs
`pre-commit` into it, and runs `pre-commit install`. Override `VENV_DIR`,
`PYTHON`, or `REQUIREMENTS` to customize.

## Running manually

Run all hooks against every file (useful for first-time setup or CI):

```sh
pre-commit run --all-files
```

Run a single hook:

```sh
pre-commit run clang-format --all-files
```

## Skipping a hook

Bypass a specific hook for one commit (e.g. when `compile_commands.json` is not yet available):

```sh
SKIP=clang-tidy git commit -m "your message"
```
