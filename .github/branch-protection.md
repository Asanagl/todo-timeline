# Branch Protection Rules

This document describes the branch protection rules configured for this repository.

## Main Branch (`main`)

The `main` branch is protected with the following rules:

### Pull Request Requirements

- **Required approving reviews**: 1
- **Dismiss stale reviews**: Yes
- **Require code owner reviews**: Yes
- **Restrict dismissals**: No

### Status Checks

The following status checks must pass before merging:

- `build-windows` - Windows build must succeed
- `build-linux` - Linux build must succeed
- `build-android` - Android build must succeed
- `test` - Tests must pass

### Additional Rules

- **Enforce restrictions for administrators**: Yes
- **Require linear history**: No
- **Allow force pushes**: No
- **Allow deletions**: No

## Development Branch (`develop`)

The `develop` branch has lighter protection:

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

## Branch Workflow

1. **Create feature branch** from `develop`
2. **Make changes** in feature branch
3. **Create pull request** to `develop`
4. **Code review** and approval
5. **Merge** to `develop`
6. **Create release branch** from `develop`
7. **Merge** to `main` and `develop`

## Rules for Contributors

1. **Never push directly** to `main` or `develop`
2. **Always create a branch** for your work
3. **Keep branches up to date** with their base
4. **Delete branches** after merging
5. **Use meaningful branch names**

## Emergency Procedures

### Hotfix Process

1. Create `hotfix/<name>` from `main`
2. Make minimal changes to fix the issue
3. Create pull request to `main`
4. After merge, cherry-pick to `develop`

### Breaking Changes

1. Discuss in issue first
2. Create `breaking/<name>` from `develop`
3. Document all breaking changes
4. Update version according to semver
5. Create pull request with detailed description

## Configuration

Branch protection is configured in `.github/settings.yml`.

## References

- [GitHub Branch Protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule)
- [Git Flow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
- [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow)
