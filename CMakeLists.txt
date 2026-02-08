cmake_minimum_required(VERSION 3.15)
project(bochi_browser LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Disable CEF test apps
set(CEF_BUILD_TESTS OFF CACHE BOOL "Disable CEF tests" FORCE)

# CEF root
set(CEF_ROOT "${CMAKE_SOURCE_DIR}/third_party/cef")

# Add CEF
add_subdirectory(${CEF_ROOT} ${CMAKE_BINARY_DIR}/cef)

# Bochi executable
add_executable(bochi
    app/main.mm
    app/browser_app.h
    app/browser_client.h
)

# macOS frameworks required for Objective-C++
target_link_libraries(bochi
    libcef_dll_wrapper
    "-framework Cocoa"
    "-framework Foundation"
)

target_include_directories(bochi PRIVATE
    ${CEF_ROOT}
)

# Link against the CEF wrapper (REQUIRED)
target_link_libraries(bochi
    libcef_dll_wrapper
)

# macOS app bundle
set_target_properties(bochi PROPERTIES
    MACOSX_BUNDLE TRUE
)

