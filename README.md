# GitHub Issues + Projects Workflow Demo

A comprehensive demonstration of GitHub's native Issues and Projects workflow, showing how developers can manage tasks, features, and bugs seamlessly within the GitHub ecosystem. This project showcases issue templates, project automation, and Git Flow integration that keeps developers in their natural environment.

> **Note**: The TypeScript/Node.js code in this repository is purely for CI/CD demonstration purposes. The real value lies in the **templates, automation, and workflow integration**.

## 🎯 What This Demonstrates

- **Issue Templates**: Structured, validated templates for Features, Bugs, and Technical tasks
- **Automatic Project Management**: Issues automatically appear on project boards with proper categorization
- **Commit-Driven Workflow**: Git commit messages advance issue status without manual updates
- **Seamless Integration**: Everything happens within GitHub - no context switching between tools
- **Developer-Centric Automation**: Workflows designed around how developers actually work

## 🚀 Quick Start for Developers

### 1. Clone and Explore
```bash
git clone <repository-url>
cd issues-test

# Install dependencies (for CI/CD demo only)
npm install
```

### 2. Try the Workflow
1. **Create an Issue**: Use one of the issue templates (Feature, Bug, or Technical)
2. **Create a Branch**: Follow the naming convention `feature/issue-123-description`
   - Issue automatically moves to "In Progress" when branch is pushed
3. **Develop**: Write code, make commits with proper messages
4. **Create PR**: Link to the issue with `Closes #123` in the description
5. **Watch Magic**: Issue automatically moves to "Dev Complete" when PR merges

### 3. Observe the Automation
- New issues automatically appear on the project board
- Branch creation moves issues to "In Progress" status
- Commit messages with `Closes #123` trigger status updates
- Priority labels automatically update project fields
- Testing workflows activate with label changes

## 👨‍💻 Developer Workflow

### Creating Issues
Use the provided templates for consistency:

- **🎨 Feature Request** (`feature.yml`): New functionality with design requirements
- **🐛 Bug Report** (`bug.yml`): Issues with reproduction steps and priority
- **🔧 Technical Task** (`technical.yml`): Refactoring, infrastructure, security work

Each template includes:
- Required fields that ensure completeness
- Automatic project board assignment
- Priority and estimation fields
- Dependency tracking

### Branch Management
Follow Git Flow conventions:
```bash
# Feature development
git checkout -b feature/issue-123-user-authentication

# Bug fixes  
git checkout -b bugfix/issue-456-login-validation

# Hotfixes
git checkout -b hotfix/issue-789-security-patch
```

### Commit Messages That Work
Your commit messages automatically advance issue status:
```bash
git commit -m "feat(auth): implement user login system

Add JWT-based authentication with session management
- Create login/logout endpoints
- Add middleware for route protection
- Implement token refresh mechanism

Closes #123"
```

When this commit is merged via PR, issue #123 automatically moves to "Dev Complete" status.

### Pull Request Integration
Create PRs that link to issues:
- Use `Closes #123`, `Fixes #456`, or `Resolves #789` in PR description
- Follow the PR template checklist
- CI automatically runs tests, linting, and builds
- Issues advance through workflow stages automatically

## 🎨 Issue Templates Deep Dive

### Feature Request Template
Perfect for new functionality with stakeholder input:
- **Figma Link**: Design specifications (required)
- **Design Approval**: Checkbox for design team sign-off  
- **Acceptance Criteria**: Clear requirements for completion
- **Story Points**: Fibonacci estimation (1,2,3,5,8,13)
- **Dependencies**: Links to blocking issues

### Bug Report Template  
Structured bug reporting with priority handling:
- **Priority**: Critical, High, Medium, Low (automatically updates project board)
- **Reproduction Steps**: Numbered, clear steps to reproduce
- **Expected vs Actual Behavior**: Clear problem definition
- **Testing Criteria**: How to verify the fix works

### Technical Task Template
For internal development work:
- **Task Type**: Refactoring, Infrastructure, Security, Documentation
- **Current State → Desired State**: Clear before/after definition
- **Technical Requirements**: Specific implementation details
- **Testing Strategy**: How to validate technical changes

## ⚙️ Automation in Action

### Issue Lifecycle
1. **Created** → Automatically added to project board as "Backlog"
2. **Branch Created** → Moves to "In Progress" when Git Flow branch is created (e.g., `feature/issue-123-*`)
3. **Labeled** → Priority automatically updated based on labels
4. **PR Linked** → Stays in current status during development
5. **PR Merged** → Moves to "Dev Complete" when commit contains `Closes #123`
6. **Testing** → Manual move to testing, or automated via labels
7. **Done** → Closed automatically or manually

