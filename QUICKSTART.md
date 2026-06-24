# Todo Timeline 快速开始指南

## 5 分钟快速上手

### 第一步：安装依赖

#### Windows 用户
1. 下载并安装 Qt：https://www.qt.io/download-qt-installer
   - 选择 Qt 6.8.0
   - 安装 MinGW 13.1 64-bit 或 MSVC 2022 64-bit 组件
   - 确保勾选 Qt Quick Controls
2. 下载并安装 CMake：https://cmake.org/download/
   - 安装时选择 "Add CMake to the system PATH"

#### Linux 用户
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

### 第二步：构建项目

#### Windows
```powershell
# 双击运行 start.bat
# 或者手动执行:
./build.bat windows
```

#### Linux
```bash
chmod +x start.sh
./start.sh
# 或者手动执行:
chmod +x build.sh
./build.sh linux
```

### 第三步：运行应用

#### Windows
```powershell
./run.bat
# 或者: ./run.bat debug (调试模式)
```

#### Linux
```bash
chmod +x run.sh
./run.sh
# 或者: ./run.sh debug (调试模式)
```

## 核心功能

### 1. 添加任务
- 点击左上角的 **+** 按钮，或按 `Ctrl+N`
- 输入任务标题和描述
- 选择优先级（低/中/高）
- 选择颜色标记
- 选择分类（可选）
- 设置提醒时间（可选）
- 点击 "创建任务"

### 2. 安排任务到时间轴
- 在左侧任务列表找到要安排的任务
- 编辑任务设置开始/结束时间
- 任务会显示在右侧时间轴对应时间段

### 3. 管理任务
- **完成任务**：点击任务左侧的复选框
- **编辑任务**：点击任务右侧的编辑按钮
- **删除任务**：点击任务右侧的删除按钮

### 4. 管理分类
- 打开分类管理对话框
- 添加、编辑、删除分类
- 为分类设置名称和颜色
- 在任务列表按分类筛选

### 5. 搜索与过滤
- 按 `Ctrl+F` 聚焦搜索框
- 输入关键词实时过滤任务
- 可按分类进一步筛选

### 6. 导入/导出数据
- `Ctrl+E`：导出任务数据为 JSON
- `Ctrl+I`：从 JSON 文件导入任务数据

### 7. 切换主题
- `Ctrl+D`：在浅色/深色模式间切换
- `Ctrl+T`：打开主题设置对话框
  - 选择 6 套预设主题（海洋蓝、森林绿、日落橙、皇家紫、极简灰、极光）
  - 自定义 9 种颜色（主色调、辅助色、成功/警告/危险色等）
  - 开关亚克力半透明效果
  - 调整透明度（0-100% 滑块）

## 界面说明

```
+---------------------------------------------------+
| [搜索] [导入] [导出] [主题] [快捷键]              |
+---------------------------------------------------+
| [任务列表]                  [时间轴视图]          |
| +----------+               +------------------+   |
| | 任务 1   |               | 08:00 ---------- |   |
| | 任务 2   |               | 09:00 ---------- |   |
| | 任务 3   |               | 10:00 ---------- |   |
| +----------+               +------------------+   |
+---------------------------------------------------+
| [底部工具栏: 今天 | 日期 | 分类筛选]              |
+---------------------------------------------------+
```

## 快捷键

| 快捷键 | 功能 |
|--------|------|
| Ctrl+N | 新建任务 |
| Ctrl+F | 搜索任务 |
| Ctrl+S | 保存数据 |
| Ctrl+E | 导出数据 |
| Ctrl+I | 导入数据 |
| Ctrl+D | 切换深色/浅色模式 |
| Ctrl+T | 主题设置（配色/亚克力/透明度） |

应用内点击工具栏的 "快捷键" 按钮也可查看完整列表。

## 数据存储

任务与分类数据以 JSON 格式保存在：

- **Windows**：`%APPDATA%\TodoApp\tasks.json`、`%APPDATA%\TodoApp\categories.json`
- **Linux**：`~/.local/share/TodoApp/tasks.json`、`~/.local/share/TodoApp/categories.json`
- **Android**：应用私有存储目录

### 测试/沙箱模式

在受限环境或自动化测试中，可设置环境变量覆盖数据目录：

```powershell
$env:TODO_APP_DATA_DIR = "C:\path\to\test_data"
./run.bat
```

## 常见问题

### Q: 构建失败怎么办？
A: 检查以下几点：
1. Qt 和 CMake 是否已正确安装
2. 是否添加到系统 PATH
3. 编译器是否与 Qt 套件匹配
4. Linux 用户是否已安装 X11/XCB 开发库

### Q: 应用启动后闪退怎么办？
A: 尝试以下步骤：
1. 以调试模式运行：`./run.bat debug`
2. 查看控制台输出的错误信息
3. 查看数据目录下的 `todo.log` 日志文件
4. 确保所有依赖库已正确安装

### Q: 如何备份数据？
A: 复制以下文件即可：
- Windows: `%APPDATA%\TodoApp\tasks.json`、`%APPDATA%\TodoApp\categories.json`
- Linux: `~/.local/share/TodoApp/tasks.json`、`~/.local/share/TodoApp/categories.json`

### Q: 如何在多台设备间同步数据？
A: 目前版本不支持自动同步。您可以：
1. 手动复制 JSON 数据文件
2. 使用云存储服务同步该文件
3. 等待后续版本添加同步功能

## 技术支持

如有问题或建议，请：
1. 查看 [README.md](README.md) 获取详细文档
2. 提交 Issue 到项目仓库：https://github.com/Asanagl/todo-timeline/issues
3. 查看 [DELIVERY_REPORT.md](DELIVERY_REPORT.md) 了解最新交付状态

## 更新日志

### v1.3.0 (2026-06-24)
- 新增主题管理器（ThemeManager C++ 类）
- 新增 6 套预设主题方案
- 新增完整调色板自定义（9 种颜色）
- 新增亚克力半透明模糊效果
- 新增透明度调整功能（0-100%）
- 新增主题设置对话框（Ctrl+T）
- 所有主题设置通过 QSettings 持久化存储

### v1.2.0 (2026-06-24)
- UI 视觉全面优化：现代配色、统一间距、圆角设计
- 全局字体调整为 MiSans 优先，JetBrains Mono / Microsoft YaHei / Segoe UI 回退
- 新增任务分类管理功能
- 新增任务提醒与通知功能
- 新增搜索过滤与分类筛选
- 新增浅色/深色主题切换
- 新增数据导入/导出功能
- 新增键盘快捷键支持
- 性能优化：过滤缓存、按小时任务缓存、脏标记机制
- 修复 QML `modelData` 未定义等运行时错误
- 升级 GitHub Actions 至 Qt 6.8.0

### v1.0.0 (2026-06-17)
- 初始版本发布
- 支持任务管理（添加、删除、编辑、完成）
- 支持时间轴视图
- 支持优先级与颜色标记
- 支持 Windows、Android、Linux 三端
- 支持动画效果
- 支持本地 JSON 存储
