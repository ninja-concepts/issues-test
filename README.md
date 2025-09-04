# GitHub Projects & Issues Complete Setup

A comprehensive, production-ready GitHub Projects and Issues management system with automated workflows, standardized templates, and sample data for demonstration purposes.

## 🌟 Features

- **📝 Enhanced Issue Templates**: Feature, Bug, and Technical task templates with validation
- **⚙️ Automated Workflows**: GitHub Actions for project automation and testing handoffs
- **📊 Standardized Project Board**: Consistent fields, views, and organization
- **🏷️ Label Management**: Comprehensive labeling system with priorities and categories  
- **📋 Sample Data Generation**: Realistic test issues for demonstrating your setup
- **🚀 One-Click Setup**: Automated scripts for complete project configuration

## 🏗️ Project Structure

```
.
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── feature.yml          # Feature request template
│   │   ├── bug.yml             # Bug report template
│   │   └── technical.yml       # Technical task template
│   ├── workflows/
│   │   ├── project-automation.yml    # Main project automation
│   │   └── testing-handoff.yml      # Testing workflow management
│   └── project-templates/
│       └── standard-project-template.json  # Project configuration
├── scripts/
│   ├── setup-project.sh        # Main project setup automation
│   ├── setup-labels.sh         # Label configuration script
│   └── generate-sample-issues.sh    # Sample data generator
└── README.md                   # This file
```

## 🚀 Quick Start

### Prerequisites

1. **GitHub CLI**: Install and authenticate with `gh auth login`
2. **Repository Access**: Admin permissions on the target repository
3. **GitHub App** (optional): For advanced project automation

### 1. Initial Setup

Clone or download these files to your repository:

```bash
# If starting from scratch
git clone <this-repo>
cd <your-project>

# Copy the template files
cp -r .github/ /path/to/your/repo/
cp -r scripts/ /path/to/your/repo/
```

### 2. Set Up Project Board

Run the main setup script to create your standardized project board:

```bash
./scripts/setup-project.sh
```

This script will:
- ✅ Create a new project board with standard fields
- ✅ Set up Status, Priority, Story Points, and Issue Type fields
- ✅ Configure project views (Sprint Board, Backlog, Testing Queue)
- ✅ Generate configuration file for GitHub Actions

### 3. Configure Labels

Set up comprehensive labeling system:

```bash
./scripts/setup-labels.sh
```

Creates labels for:
- Priority levels (critical, high, medium, low)
- Issue types and status indicators
- Team assignments and effort estimation
- Epic tracking and special purposes

### 4. Generate Sample Data

Create realistic sample issues to showcase your templates:

```bash
./scripts/generate-sample-issues.sh
```

Generates:
- 3 Feature issues with design approvals and acceptance criteria
- 2 Bug reports with reproduction steps and priorities
- 2 Technical tasks for infrastructure and security

### 5. Configure GitHub Actions

Set up repository variables for automation:

```bash
# Copy values from .github-project-config.env to repository variables
gh variable set PROJECT_ID --body "your-project-id"
gh variable set STATUS_FIELD_ID --body "your-status-field-id"
# ... (see configuration section below)
```

## 🎯 Issue Templates

### Feature Request Template (`feature.yml`)

Includes fields for:
- **Figma Link**: Design specifications (required)
- **Design Approval**: Checkbox for design team sign-off
- **Feature Description**: What and why of the feature
- **Acceptance Criteria**: Specific requirements checklist
- **Testing Criteria**: QA requirements and test scenarios
- **Dependencies**: Blocked by other issues
- **Story Points**: Fibonacci estimation (1,2,3,5,8,13)

### Bug Report Template (`bug.yml`)

Includes fields for:
- **Bug Description**: What's happening that shouldn't
- **Priority**: Critical, High, Medium, Low dropdown
- **Reproduction Steps**: Numbered steps to reproduce
- **Expected Behavior**: What should happen instead
- **Acceptance Criteria**: Requirements for fix
- **Testing Criteria**: Verification checklist
- **Dependencies**: Blocking issues
- **Story Points**: Effort estimation

