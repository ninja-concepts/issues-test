# Branch Protection Configuration Guide

This guide helps you configure branch protection rules to enforce your Git Flow workflow and maintain code quality.

## Overview

Branch protection rules prevent force pushes, require status checks, and enforce review requirements on important branches.

## Recommended Settings

### Main Branch Protection

**Branch:** `main`

**Settings:**
- ✅ Restrict pushes that create files larger than 100 MB
- ✅ Require a pull request before merging
  - ✅ Require approvals: **1** (minimum)
  - ✅ Dismiss stale PR approvals when new commits are pushed
  - ✅ Require review from code owners (if CODEOWNERS file exists)
- ✅ Require status checks to pass before merging
  - ✅ Require branches to be up to date before merging
  - Required status checks (configure based on your CI):
    - `CI / test` (if using GitHub Actions)
    - `CI / lint` (if using linting checks)
    - `CI / build` (if using build verification)
- ✅ Require conversation resolution before merging
- ✅ Require signed commits (recommended for security)
- ✅ Require linear history
- ✅ Include administrators (applies rules to repo admins too)
- ✅ Allow force pushes: **Everyone** (disabled - no force pushes allowed)
- ✅ Allow deletions: **Disabled**

### Develop Branch Protection

**Branch:** `develop`

**Settings:**
- ✅ Restrict pushes that create files larger than 100 MB
- ✅ Require a pull request before merging
  - ✅ Require approvals: **1** (minimum)
  - ✅ Dismiss stale PR approvals when new commits are pushed
- ✅ Require status checks to pass before merging
  - ✅ Require branches to be up to date before merging
  - Required status checks:
    - `CI / test`
    - `CI / lint`
    - `CI / build`
- ✅ Require conversation resolution before merging
- ✅ Include administrators
- ✅ Allow force pushes: **Disabled**
- ✅ Allow deletions: **Disabled**

## Step-by-Step Configuration

### Via GitHub Web Interface

1. **Navigate to Repository Settings**
   - Go to your repository on GitHub
   - Click "Settings" tab
   - Click "Branches" in left sidebar

2. **Add Branch Protection Rule for `main`**
   - Click "Add rule"
   - Branch name pattern: `main`
   - Configure settings as listed above
   - Click "Create"

3. **Add Branch Protection Rule for `develop`**
   - Click "Add rule" again
   - Branch name pattern: `develop`
   - Configure settings as listed above
   - Click "Create"

### Via GitHub CLI

```bash
# Protect main branch
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["CI / test","CI / lint","CI / build"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true}' \
  --field restrictions=null

# Protect develop branch  
gh api repos/:owner/:repo/branches/develop/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["CI / test","CI / lint","CI / build"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true}' \
  --field restrictions=null
```

## Status Checks Integration

Your branch protection should integrate with your CI/CD pipeline. Common status checks include:

### GitHub Actions (if using)
```yaml
# Example status check names from your workflows:
- "CI / test"           # Test suite
- "CI / lint"           # Code linting  
- "CI / build"          # Build verification
- "CI / security-scan"  # Security scanning
- "CI / type-check"     # TypeScript checking
```

### External CI Services
```yaml
# Examples for other CI services:
- "ci/circleci: test"
- "continuous-integration/travis-ci/pr"
- "Jenkins/build"
```

## Git Flow Integration

These protection rules enforce your Git Flow workflow:

### What's Protected
- **Direct pushes to `main`** - Blocked, must go through PR
- **Direct pushes to `develop`** - Blocked, must go through PR
- **Incomplete features** - Status checks prevent broken code
- **Unreviewed changes** - Require at least one approval

### What's Allowed
- **Feature branches** - No restrictions, full development freedom
- **Hotfix workflow** - Can target `main` through emergency PR process
- **Release branches** - Can merge to `main` after testing

## Emergency Procedures

### Hotfix Process
1. Create `hotfix/issue-XXX-description` from `main`
2. Make minimal fix
3. Create PR targeting `main`
4. Get expedited review (consider temporarily reducing approval requirements if needed)
5. Merge to `main`
6. Tag release
7. Cherry-pick or merge back to `develop`

### Temporary Rule Bypass
If admin override is needed:

1. **Disable rule temporarily**
   ```bash
   # Via GitHub CLI - disable enforcement
   gh api repos/:owner/:repo/branches/main/protection \
     --method PUT \
     --field enforce_admins=false
   ```

2. **Make emergency change**

3. **Re-enable protection**
   ```bash
   # Re-enable enforcement
   gh api repos/:owner/:repo/branches/main/protection \
     --method PUT \
     --field enforce_admins=true
   ```

## Testing Branch Protection

After setup, test that rules work:

```bash
# This should fail:
git checkout main
echo "test" >> README.md
git add README.md
git commit -m "test direct push"
git push origin main
# Should be rejected by GitHub

# This should work:
git checkout -b test-branch-protection
git push origin test-branch-protection
# Create PR via GitHub UI - should require approval
```

## Monitoring and Maintenance

### Regular Review
- Review protection rules quarterly
- Update required status checks when CI changes
- Verify rules match current workflow needs

### Metrics to Monitor
- PR approval time
- Failed status check frequency
- Emergency override usage
- Developer feedback on workflow friction

## Troubleshooting

### Common Issues

**Status checks always failing:**
- Verify status check names match your CI configuration exactly
- Check that CI workflows run on pull requests
- Ensure status checks are not case-sensitive mismatches

**Reviewers not available:**
- Set up CODEOWNERS file for automatic reviewer assignment
- Consider multiple required reviewers for critical areas
- Have backup reviewers identified

**Emergency changes blocked:**
- Document emergency override process
- Ensure admin access for critical situations
- Consider separate hotfix approval workflow

### Support
- GitHub Branch Protection Documentation: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches
- GitHub CLI Documentation: https://cli.github.com/manual/gh_api