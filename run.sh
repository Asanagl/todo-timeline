#!/bin/bash

# Todo Timeline 应用运行脚本
# 使用方法: ./run.sh [模式]
# 模式选项: debug, release

BUILD_DIR="build"
MODE=${1:-"release"}

echo "========================================"
echo "Todo Timeline 应用运行脚本"
echo "========================================"
echo

# 检查构建目录
if [ ! -d "$BUILD_DIR" ]; then
    echo "构建目录不存在。请先运行 ./build.sh 构建项目。"
    exit 1
fi

# 进入构建目录
cd "$BUILD_DIR"

# 检查可执行文件
if [ ! -f "TodoApp" ]; then
    echo "可执行文件不存在。请先运行 ./build.sh 构建项目。"
    exit 1
fi

# 运行应用
echo "正在启动 Todo Timeline 应用..."
echo

if [ "$MODE" = "debug" ]; then
    echo "调试模式运行..."
    ./TodoApp --debug
else
    echo "发布模式运行..."
    ./TodoApp
fi

echo
echo "应用已退出。"
