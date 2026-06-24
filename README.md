# Todo Timeline - 跨平台任务管理应用

一个基于 Qt6/C++ 的跨平台任务管理应用，采用 Qt Quick/QML 构建现代化 UI，支持 Windows、Linux 与 Android。

- **当前版本**：1.3.0
- **Qt 版本**：6.8.0（推荐），最低 6.5
- **C++ 标准**：C++17
- **构建工具**：CMake 3.16+

## 功能特性

- **任务管理**：添加、编辑、删除、完成任务
- **时间轴视图**：24 小时时间轴，直观安排与查看任务
- **任务分类**：自定义分类（名称 + 颜色），按分类筛选任务
- **任务提醒**：设置提醒时间，到期触发通知
- **搜索过滤**：实时按标题/描述搜索任务
- **优先级**：低 / 中 / 高三级优先级
- **颜色标记**：为任务与分类自定义颜色
- **数据持久化**：本地 JSON 存储，自动保存/加载
- **导入/导出**：支持任务数据的 JSON 导入与导出
- **主题切换**：浅色 / 深色模式
- **自定义配色**：6 套预设主题 + 完整调色板自定义（主色调、辅助色、成功/警告/危险色等 9 种颜色）
- **亚克力材质**：导航栏、任务卡片、对话框、时间轴头部的半透明模糊效果
- **透明度调整**：0-100% 透明度滑块，实时预览亚克力效果
- **动画效果**：任务增删、完成、对话框、按钮悬停等流畅动画
- **跨平台支持**：Windows（MinGW/MSVC）、Linux（GCC）、Android

## 系统要求

### Windows
- Qt 6.8.0（推荐）或更高版本
- MinGW 13.1 64-bit 或 MSVC 2022 64-bit
- CMake 3.16+

### Linux（Ubuntu/Debian 示例）
- Qt 6.8.0（推荐）或更高版本
- GCC/G++ 编译器
- CMake 3.16+
- 以下开发库：
  ```bash
  sudo apt-get install -y build-essential cmake libgl1-mesa-dev libegl1-mesa-dev \
    libxkbcommon-dev libfontconfig1-dev libfreetype-dev libx11-dev libx11-xcb-dev \
    libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev libxcb-cursor-dev \
    libxcb-glx0-dev libxcb-keysyms1-dev libxcb-image0-dev libxcb-shm0-dev \
    libxcb-icccm4-dev libxcb-sync-dev libxcb-xfixes0-dev libxcb-shape0-dev \
    libxcb-randr0-dev libxcb-render-util0-dev libxcb-util-dev libxcb-xinerama0-dev \
    libxcb-xkb-dev libxkbcommon-x11-dev
  ```

### Android
- Qt 6.6.3（当前 CI 使用版本）
- Android SDK（API 34）
- Android NDK
- CMake 3.16+

## 安装依赖

### Windows

1. 安装 Qt：
   - 下载 Qt 在线安装程序：https://www.qt.io/download-qt-installer
   - 选择 Qt 6.8.0，安装 MinGW 13.1 64-bit 或 MSVC 2022 64-bit 组件
   - 确保勾选 Qt 5 Compatibility Module（如需要）与 Qt Quick Controls

2. 安装 CMake：
   - 下载地址：https://cmake.org/download/
   - 安装时选择 "Add CMake to the system PATH"

### Linux

```bash
sudo apt update
sudo apt install -y qt6-base-dev qt6-declarative-dev cmake build-essential \
  libgl1-mesa-dev libegl1-mesa-dev libxkbcommon-dev libfontconfig1-dev \
  libfreetype-dev libx11-dev libx11-xcb-dev libxext-dev libxfixes-dev \
  libxi-dev libxrender-dev libxcb1-dev libxcb-cursor-dev libxcb-glx0-dev \
  libxcb-keysyms1-dev libxcb-image0-dev libxcb-shm0-dev libxcb-icccm4-dev \
  libxcb-sync-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-randr0-dev \
  libxcb-render-util0-dev libxcb-util-dev libxcb-xinerama0-dev \
  libxcb-xkb-dev libxkbcommon-x11-dev
```

### Android 开发环境

1. 安装 Android Studio：https://developer.android.com/studio
2. 安装 Android SDK（API 34）
3. 安装 Android NDK
4. 设置环境变量：
   - `ANDROID_SDK_ROOT`：Android SDK 路径
   - `ANDROID_NDK_ROOT`：Android NDK 路径

