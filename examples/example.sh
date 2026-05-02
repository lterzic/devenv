#!/usr/bin/env bash

set -euo pipefail

VENV_DIR=".venv"
readonly VENV_DIR

log() {
    local level="$1"
    local message="$2"
    printf '[%s] %s\n' "${level}" "${message}" >&2
}

check_tool() {
    local tool="$1"
    if ! command -v "${tool}" > /dev/null 2>&1; then
        log "ERROR" "Required tool not found: ${tool}"
        return 1
    fi
}

create_venv() {
    if [[ -d "${VENV_DIR}" ]]; then
        log "INFO" "Virtual environment already exists at ${VENV_DIR}"
        return 0
    fi
    log "INFO" "Creating virtual environment at ${VENV_DIR}"
    python3 -m venv "${VENV_DIR}"
}

install_deps() {
    local requirements_file="$1"
    if [[ ! -f "${requirements_file}" ]]; then
        log "ERROR" "Requirements file not found: ${requirements_file}"
        return 1
    fi
    log "INFO" "Installing dependencies from ${requirements_file}"
    "${VENV_DIR}/bin/pip" install --quiet -r "${requirements_file}"
}

main() {
    local requirements="${1:-requirements.txt}"
    check_tool python3
    create_venv
    install_deps "${requirements}"
    log "INFO" "Setup complete"
}

main "$@"
