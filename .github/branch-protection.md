# Branch Protection Rules

This document describes the intended branch protection rules for this repository.

> **Note**: Actual enforcement is configured via GitHub repository settings. This file documents the agreed-upon rules for contributors.

## Main Branch (`main`)

The `main` branch is protected with the following rules:

### Pull Request Requirements

- **Required approving reviews**: 1
- **Dismiss stale reviews**: Yes
- **Require code owner reviews**: No (unless explicitly enabled)
- **Restrict dismissals**: No

### Status Checks

The following status checks must pass before merging:

- `build-windows` - Windows build must succeed
- `build-linux` - Linux build must succeed
- `build-android` - Android build must succeed (compile-only)

### Additional Rules

- **Enforce restrictions for administrators**: Yes
- **Require linear history**: No
- **Allow force pushes**: No
- **Allow deletions**: No

## Development Branch (`develop`)

If used, the `develop` branch has lighter protection:

### Pull Request Requirements

- **Required approving reviews**: 0 (self-merge allowed)
- **Dismiss stale reviews**: No
- **Require code owner reviews**: No

### Status Checks

- `build-linux` - Linux build must succeed

## Feature Branches

Feature branches follow the naming convention:

- `feature/<feature-name>` - New features
- `bugfix/<bug-name>` - Bug fixes
- `hotfix/<hotfix-name>` - Urgent fixes
- `release/<version>` - Release preparation
- `docs/<doc-name>` - Documentation updates

## Branch Workflow

1. **Create feature branch** from `main` (or `develop` if active)
2. **Make changes** in feature branch
3. **Create pull request** to `main` (or `develop`)
4. **Code review** and approval
5. **Merge** to `main` (or `develop`)

For releases:

1. **Create release branch** from `main`
2. **Prepare release** (version bump, changelog update)
3. **Merge** to `main`

## Rules for Contributors

1. **Never push directly** to `main`
2. **Always create a branch** for your work
3. **Keep branches up to date** with their base
4. **Delete branches** after merging
5. **Use meaningful branch names**

## Emergency Procedures

### Hotfix Process

1. Create `hotfix/<name>` from `main`
2. Make minimal changes to fix the issue
3. Create pull request to `main`
4. After merge, cherry-pick or backport to `develop` if applicable

### Breaking Changes

1. Discuss in issue first
2. Create `breaking/<name>` from `main`
3. Document all breaking changes
4. Update version according to semver
5. Create pull request with detailed description

## Configuration

Branch protection is configured in the repository's GitHub Settings (`Settings > Branches`).

## References

- [GitHub Branch Protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule)
- [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow)