## 构建项目

### 使用脚本（推荐）

#### Windows

```powershell
# 构建 Windows 版本（默认）
./build.bat windows

# 构建 Linux 版本（交叉编译环境）
./build.bat linux

# 构建 Android 版本
./build.bat android
```

#### Linux

```bash
# 构建 Linux 版本（默认）
chmod +x build.sh
./build.sh linux

# 构建 Windows 版本（交叉编译环境）
./build.sh windows

# 构建 Android 版本
./build.sh android
```

### 手动构建

#### Windows（MinGW）

```powershell
$env:PATH = "C:\Qt\6.8.0\mingw_64\bin;C:\Qt\Tools\mingw1310_64\bin;" + $env:PATH
cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release -S . -B build
cmake --build build --config Release -j4
```

#### Linux

```bash
export PATH="/path/to/Qt/6.8.0/gcc_64/bin:$PATH"
cmake -DCMAKE_BUILD_TYPE=Release -S . -B build
cmake --build build --config Release -j4
```

#### Android

```bash
export QT_ROOT=/path/to/Qt/6.6.3/android_arm64_v8a
export QT_HOST_PATH=/path/to/Qt/6.6.3/gcc_64
export ANDROID_SDK_ROOT=/path/to/android-sdk

cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=$QT_ROOT/lib/cmake/Qt6/qt.toolchain.cmake \
  -DQT_ANDROID_ABIS=arm64-v8a \
  -DQT_HOST_PATH=$QT_HOST_PATH \
  -DCMAKE_BUILD_TYPE=Release \
  -DANDROID_SDK_ROOT=$ANDROID_SDK_ROOT \
  -DQT_ANDROID_TARGET_SDK_VERSION=34 \
  -DQT_ANDROID_BUILD_TOOLS_REVISION=34.0.0

cmake --build build --config Release
```

## 运行与验证

### 运行应用

#### Windows

```powershell
# 运行发布版本
./run.bat

# 运行调试版本（带控制台输出）
./run.bat debug
```

#### Linux

```bash
# 运行发布版本
./run.sh

# 运行调试版本
./run.sh debug
```

### 测试脚本

构建完成后，可运行测试脚本检查依赖与资源文件：

```powershell
# Windows
./test.bat

# Linux
./test.sh
```

### 自动化截图验证

使用 `capture_ui.py` 可自动生成 8 张界面截图并验证 UI：

```powershell
python capture_ui.py
```

## 项目结构

```
todo-qt/
├── CMakeLists.txt              # CMake 配置
├── resources.qrc               # Qt 资源文件
├── build.bat / build.sh        # 构建脚本
├── run.bat / run.sh            # 运行脚本
├── test.bat / test.sh          # 测试脚本
├── capture_ui.py               # 自动化截图脚本
├── .qmllint.ini                # QML 静态检查配置
├── src/
│   ├── main.cpp                # 应用入口（字体、样式、上下文）
│   ├── taskmanager.h/.cpp      # 任务/分类管理、持久化、缓存
│   ├── timelinemodel.h/.cpp    # 时间轴模型
│   └── logger.h/.cpp           # 日志系统
├── qml/
│   ├── Main.qml                # 主界面
│   ├── AppConstants.js         # 全局样式常量
│   ├── TaskList.qml            # 任务列表
│   ├── TaskItem.qml            # 任务项卡片
│   ├── Timeline.qml            # 时间轴
│   ├── TaskCreator.qml         # 创建任务对话框
│   ├── TaskEditor.qml          # 编辑任务对话框
│   ├── CategoryDialog.qml      # 分类管理对话框
│   ├── DeleteConfirmDialog.qml # 删除确认对话框
│   ├── Notification.qml        # 提醒通知
│   ├── PriorityButton.qml      # 优先级选择按钮
│   ├── ColorCircle.qml         # 颜色选择器
│   ├── ColorCircleSmall.qml    # 小型颜色选择器
│   ├── AcrylicPanel.qml        # 亚克力材质面板组件
│   └── ThemeSettingsDialog.qml # 主题设置对话框
├── icons/                      # SVG 图标资源
├── android/                    # Android 配置文件
└── .github/workflows/          # GitHub Actions CI/CD
```

## 使用说明

