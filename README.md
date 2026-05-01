# coding-standards

Shared linter and formatter configurations for C++, Python, CMake, shell, and general editor hygiene. Drop these files into any project to get consistent style enforcement enforced automatically on every commit.

## Prerequisites

- [pre-commit](https://pre-commit.com/) ≥ 3 (`pip install pre-commit`)
- Python ≥ 3.11 (required by the mypy hook)
- LLVM 18 (`clang-format`, `clang-tidy` — required for C++ hooks)

## Setup

Clone or add this repository as a subdirectory of your project (e.g. a submodule), then run `make` from inside it:

```sh
# Basic setup — copies .editorconfig and .pre-commit-config.yaml, installs hooks
make install

# With an explicit destination (default: parent directory)
make install DEST=/path/to/my-project

# Reuse an existing virtualenv instead of creating one
make install VENV=/path/to/my-project/.venv

# Copy language-specific configs on top of the base install
make install-cpp
make install-python
```

Hooks will run automatically on every `git commit` in the target project.

### Manual setup

If you prefer not to use Make:

1. Copy `.pre-commit-config.yaml` and `.editorconfig` to your project root.
2. Copy any language-specific config directories you need (`cpp/`, `python/`).
3. Install the hooks:

```sh
pip install pre-commit
pre-commit install
```

## Language configs

### C++

Copy `cpp/.clang-format` and `cpp/.clang-tidy` to your project root.

`clang-tidy` requires a compilation database. If you use CMake, generate it with:

```sh
cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

The hook expects the file at `build/compile_commands.json`.

### Python

Copy `python/ruff.toml` and `python/mypy.ini` to your project root.

Open `ruff.toml` and update `known-first-party` with your package name so import ordering works correctly:

```toml
[lint.isort]
known-first-party = ["your_package_name"]
```

### Shell, CMake, and general hygiene

No extra files needed — these are handled entirely by `.pre-commit-config.yaml`.

## Running manually

To run all hooks against every file (useful for first-time setup or CI):

```sh
pre-commit run --all-files
```

To run a single hook:

```sh
pre-commit run clang-format --all-files
```

## Skipping a hook

To bypass a specific hook for one commit (e.g. when `compile_commands.json` is not yet available):

```sh
SKIP=clang-tidy git commit -m "your message"
```
