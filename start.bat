@echo off
REM Todo Timeline 应用快速启动脚本
REM 使用方法: start.bat

setlocal enabledelayedexpansion

echo ========================================
echo Todo Timeline 应用快速启动
echo ========================================
echo.

REM 检查 Qt 安装
where qmake >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 Qt。
    echo.
    echo 请按照以下步骤安装 Qt:
    echo 1. 访问 https://www.qt.io/download-qt-installer
    echo 2. 下载并运行 Qt 在线安装程序
    echo 3. 选择 Qt 6.x 版本，确保包含 MinGW 编译器
    echo 4. 安装完成后重新运行此脚本
    echo.
    pause
    exit /b 1
)

REM 检查 CMake 安装
where cmake >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 CMake。
    echo.
    echo 请按照以下步骤安装 CMake:
    echo 1. 访问 https://cmake.org/download/
    echo 2. 下载 Windows 安装程序
    echo 3. 安装时选择 "Add CMake to the system PATH"
    echo 4. 安装完成后重新运行此脚本
    echo.
    pause
    exit /b 1
)

echo [1/4] 检查依赖...
echo ✓ Qt 已安装
echo ✓ CMake 已安装

echo.
echo [2/4] 构建项目...
call build.bat windows
if errorlevel 1 (
    echo [错误] 构建失败！
    pause
    exit /b 1
)

echo.
echo [3/4] 测试构建...
call test.bat
if errorlevel 1 (
    echo [错误] 测试失败！
    pause
    exit /b 1
)

echo.
echo [4/4] 启动应用...
echo.
echo 应用正在启动...
echo.
echo 使用说明:
echo - 左侧是任务列表
echo - 右侧是时间轴视图
echo - 点击 + 按钮添加新任务
echo - 将任务拖到时间轴上安排时间
echo.
echo 数据保存位置: %APPDATA%\TodoApp\tasks.json
echo.
echo 按任意键启动应用...
pause >nul

call run.bat

echo.
echo 应用已关闭。
pause
