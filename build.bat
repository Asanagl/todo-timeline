@echo off
REM Todo Timeline 应用构建脚本
REM 使用方法: build.bat [平台]
REM 平台选项: windows, android, linux, all

setlocal enabledelayedexpansion

set BUILD_DIR=build
set PLATFORM=%1

if "%PLATFORM%"=="" set PLATFORM=windows

echo ========================================
echo Todo Timeline 应用构建脚本
echo ========================================
echo.

REM 检查 Qt 安装
where qmake >nul 2>&1
if errorlevel 1 (
    echo 错误: 未找到 Qt。请确保 Qt 已安装并添加到 PATH。
    echo 下载地址: https://www.qt.io/download-qt-installer
    pause
    exit /b 1
)

REM 检查 CMake 安装
where cmake >nul 2>&1
if errorlevel 1 (
    echo 错误: 未找到 CMake。请确保 CMake 已安装并添加到 PATH。
    echo 下载地址: https://cmake.org/download/
    pause
    exit /b 1
)

REM 创建构建目录
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

if "%PLATFORM%"=="windows" (
    echo 构建 Windows 版本...
    cd "%BUILD_DIR%"
    cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release ..
    if errorlevel 1 (
        echo CMake 配置失败！
        pause
        exit /b 1
    )
    cmake --build . --config Release
    if errorlevel 1 (
        echo 构建失败！
        pause
        exit /b 1
    )
    echo 构建完成！可执行文件位于: %BUILD_DIR%\TodoApp.exe
)

if "%PLATFORM%"=="android" (
    echo 构建 Android 版本...
    echo 注意: Android 构建需要 Android SDK 和 NDK。
    echo 请确保已设置 ANDROID_SDK_ROOT 和 ANDROID_NDK_ROOT 环境变量。
    echo.
    echo 正在使用 Qt 的 Android 构建工具...
    
    cd "%BUILD_DIR%"
    cmake -DCMAKE_TOOLCHAIN_FILE=%ANDROID_NDK_ROOT%/build/cmake/android.toolchain.cmake ^
          -DANDROID_ABI=arm64-v8a ^
          -DANDROID_BUILD_ABI_arm64-v8a=ON ^
          -DCMAKE_BUILD_TYPE=Release ^
          -DANDROID_SDK_ROOT=%ANDROID_SDK_ROOT% ^
          ..
    
    if errorlevel 1 (
        echo CMake 配置失败！请检查 Android SDK 和 NDK 配置。
        pause
        exit /b 1
    )
    
    cmake --build . --config Release
    if errorlevel 1 (
        echo 构建失败！
        pause
        exit /b 1
    )
    
    echo Android APK 构建完成！
    echo APK 文件位于: %BUILD_DIR%\android-build\build\outputs\apk\
)

if "%PLATFORM%"=="linux" (
    echo 构建 Linux 版本...
    cd "%BUILD_DIR%"
    cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ..
    if errorlevel 1 (
        echo CMake 配置失败！
        pause
        exit /b 1
    )
    cmake --build . --config Release
    if errorlevel 1 (
        echo 构建失败！
        pause
        exit /b 1
    )
    echo Linux 版本构建完成！可执行文件位于: %BUILD_DIR%/TodoApp
)

if "%PLATFORM%"=="all" (
    echo 构建所有平台版本...
    
    REM 构建 Windows 版本
    call :build_windows
    
    REM 构建 Linux 版本
    call :build_linux
    
    REM 构建 Android 版本
    call :build_android
    
    echo 所有平台版本构建完成！
)

cd ..
echo.
echo ========================================
echo 构建完成！
echo ========================================
pause
exit /b 0

:build_windows
echo.
echo [1/3] 构建 Windows 版本...
if not exist "build_windows" mkdir "build_windows"
cd "build_windows"
cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --config Release
cd ..
goto :eof

:build_linux
echo.
echo [2/3] 构建 Linux 版本...
if not exist "build_linux" mkdir "build_linux"
cd "build_linux"
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --config Release
cd ..
goto :eof

:build_android
echo.
echo [3/3] 构建 Android 版本...
if not exist "build_android" mkdir "build_android"
cd "build_android"
cmake -DCMAKE_TOOLCHAIN_FILE=%ANDROID_NDK_ROOT%/build/cmake/android.toolchain.cmake ^
      -DANDROID_ABI=arm64-v8a ^
      -DANDROID_BUILD_ABI_arm64-v8a=ON ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DANDROID_SDK_ROOT=%ANDROID_SDK_ROOT% ^
      ..
cmake --build . --config Release
cd ..
goto :eof