### 添加任务
1. 点击左上角的 "+" 按钮
2. 输入任务标题与描述
3. 选择优先级、颜色与分类
4. 可选：设置提醒时间
5. 点击 "创建任务"

### 安排任务到时间轴
1. 在任务列表中右键/操作任务，设置开始与结束时间
2. 或在时间轴对应小时点击安排

### 编辑任务
1. 点击任务项右侧的编辑按钮
2. 修改任务信息
3. 保存更改

### 删除任务
1. 点击任务项右侧的删除按钮
2. 确认删除

### 管理分类
1. 打开分类管理对话框
2. 添加、编辑或删除分类
3. 任务可按分类筛选

### 搜索任务
- 在搜索框中输入关键词，任务列表会实时过滤

### 切换主题
- 应用支持浅色/深色模式切换
- `Ctrl+T` 打开主题设置对话框，可选择预设主题或自定义配色
- 支持调整亚克力效果的透明度（0-100%）

## 数据存储

任务与分类数据以 JSON 格式保存在用户应用数据目录：

- **Windows**：`%APPDATA%/TodoApp/tasks.json`、`%APPDATA%/TodoApp/categories.json`
- **Linux**：`~/.local/share/TodoApp/tasks.json`、`~/.local/share/TodoApp/categories.json`
- **Android**：应用私有存储目录

### 沙箱/测试模式

在自动化测试或受限环境中，可通过环境变量覆盖数据目录：

```powershell
$env:TODO_APP_DATA_DIR = "C:\path\to\test_data"
./run.bat
```

启用后，应用会自动设置 `QStandardPaths::setTestModeEnabled(true)`，避免写入系统路径。

## 自定义配置

### 修改主题与样式

- 运行时通过 `Ctrl+T` 打开主题设置对话框进行可视化配置
- 主题设置（配色、亚克力效果、透明度）通过 QSettings 持久化存储
- 编辑 `qml/AppConstants.js` 调整间距、圆角、字体等全局样式常量

### 修改全局字体

编辑 `src/main.cpp` 中的 `defaultFont.setFamilies({...})`：

```cpp
defaultFont.setFamilies({"MiSans", "JetBrains Mono", "Microsoft YaHei", "Segoe UI"});
```

### 修改时间轴显示

编辑 `qml/Timeline.qml` 中的时间轴配置。

## GitHub Actions CI

项目已配置 GitHub Actions 自动构建：

- **build-windows**：Windows + Qt 6.8.0 + MSVC 2022
- **build-linux**：Ubuntu + Qt 6.8.0 + GCC
- **build-android**：Ubuntu + Qt 6.6.3 + Android SDK 34

运行状态：[https://github.com/Asanagl/todo-timeline/actions](https://github.com/Asanagl/todo-timeline/actions)

## 故障排除

### 构建失败
1. 确保 Qt 和 CMake 已正确安装并添加到 PATH
2. 检查 Qt 版本是否为 6.5 或更高（推荐 6.8.0）
3. 确保编译器与 Qt 构建套件匹配（MinGW/MSVC）
4. Linux 用户请确认已安装所有 X11/XCB 开发库

### Android 构建失败
1. 检查 `ANDROID_SDK_ROOT` 和 `ANDROID_NDK_ROOT` 环境变量
2. 确保 Android SDK 包含 API 34
3. 检查 Qt for Android 组件是否完整安装

### 运行时缺少平台插件

如果独立运行包提示缺少平台插件，请手动复制 Qt platforms 目录：

```powershell
Copy-Item -Path "C:\Qt\6.8.0\mingw_64\plugins\platforms" `
          -Destination "deploy\TodoTimeline\platforms" -Recurse -Force
```

### 运行时错误
1. 确保所有 Qt 依赖库已正确安装
2. 查看应用日志：`todo.log`（位于数据目录或测试目录）
3. 以调试模式运行查看控制台输出

## 开发计划

详见 [TODO.md](TODO.md)。

主要后续方向：

- 多日视图（周视图/月视图）
- 数据云同步
- 任务模板
- 统计与报表
- 桌面小组件
- 多语言支持

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！请参阅 [CONTRIBUTING.md](CONTRIBUTING.md) 了解贡献规范。

## 联系方式

如有问题或建议，请提交 [GitHub Issue](https://github.com/Asanagl/todo-timeline/issues)。
