#!/bin/bash

# Todo Timeline 应用快速启动脚本
# 使用方法: ./start.sh

echo "========================================"
echo "Todo Timeline 应用快速启动"
echo "========================================"
echo

# 检查 Qt 安装
if ! command -v qmake &> /dev/null; then
    echo "[错误] 未找到 Qt。"
    echo
    echo "请按照以下步骤安装 Qt:"
    echo "1. 运行: sudo apt update"
    echo "2. 运行: sudo apt install qt6-base-dev qt6-declarative-dev qt6-quickcontrols2-dev"
    echo "3. 安装完成后重新运行此脚本"
    echo
    exit 1
fi

# 检查 CMake 安装
if ! command -v cmake &> /dev/null; then
    echo "[错误] 未找到 CMake。"
    echo
    echo "请按照以下步骤安装 CMake:"
    echo "1. 运行: sudo apt update"
    echo "2. 运行: sudo apt install cmake"
    echo "3. 安装完成后重新运行此脚本"
    echo
    exit 1
fi

echo "[1/4] 检查依赖..."
echo "✓ Qt 已安装"
echo "✓ CMake 已安装"

echo
echo "[2/4] 构建项目..."
chmod +x build.sh
./build.sh linux
if [ $? -ne 0 ]; then
    echo "[错误] 构建失败！"
    exit 1
fi

echo
echo "[3/4] 测试构建..."
chmod +x test.sh
./test.sh
if [ $? -ne 0 ]; then
    echo "[错误] 测试失败！"
    exit 1
fi

echo
echo "[4/4] 启动应用..."
echo
echo "应用正在启动..."
echo
echo "使用说明:"
echo "- 左侧是任务列表"
echo "- 右侧是时间轴视图"
echo "- 点击 + 按钮添加新任务"
echo "- 将任务拖到时间轴上安排时间"
echo
echo "数据保存位置: ~/.local/share/TodoApp/tasks.json"
echo
echo "按 Enter 键启动应用..."
read

chmod +x run.sh
./run.sh

echo
echo "应用已关闭。"
