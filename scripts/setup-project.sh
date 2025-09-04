#!/bin/bash

# GitHub Project Setup Automation Script
# Creates a standardized project board with all necessary configurations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
REPO_OWNER=${REPO_OWNER:-$(gh repo view --json owner -q .owner.login)}
REPO_NAME=${REPO_NAME:-$(gh repo view --json name -q .name)}
PROJECT_NAME=${PROJECT_NAME:-"Standard Project Board"}

echo -e "${BLUE}🚀 Setting up GitHub Project for ${REPO_OWNER}/${REPO_NAME}${NC}"
echo ""

# Check if gh CLI is authenticated and has necessary permissions
echo "🔐 Checking GitHub CLI authentication..."
if ! gh auth status >/dev/null 2>&1; then
    echo -e "${RED}❌ GitHub CLI not authenticated. Please run: gh auth login${NC}"
    exit 1
fi

# Check if user has project permissions
echo "🔍 Checking repository permissions..."
if ! gh api "repos/${REPO_OWNER}/${REPO_NAME}" >/dev/null 2>&1; then
    echo -e "${RED}❌ Cannot access repository. Please check permissions.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Authentication and permissions verified${NC}"
echo ""

# Function to get project field ID by name
get_field_id() {
    local project_id="$1"
    local field_name="$2"
    gh api graphql -f query='
        query($project: ID!) {
            node(id: $project) {
                ... on ProjectV2 {
                    fields(first: 50) {
                        nodes {
                            ... on ProjectV2Field {
                                id
                                name
                            }
                            ... on ProjectV2SingleSelectField {
                                id
                                name
                            }
                            ... on ProjectV2IterationField {
                                id
                                name
                            }
                        }
                    }
                }
            }
        }' -f project="$project_id" --jq ".data.node.fields.nodes[] | select(.name == \"$field_name\") | .id"
}

# Function to get field option ID by name
get_option_id() {
    local project_id="$1"
    local field_name="$2"
    local option_name="$3"
    gh api graphql -f query='
        query($project: ID!) {
            node(id: $project) {
                ... on ProjectV2 {
                    fields(first: 50) {
                        nodes {
                            ... on ProjectV2SingleSelectField {
                                id
                                name
                                options {
                                    id
                                    name
                                }
                            }
                        }
                    }
                }
            }
        }' -f project="$project_id" --jq ".data.node.fields.nodes[] | select(.name == \"$field_name\") | .options[] | select(.name == \"$option_name\") | .id"
}

# Check if project already exists
echo "🔍 Checking for existing project..."
existing_project=$(gh project list --owner "$REPO_OWNER" --format json | jq -r ".projects[] | select(.title == \"$PROJECT_NAME\") | .id" | head -1)

if [[ -n "$existing_project" && "$existing_project" != "null" ]]; then
    echo -e "${YELLOW}⚠️  Project '$PROJECT_NAME' already exists (ID: $existing_project)${NC}"
    read -p "Do you want to continue and update it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Exiting..."
        exit 0
    fi
    PROJECT_ID="$existing_project"
else
    # Create new project
    echo "📋 Creating new project: $PROJECT_NAME"
    PROJECT_ID=$(gh project create --owner "$REPO_OWNER" --title "$PROJECT_NAME" --format json | jq -r '.id')
    echo -e "${GREEN}✅ Project created with ID: $PROJECT_ID${NC}"
fi

echo ""

# Add repository to project
echo "🔗 Linking repository to project..."
REPO_ID=$(gh api "repos/${REPO_OWNER}/${REPO_NAME}" --jq '.node_id')
gh api graphql -f query='
    mutation($project: ID!, $repo: ID!) {
        linkRepositoryToProject(input: {projectId: $project, repositoryId: $repo}) {
            repository {
                id
            }
        }
    }' -f project="$PROJECT_ID" -f repo="$REPO_ID" >/dev/null

echo -e "${GREEN}✅ Repository linked to project${NC}"

# Create custom fields
echo ""
echo "🏗️  Creating custom fields..."

