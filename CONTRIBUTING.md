# Contributing to Todo Timeline

Thank you for your interest in contributing to Todo Timeline! This document provides guidelines and instructions for contributing.

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
6. **Commit your changes** with clear messages
7. **Push to your fork**
8. **Create a Pull Request**

## Development Setup

### Prerequisites

- Qt 6.0 or higher
- CMake 3.16 or higher
- C++17 compatible compiler

### Building the Project

```bash
# Windows
build.bat windows

# Linux
./build.sh linux

# Android
./build.sh android
```

### Running Tests

```bash
# Windows
test.bat

# Linux
./test.sh
```

## Code Style

### C++ Code

- Follow Qt coding conventions
- Use meaningful variable names
- Add comments for complex logic
- Keep functions short and focused
- Use const where appropriate

### QML Code

- Follow Qt Quick coding conventions
- Use meaningful component IDs
- Keep components reusable
- Add comments for complex bindings
- Use proper indentation (4 spaces)

## Commit Messages

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
- `test`: Adding tests
- `chore`: Maintenance tasks

Examples:
```
feat(timeline): add drag and drop support
fix(tasks): resolve completion animation issue
docs(readme): update build instructions
```

## Pull Request Guidelines

1. **Keep PRs focused** - One feature/fix per PR
2. **Write clear descriptions** - Explain what and why
3. **Include tests** - Add unit tests for new features
4. **Update docs** - Update README if needed
5. **Be responsive** - Respond to review comments

## Code Review

All submissions require review. We use GitHub pull requests for this purpose.

### Review Checklist

- [ ] Code compiles without warnings
- [ ] Tests pass
- [ ] Documentation is updated
- [ ] Code style is consistent
- [ ] No security issues
- [ ] Performance is acceptable

## Getting Help

- **Issues**: Use GitHub issues for bugs and features
- **Discussions**: Use GitHub discussions for questions
- **Email**: Contact maintainers directly

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Project documentation

---

Thank you for contributing to Todo Timeline! 🎉