### Branch Creation Automation
Creating branches with Git Flow naming automatically updates issue status:
- `feature/issue-123-description` → Moves issue #123 to "In Progress"
- `bugfix/issue-456-fix-name` → Moves issue #456 to "In Progress"
- `hotfix/issue-789-urgent-fix` → Moves issue #789 to "In Progress"

This happens automatically via GitHub Actions when you push new branches to the repository.

### Commit Message Automation
These commit message patterns trigger automatic issue advancement:
- `Closes #123` → Moves issue to "Dev Complete"
- `Fixes #456` → Moves issue to "Dev Complete"  
- `Resolves #789` → Moves issue to "Dev Complete"

### Priority Label Automation
Adding these labels automatically updates project priority fields:
- `priority:critical` → Critical priority
- `priority:high` → High priority
- `priority:medium` → Medium priority
- `priority:low` → Low priority

## 📊 Project Board Configuration

### Custom Fields
- **Status**: Backlog → Sprint Ready → In Progress → Dev Complete → Testing → Done
- **Priority**: Critical → High → Medium → Low  
- **Story Points**: Fibonacci sequence (1, 2, 3, 5, 8, 13)
- **Issue Type**: Feature, Bug, Technical, Research, Documentation

### Automated Views
- **🏃 Sprint Board**: Kanban view of active work
- **📋 Backlog**: Prioritized list of upcoming work
- **🧪 Testing Queue**: Items ready for QA
- **🚫 Blocked Items**: Dependencies and blockers

## 🛠️ Setup for Your Project

### 1. Copy Templates
```bash
# Copy issue templates
cp -r .github/ISSUE_TEMPLATE/ /your/project/.github/
cp .github/pull_request_template.md /your/project/.github/

# Copy automation workflows  
cp -r .github/workflows/ /your/project/.github/
```

### 2. Configure Project Board
Run the setup script to create standardized project board:
```bash
./scripts/setup-project.sh
```

### 3. Set Repository Variables
Configure GitHub Actions automation:
```bash
gh variable set PROJECT_ID --body "your-project-id"
gh variable set STATUS_FIELD_ID --body "your-status-field-id"
gh variable set BACKLOG_OPTION_ID --body "your-backlog-option-id"
gh variable set DEV_COMPLETE_OPTION_ID --body "your-dev-complete-option-id"
# ... (see CONTRIBUTING.md for complete list)
```

### 4. Configure AI-Assisted Workflow (Optional)
Set up AI assistance for commit messages and pull requests:
```bash
# Set your OpenAI API key
export OPENAI_API_KEY="your-api-key-here"

# Test AI workflow
./scripts/ai-workflow.sh --help
```

### 5. Test the Workflow
1. Create a test issue using one of the templates
2. Create a branch following the naming convention
3. Make commits (use AI assistance: `./scripts/ai-commit.sh`)
4. Create a PR (use AI assistance: `./scripts/ai-pr.sh`)
5. Merge PR and observe automatic issue status update

## 🎭 Demo Application (For CI/CD Only)

The included TypeScript/Express API serves solely to demonstrate CI/CD integration:

### Available Endpoints
- `GET /` - Welcome message
- `GET /api/users` - List users
- `GET /api/users/:id` - Get user by ID

### Development Commands
```bash
npm run dev        # Start development server
npm run test       # Run test suite
npm run lint       # Check code style  
npm run typecheck  # Validate TypeScript
npm run build      # Build for production
```

### CI/CD Pipeline
The GitHub Actions workflow demonstrates quality gates:
1. **Lint** - Code style validation
2. **Type Check** - TypeScript validation
3. **Test** - Jest test suite
4. **Build** - Production build verification  
5. **Security Scan** - Dependency vulnerability check
6. **Integration** - End-to-end workflow validation

Branch protection rules require all checks to pass before merge.

## 📋 Templates & Configuration Files

### Key Files
- `.github/ISSUE_TEMPLATE/` - Issue templates with validation
- `.github/pull_request_template.md` - PR template with Git Flow checklist
- `.github/workflows/` - Automation workflows
- `scripts/` - Setup and configuration scripts (including AI-assisted workflow)
- `CONTRIBUTING.md` - Complete Git Flow workflow guide

### Customization
Each template can be customized by:
1. Editing the `.yml` files in `.github/ISSUE_TEMPLATE/`
2. Modifying field options and validation rules
3. Adjusting automation workflows in `.github/workflows/`
4. Updating project board configuration

