@echo off
REM Todo Timeline 应用运行脚本
REM 使用方法: run.bat [模式]
REM 模式选项: debug, release

setlocal enabledelayedexpansion

set BUILD_DIR=build
set MODE=%1

if "%MODE%"=="" set MODE=release

echo ========================================
echo Todo Timeline 应用运行脚本
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

REM 运行应用
echo 正在启动 Todo Timeline 应用...
echo.

if "%MODE%"=="debug" (
    echo 调试模式运行...
    start TodoApp.exe --debug
) else (
    echo 发布模式运行...
    start TodoApp.exe
)

echo 应用已启动！
echo.
echo 提示:
echo - 关闭此窗口不会影响应用运行
echo - 应用数据保存在: %APPDATA%\TodoApp\tasks.json
echo.
pause
