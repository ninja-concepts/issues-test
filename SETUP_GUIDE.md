# 🚀 Quick Setup Guide

## Prerequisites Checklist

Before starting, ensure you have:

- [ ] GitHub CLI installed (`gh --version`)
- [ ] GitHub CLI authenticated (`gh auth status`)
- [ ] Admin permissions on target repository
- [ ] Repository cloned locally

## 🎯 Step-by-Step Setup

### Step 1: Verify Environment

```bash
# Check GitHub CLI
gh --version
gh auth status

# Check repository access
gh repo view
```

### Step 2: Set Up Project Board

```bash
# Run the main setup script
./scripts/setup-project.sh

# This will:
# ✅ Create project with standard fields  
# ✅ Set up Status, Priority, Story Points fields
# ✅ Generate configuration for GitHub Actions
```

### Step 3: Configure Labels

```bash
# Set up comprehensive labeling system
./scripts/setup-labels.sh

# Creates:
# ✅ Priority labels (critical, high, medium, low)
# ✅ Team labels (frontend, backend, devops, design, qa)
# ✅ Status labels (ready-for-dev, testing, blocked, etc.)
# ✅ Size estimation labels (xs, s, m, l, xl, xxl)
```

### Step 4: Generate Sample Data

```bash
# Create realistic test issues
./scripts/generate-sample-issues.sh

# Generates:
# ✅ 3 Feature requests with design specs
# ✅ 2 Bug reports with reproduction steps  
# ✅ 2 Technical tasks for infrastructure work
```

### Step 5: Configure GitHub Actions

Copy values from `.github-project-config.env` to repository variables:

```bash
# Required variables (get values from .github-project-config.env)
gh variable set PROJECT_ID --body \"PVT_kwDOA...\"
gh variable set STATUS_FIELD_ID --body \"PVTSSF_...\"
gh variable set PRIORITY_FIELD_ID --body \"PVTSSF_...\"

# Status option IDs
gh variable set BACKLOG_OPTION_ID --body \"PVTSSO_...\"
gh variable set DEV_COMPLETE_OPTION_ID --body \"PVTSSO_...\"
gh variable set TESTING_OPTION_ID --body \"PVTSSO_...\"
gh variable set DONE_OPTION_ID --body \"PVTSSO_...\"
gh variable set IN_PROGRESS_OPTION_ID --body \"PVTSSO_...\"

# Priority option IDs  
gh variable set CRITICAL_PRIORITY_ID --body \"PVTSSO_...\"
gh variable set HIGH_PRIORITY_ID --body \"PVTSSO_...\"
gh variable set MEDIUM_PRIORITY_ID --body \"PVTSSO_...\"
gh variable set LOW_PRIORITY_ID --body \"PVTSSO_...\"

# Team settings
gh variable set QA_ASSIGNEE --body \"qa-team-member\"
```

### Step 6: Test the Setup

1. **Create a test issue** using one of the templates
2. **Verify project automation** - issue should auto-assign to project
3. **Test PR workflow** - create PR with \"Closes #123\" and merge
4. **Test testing workflow** - add \"testing\" label to an issue

## ⚡ Advanced Configuration (Optional)

### GitHub App Setup

For enhanced automation, create a GitHub App:

1. Go to Settings → Developer settings → GitHub Apps → New GitHub App
2. Set permissions:
   - Issues: Read & Write
   - Pull requests: Read & Write
   - Projects: Write
3. Generate private key
4. Install on repository
5. Add secrets:

```bash
gh secret set PROJECT_APP_ID --body \"123456\"
gh secret set PROJECT_APP_KEY --body \"$(cat private-key.pem)\"
```

### Slack Integration

For testing notifications:

```bash
gh secret set SLACK_TESTING_WEBHOOK --body \"https://hooks.slack.com/services/...\"
```

## 🧪 Verification Steps

### ✅ Issue Templates Working
- Go to Issues → New Issue
- Verify all 3 templates appear (Feature, Bug, Technical)  
- Test form validation and required fields

### ✅ Project Board Configured
- Navigate to Projects tab
- Verify \"Standard Project Board\" exists
- Check all custom fields and views are present

### ✅ Automation Functioning
- Create test issue and verify auto-assignment
- Create PR linking to issue and test status updates
- Add labels and verify priority field updates

### ✅ Labels Configured
- Go to Issues → Labels  
- Verify comprehensive label set exists
- Test label application and colors

## 🎉 Success Indicators

When setup is complete, you should see:

- ✅ **3 Issue templates** available when creating new issues
- ✅ **Project board** with 6+ custom fields and multiple views
- ✅ **40+ labels** organized by category and priority
- ✅ **7 sample issues** demonstrating the templates
- ✅ **GitHub Actions** automating issue/PR workflows
- ✅ **Configuration file** with all necessary IDs

## 🚨 Troubleshooting

**\"Command not found\" errors:**
```bash
# Install GitHub CLI
brew install gh  # macOS
# or follow: https://cli.github.com/
```

**\"Authentication required\" errors:**
```bash
gh auth login
# Follow prompts to authenticate
```

**\"Permission denied\" errors:**
- Verify you have admin access to the repository
- Check organization permissions if applicable

**Automation not working:**
- Verify all GitHub Actions variables are set
- Check workflow run logs in repository Actions tab
- Ensure `.github/workflows/` files are committed

## 💡 Pro Tips

1. **Customize templates** in `.github/ISSUE_TEMPLATE/` before running setup
2. **Modify field names** in `scripts/setup-project.sh` for your needs  
3. **Add custom labels** in `scripts/setup-labels.sh`
4. **Backup configuration** - save `.github-project-config.env`
5. **Test in staging** repository first before production use

---

**🎯 Next Steps:** Once setup is complete, check out the full README.md for detailed usage instructions, best practices, and customization options.