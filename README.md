# Todo Timeline - 跨平台任务管理应用

一个基于 Qt6/C++ 的跨平台任务管理应用，支持 Windows、Android 和 Linux。

## 功能特性

- ✅ 任务管理：添加、删除、编辑任务
- ✅ 时间轴视图：直观显示任务安排
- ✅ 拖拽功能：将任务拖到时间轴上安排时间
- ✅ 优先级设置：低/中/高优先级
- ✅ 颜色标记：自定义任务颜色
- ✅ 本地存储：JSON 格式保存数据
- ✅ 动画效果：流畅的 UI 动画
- ✅ 跨平台支持：Windows、Android、Linux

## 系统要求

### Windows
- Qt 6.0 或更高版本
- MinGW 或 MSVC 编译器
- CMake 3.16 或更高版本

### Linux
- Qt 6.0 或更高版本
- GCC/G++ 编译器
- CMake 3.16 或更高版本

### Android
- Qt 6.0 或更高版本（带 Android 支持）
- Android SDK (API 21+)
- Android NDK
- CMake 3.16 或更高版本

## 安装依赖

### Windows

1. 安装 Qt：
   - 下载 Qt 在线安装程序：https://www.qt.io/download-qt-installer
   - 选择 Qt 6.x 版本，确保包含 MinGW 编译器
   - 安装过程中确保勾选 "Qt 6.x for Desktop development"

2. 安装 CMake：
   - 下载地址：https://cmake.org/download/
   - 安装时选择 "Add CMake to the system PATH"

### Linux (Ubuntu/Debian)

```bash
# 安装 Qt6
sudo apt update
sudo apt install qt6-base-dev qt6-declarative-dev qt6-quickcontrols2-dev

# 安装编译工具
sudo apt install build-essential cmake

# 安装 Android 开发工具（可选）
sudo apt install android-sdk android-ndk
```

### Android 开发环境

1. 安装 Android Studio：https://developer.android.com/studio
2. 安装 Android SDK (API 21+)
3. 安装 Android NDK
4. 设置环境变量：
   - `ANDROID_SDK_ROOT`：Android SDK 路径
   - `ANDROID_NDK_ROOT`：Android NDK 路径

## 构建项目

### Windows

```bash
# 使用构建脚本
build.bat windows

# 或者手动构建
mkdir build
cd build
cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --config Release
```

### Linux

```bash
# 使用构建脚本
chmod +x build.sh
./build.sh linux

# 或者手动构建
mkdir build
cd build
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --config Release
```

### Android

```bash
# 设置环境变量
export ANDROID_SDK_ROOT=/path/to/android-sdk
export ANDROID_NDK_ROOT=/path/to/android-ndk

# 使用构建脚本
./build.sh android

# 或者手动构建
mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake \
      -DANDROID_ABI=arm64-v8a \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_SDK_ROOT=$ANDROID_SDK_ROOT \
      ..
cmake --build . --config Release
```

## 项目结构

```
todo-qt/
├── CMakeLists.txt          # CMake 配置文件
├── resources.qrc           # Qt 资源文件
├── build.bat               # Windows 构建脚本
├── build.sh                # Linux 构建脚本
├── README.md               # 本文件
├── src/
│   ├── main.cpp            # 应用入口
│   ├── taskmanager.h/cpp   # 任务管理器
│   └── timelinemodel.h/cpp # 时间轴模型
├── qml/
│   ├── Main.qml            # 主界面
│   ├── TaskList.qml        # 任务列表组件
│   ├── TaskItem.qml        # 任务项组件
│   ├── Timeline.qml        # 时间轴组件
│   ├── TaskCreator.qml     # 任务创建对话框
│   └── Notification.qml    # 通知组件
└── android/
    └── AndroidManifest.xml # Android 配置文件
```

## 使用说明

### 添加任务
1. 点击左上角的 "+" 按钮
2. 输入任务标题和描述
3. 选择优先级和颜色
4. 点击 "创建任务"

### 安排任务到时间轴
1. 在任务列表中找到要安排的任务
2. 将任务拖拽到右侧时间轴的对应时间段
3. 任务会自动安排到该时间段

### 编辑任务
1. 点击任务项右侧的编辑按钮
2. 修改任务信息
3. 保存更改

### 删除任务
1. 点击任务项右侧的删除按钮
2. 确认删除

## 动画效果

应用包含以下动画效果：
- 任务添加/删除动画
- 任务完成动画
- 时间轴滚动动画
- 对话框打开/关闭动画
- 按钮悬停动画
- 当前时间指示器脉冲动画

## 数据存储

任务数据以 JSON 格式保存在用户应用数据目录：
- Windows: `%APPDATA%/TodoApp/tasks.json`
- Linux: `~/.local/share/TodoApp/tasks.json`
- Android: 应用私有存储目录

## 自定义配置

### 修改主题颜色
编辑 `qml/Main.qml` 中的 Material 主题配置：
```qml
Material.theme: Material.Light
Material.accent: Material.Blue
```

### 修改时间轴显示
编辑 `qml/Timeline.qml` 中的时间轴配置：
```qml
property int hourHeight: 80  // 每小时的高度
```

## 故障排除

### 构建失败
1. 确保 Qt 和 CMake 已正确安装并添加到 PATH
2. 检查 Qt 版本是否为 6.0 或更高
3. 确保编译器已正确配置

### Android 构建失败
1. 检查 ANDROID_SDK_ROOT 和 ANDROID_NDK_ROOT 环境变量
2. 确保 Android SDK API 版本为 21 或更高
3. 检查 Android NDK 版本是否与 Qt 兼容

### 运行时错误
1. 确保所有 Qt 依赖库已正确安装
2. 检查系统是否支持 OpenGL（某些功能需要）
3. 查看控制台输出的错误信息

## 开发计划

- [ ] 任务分类功能
- [ ] 任务提醒功能
- [ ] 多日视图
- [ ] 数据同步功能
- [ ] 主题切换功能
- [ ] 快捷键支持
- [ ] 任务模板功能

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！

## 联系方式

如有问题或建议，请提交 Issue 或联系开发者。