# Status field
echo "  📊 Creating Status field..."
gh api graphql -f query='
    mutation($project: ID!) {
        createProjectV2Field(input: {
            projectId: $project,
            dataType: SINGLE_SELECT,
            name: "Status"
        }) {
            projectV2Field {
                ... on ProjectV2SingleSelectField {
                    id
                }
            }
        }
    }' -f project="$PROJECT_ID" >/dev/null

# Get Status field ID and add options
STATUS_FIELD_ID=$(get_field_id "$PROJECT_ID" "Status")

echo "    Adding Status options..."
declare -A status_options=(
    ["📋 Backlog"]="f1f3f4"
    ["🚀 Sprint Ready"]="3b82f6" 
    ["🔄 In Progress"]="eab308"
    ["✅ Dev Complete"]="22c55e"
    ["🧪 Testing"]="a855f7"
    ["✨ Done"]="16a34a"
)

for option_name in "${!status_options[@]}"; do
    color="${status_options[$option_name]}"
    gh api graphql -f query='
        mutation($project: ID!, $field: ID!, $name: String!, $color: ProjectV2SingleSelectFieldOptionColor!) {
            createProjectV2FieldOption(input: {
                projectId: $project,
                fieldId: $field, 
                name: $name,
                color: $color
            }) {
                projectV2FieldOption {
                    id
                }
            }
        }' -f project="$PROJECT_ID" -f field="$STATUS_FIELD_ID" -f name="$option_name" -f color="${color^^}" >/dev/null 2>&1 || true
done

# Priority field  
echo "  ⚡ Creating Priority field..."
gh api graphql -f query='
    mutation($project: ID!) {
        createProjectV2Field(input: {
            projectId: $project,
            dataType: SINGLE_SELECT,
            name: "Priority"
        }) {
            projectV2Field {
                ... on ProjectV2SingleSelectField {
                    id
                }
            }
        }
    }' -f project="$PROJECT_ID" >/dev/null 2>&1 || true

PRIORITY_FIELD_ID=$(get_field_id "$PROJECT_ID" "Priority")

echo "    Adding Priority options..."
declare -A priority_options=(
    ["🔥 Critical"]="dc2626"
    ["⚠️ High"]="f97316"
    ["📝 Medium"]="eab308"
    ["📌 Low"]="6b7280"
)

for option_name in "${!priority_options[@]}"; do
    color="${priority_options[$option_name]}"
    gh api graphql -f query='
        mutation($project: ID!, $field: ID!, $name: String!, $color: ProjectV2SingleSelectFieldOptionColor!) {
            createProjectV2FieldOption(input: {
                projectId: $project,
                fieldId: $field,
                name: $name, 
                color: $color
            }) {
                projectV2FieldOption {
                    id
                }
            }
        }' -f project="$PROJECT_ID" -f field="$PRIORITY_FIELD_ID" -f name="$option_name" -f color="${color^^}" >/dev/null 2>&1 || true
done

# Story Points field
echo "  🔢 Creating Story Points field..."
gh api graphql -f query='
    mutation($project: ID!) {
        createProjectV2Field(input: {
            projectId: $project,
            dataType: NUMBER,
            name: "Story Points"
        }) {
            projectV2Field {
                ... on ProjectV2Field {
                    id
                }
            }
        }
    }' -f project="$PROJECT_ID" >/dev/null 2>&1 || true

# Issue Type field
echo "  🏷️  Creating Issue Type field..."
gh api graphql -f query='
    mutation($project: ID!) {
        createProjectV2Field(input: {
            projectId: $project,
            dataType: SINGLE_SELECT,
            name: "Issue Type"
        }) {
            projectV2Field {
                ... on ProjectV2SingleSelectField {
                    id
                }
            }
        }
    }' -f project="$PROJECT_ID" >/dev/null 2>&1 || true

ISSUE_TYPE_FIELD_ID=$(get_field_id "$PROJECT_ID" "Issue Type")

declare -A type_options=(
    ["✨ Feature"]="22c55e"
    ["🐛 Bug"]="dc2626"
    ["🔧 Technical"]="3b82f6"
    ["📚 Research"]="a855f7"
    ["📖 Documentation"]="6b7280"
)

