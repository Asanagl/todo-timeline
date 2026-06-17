# Commit Message Convention

This project follows [Conventional Commits](https://www.conventionalcommits.org/) specification.

## Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

## Types

| Type | Description | Example |
|------|-------------|---------|
| `feat` | A new feature | `feat(timeline): add drag and drop support` |
| `fix` | A bug fix | `fix(tasks): resolve completion animation issue` |
| `docs` | Documentation changes | `docs(readme): update build instructions` |
| `style` | Code style changes (formatting, missing semi-colons, etc) | `style(src): fix indentation` |
| `refactor` | Code refactoring | `refactor(timeline): extract reusable components` |
| `perf` | Performance improvements | `perf(qml): optimize rendering performance` |
| `test` | Adding or updating tests | `test(tasks): add unit tests for task manager` |
| `build` | Build system or external dependencies | `build(cmake): update Qt version` |
| `ci` | CI configuration | `ci(actions): add Android build workflow` |
| `chore` | Other changes | `chore(deps): update dependencies` |
| `revert` | Revert a commit | `revert: feat(timeline): add drag and drop support` |

## Scopes

| Scope | Description |
|-------|-------------|
| `timeline` | Timeline component |
| `tasks` | Task management |
| `ui` | User interface |
| `build` | Build system |
| `docs` | Documentation |
| `ci` | Continuous integration |
| `deps` | Dependencies |
| `android` | Android platform |
| `linux` | Linux platform |
| `windows` | Windows platform |

## Description

- Use imperative, present tense: "add" not "added" or "adds"
- Don't capitalize first letter
- No dot (.) at the end

## Body

- Use the body to explain **what** and **why** vs. **how**
- Wrap at 72 characters

## Footer

- Reference issues and pull requests
- Use `BREAKING CHANGE:` for breaking changes

## Examples

### Simple feature
```
feat(tasks): add task priority selection
```

### Bug fix with body
```
fix(timeline): resolve drag and drop issue

The drag and drop was not working correctly when dragging tasks
from the task list to the timeline. This was due to incorrect
coordinate calculation.

Fixes #123
```

### Breaking change
```
feat(api): change task data structure

BREAKING CHANGE: The task data structure has changed. 
Old format: { title: string, description: string }
New format: { title: string, description: string, priority: number }
```

### Documentation
```
docs(readme): update installation instructions

Added detailed instructions for installing Qt and CMake
on Windows and Linux.
```

### Build system
```
build(cmake): upgrade to Qt 6.5.0

Updated CMakeLists.txt to use Qt 6.5.0 and added
new dependencies for QuickControls2.
```

### CI/CD
```
ci(actions): add multi-platform build workflow

Added GitHub Actions workflow for building on Windows,
Linux, and Android platforms.
```

## Validation

Commit messages are validated using [commitlint](https://commitlint.js.org/).

## Tools

- [commitizen](https://github.com/commitizen/cz-cli) - Command line tool
- [commitlint](https://commitlint.js.org/) - Lint commit messages
- [husky](https://typicode.github.io/husky/) - Git hooks

## References

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Angular Commit Message Guidelines](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit)
- [Semantic Versioning](https://semver.org/)