### Technical Task Template (`technical.yml`)

Includes fields for:
- **Task Type**: Refactoring, Infrastructure, Security, etc.
- **Description**: Technical work requirements
- **Current State**: Existing situation
- **Desired State**: Target outcome
- **Acceptance Criteria**: Technical requirements
- **Testing Criteria**: Technical validation
- **Dependencies**: Required prerequisites
- **Priority & Story Points**: Standard estimation fields

## ⚙️ Automation Workflows

### Project Automation (`project-automation.yml`)

**Triggers:**
- Issue opened/closed/labeled
- Pull request opened/closed/merged

**Actions:**
- Auto-assigns new issues to project board
- Sets initial status to \"Backlog\"
- Moves issues to \"Dev Complete\" on PR merge
- Updates priority based on labels
- Assigns to QA team member when appropriate

### Testing Handoff (`testing-handoff.yml`)

**Triggers:**
- Issues labeled with \"testing\"
- Issue comments with testing keywords

**Actions:**
- Moves issues to \"Testing\" status
- Creates testing checklist comments
- Handles testing completion/failure
- Manages status transitions and assignments
- Optional Slack notifications

## 🏷️ Label System

### Priority Labels
- `priority:critical` 🔥 - Urgent, blocking issues
- `priority:high` ⚠️ - Important, address soon
- `priority:medium` 📝 - Normal priority
- `priority:low` 📌 - Nice-to-have improvements

### Issue Type Labels
- `feature` ✨ - New functionality
- `bug` 🐛 - Bug fixes
- `technical` 🔧 - Technical tasks
- `documentation` 📖 - Documentation updates
- `research` 📚 - Investigation tasks

### Status & Workflow Labels
- `needs-estimation` 🤔 - Needs story points
- `ready-for-dev` 🚀 - Ready for development
- `testing` 🧪 - In QA testing
- `blocked` 🚫 - Waiting on external dependency
- `completed` ✅ - Successfully finished

### Team Labels
- `team:frontend` 🎨 - Frontend responsibility
- `team:backend` ⚙️ - Backend responsibility
- `team:devops` 🚀 - DevOps responsibility
- `team:design` 🎨 - Design responsibility
- `team:qa` 🧪 - QA responsibility

## 📊 Project Board Configuration

### Custom Fields

1. **Status** (Single Select)
   - 📋 Backlog → 🚀 Sprint Ready → 🔄 In Progress → ✅ Dev Complete → 🧪 Testing → ✨ Done

2. **Priority** (Single Select)
   - 🔥 Critical → ⚠️ High → 📝 Medium → 📌 Low

3. **Story Points** (Number)
   - Fibonacci sequence: 1, 2, 3, 5, 8, 13

4. **Issue Type** (Single Select)
   - ✨ Feature, 🐛 Bug, 🔧 Technical, 📚 Research, 📖 Documentation

### Project Views

1. **🏃 Sprint Board**: Kanban view of current sprint work
2. **📋 Backlog**: Prioritized table view of all backlog items
3. **🧪 Testing Queue**: Items ready for or in testing
4. **📊 Sprint Planning**: Planning view with story points
5. **🚫 Blocked Items**: Issues waiting on dependencies
6. **📈 Team Overview**: Work grouped by responsible team

## ⚙️ GitHub Actions Configuration

### Required Repository Variables

Add these to your repository settings → Variables:

```bash
# Project Configuration
PROJECT_ID=your-project-id
STATUS_FIELD_ID=your-status-field-id  
PRIORITY_FIELD_ID=your-priority-field-id

# Status Options
BACKLOG_OPTION_ID=your-backlog-option-id
DEV_COMPLETE_OPTION_ID=your-dev-complete-option-id
TESTING_OPTION_ID=your-testing-option-id
DONE_OPTION_ID=your-done-option-id
IN_PROGRESS_OPTION_ID=your-in-progress-option-id

# Priority Options
CRITICAL_PRIORITY_ID=your-critical-priority-id
HIGH_PRIORITY_ID=your-high-priority-id
MEDIUM_PRIORITY_ID=your-medium-priority-id
LOW_PRIORITY_ID=your-low-priority-id

# Team Settings
QA_ASSIGNEE=github-username-for-qa
```

