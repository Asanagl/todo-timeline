# Todo Timeline 快速开始指南

## 5 分钟快速上手

### 第一步：安装依赖

#### Windows 用户
1. 下载并安装 Qt：https://www.qt.io/download-qt-installer
   - 选择 Qt 6.x 版本
   - 确保勾选 MinGW 编译器
2. 下载并安装 CMake：https://cmake.org/download/
   - 安装时选择 "Add CMake to the system PATH"

#### Linux 用户
```bash
sudo apt update
sudo apt install qt6-base-dev qt6-declarative-dev qt6-quickcontrols2-dev cmake build-essential
```

### 第二步：构建项目

#### Windows
```bash
# 双击运行 start.bat
# 或者手动执行:
build.bat windows
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
```bash
run.bat
# 或者: run.bat debug (调试模式)
```

#### Linux
```bash
chmod +x run.sh
./run.sh
# 或者: ./run.sh debug (调试模式)
```

## 核心功能

### 1. 添加任务
- 点击左上角的 **+** 按钮
- 输入任务标题和描述
- 选择优先级（低/中/高）
- 选择颜色标记
- 点击 "创建任务"

### 2. 安排任务到时间轴
- 在左侧任务列表找到要安排的任务
- 将任务拖拽到右侧时间轴的对应时间段
- 任务会自动安排到该时间段

### 3. 管理任务
- **完成任务**：点击任务左侧的复选框
- **编辑任务**：点击任务右侧的编辑按钮
- **删除任务**：点击任务右侧的删除按钮

### 4. 时间轴操作
- **切换日期**：点击左右箭头按钮
- **回到今天**：点击 "今天" 按钮
- **滚动时间**：上下滚动鼠标滚轮

## 界面说明

```
+-------------------------------------------+
| [任务列表]          [时间轴视图]          |
| +--------+         +------------------+  |
| | 任务1  |         | 08:00 ---------- |  |
| | 任务2  |  -----> | 09:00 ---------- |  |
| | 任务3  |  拖拽    | 10:00 ---------- |  |
| +--------+         +------------------+  |
+-------------------------------------------+
| [底部工具栏: 今天 | 日期 | 设置]         |
+-------------------------------------------+
```

## 快捷键

| 快捷键 | 功能 |
|--------|------|
| Ctrl+N | 新建任务 |
| Ctrl+S | 保存数据 |
| Ctrl+F | 搜索任务 |
| Delete | 删除选中任务 |
| Ctrl+Z | 撤销操作 |

## 数据存储

任务数据以 JSON 格式保存在：
- **Windows**: `%APPDATA%\TodoApp\tasks.json`
- **Linux**: `~/.local/share/TodoApp/tasks.json`
- **Android**: 应用私有存储目录

## 常见问题

### Q: 构建失败怎么办？
A: 检查以下几点：
1. Qt 和 CMake 是否已正确安装
2. 是否添加到系统 PATH
3. 编译器是否正确配置

### Q: 应用启动后闪退怎么办？
A: 尝试以下步骤：
1. 以调试模式运行：`run.bat debug`
2. 查看控制台输出的错误信息
3. 确保所有依赖库已正确安装

### Q: 如何备份数据？
A: 复制以下文件即可：
- Windows: `%APPDATA%\TodoApp\tasks.json`
- Linux: `~/.local/share/TodoApp/tasks.json`

### Q: 如何在多台设备间同步数据？
A: 目前版本不支持自动同步。您可以：
1. 手动复制 tasks.json 文件
2. 使用云存储服务同步该文件
3. 等待后续版本添加同步功能

## 技术支持

如有问题或建议，请：
1. 查看 README.md 获取详细文档
2. 提交 Issue 到项目仓库
3. 联系开发者

## 更新日志

### v1.0.0 (2026-06-17)
- 初始版本发布
- 支持任务管理（添加、删除、编辑）
- 支持时间轴视图
- 支持拖拽安排任务
- 支持 Windows、Android、Linux 三端
- 支持动画效果
- 支持本地 JSON 存储
