# Contributing to Todo Timeline

Thank you for your interest in contributing to Todo Timeline! This document provides guidelines and instructions for contributing to this Qt6/QML task management application.

## How to Contribute

### Reporting Bugs

1. **Check existing issues** to avoid duplicates
2. **Create a new issue** with a clear title and description
3. **Include reproduction steps** and expected behavior
4. **Add screenshots** if applicable
5. **Specify your environment** (OS, Qt version, compiler)

### Suggesting Features

1. **Check existing feature requests** to avoid duplicates
2. **Create a new issue** with the "enhancement" label
3. **Describe the feature** in detail
4. **Explain the use case** and benefits
5. **Consider implementation** complexity

### Submitting Changes

1. **Fork the repository**
2. **Create a feature branch** from `main`
3. **Make your changes**
4. **Add tests** if applicable
5. **Update documentation** if needed
6. **Commit your changes** with clear messages following our convention
7. **Push to your fork**
8. **Create a Pull Request**

## Development Setup

### Prerequisites

- Qt 6.8.0 (recommended), minimum Qt 6.5
- CMake 3.16 or higher
- C++17 compatible compiler
  - Windows: MinGW 13.1 64-bit or MSVC 2022 64-bit
  - Linux: GCC 9+

### Building the Project

```bash
# Windows
./build.bat windows

# Linux
./build.sh linux

# Android (requires Android SDK/NDK)
./build.sh android
```

For manual build instructions, see [README.md](README.md).

### Running Tests

```bash
# Windows
./test.bat

# Linux
./test.sh
```

These scripts verify that the executable, Qt dependencies, and QML resources are present.

### UI Verification

Use the automated screenshot script to verify UI changes:

```bash
python capture_ui.py
```

This generates 8 screenshots covering main views and dialogs.

## Code Style

### C++ Code

- Follow Qt coding conventions
- Use meaningful variable names
- Add comments for complex logic
- Keep functions short and focused
- Use `const` where appropriate
- Prefer C++17 features when they improve readability

### QML Code

- Follow Qt Quick coding conventions
- Use `AppConstants.js` for colors, spacing, and sizes
- Use `Layout.preferredWidth/Height` instead of direct width/height in layouts
- Keep components reusable
- Add comments for complex bindings
- Use proper indentation (4 spaces)
- Avoid fixed dialog heights; prefer automatic height calculation

### Commit Messages

Use conventional commit messages:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding tests
- `build`: Build system changes
- `ci`: CI configuration changes
- `chore`: Maintenance tasks

Examples:
```
feat(tasks): add task category selection
fix(qml): resolve modelData undefined in Repeater delegates
perf(timeline): cache tasks by hour to avoid repeated filtering
docs(readme): update build instructions for Qt 6.8.0
```

## Pull Request Guidelines

1. **Keep PRs focused** - One feature/fix per PR
2. **Write clear descriptions** - Explain what and why
3. **Include tests** - Add unit tests for new features when possible
4. **Update docs** - Update README/QUICKSTART/CHANGELOG if needed
5. **Be responsive** - Respond to review comments

## Code Review

All submissions require review. We use GitHub pull requests for this purpose.

### Review Checklist

- [ ] Code compiles without warnings
- [ ] Test scripts pass
- [ ] UI screenshots look correct (if applicable)
- [ ] Documentation is updated
- [ ] Code style is consistent
- [ ] No security issues
- [ ] Performance is acceptable

## CI/CD

Pull requests trigger GitHub Actions builds for Windows, Linux, and Android. Ensure all checks pass before requesting review.

## Getting Help

- **Issues**: Use GitHub issues for bugs and features
- **Discussions**: Use GitHub discussions for questions
- **Project docs**: See [README.md](README.md) and [QUICKSTART.md](QUICKSTART.md)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Project documentation

---

Thank you for contributing to Todo Timeline!
