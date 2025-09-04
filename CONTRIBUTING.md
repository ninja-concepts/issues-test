# Contributing Guidelines

Thank you for contributing to this project! This guide will help you understand our development workflow and conventions.

## Git Flow Workflow

We use Git Flow for structured development. Here's how it works:

### Branch Structure

#### Main Branches
- **`main`** - Production-ready code only. All releases are tagged here.
- **`develop`** - Integration branch where features are merged before release.

#### Supporting Branches
- **`feature/issue-{number}-{description}`** - New features and enhancements
- **`bugfix/issue-{number}-{description}`** - Bug fixes for the develop branch
- **`hotfix/issue-{number}-{description}`** - Critical fixes for production
- **`release/v{version}`** - Prepare releases (version bumps, final testing)

### Development Workflow

#### 1. Working on a New Feature
```bash
# Start from develop
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/issue-123-add-user-login

# Work on your feature, make commits
git add .
git commit -m "feat(auth): add user login functionality

Implements user authentication with email/password
- Add login form component
- Add authentication service
- Add route protection

Closes #123"

# Push and create PR
git push origin feature/issue-123-add-user-login
```

#### 2. Working on a Bug Fix
```bash
# Start from develop
git checkout develop
git pull origin develop

# Create bugfix branch
git checkout -b bugfix/issue-456-fix-validation-error

# Fix the bug, commit changes
git commit -m "fix(validation): resolve form validation error

Fix email validation not triggering on blur event

Fixes #456"
```

#### 3. Creating a Hotfix
```bash
# Start from main for critical production issues
git checkout main
git pull origin main

# Create hotfix branch
git checkout -b hotfix/issue-789-critical-security-fix

# Fix the issue, commit
git commit -m "fix(security): patch XSS vulnerability

Sanitize user input to prevent script injection

Fixes #789"

# Hotfix PRs should target both main AND develop
```

### Pull Request Guidelines

#### Branch Targets
- `feature/*` and `bugfix/*` branches → `develop`
- `hotfix/*` branches → `main` (and cherry-pick to `develop`)
- `release/*` branches → `main`

#### PR Requirements
- Use the PR template checklist
- Link to related issues using keywords: `Closes #123`, `Fixes #456`, `Resolves #789`
- Ensure all CI checks pass
- Get at least one code review approval
- Keep PRs focused and atomic

## Commit Message Conventions

### Format
```
type(scope): brief description

Detailed explanation (optional)

Closes #123
```

### Types
- **`feat`**: New feature or enhancement
- **`fix`**: Bug fix
- **`docs`**: Documentation changes
- **`refactor`**: Code refactoring (no functional changes)
- **`test`**: Adding or updating tests
- **`chore`**: Maintenance, dependencies, build tools
- **`perf`**: Performance improvements
- **`style`**: Code style/formatting changes

### Scope (Optional)
Indicates the area of codebase affected:
- `auth`, `api`, `ui`, `database`, `config`, etc.

### Examples
```bash
# Feature
feat(auth): implement OAuth2 login integration

# Bug fix  
fix(api): resolve 500 error on user creation

# Documentation
docs: update API documentation for v2.0

# Refactoring
refactor(database): optimize user query performance
```

## Issue Management

### Labels and Automation
Our project uses automated issue management:

#### Priority Labels
- `priority:critical` - Immediate attention required
- `priority:high` - Important, address soon
- `priority:medium` - Normal priority
- `priority:low` - Nice to have

#### Type Labels
- `bug` - Something isn't working
- `enhancement` - New feature or improvement
- `documentation` - Documentation related
- `technical` - Technical debt or infrastructure

### Issue Lifecycle
1. **New Issue** → Automatically added to project board as "Backlog"
2. **Development** → Manually move to "In Progress" when starting work
3. **PR Created** → Keep in "In Progress"
4. **PR Merged** → Automatically moves to "Dev Complete" (if PR contains issue link)
5. **QA/Review** → Manual process
6. **Done** → Manual completion after verification

## Development Setup

### Prerequisites
- Node.js (version specified in `.nvmrc` if present)
- Git configured with your name and email

### Initial Setup
```bash
# Clone the repository
git clone <repository-url>
cd <project-name>

# Install dependencies
npm install

# Set up Git Flow (if using git-flow extension)
git flow init

# Or manually create develop branch
git checkout -b develop
git push origin develop
```

### Running Tests
```bash
# Run all tests
npm test

# Run with coverage
npm run test:coverage

# Run linting
npm run lint
```

## Code Review Guidelines

### For Authors
- Keep PRs small and focused
- Write clear commit messages
- Add tests for new functionality
- Update documentation as needed
- Respond promptly to review feedback

### For Reviewers
- Be constructive and helpful
- Focus on code quality, logic, and maintainability
- Test the changes locally if needed
- Approve only when confident in the changes

## Release Process

### Creating a Release
```bash
# Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v1.2.0

# Update version numbers, changelog, etc.
# Commit changes
git commit -m "chore(release): prepare v1.2.0"

# Create PR to main
# After PR approval and merge:
git checkout main
git pull origin main
git tag v1.2.0
git push origin v1.2.0

# Merge back to develop
git checkout develop
git merge main
git push origin develop
```

## Getting Help

- Check existing issues and documentation first
- Create a new issue for bugs or feature requests
- Use clear, descriptive titles and provide context
- Follow the issue templates

## Code of Conduct

- Be respectful and professional
- Welcome newcomers and help them learn
- Focus on what is best for the community
- Show empathy towards other community members