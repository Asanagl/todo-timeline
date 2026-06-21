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

- **1.1.0** (2026-06-21): UI refresh, categories, reminders, search, theme switch, performance improvements
- **1.0.0** (2026-06-17): Initial release with core functionality
- **0.1.0** (Development): Internal development version

---

For a detailed list of changes, see the [commit history](https://github.com/Asanagl/todo-timeline/commits/main).
