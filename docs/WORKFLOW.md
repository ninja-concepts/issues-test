# Git Flow Workflow Guide

This document provides a comprehensive guide to our Git Flow workflow, including visual diagrams and practical commands for common development scenarios.

## Workflow Overview

```
main     ──●────●────●────●────●── (Production releases)
            │    │    │    │    │
            │    │   v1.1 │   v1.2
            │    │    │    │    │
develop  ───●────●────●────●────●── (Integration branch)
           /│   /│    │\   │\   │\
feature   ● │  ● │    │ ●  │ ●  │ ●
branches   \│   \│    │/   │/   │/
            ●    ●    ●    ●    ●
```

## Branch Types and Purposes

### Main Branches

#### `main` Branch
- **Purpose**: Production-ready code only
- **Lifetime**: Permanent
- **Protection**: High (protected, requires PR + reviews)
- **Deploy**: All commits trigger production deployment
- **Merges from**: `release/*`, `hotfix/*`

#### `develop` Branch  
- **Purpose**: Integration of new features
- **Lifetime**: Permanent
- **Protection**: Medium (protected, requires PR)
- **Deploy**: Staging/development environment
- **Merges from**: `feature/*`, `bugfix/*`, `hotfix/*`

### Supporting Branches

#### `feature/*` Branches
- **Purpose**: New features and enhancements
- **Lifetime**: Temporary (deleted after merge)
- **Naming**: `feature/issue-{number}-{brief-description}`
- **Branch from**: `develop`
- **Merge to**: `develop`

#### `bugfix/*` Branches
- **Purpose**: Bug fixes for development
- **Lifetime**: Temporary (deleted after merge)
- **Naming**: `bugfix/issue-{number}-{brief-description}`
- **Branch from**: `develop`  
- **Merge to**: `develop`

#### `release/*` Branches
- **Purpose**: Prepare releases (version bump, final testing)
- **Lifetime**: Temporary (deleted after merge)
- **Naming**: `release/v{major.minor.patch}`
- **Branch from**: `develop`
- **Merge to**: `main` (then back to `develop`)

#### `hotfix/*` Branches
- **Purpose**: Critical production fixes
- **Lifetime**: Temporary (deleted after merge)
- **Naming**: `hotfix/issue-{number}-{brief-description}`
- **Branch from**: `main`
- **Merge to**: `main` and `develop`

## Common Workflows

### 1. Feature Development

```bash
# 1. Start from develop
git checkout develop
git pull origin develop

# 2. Create feature branch
git checkout -b feature/issue-123-user-authentication

# 3. Work on feature (make multiple commits)
git add .
git commit -m "feat(auth): add login form component"
git add .
git commit -m "feat(auth): implement authentication service"
git add .
git commit -m "feat(auth): add route protection middleware

Complete user authentication system with login/logout
- Add JWT token handling
- Implement session management  
- Add protected route guards

Closes #123"

# 4. Push and create PR
git push origin feature/issue-123-user-authentication
# Create PR: feature/issue-123-user-authentication → develop
```

**Visual Flow:**
```
develop     ●────●────●──────●
             \         \    /
feature       ●─●─●─●───●───● (merged)
```

### 2. Bug Fix Development

```bash
# 1. Start from develop
git checkout develop
git pull origin develop

# 2. Create bugfix branch
git checkout -b bugfix/issue-456-validation-error

# 3. Fix the bug
git add .
git commit -m "fix(validation): resolve form validation timing issue

Fix email validation not triggering on blur event
- Update validation event listeners
- Add proper error state management

Fixes #456"

# 4. Push and create PR
git push origin bugfix/issue-456-validation-error
# Create PR: bugfix/issue-456-validation-error → develop
```

### 3. Release Process

```bash
# 1. Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v1.2.0

# 2. Prepare release (version bump, changelog, final testing)
# Update package.json, CHANGELOG.md, etc.
git add .
git commit -m "chore(release): prepare v1.2.0

- Bump version to 1.2.0
- Update changelog
- Final documentation updates"

# 3. Create PR to main
git push origin release/v1.2.0
# Create PR: release/v1.2.0 → main

# 4. After PR is merged to main:
git checkout main
git pull origin main

# 5. Tag the release
git tag v1.2.0
git push origin v1.2.0

# 6. Merge back to develop
git checkout develop
git merge main
git push origin develop

# 7. Delete release branch
git branch -d release/v1.2.0
git push origin --delete release/v1.2.0
```

**Visual Flow:**
```
main        ●────●────●─────●
             \    \    \   / (merge + tag v1.2.0)
develop      ●────●────●─●─●
                   \     /
release             ●─●─●  (deleted)
```

### 4. Hotfix Process

