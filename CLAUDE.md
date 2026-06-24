# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Todo Timeline — a cross-platform task management desktop app built with Qt 6.8.0 and QML. Tasks are organized on a 24-hour timeline rather than a flat list. Version 1.3.0, C++17, CMake 3.16+.

The repo root also contains `todo-app/`, an Expo/React Native scaffold (Expo v56) that is **not the active project**. All work targets `todo-qt/`.

## Build, run, test

```bash
# Build (Windows)
./build.bat            # defaults to windows target
# Build (Linux)
./build.sh linux

# Run
./run.bat              # release mode; pass "debug" for console output
./run.sh

# Verify binary + DLLs + QML resources exist
./test.bat
./test.sh

# UI screenshot regression (8 screens: main view, dialogs)
python capture_ui.py
```

Manual build (Windows/MinGW):
```powershell
$env:PATH = "C:\Qt\6.8.0\mingw_64\bin;C:\Qt\Tools\mingw1310_64\bin;" + $env:PATH
cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release -S . -B build
cmake --build build --config Release -j4
```

## Lint and formatting

- **C++**: `.clang-format` (Google-based, 4-space indent, 120 cols) and `.clang-tidy` (broad checks enabled; `bugprone-*`, `cert-*`, `clang-analyzer-*`, `performance-*` are errors)
- **QML**: `qmllint` configured via `.qmllint.ini` (`UnqualifiedAccess` disabled because C++ context properties are injected at runtime)
- **JS/JSON/MD/YAML**: Prettier via `.prettierrc` (4 spaces, 120 width, single quotes, trailing commas)
- **Commits**: Conventional Commits enforced by `.commitlintrc.yml`. Types: `feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert`. Scopes: `timeline|tasks|ui|build|docs|ci|deps|android|linux|windows`.

## Architecture

**Entry point**: `src/main.cpp` — sets up Qt app, registers `TaskManager`, `TimelineModel`, and `ThemeManager` as QML context properties, loads `qrc:/qml/Main.qml`.

```
C++ backend (src/)          QML UI (qml/)
─────────────────────       ─────────────────────
main.cpp                    Main.qml          — root ApplicationWindow, SplitView, dialogs
taskmanager.{h,cpp}         TaskList.qml      — left panel: search + filtered ListView
timelinemodel.{h,cpp}       TaskItem.qml      — single task card (96px, checkbox, edit/delete)
thememanager.{h,cpp}        Timeline.qml      — right panel: 24h ListView, current-time indicator
logger.{h,cpp}              TaskCreator.qml   — create-task dialog
                            TaskEditor.qml    — edit-task dialog
                            CategoryDialog.qml— category CRUD dialog
                            ThemeSettingsDialog.qml — theme customization (presets, colors, acrylic)
                            AcrylicPanel.qml  — reusable acrylic blur panel
                            Notification.qml  — toast (auto-dismiss 3s)
                            AppConstants.js   — global colors, spacing, sizes, durations
```

**`TaskManager`** (`taskmanager.h/.cpp`) — the central C++ class. Owns all `Task` and `Category` objects, handles JSON persistence, search/filter, reminder checking, import/export. Key design decisions:

- **Dirty-flag caching**: `filteredTasks()`, `tasksByHour()`, and completed-task counts use version/dirty flags so QML bindings recompute only when data actually changes.
- **`tasksByHour(date, hour)`** — O(1) lookup via `QHash<QDate, QVector<QList<Task*>>>` rebuilt once when scheduled tasks change, avoiding O(N×24) in the timeline delegate.
- **Deferred persistence**: 500ms single-shot `QTimer` debounces writes; atomic save via temp-file + rename.
- **Reminder polling**: 1-minute timer; `m_hasAnyReminders` flag lets the check bail early when no reminders exist.

**`TimelineModel`** (`timelinemodel.h/.cpp`) — `QAbstractListModel` with 24 rows (one per hour). Exposes roles: `hour`, `timeString` (e.g. "14:00"), `isCurrentHour`. Used by `Timeline.qml`'s ListView.

**`Logger`** (`logger.h/.cpp`) — singleton with 4 levels (debug/info/warning/error), console + file output, 5 MB rotation.

**`ThemeManager`** (`thememanager.h/.cpp`) — manages custom colors, dark mode, and acrylic effects. All settings persisted via QSettings. Exposes 9 color Q_PROPERTYs (primaryColor, accentColor, successColor, warningColor, dangerColor, backgroundColor, surfaceColor, textColor, borderColor) + 3 control properties (darkModeEnabled, acrylicEnabled, acrylicOpacity). Provides 6 preset themes via Q_INVOKABLE methods. Mode-aware colors return hardcoded dark variants when darkModeEnabled is true.

QML files access C++ objects via context properties (`taskManager`, `timelineModel`, `themeManager`) — no import/plugin layer. Constants (colors, spacing, animation durations) live in `qml/AppConstants.js` as a `.pragma library`.

## Data storage

JSON files at the platform app-data location (`QStandardPaths::AppDataLocation`):
- `tasks.json` / `categories.json`

Set `TODO_APP_DATA_DIR` env var to override for testing/sandbox (enables `QStandardPaths::setTestModeEnabled(true)`).

## CI/CD

GitHub Actions (`.github/workflows/`):
- **build.yml** — Windows (Qt 6.8.0 + MSVC 2022), Linux (Qt 6.8.0 + GCC), Android (Qt 6.6.3 + SDK 34). Triggered on push/PR to `main`/`develop`.
- **release.yml** — tag-push (`v*`), builds + windeployqt, creates GitHub Release.
- **codeql.yml** — weekly Monday 06:00 UTC + on PR.
- **scorecard.yml** — OpenSSF Scorecard.

## Naming conventions

- QML files: PascalCase matching the component name (`TaskItem.qml` → `TaskItem {}` in QML)
- C++ classes: PascalCase, matching filename (`TaskManager` → `taskmanager.h/.cpp`)
- SVG icons in `icons/` are loaded via `resources.qrc`
