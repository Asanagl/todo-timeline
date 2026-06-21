cmake_minimum_required(VERSION 3.16)

project(TodoApp VERSION 1.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Qt 自动处理
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# 查找 Qt6 包
find_package(Qt6 REQUIRED COMPONENTS Core Quick QuickControls2)

# 源文件
set(SOURCES
    src/main.cpp
    src/taskmanager.cpp
    src/timelinemodel.cpp
    src/logger.cpp
)

# 头文件
set(HEADERS
    src/taskmanager.h
    src/timelinemodel.h
    src/logger.h
)

# QML 文件
set(QML_FILES
    qml/Main.qml
    qml/TaskList.qml
    qml/TaskItem.qml
    qml/Timeline.qml
    qml/TaskCreator.qml
    qml/TaskEditor.qml
    qml/Notification.qml
    qml/DeleteConfirmDialog.qml
    qml/CategoryDialog.qml
)

# 资源文件
set(RESOURCES
    resources.qrc
)

# 创建可执行文件（WIN32 去掉控制台窗口）
qt_add_executable(${PROJECT_NAME} WIN32
    ${SOURCES}
    ${HEADERS}
    ${RESOURCES}
)

# 链接 Qt 库
target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::QuickControls2
)

# Android 特殊配置
if(ANDROID)
    set_target_properties(${PROJECT_NAME} PROPERTIES
        QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
    )
endif()

# 安装配置
include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