## 🤖 AI-Assisted Development Workflow

Reduce menial development tasks with AI-powered automation for commit messages and pull requests.

### Available Scripts

#### `./scripts/ai-commit.sh`
Generate conventional commit messages from your staged changes:
- Analyzes `git diff --staged` to understand changes
- Creates properly formatted commit messages with conventional prefixes
- Auto-detects issue numbers from branch names
- Includes detailed descriptions and bullet points
- Adds `Closes #123` when appropriate

#### `./scripts/ai-pr.sh`  
Generate pull request titles and descriptions:
- Analyzes commit history and changes
- Fills out your PR template automatically
- Includes proper issue linking and testing instructions
- Respects Git Flow branch targeting rules
- Uses your existing PR template format

#### `./scripts/ai-workflow.sh`
Complete end-to-end workflow automation:
- Optional project status updates (move issues to "In Progress")
- Interactive file staging
- AI-generated commit creation
- Branch pushing and PR creation
- Full workflow validation and error handling

### Setup and Usage

```bash
# 1. Set your OpenAI API key
export OPENAI_API_KEY="your-api-key-here"

# 2. Use individual scripts
./scripts/ai-commit.sh      # Generate commit message
./scripts/ai-pr.sh          # Generate pull request

# 3. Or use the complete workflow
./scripts/ai-workflow.sh    # Interactive full workflow
./scripts/ai-workflow.sh --commit-only  # Just AI commit
./scripts/ai-workflow.sh --pr-only      # Just AI PR
```

### AI Integration Benefits
- **Consistent Formatting**: Always follows your established conventions
- **Time Savings**: Eliminates writing repetitive commit/PR descriptions
- **Context Awareness**: Understands your code changes and linked issues
- **Quality Improvement**: Generates comprehensive, professional descriptions
- **Workflow Integration**: Works seamlessly with existing GitHub automation

## 🔄 Git Flow Integration

This project demonstrates Git Flow with branch protection:

### Branch Strategy
- **`main`** - Production releases only
- **`develop`** - Integration branch for features  
- **`feature/*`** - New features and enhancements
- **`bugfix/*`** - Bug fixes for develop
- **`hotfix/*`** - Critical production fixes
- **`release/*`** - Release preparation

### Protection Rules
Both main and develop branches require:
- Pull request reviews (minimum 1 approval)
- All CI status checks passing
- Conversation resolution
- No direct pushes allowed

### Workflow Commands
```bash
# Feature development
git checkout develop
git pull origin develop
git checkout -b feature/issue-123-new-feature

# Make changes, commit with proper message
git commit -m "feat: implement new feature

Detailed description of changes made

Closes #123"

# Push and create PR
git push origin feature/issue-123-new-feature
gh pr create --title "feat: implement new feature" --body "Closes #123"
```

## 🧪 Testing the Setup

### Validation Checklist
- [ ] Issue templates show required field validation
- [ ] New issues automatically appear on project board
- [ ] Branch creation moves issues to "In Progress" status
- [ ] Priority labels update project priority fields
- [ ] PR merge with "Closes #123" moves issue to "Dev Complete"
- [ ] Branch protection prevents direct pushes to main/develop
- [ ] CI pipeline runs on all PRs

### Common Workflow Test
1. Create feature issue using template
2. Note issue appears on project board as "Backlog"
3. Create feature branch following naming convention (`feature/issue-N-description`)
4. Push branch and verify issue moves to "In Progress" status
5. Make commits and create PR linking to issue
6. Verify CI runs and status checks appear
7. Merge PR and confirm issue moves to "Dev Complete"

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed Git Flow workflow guide, including:
- Branch naming conventions
- Commit message standards
- Pull request requirements
- Code review process
- Release management

## 📚 Additional Resources

- [Git Flow Workflow Guide](docs/WORKFLOW.md) - Complete workflow with examples
- [Branch Protection Setup](docs/BRANCH_PROTECTION.md) - Security and quality controls
- [Issue Template Customization](CONTRIBUTING.md#templates) - Extending and modifying templates

## 🎉 Why This Approach Works

By keeping everything within GitHub's ecosystem:
- **Reduced Context Switching**: Developers never leave their code environment
- **Automatic Integration**: Git operations naturally advance project management
- **Consistent Workflow**: Same interface for code, issues, reviews, and project tracking
- **Developer-Friendly**: Tools that enhance rather than interrupt development flow
- **Transparent Process**: Every change is tracked, linked, and auditable through Git history

---

**Ready to transform your development workflow?** Start by creating your first issue using one of our templates and experience the seamless integration yourself.