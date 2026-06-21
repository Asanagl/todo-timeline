# Todo Timeline 项目待办事项

## 高优先级 (High Priority)

- [x] 完善任务编辑功能
- [x] 添加任务删除确认对话框
- [x] 优化时间轴拖拽体验
- [x] 添加任务搜索功能
- [x] 实现数据导入/导出功能

## 中优先级 (Medium Priority)

- [x] 添加任务分类/文件夹功能
  - Category 类实现（id/name/color/taskCount）
  - 分类管理对话框（CategoryDialog.qml）
  - 任务创建时可选分类
  - 分类持久化存储
- [x] 实现任务提醒/通知功能
  - Task 添加 hasReminder/reminderTime 属性
  - TaskManager 定时检查提醒（每分钟）
  - 提醒触发时发送 taskReminderTriggered 信号
  - UI 显示提醒通知（红色背景）
- [ ] 添加多日视图（周视图/月视图）
- [x] 支持主题切换（深色模式）
- [x] 添加键盘快捷键支持

## 低优先级 (Low Priority)

- [ ] 实现数据云同步功能
- [ ] 添加任务模板功能
- [ ] 添加统计和报表功能
- [ ] 支持桌面小组件
- [ ] 添加任务依赖关系

## 技术改进 (Technical Improvements)

- [x] 优化 QML 性能
  - Timeline delegate 热路径优化（hourHeight/currentDateStr/baseColor 缓存）
  - TaskList 搜索过滤优化（filterLower 预计算）
  - Notification y-anim 抖动修复
- [ ] 添加单元测试
- [x] 改进错误处理
  - 任务数量限制（MAX_TASKS = 10000）
  - 导入文件大小限制（MAX_IMPORT_SIZE = 10MB）
  - JSON 数据验证和错误处理
  - 输入长度限制（title 200字符，description 2000字符）
  - 颜色格式验证（正则表达式验证 #RRGGBB）
- [x] 优化内存使用
  - 延迟保存机制
  - 原子写入（先写临时文件再重命名）
  - 修复内存泄漏问题
  - 哈希表优化（findTask O(1) 查找）
  - 过滤结果缓存
- [x] 添加日志系统
  - Logger 单例类实现
  - 支持 Debug/Info/Warning/Error 四级日志
  - 日志文件自动轮转（最大 5MB）
  - 便捷宏（LOG_DEBUG/LOG_INFO/LOG_WARNING/LOG_ERROR）
- [x] UI 视觉与字体优化
  - 新增 `AppConstants.js` 全局样式常量
  - 低饱和现代配色方案
  - 统一间距、圆角、高度规范
  - 全局字体：MiSans 优先，JetBrains Mono / Microsoft YaHei / Segoe UI 回退
  - 修复文字与文本框对齐问题
- [x] 修复 QML 运行时错误
  - PriorityButton.qml / ColorCircle.qml / ColorCircleSmall.qml 添加 `required property var modelData`
  - 修复提醒设置对话框无限宽度循环
  - 对话框移除固定高度，防止内容溢出

## 文档完善 (Documentation)

- [x] 更新 README.md 符合项目实际
- [x] 更新 QUICKSTART.md 符合项目实际
- [x] 更新 CHANGELOG.md
- [ ] 编写 API 文档
- [x] 添加代码注释（核心逻辑）
- [ ] 创建用户手册
- [x] 编写贡献指南（CONTRIBUTING.md 已存在，待持续更新）
- [ ] 添加示例代码

## 平台适配 (Platform Adaptation)

- [ ] 优化 Android 触控体验
- [x] 适配不同屏幕尺寸（基础响应式布局）
- [x] 支持高 DPI 显示（Qt 自动处理）
- [ ] 优化启动速度
- [ ] 减小安装包体积

## 国际化 (Internationalization)

- [ ] 支持多语言
- [x] 中文界面
- [ ] 添加英文翻译
- [ ] 支持日期格式本地化
- [ ] 支持数字格式本地化

---

## 完成标准

- [x] 所有核心功能正常工作
- [x] 跨平台测试通过（Windows/Linux 构建成功）
- [x] 性能测试达标（过滤/计数缓存、按小时缓存）
- [ ] 文档完整（持续完善中）
- [x] 代码审查通过

---

## 更新记录

- **2026-06-17**: 创建项目，完成基础框架
- **2026-06-17**: 完成高优先级任务调优
  - 完善任务编辑功能（TaskEditor.qml）
  - 添加任务删除确认对话框（DeleteConfirmDialog.qml）
  - 优化时间轴拖拽体验（添加拖拽指示器动画）
  - 添加任务搜索功能（实时过滤+清除按钮）
  - 实现数据导入/导出功能（JSON格式）
  - 支持主题切换（深色/浅色模式）
  - 添加键盘快捷键支持（Ctrl+N/F/S/E/I/D）
- **2026-06-18**: 完成技术改进优化
  - Timeline delegate 热路径优化（hourHeight/currentDateStr/baseColor 缓存）
  - TaskList 搜索过滤优化（filterLower 预计算，避免重复 toLowerCase）
  - Notification y-anim 抖动修复（固定偏移量替代依赖当前 y 值）
  - focusSearchField 修复（正确聚焦到搜索框）
  - 深色模式统一适配（TaskCreator/TaskEditor delegate 背景）
  - CMakeLists.txt 同步新 QML 文件
  - 安全加固（任务数量限制、导入大小限制、JSON验证）
  - 内存优化（延迟保存、原子写入、内存泄漏修复）
- **2026-06-18**: 完成中优先级功能
  - 任务分类/文件夹功能（Category 类、分类管理对话框、分类持久化）
  - 任务提醒/通知功能（提醒属性、定时检查、UI通知）
  - 日志系统（Logger 单例、四级日志、文件轮转）
  - 输入验证（标题/描述长度限制、颜色格式验证）
  - 性能优化（哈希表查找 O(1)、过滤结果缓存）
  - 版本升级到 1.1.0
- **2026-06-21**: UI 视觉全面优化与最终交付
  - 新增 AppConstants.js 全局样式常量
  - 现代低饱和配色、统一间距/圆角
  - 全局字体更换为 MiSans 优先
  - 修复 TaskItem/TaskCreator/TaskEditor/CategoryDialog 布局问题
  - 修复 modelData 未定义、提醒对话框无限宽度等 QML 错误
  - 添加沙箱/测试环境支持（TODO_APP_DATA_DIR）
  - 更新 GitHub Actions 至 Qt 6.8.0 + MSVC 2022
  - 生成自动化截图与交付报告
  - 更新 README.md、QUICKSTART.md、CHANGELOG.md、TODO.md 等文档

---

*注：此文件用于跟踪项目开发进度，请定期更新。*
