# Create a python virtual environment if it doesn't exist at the
# given path and install requirements if provided.
function(python_create_venv VENV_PATH)
    cmake_parse_arguments(ARG "" "REQUIREMENTS" "" ${ARGN})

    set(VENV_PIP ${VENV_PATH}/bin/pip)

    if(NOT EXISTS ${VENV_PATH})
        # Create the virtual environment
        execute_process(COMMAND python3 -m venv ${VENV_PATH})
        message(STATUS "Created venv at: ${VENV_PATH}")

        # Install the packages if requirements are specified
        if(ARG_REQUIREMENTS)
            message(STATUS "Installing requirements from: ${ARG_REQUIREMENTS}")
            execute_process(COMMAND ${VENV_PIP} install -r ${ARG_REQUIREMENTS})
        endif()
    endif()

    set(Python_ROOT_DIR ${VENV_PATH} PARENT_SCOPE)
    set(Python_FIND_VIRTUALENV ONLY PARENT_SCOPE)
endfunction()

# Create if needed and set the virtual environment as default python used.
macro(python_set_venv VENV_PATH)
    python_create_venv(${VENV_PATH} ${ARGN})
    find_package(Python REQUIRED COMPONENTS Interpreter Development)
endmacro()
