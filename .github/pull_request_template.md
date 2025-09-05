## Pull Request Checklist

### Git Flow Requirements
- [ ] Branch follows naming convention: `feature/issue-{number}-{description}`, `bugfix/issue-{number}-{description}`, `hotfix/issue-{number}-{description}`, or `release/v{version}`
- [ ] Targeting correct base branch:
  - `feature/*` and `bugfix/*` → `develop`
  - `hotfix/*` and `release/*` → `main`
- [ ] Branch is up to date with target branch

### Issue Linking
- [ ] PR title clearly describes the change
- [ ] Linked to related issue using keywords below:

**Closes #** (replace with issue number)

### Code Quality
- [ ] Code follows project conventions and style guidelines
- [ ] All tests are passing
- [ ] New tests added for new functionality (if applicable)
- [ ] Documentation updated (if applicable)
- [ ] No merge conflicts

### Testing
- [ ] Manually tested the changes
- [ ] Verified no breaking changes to existing functionality
- [ ] Tested edge cases and error scenarios

### Review Requirements
- [ ] Ready for review
- [ ] All CI checks passing
- [ ] At least one reviewer assigned

## Description
Brief description of what this PR accomplishes.

## Changes Made
- List the main changes
- Use bullet points
- Be specific but concise

## Testing Instructions
1. Steps to test the changes
2. Expected behavior
3. Any special setup required

## Additional Notes
Any additional context, screenshots, or considerations for reviewers.