### Required Repository Secrets

```bash
# GitHub App (for enhanced permissions)
PROJECT_APP_KEY=your-github-app-private-key

# Optional: Slack Integration
SLACK_TESTING_WEBHOOK=your-slack-webhook-url
```

### GitHub App Setup (Advanced)

For full automation capabilities, create a GitHub App:

1. Go to Settings → Developer settings → GitHub Apps
2. Create new GitHub App with permissions:
   - Issues: Read & Write
   - Pull requests: Read & Write  
   - Projects: Write
3. Generate and download private key
4. Install app on your repository
5. Add app ID to `PROJECT_APP_ID` variable
6. Add private key to `PROJECT_APP_KEY` secret

## 🧪 Testing the Setup

### 1. Create Test Issues

Use the issue templates to create sample issues and verify:
- Fields populate correctly
- Issues auto-assign to project
- Labels and priorities work
- Validation requirements function

### 2. Test Automation Workflows

1. Create a pull request that \"Closes #123\"
2. Merge the PR and verify issue moves to \"Dev Complete\"
3. Add \"testing\" label to an issue
4. Verify testing workflow triggers
5. Comment \"testing complete\" to verify completion flow

### 3. Verify Project Views

Check that all project views display correctly:
- Sprint board shows proper status columns
- Backlog sorts by priority
- Testing queue filters appropriately
- Story points calculate correctly

## 📚 Best Practices

### Issue Management
- Always fill out required template fields
- Use consistent labeling for better organization
- Keep story points realistic (prefer smaller tasks)
- Link related issues in comments or descriptions

### Project Workflow
- Move issues through status columns systematically
- Use \"Blocked\" status for dependency issues
- Assign team labels for clear ownership
- Review backlog regularly for priority changes

### Automation Optimization
- Use PR descriptions to link issues (\"Closes #123\")
- Apply priority labels consistently
- Comment \"testing complete\" for automatic closure
- Review GitHub Actions logs for troubleshooting

## 🤝 Contributing

### Adding New Templates

1. Create new `.yml` file in `.github/ISSUE_TEMPLATE/`
2. Follow existing template structure
3. Add `projects: [\"Standard Project Board\"]` field
4. Test template validation

### Extending Automation

1. Modify workflow files in `.github/workflows/`
2. Add new triggers or actions as needed
3. Update repository variables if new fields required
4. Test changes in staging environment first

### Customizing Project Fields

1. Edit `standard-project-template.json`
2. Run `setup-project.sh` to apply changes
3. Update automation workflows with new field IDs
4. Document changes in this README

## 🐛 Troubleshooting

### Common Issues

**Issue templates not showing:**
- Check file syntax with YAML validator  
- Verify files are in `.github/ISSUE_TEMPLATE/` directory
- Ensure proper indentation and required fields

**Automation not working:**
- Verify GitHub Actions variables are set correctly
- Check workflow run logs in Actions tab
- Ensure GitHub App has proper permissions
- Verify project and field IDs are correct

**Project board not updating:**
- Check repository is linked to project
- Verify field IDs match in workflows
- Ensure automation workflows are enabled
- Check for GitHub API rate limits

### Getting Help

1. Check GitHub Actions logs for error details
2. Verify all configuration values in `.github-project-config.env`
3. Test individual workflow components
4. Consult GitHub API documentation for GraphQL queries

## 📄 License

This project template is available under the MIT License. Feel free to customize and distribute according to your needs.

---

**🎉 You now have a complete, production-ready GitHub Projects and Issues management system!**

The setup includes automated workflows, comprehensive templates, and all the tooling needed to manage projects effectively. Your team can now focus on building great software instead of managing project overhead.