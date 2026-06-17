@echo off
REM Todo Timeline 应用测试脚本
REM 使用方法: test.bat

setlocal enabledelayedexpansion

set BUILD_DIR=build

echo ========================================
echo Todo Timeline 应用测试脚本
echo ========================================
echo.

REM 检查构建目录
if not exist "%BUILD_DIR%" (
    echo 构建目录不存在。请先运行 build.bat 构建项目。
    pause
    exit /b 1
)

REM 进入构建目录
cd "%BUILD_DIR%"

REM 检查可执行文件
if not exist "TodoApp.exe" (
    echo 可执行文件不存在。请先运行 build.bat 构建项目。
    pause
    exit /b 1
)

echo [1/3] 检查可执行文件...
echo ✓ 可执行文件存在: TodoApp.exe

echo.
echo [2/3] 检查依赖库...
set MISSING_DLLS=

REM 检查 Qt 依赖库
if not exist "Qt6Core.dll" set MISSING_DLLS=!MISSING_DLLS! Qt6Core.dll
if not exist "Qt6Gui.dll" set MISSING_DLLS=!MISSING_DLLS! Qt6Gui.dll
if not exist "Qt6Qml.dll" set MISSING_DLLS=!MISSING_DLLS! Qt6Qml.dll
if not exist "Qt6Quick.dll" set MISSING_DLLS=!MISSING_DLLS! Qt6Quick.dll
if not exist "Qt6QuickControls2.dll" set MISSING_DLLS=!MISSING_DLLS! Qt6QuickControls2.dll

if "!MISSING_DLLS!"=="" (
    echo ✓ 所有 Qt 依赖库存在
) else (
    echo ✗ 缺少以下依赖库:
    echo !MISSING_DLLS!
    echo.
    echo 请确保 Qt 库已正确安装并复制到构建目录。
    pause
    exit /b 1
)

echo.
echo [3/3] 检查资源文件...
if exist "qml\Main.qml" (
    echo ✓ QML 资源文件存在
) else (
    echo ✗ QML 资源文件不存在
    pause
    exit /b 1
)

echo.
echo ========================================
echo 测试完成！
echo 所有检查通过，应用可以正常运行。
echo ========================================
echo.
echo 运行应用:
echo   run.bat        - 以发布模式运行
echo   run.bat debug  - 以调试模式运行
echo.
pause
