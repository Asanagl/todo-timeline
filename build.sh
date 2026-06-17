#!/bin/bash

# Todo Timeline 应用构建脚本
# 使用方法: ./build.sh [平台]
# 平台选项: windows, android, linux, all

BUILD_DIR="build"
PLATFORM=${1:-"windows"}

echo "========================================"
echo "Todo Timeline 应用构建脚本"
echo "========================================"
echo

# 检查 Qt 安装
if ! command -v qmake &> /dev/null; then
    echo "错误: 未找到 Qt。请确保 Qt 已安装并添加到 PATH。"
    echo "下载地址: https://www.qt.io/download-qt-installer"
    exit 1
fi

# 检查 CMake 安装
if ! command -v cmake &> /dev/null; then
    echo "错误: 未找到 CMake。请确保 CMake 已安装并添加到 PATH。"
    echo "下载地址: https://cmake.org/download/"
    exit 1
fi

# 创建构建目录
mkdir -p "$BUILD_DIR"

build_windows() {
    echo
    echo "[Windows] 构建 Windows 版本..."
    mkdir -p build_windows
    cd build_windows
    cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release ..
    cmake --build . --config Release
    cd ..
    echo "Windows 版本构建完成！"
}

build_linux() {
    echo
    echo "[Linux] 构建 Linux 版本..."
    mkdir -p build_linux
    cd build_linux
    cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ..
    cmake --build . --config Release
    cd ..
    echo "Linux 版本构建完成！可执行文件位于: build_linux/TodoApp"
}

build_android() {
    echo
    echo "[Android] 构建 Android 版本..."
    
    # 检查 Android 环境变量
    if [ -z "$ANDROID_SDK_ROOT" ]; then
        echo "错误: 未设置 ANDROID_SDK_ROOT 环境变量。"
        echo "请设置 Android SDK 路径: export ANDROID_SDK_ROOT=/path/to/android-sdk"
        return 1
    fi
    
    if [ -z "$ANDROID_NDK_ROOT" ]; then
        echo "错误: 未设置 ANDROID_NDK_ROOT 环境变量。"
        echo "请设置 Android NDK 路径: export ANDROID_NDK_ROOT=/path/to/android-ndk"
        return 1
    fi
    
    mkdir -p build_android
    cd build_android
    cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake \
          -DANDROID_ABI=arm64-v8a \
          -DANDROID_BUILD_ABI_arm64-v8a=ON \
          -DCMAKE_BUILD_TYPE=Release \
          -DANDROID_SDK_ROOT=$ANDROID_SDK_ROOT \
          ..
    cmake --build . --config Release
    cd ..
    echo "Android APK 构建完成！"
    echo "APK 文件位于: build_android/android-build/build/outputs/apk/"
}

case $PLATFORM in
    "windows")
        cd "$BUILD_DIR"
        cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release ..
        if [ $? -ne 0 ]; then
            echo "CMake 配置失败！"
            exit 1
        fi
        cmake --build . --config Release
        if [ $? -ne 0 ]; then
            echo "构建失败！"
            exit 1
        fi
        echo "构建完成！可执行文件位于: $BUILD_DIR/TodoApp.exe"
        ;;
    "linux")
        cd "$BUILD_DIR"
        cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ..
        if [ $? -ne 0 ]; then
            echo "CMake 配置失败！"
            exit 1
        fi
        cmake --build . --config Release
        if [ $? -ne 0 ]; then
            echo "构建失败！"
            exit 1
        fi
        echo "Linux 版本构建完成！可执行文件位于: $BUILD_DIR/TodoApp"
        ;;
    "android")
        cd "$BUILD_DIR"
        
        if [ -z "$ANDROID_SDK_ROOT" ]; then
            echo "错误: 未设置 ANDROID_SDK_ROOT 环境变量。"
            exit 1
        fi
        
        if [ -z "$ANDROID_NDK_ROOT" ]; then
            echo "错误: 未设置 ANDROID_NDK_ROOT 环境变量。"
            exit 1
        fi
        
        cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake \
              -DANDROID_ABI=arm64-v8a \
              -DANDROID_BUILD_ABI_arm64-v8a=ON \
              -DCMAKE_BUILD_TYPE=Release \
              -DANDROID_SDK_ROOT=$ANDROID_SDK_ROOT \
              ..
        
        if [ $? -ne 0 ]; then
            echo "CMake 配置失败！"
            exit 1
        fi
        
        cmake --build . --config Release
        if [ $? -ne 0 ]; then
            echo "构建失败！"
            exit 1
        fi
        echo "Android APK 构建完成！"
        ;;
    "all")
        build_windows
        build_linux
        build_android
        echo "所有平台版本构建完成！"
        ;;
    *)
        echo "未知平台: $PLATFORM"
        echo "可用平台: windows, linux, android, all"
        exit 1
        ;;
esac

echo
echo "========================================"
echo "构建完成！"
echo "========================================"
