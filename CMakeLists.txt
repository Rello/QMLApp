cmake_minimum_required(VERSION 3.21)

project(CloudPanePrototype VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_OSX_DEPLOYMENT_TARGET "13.0" CACHE STRING "Minimum macOS deployment target")

find_package(Qt6 6.5 REQUIRED COMPONENTS
    Core
    Gui
    Qml
    Quick
    QuickControls2
    Widgets
)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(CloudPanePrototype
    MACOSX_BUNDLE
    src/main.cpp
    src/appcontroller.cpp
    src/appcontroller.h
    src/syncactivitymodel.cpp
    src/syncactivitymodel.h
    src/quickactionsmodel.cpp
    src/quickactionsmodel.h
)

qt_add_qml_module(CloudPanePrototype
    URI CloudPane
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/components/FrostedPanel.qml
        qml/components/QuickActionButton.qml
        qml/components/SyncRow.qml
)

target_link_libraries(CloudPanePrototype
    PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::Widgets
)

set_target_properties(CloudPanePrototype PROPERTIES
    OUTPUT_NAME "CloudPane Prototype"
    MACOSX_BUNDLE_BUNDLE_NAME "CloudPane Prototype"
    MACOSX_BUNDLE_GUI_IDENTIFIER "com.rello.cloudpane.prototype"
    MACOSX_BUNDLE_BUNDLE_VERSION "${PROJECT_VERSION}"
    MACOSX_BUNDLE_SHORT_VERSION_STRING "${PROJECT_VERSION}"
    WIN32_EXECUTABLE TRUE
)

install(TARGETS CloudPanePrototype
    BUNDLE DESTINATION .
    RUNTIME DESTINATION bin
)
