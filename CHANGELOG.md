# Changelog

All notable changes to the Todo Timeline project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1](https://github.com/Asanagl/todo-timeline/compare/v1.1.0...v1.1.1) (2026-06-18)


### Bug Fixes

* **ci:** add QT_HOST_PATH for Android cross-compilation ([e3dca24](https://github.com/Asanagl/todo-timeline/commit/e3dca24337ae18589e7596a07ca5ca40e234b632))
* **ci:** switch Windows to MSVC and use windeployqt for deployment ([98d6de9](https://github.com/Asanagl/todo-timeline/commit/98d6de915456cf8c89eaeb7fc2dab152fd9df24c))

## [1.0.0] - 2026-06-17

### Added
- Initial release
- Task management features:
  - Add new tasks with title and description
  - Delete tasks with confirmation animation
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
  - Build scripts for Windows (build.bat)
  - Build scripts for Linux (build.sh)
  - Run scripts for easy execution
  - Test scripts for verification
- Documentation:
  - README.md with detailed instructions
  - QUICKSTART.md for quick setup
  - CHANGELOG.md (this file)
  - LICENSE (MIT)

### Technical Details
- Built with Qt 6.x
- Uses Qt Quick/QML for UI
- Material Design theme
- C++17 standard
- CMake build system

## [Unreleased]

### Planned
- Task categories/folders
- Task reminders/notifications
- Multi-day view
- Data sync across devices
- Theme customization
- Keyboard shortcuts
- Task templates
- Export/Import functionality
- Statistics and reports
- Widget support

---

## Version History

- **1.0.0** (2026-06-17): Initial release with core functionality
- **0.1.0** (Development): Internal development version

---

For a detailed list of changes, see the [commit history](https://github.com/yourusername/todo-timeline/commits/main).
