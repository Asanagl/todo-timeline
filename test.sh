#!/bin/bash

# Todo Timeline 应用测试脚本
# 使用方法: ./test.sh

BUILD_DIR="build"

echo "========================================"
echo "Todo Timeline 应用测试脚本"
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

echo "[1/3] 检查可执行文件..."
echo "✓ 可执行文件存在: TodoApp"

echo
echo "[2/3] 检查依赖库..."

# 检查 Qt 依赖库
MISSING_LIBS=""

if ! ldd TodoApp | grep -q "libQt6Core"; then
    MISSING_LIBS="$MISSING_LIBS libQt6Core"
fi

if ! ldd TodoApp | grep -q "libQt6Gui"; then
    MISSING_LIBS="$MISSING_LIBS libQt6Gui"
fi

if ! ldd TodoApp | grep -q "libQt6Qml"; then
    MISSING_LIBS="$MISSING_LIBS libQt6Qml"
fi

if ! ldd TodoApp | grep -q "libQt6Quick"; then
    MISSING_LIBS="$MISSING_LIBS libQt6Quick"
fi

if ! ldd TodoApp | grep -q "libQt6QuickControls2"; then
    MISSING_LIBS="$MISSING_LIBS libQt6QuickControls2"
fi

if [ -z "$MISSING_LIBS" ]; then
    echo "✓ 所有 Qt 依赖库存在"
else
    echo "✗ 缺少以下依赖库:"
    echo "$MISSING_LIBS"
    echo
    echo "请确保 Qt 库已正确安装。"
    exit 1
fi

echo
echo "[3/3] 检查资源文件..."
if [ -f "qml/Main.qml" ]; then
    echo "✓ QML 资源文件存在"
else
    echo "✗ QML 资源文件不存在"
    exit 1
fi

echo
echo "========================================"
echo "测试完成！"
echo "所有检查通过，应用可以正常运行。"
echo "========================================"
echo
echo "运行应用:"
echo "  ./run.sh        - 以发布模式运行"
echo "  ./run.sh debug  - 以调试模式运行"
echo
