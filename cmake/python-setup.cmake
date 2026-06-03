# Automatically sets up the python virtual environment if this is the top
# level project. Requirements file is first looked for in the root and then
# a folder named python. If not found venv is created without requirements.

# Can replace with "NOT DEFINED Python_EXECUTABLE"
if(PROJECT_IS_TOP_LEVEL)
    set(PYTHON_REQ_PATH1 ${CMAKE_CURRENT_SOURCE_DIR}/requirements.txt)
    set(PYTHON_REQ_PATH2 ${CMAKE_CURRENT_SOURCE_DIR}/python/requirements.txt)
    
    if(EXISTS ${PYTHON_REQ_PATH1})
        set(PYTHON_REQUIREMENTS ${PYTHON_REQ_PATH1})
    elseif(EXISTS ${PYTHON_REQ_PATH2})
        set(PYTHON_REQUIREMENTS ${PYTHON_REQ_PATH2})
    endif()

    include(${CMAKE_CURRENT_LIST_DIR}/python-venv.cmake)
    if(DEFINED PYTHON_REQUIREMENTS)
        python_set_venv(${PROJECT_SOURCE_DIR}/.venv REQUIREMENTS ${PYTHON_REQUIREMENTS})
    else()
        python_set_venv(${PROJECT_SOURCE_DIR}/.venv)
    endif()    
endif()