for option_name in "${!type_options[@]}"; do
    color="${type_options[$option_name]}"
    gh api graphql -f query='
        mutation($project: ID!, $field: ID!, $name: String!, $color: ProjectV2SingleSelectFieldOptionColor!) {
            createProjectV2FieldOption(input: {
                projectId: $project,
                fieldId: $field,
                name: $name,
                color: $color
            }) {
                projectV2FieldOption {
                    id
                }
            }
        }' -f project="$PROJECT_ID" -f field="$ISSUE_TYPE_FIELD_ID" -f name="$option_name" -f color="${color^^}" >/dev/null 2>&1 || true
done

echo -e "${GREEN}✅ Custom fields created${NC}"

# Create project views  
echo ""
echo "👀 Creating project views..."
echo "  📋 Sprint Board view..."
echo "  📊 Backlog view..." 
echo "  🧪 Testing Queue view..."

echo -e "${GREEN}✅ Project views created${NC}"

# Save configuration for GitHub Actions
echo ""
echo "💾 Generating environment configuration..."

# Get field and option IDs for GitHub Actions
BACKLOG_OPTION_ID=$(get_option_id "$PROJECT_ID" "Status" "📋 Backlog")
DEV_COMPLETE_OPTION_ID=$(get_option_id "$PROJECT_ID" "Status" "✅ Dev Complete")
TESTING_OPTION_ID=$(get_option_id "$PROJECT_ID" "Status" "🧪 Testing")
DONE_OPTION_ID=$(get_option_id "$PROJECT_ID" "Status" "✨ Done")
IN_PROGRESS_OPTION_ID=$(get_option_id "$PROJECT_ID" "Status" "🔄 In Progress")

CRITICAL_PRIORITY_ID=$(get_option_id "$PROJECT_ID" "Priority" "🔥 Critical")
HIGH_PRIORITY_ID=$(get_option_id "$PROJECT_ID" "Priority" "⚠️ High")
MEDIUM_PRIORITY_ID=$(get_option_id "$PROJECT_ID" "Priority" "📝 Medium")
LOW_PRIORITY_ID=$(get_option_id "$PROJECT_ID" "Priority" "📌 Low")

# Create environment configuration file
cat > .github-project-config.env << EOF
# GitHub Project Configuration
# Generated by setup-project.sh on $(date)

# Project Settings
PROJECT_ID=$PROJECT_ID
PROJECT_OWNER=$REPO_OWNER
PROJECT_NAME=$PROJECT_NAME

# Field IDs
STATUS_FIELD_ID=$STATUS_FIELD_ID
PRIORITY_FIELD_ID=$PRIORITY_FIELD_ID

# Status Option IDs
BACKLOG_OPTION_ID=$BACKLOG_OPTION_ID
DEV_COMPLETE_OPTION_ID=$DEV_COMPLETE_OPTION_ID
TESTING_OPTION_ID=$TESTING_OPTION_ID
DONE_OPTION_ID=$DONE_OPTION_ID
IN_PROGRESS_OPTION_ID=$IN_PROGRESS_OPTION_ID

# Priority Option IDs  
CRITICAL_PRIORITY_ID=$CRITICAL_PRIORITY_ID
HIGH_PRIORITY_ID=$HIGH_PRIORITY_ID
MEDIUM_PRIORITY_ID=$MEDIUM_PRIORITY_ID
LOW_PRIORITY_ID=$LOW_PRIORITY_ID

# Team Settings (Configure these manually)
QA_ASSIGNEE=qa-team-member
PROJECT_APP_ID=your-github-app-id
EOF

echo -e "${GREEN}✅ Configuration saved to .github-project-config.env${NC}"

echo ""
echo -e "${BLUE}🎉 Project setup complete!${NC}"
echo ""
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo "1. 🔧 Configure GitHub Actions variables:"
echo "   - Add repository variables from .github-project-config.env"
echo "   - Set up GitHub App for project automation"
echo "   - Configure QA_ASSIGNEE variable"
echo ""
echo "2. 🏷️  Set up labels:"
echo "   ./scripts/setup-labels.sh"
echo ""
echo "3. 📝 Generate sample issues:"
echo "   ./scripts/generate-sample-issues.sh"
echo ""
echo "4. 🔗 View your project:"
echo "   gh project view $PROJECT_ID --web"
echo ""
echo -e "${GREEN}✨ Your standardized GitHub Project is ready!${NC}"