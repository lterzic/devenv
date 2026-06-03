function(target_include_directory_prefix TARGET PREFIX VISIBILITY DIR)
    # Prefix relative path without the last entry since the last entry will be the
    # symlink to the original include folder
    get_filename_component(PREFIX_DIR ${PREFIX} DIRECTORY)

    # Create symlinks in the include folder of the current CMake build directory
    set(BUILD_INCLUDE_DIR ${CMAKE_CURRENT_BINARY_DIR}/include)
    set(SYMLINK_PATH ${BUILD_INCLUDE_DIR}/${PREFIX})

    file(MAKE_DIRECTORY ${BUILD_INCLUDE_DIR}/${PREFIX_DIR})
    file(CREATE_LINK ${CMAKE_CURRENT_LIST_DIR}/${DIR} ${SYMLINK_PATH} SYMBOLIC)

    target_include_directories(${TARGET} ${VISIBILITY} ${BUILD_INCLUDE_DIR})
endfunction()