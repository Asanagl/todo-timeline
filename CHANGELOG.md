# Changelog

All notable changes to the Todo Timeline project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Multi-day view (week/month view)
- Data sync across devices
- Task templates
- Statistics and reports
- Desktop widget support
- Task dependencies
- Multi-language support (i18n)

## [1.3.0] - 2026-06-24

### Added
- ThemeManager C++ class (`src/thememanager.h/.cpp`):
  - 9 customizable color Q_PROPERTYs: primaryColor, accentColor, successColor, warningColor, dangerColor, backgroundColor, surfaceColor, textColor, borderColor
  - 3 control properties: darkModeEnabled, acrylicEnabled, acrylicOpacity
  - 6 preset themes: 海洋蓝, 森林绿, 日落橙, 皇家紫, 极简灰, 极光
  - Q_INVOKABLE methods: presetNames(), presetColors(int), applyPreset(int), resetToDefault()
  - QSettings persistence (org: "TodoApp", app: "Todo Timeline")
  - Mode-aware colors: dark mode returns hardcoded dark variants for background/surface/text/border
- ThemeSettingsDialog.qml:
  - Tab-based UI: 预设主题 (GridView with 6 preset cards) | 自定义配色 (9 color editors + controls)
  - ColorDialog integration for visual color picking
  - Hex TextField for manual color input (#RRGGBB format)
  - Dark mode Switch
  - Acrylic effect Switch
  - Transparency Slider (0-100%, step 5%)
  - Snapshot/restore mechanism for cancel button
  - Real-time preview via themeManager setters
- AcrylicPanel.qml:
  - Reusable acrylic blur panel component
  - MultiEffect + ShaderEffectSource for real blur
  - Gradient texture overlay for frosted glass effect
  - Graceful degradation when acrylic disabled
- Acrylic semi-transparent backgrounds applied to:
  - Main.qml footer toolbar
  - TaskList.qml header
  - Timeline.qml date navigation header
  - TaskItem.qml task cards
  - TaskCreator.qml, TaskEditor.qml, CategoryDialog.qml, DeleteConfirmDialog.qml dialogs
- Ctrl+T shortcut for opening theme settings dialog
- "主题" ToolButton in footer toolbar

### Changed
- Version bumped to 1.3.0
- Main.qml Material.theme/primary/accent/color bound to themeManager properties
- All UI files migrated from C.colorXxx to themeManager.xxxColor for theme-aware colors
- Timeline.qml line 127: C.colorBorderLight → themeManager.borderColor

### Performance
- Acrylic effect uses semi-transparent simulation (Qt.rgba) for dynamic elements (task cards) to prioritize performance
- Real blur (MultiEffect) reserved for static elements via AcrylicPanel component
- Dialog acrylic backgrounds use Math.max(0.85, opacity) to ensure readability

## [1.2.0] - 2026-06-24

### Added
- TaskEditor functional symmetry completion:
  - Category editing in TaskEditor (ComboBox with category list)
  - Schedule time editing in TaskEditor (CheckBox + Tumbler for start/end time)
  - Reminder editing in TaskEditor (CheckBox + advance minutes SpinBox)
  - `updateTaskSchedule()` and `updateTaskReminder()` C++ backend APIs
- Visual/UX enhancements:
  - Priority text labels (低/中/高) with colored badges on TaskItem
  - Reminder indicator badge on TaskItem
  - Adaptive TaskItem height (96px collapsed, 120px expanded)
  - Completed task background tint (green tint for visual feedback)
  - Timeline task blocks now show time range ("HH:mm Title") with divider
  - Timeline task block height increased to 24px with border
  - Empty state hint in Timeline when no scheduled tasks
  - Toolbar task counter shows "completed/total" (e.g., "3/5 已完成")
  - Weekday badge in toolbar
- New AppConstants.js constants:
  - `colorStripeLight`/`colorStripeDark` for Timeline stripes
  - `priorityLabelBgLow`/`Medium`/`High` for priority badges
  - `colorCompletedBgDark` for completed task background
  - `taskBlockHeight`/`taskBlockSpacing` for Timeline blocks

### Changed
- Replaced hardcoded colors in Timeline.qml with AppConstants.js constants
- CMakeLists.txt QML_FILES synchronized with resources.qrc (added PriorityButton, ColorCircle, ColorCircleSmall, AppConstants.js)
- Version bumped to 1.2.0

### Fixed
- Removed unused `reminderHourSpinBox` and `reminderMinuteSpinBox` from TaskCreator.qml (dead code)
- Fixed rgba color string format issues (use Qt.rgba() and #AARRGGBB format)
- Fixed capture_ui.py screenshot script:
  - Richer sample data (5 tasks, 3 categories with varied priorities/colors)
  - Improved coordinate calculation for schedule/reminder checkbox clicks
  - Increased wait times for UI stability

### Removed
- Cleaned up redundant build directories (build/, build_mingw/)

## [1.1.0] - 2026-06-21

### Added
- Task categories/folders:
  - Category model with id/name/color/taskCount
  - Category management dialog (`CategoryDialog.qml`)
  - Task assignment to categories
  - Category filtering in task list
  - Category persistence
- Task reminders/notifications:
  - `hasReminder` and `reminderTime` properties on Task
  - Per-minute reminder check in TaskManager
  - In-app notification UI
- Search and filter:
  - Real-time text filtering by title/description
  - Category-based filtering
- Theme switching:
  - Light/dark mode toggle
  - Persistent theme preference
- Data import/export:
  - Export tasks to JSON
  - Import tasks from JSON with validation
- Keyboard shortcuts:
  - `Ctrl+N` new task
  - `Ctrl+F` focus search
  - `Ctrl+S` save data
  - `Ctrl+E` export data
  - `Ctrl+I` import data
  - `Ctrl+D` toggle theme
- Logging system:
  - Logger singleton with Debug/Info/Warning/Error levels
  - Log file rotation (max 5MB)
  - Convenient macros (`LOG_DEBUG`, `LOG_INFO`, etc.)
- UI visual refresh:
  - Modern low-saturation color palette
  - Unified spacing/radius/height constants in `AppConstants.js`
  - Refreshed task item cards with rounded corners and highlights
  - Global font stack: MiSans preferred, fallback to JetBrains Mono / Microsoft YaHei / Segoe UI
- New QML components:
  - `PriorityButton.qml`
  - `ColorCircle.qml`
  - `ColorCircleSmall.qml`
- Test/sandbox mode:
  - `TODO_APP_DATA_DIR` environment variable overrides data directory
  - `QStandardPaths::setTestModeEnabled(true)` for restricted environments
- Static analysis:
  - `.qmllint.ini` configuration

### Changed
- Upgraded GitHub Actions to Qt 6.8.0 for Windows and Linux builds
- Windows CI builds now use MSVC 2022 64-bit (`win64_msvc2022_64`)
- Refactored QML layouts to use `Layout.preferredWidth/Height` instead of direct width/height
- Dialogs no longer use fixed heights to prevent content overflow
- Improved input field padding and vertical alignment

### Fixed
- `ReferenceError: modelData is not defined` in Repeater delegates
  - Added `required property var modelData` to `PriorityButton.qml`, `ColorCircle.qml`, and `ColorCircleSmall.qml`
- Infinite width loop in reminder settings dialog by splitting controls into multiple rows
- Sandbox/restricted environment data write failures
- QML layout warnings and text overflow issues

### Performance
- Added `filteredTasks` cache with dirty flag to avoid repeated filtering in QML
- Added `completedTaskCount` cache with dirty flag
- Added per-hour task cache (`tasksForHour`) to avoid 24 Repeater iterations
- Fast task/category lookup via `QHash` (O(1))
- Incremental category task count updates

### Security
- Task count limit (`MAX_TASKS = 10000`)
- Import file size limit (`MAX_IMPORT_SIZE = 10MB`)
- JSON data validation
- Input length limits (title 200 chars, description 2000 chars)
- Color format validation (`#RRGGBB` regex)
- Atomic file writes via temporary file + rename

## [1.0.0] - 2026-06-17

### Added
- Initial release
- Task management features:
  - Add new tasks with title and description
  - Delete tasks with confirmation
  - Edit task details
  - Mark tasks as completed
  - Set task priority (Low/Medium/High)
  - Assign colors to tasks
- Timeline view:
  - 24-hour timeline display
  - Current time indicator with pulse animation
  - Date navigation (previous/next day)
  - "Today" quick navigation button
- Drag and drop:
  - Drag tasks from task list to timeline
  - Auto-schedule tasks to specific time slots
- Animations:
  - Task add/remove animations
  - Task completion animation
  - Dialog open/close animations
  - Button hover animations
  - Timeline scroll animations
- Data persistence:
  - Local JSON file storage
  - Auto-save on changes
  - Auto-load on startup
- Cross-platform support:
  - Windows (MinGW/MSVC)
  - Linux (GCC)
  - Android (via Qt for Android)
- Build system:
  - CMake configuration
  - Build scripts for Windows (`build.bat`)
  - Build scripts for Linux (`build.sh`)
  - Run scripts for easy execution
  - Test scripts for verification
- Documentation:
  - `README.md` with detailed instructions
  - `QUICKSTART.md` for quick setup
  - `CHANGELOG.md` (this file)
  - `LICENSE` (MIT)

### Technical Details
- Built with Qt 6.x
- Uses Qt Quick/QML for UI
- Material Design theme
- C++17 standard
- CMake build system

---

## Version History

- **1.3.0** (2026-06-24): ThemeManager, custom color system, acrylic effects, transparency control
- **1.2.0** (2026-06-24): TaskEditor symmetry, visual/UX enhancements, engineering cleanup
- **1.1.0** (2026-06-21): UI refresh, categories, reminders, search, theme switch, performance improvements
- **1.0.0** (2026-06-17): Initial release with core functionality
- **0.1.0** (Development): Internal development version

---

For a detailed list of changes, see the [commit history](https://github.com/Asanagl/todo-timeline/commits/main).