```bash
# 1. Create hotfix from main (critical production issue)
git checkout main
git pull origin main
git checkout -b hotfix/issue-789-security-vulnerability

# 2. Make the minimal fix
git add .
git commit -m "fix(security): patch XSS vulnerability in user input

Sanitize user input to prevent script injection
- Add input validation middleware
- Update content security policy

Fixes #789"

# 3. Create PR to main (expedited review)
git push origin hotfix/issue-789-security-vulnerability
# Create PR: hotfix/issue-789-security-vulnerability → main

# 4. After merge to main, tag if needed
git checkout main
git pull origin main
git tag v1.1.1  # Patch version
git push origin v1.1.1

# 5. Merge/cherry-pick to develop
git checkout develop
git merge main  # or cherry-pick the hotfix commits
git push origin develop

# 6. Delete hotfix branch
git branch -d hotfix/issue-789-security-vulnerability
git push origin --delete hotfix/issue-789-security-vulnerability
```

**Visual Flow:**
```
main        ●────●────●─────●
             \         \   /│ (hotfix merge)
             │          \ / │
             │           ●  │ (hotfix branch - deleted)
develop      ●────●──────●──● (merge from main)
```

## Integration with Project Automation

Your existing automation workflow integrates perfectly:

### Issue Lifecycle
1. **Issue Created** → Auto-added to project board ("Backlog")
2. **Branch Created** → Move issue to "In Progress" manually
3. **PR Created** → Issue stays "In Progress"
4. **PR Merged** → Auto-moves to "Dev Complete" (via automation)
5. **Release** → Manual move to "Done"

### Automation Triggers
- **PR merged to `develop`** → Issue moves to "Dev Complete"
- **PR merged to `main`** → Issue moves to "Dev Complete" 
- **Labels added** → Priority auto-updated
- **QA assignment** → Auto-assigned to QA team member

## Commands Reference

### Branch Management
```bash
# List all branches
git branch -a

# Switch branches
git checkout branch-name
git switch branch-name  # Git 2.23+

# Create and switch to new branch
git checkout -b new-branch-name
git switch -c new-branch-name  # Git 2.23+

# Delete branch (local)
git branch -d branch-name
git branch -D branch-name  # Force delete

# Delete branch (remote)
git push origin --delete branch-name

# Rename current branch
git branch -m new-branch-name
```

### Synchronization
```bash
# Update local branches with remote
git fetch origin

# Pull latest changes
git pull origin branch-name

# Push branch to remote
git push origin branch-name

# Push and set upstream
git push -u origin branch-name

# Rebase feature branch on latest develop
git checkout feature/my-feature
git rebase develop
```

### Conflict Resolution
```bash
# When merge conflicts occur:
git status                    # See conflicted files
# Edit files to resolve conflicts
git add resolved-file.js      # Stage resolved files  
git commit                    # Complete the merge

# Or abort merge/rebase
git merge --abort
git rebase --abort
```

## Git Flow Extensions

### Using git-flow Extension
```bash
# Install git-flow (macOS)
brew install git-flow

# Initialize in repository
git flow init

# Feature workflow
git flow feature start issue-123-user-auth
git flow feature publish issue-123-user-auth
git flow feature finish issue-123-user-auth

# Release workflow  
git flow release start v1.2.0
git flow release publish v1.2.0
git flow release finish v1.2.0

# Hotfix workflow
git flow hotfix start issue-789-security-fix
git flow hotfix publish issue-789-security-fix  
git flow hotfix finish issue-789-security-fix
```

## Best Practices

### Branch Naming
- Use lowercase with hyphens: `feature/issue-123-add-user-login`
- Include issue number: helps with tracking and automation
- Be descriptive but concise: `bugfix/issue-456-fix-validation-error`

### Commit Messages
- Follow conventional commits format
- Include issue references: `Closes #123`
- Use present tense: "Add feature" not "Added feature"
- Keep first line under 50 characters

### Pull Requests
- Use the PR template checklist
- Keep PRs focused and atomic
- Test thoroughly before requesting review
- Respond promptly to review feedback

### Code Reviews
- Review code, not the person
- Look for logic, maintainability, and security
- Test the changes if needed
- Provide constructive feedback

## Troubleshooting

### Common Issues

**Merge conflicts:**
```bash
# Prevention: keep branches up to date
git checkout develop
git pull origin develop
git checkout feature/my-feature  
git rebase develop
```

**Wrong base branch:**
```bash
# Change base branch of feature
git checkout feature/wrong-base
git rebase --onto develop wrong-base
```

**Accidentally committed to wrong branch:**
```bash
# Move commit to correct branch
git checkout correct-branch
git cherry-pick commit-hash
git checkout wrong-branch
git reset --hard HEAD~1
```

**Need to update PR with latest develop:**
```bash
git checkout feature/my-feature
git rebase develop
git push --force-with-lease origin feature/my-feature
```

## Monitoring and Metrics

Track these metrics for workflow health:

- **Lead time**: Issue creation to production deployment
- **Cycle time**: Development start to production deployment  
- **PR review time**: PR creation to merge
- **Hotfix frequency**: Number of production hotfixes
- **Branch age**: How long branches live before merge

## Additional Resources

- [Git Flow Original Article](https://nvie.com/posts/a-successful-git-branching-model/)
- [GitHub Flow Alternative](https://docs.github.com/en/get-started/quickstart/github-flow)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)

## Getting Help

If you're unsure about any part of this workflow:

1. Check this documentation first
2. Look at recent PRs for examples
3. Ask in team chat or create an issue
4. Pair with experienced team member for complex scenarios