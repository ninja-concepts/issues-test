#!/bin/bash

# AI-Assisted Development Workflow Helper
# Complete end-to-end workflow automation using AI assistance

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load project configuration if available
if [ -f "${SCRIPT_DIR}/../.github-project-config.env" ]; then
    source "${SCRIPT_DIR}/../.github-project-config.env"
fi

echo -e "${CYAN}🚀 AI-Assisted Development Workflow${NC}"
echo -e "${CYAN}====================================${NC}"
echo ""

# Helper function to update project status
update_project_status() {
    local issue_number="$1"
    local status_option_id="$2"
    local status_name="$3"
    
    if [ -z "$PROJECT_ID" ] || [ -z "$STATUS_FIELD_ID" ] || [ -z "$status_option_id" ]; then
        echo -e "${YELLOW}⚠️  Project configuration not found, skipping status update${NC}"
        return 0
    fi
    
    echo -e "${BLUE}📊 Updating project status for issue #$issue_number to '$status_name'...${NC}"
    
    # Check if issue exists
    if ! gh issue view $issue_number >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  Issue #$issue_number not found, skipping status update${NC}"
        return 0
    fi
    
    # Get the project item ID for the issue
    ITEM_ID=$(gh api graphql -f query='
        query($project: ID!) {
            node(id: $project) {
                ... on ProjectV2 {
                    items(first: 100) {
                        nodes {
                            id
                            content {
                                ... on Issue {
                                    number
                                }
                            }
                        }
                    }
                }
            }
        }' -f project="$PROJECT_ID" \
        --jq ".data.node.items.nodes[] | select(.content.number == $issue_number) | .id" 2>/dev/null)
    
    if [ ! -z "$ITEM_ID" ]; then
        # Update issue status
        if gh api graphql -f query='
            mutation($project: ID!, $item: ID!, $field: ID!, $value: String!) {
                updateProjectV2ItemFieldValue(input: {
                    projectId: $project, 
                    itemId: $item, 
                    fieldId: $field, 
                    value: {singleSelectOptionId: $value}
                }) { 
                    projectV2Item { id } 
                }
            }' -f project="$PROJECT_ID" \
               -f item="$ITEM_ID" \
               -f field="$STATUS_FIELD_ID" \
               -f value="$status_option_id" >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Issue #$issue_number moved to '$status_name' status${NC}"
        else
            echo -e "${YELLOW}⚠️  Could not update status for issue #$issue_number${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Issue #$issue_number not found in project, skipping status update${NC}"
    fi
}

# Check prerequisites
check_prerequisites() {
    echo -e "${BLUE}🔍 Checking prerequisites...${NC}"
    
    # Check OpenAI API key
    if [ -z "$OPENAI_API_KEY" ]; then
        echo -e "${RED}❌ OPENAI_API_KEY not set${NC}"
        echo "Please set your OpenAI API key:"
        echo "export OPENAI_API_KEY='your-api-key-here'"
        return 1
    fi
    
    # Check GitHub CLI
    if ! command -v gh &> /dev/null; then
        echo -e "${RED}❌ GitHub CLI (gh) not found${NC}"
        echo "Please install GitHub CLI: https://cli.github.com/"
        return 1
    fi
    
    # Check GitHub authentication
    if ! gh auth status >/dev/null 2>&1; then
        echo -e "${RED}❌ GitHub CLI not authenticated${NC}"
        echo "Please run: gh auth login"
        return 1
    fi
    
    # Check git status
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo -e "${RED}❌ Not in a git repository${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ All prerequisites satisfied${NC}"
    return 0
}

# Validate branch naming convention
validate_branch() {
    local branch_name="$1"
    
    if [[ ! $branch_name =~ ^(feature|bugfix|hotfix|release)/ ]]; then
        echo -e "${YELLOW}⚠️  Branch name doesn't follow Git Flow convention${NC}"
        echo "Expected format: feature/issue-123-description"
        echo "Current branch: $branch_name"
        echo ""
        read -p "Continue anyway? [y/N]: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi
    
    return 0
}

# Show current status
show_status() {
    echo -e "${BLUE}📊 Current Git Status${NC}"
    echo "Repository: $(gh repo view --json nameWithOwner -q .nameWithOwner)"
    echo "Branch: $(git branch --show-current)"
    echo "Status: $(git status --porcelain | wc -l) changed files"
    echo ""
    
    # Show staged vs unstaged changes
    STAGED=$(git diff --staged --name-only | wc -l)
    UNSTAGED=$(git diff --name-only | wc -l)
    UNTRACKED=$(git ls-files --others --exclude-standard | wc -l)
    
    if [ $STAGED -gt 0 ]; then
        echo -e "${GREEN}📋 Staged files: $STAGED${NC}"
    fi
    if [ $UNSTAGED -gt 0 ]; then
        echo -e "${YELLOW}📝 Unstaged files: $UNSTAGED${NC}"
    fi
    if [ $UNTRACKED -gt 0 ]; then
        echo -e "${PURPLE}❓ Untracked files: $UNTRACKED${NC}"
    fi
    echo ""
}

# Interactive file staging
interactive_staging() {
    echo -e "${BLUE}📁 File Staging${NC}"
    
    # Check if there are any changes
    if git diff --quiet && git diff --staged --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
        echo -e "${YELLOW}⚠️  No changes detected${NC}"
        return 1
    fi
    
    # Show what needs to be staged
    UNSTAGED_COUNT=$(git diff --name-only | wc -l)
    UNTRACKED_COUNT=$(git ls-files --others --exclude-standard | wc -l)
    
    if [ $UNSTAGED_COUNT -gt 0 ] || [ $UNTRACKED_COUNT -gt 0 ]; then
        echo "Files that can be staged:"
        if [ $UNSTAGED_COUNT -gt 0 ]; then
            echo -e "${YELLOW}Modified files:${NC}"
            git diff --name-only | sed 's/^/  /'
        fi
        if [ $UNTRACKED_COUNT -gt 0 ]; then
            echo -e "${PURPLE}Untracked files:${NC}"
            git ls-files --others --exclude-standard | sed 's/^/  /'
        fi
        echo ""
        
        echo "Staging options:"
        echo "1) Stage all files (git add .)"
        echo "2) Interactive staging (git add -i)"
        echo "3) Skip staging (use already staged files)"
        echo ""
        
        read -p "Choose option [1-3]: " -n 1 -r
        echo
        
        case $REPLY in
            1)
                git add .
                echo -e "${GREEN}✅ All files staged${NC}"
                ;;
            2)
                git add -i
                ;;
            3)
                echo "Using already staged files..."
                ;;
            *)
                echo "Invalid option, using already staged files..."
                ;;
        esac
    fi
    
    # Verify we have staged changes
    if git diff --staged --quiet; then
        echo -e "${RED}❌ No files staged for commit${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Files ready for commit${NC}"
    return 0
}

# Main workflow
main_workflow() {
    local current_branch=$(git branch --show-current)
    
    # Step 1: Prerequisites
    if ! check_prerequisites; then
        exit 1
    fi
    
    # Step 2: Validate branch
    if ! validate_branch "$current_branch"; then
        exit 1
    fi
    
    # Step 2.5: Optional status update for issue tracking
    ISSUE_NUMBER=""
    if [[ $current_branch == feature/issue-* ]] || [[ $current_branch == bugfix/issue-* ]] || [[ $current_branch == hotfix/issue-* ]]; then
        ISSUE_NUMBER=$(echo "$current_branch" | sed -n 's/.*issue-\([0-9]\+\).*/\1/p')
        echo -e "${BLUE}🎯 Detected linked issue #$ISSUE_NUMBER${NC}"
        
        if [ ! -z "$IN_PROGRESS_OPTION_ID" ]; then
            echo ""
            read -p "$(echo -e ${YELLOW}Update issue #$ISSUE_NUMBER status to 'In Progress'? [Y/n]: ${NC})" -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                update_project_status "$ISSUE_NUMBER" "$IN_PROGRESS_OPTION_ID" "In Progress"
            fi
            echo ""
        fi
    fi
    
    # Step 3: Show current status
    show_status
    
    # Step 4: Interactive file staging
    if ! interactive_staging; then
        echo -e "${RED}❌ Cannot proceed without staged changes${NC}"
        exit 1
    fi
    
    echo ""
    echo -e "${CYAN}🤖 Starting AI-Assisted Workflow${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # Step 5: AI Commit
    echo -e "${BLUE}Step 1: AI-Generated Commit${NC}"
    echo "Running: $SCRIPT_DIR/ai-commit.sh"
    echo ""
    
    if ! "$SCRIPT_DIR/ai-commit.sh"; then
        echo -e "${RED}❌ Commit failed${NC}"
        exit 1
    fi
    
    echo ""
    echo -e "${GREEN}✅ Commit completed${NC}"
    echo ""
    
    # Step 6: Ask about PR creation
    read -p "$(echo -e ${YELLOW}Create a pull request now? [Y/n]: ${NC})" -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${BLUE}Workflow completed. You can create a PR later with:${NC}"
        echo "./scripts/ai-pr.sh"
        exit 0
    fi
    
    echo ""
    echo -e "${BLUE}Step 2: AI-Generated Pull Request${NC}"
    echo "Running: $SCRIPT_DIR/ai-pr.sh"
    echo ""
    
    if ! "$SCRIPT_DIR/ai-pr.sh"; then
        echo -e "${RED}❌ PR creation failed${NC}"
        echo -e "${YELLOW}Your commits are still safe. You can create a PR manually or try again.${NC}"
        exit 1
    fi
    
    echo ""
    echo -e "${GREEN}🎉 AI-Assisted Workflow Complete!${NC}"
    echo ""
    echo -e "${CYAN}Summary:${NC}"
    echo "✅ Files staged and committed with AI-generated message"
    echo "✅ Branch pushed to remote"
    echo "✅ Pull request created with AI-generated content"
    echo ""
    echo -e "${BLUE}Your changes are now ready for review!${NC}"
}

# Help function
show_help() {
    echo -e "${CYAN}AI-Assisted Development Workflow Helper${NC}"
    echo ""
    echo -e "${BLUE}Description:${NC}"
    echo "  Complete end-to-end development workflow with AI assistance."
    echo "  Guides you through staging, committing, and creating pull requests"
    echo "  using AI to generate conventional commit messages and PR content."
    echo ""
    echo -e "${BLUE}Prerequisites:${NC}"
    echo "  • OpenAI API key set in OPENAI_API_KEY environment variable"
    echo "  • GitHub CLI authenticated (gh auth login)"
    echo "  • Working in a Git repository"
    echo "  • Following Git Flow branch naming (feature/issue-123-description)"
    echo ""
    echo -e "${BLUE}Usage:${NC}"
    echo "  $0 [OPTIONS]"
    echo ""
    echo -e "${BLUE}Options:${NC}"
    echo "  -h, --help     Show this help message"
    echo "  --commit-only  Run only the AI commit workflow"
    echo "  --pr-only      Run only the AI PR creation workflow"
    echo ""
    echo -e "${BLUE}Workflow Steps:${NC}"
    echo "  1. Check prerequisites and branch naming"
    echo "  2. Optional project status update (move issue to 'In Progress')"
    echo "  3. Interactive file staging"
    echo "  4. AI-generated commit message creation"
    echo "  5. Optional AI-generated pull request"
    echo ""
    echo -e "${BLUE}Individual Scripts:${NC}"
    echo "  ./scripts/ai-commit.sh  - AI commit message generation only"
    echo "  ./scripts/ai-pr.sh      - AI pull request creation only"
    echo ""
    echo -e "${BLUE}Examples:${NC}"
    echo "  $0                    # Full interactive workflow"
    echo "  $0 --commit-only      # Just create AI commit"
    echo "  $0 --pr-only          # Just create AI PR (requires pushed commits)"
}

# Parse command line arguments
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    --commit-only)
        check_prerequisites || exit 1
        validate_branch "$(git branch --show-current)" || exit 1
        interactive_staging || exit 1
        "$SCRIPT_DIR/ai-commit.sh"
        ;;
    --pr-only)
        check_prerequisites || exit 1
        "$SCRIPT_DIR/ai-pr.sh"
        ;;
    "")
        main_workflow
        ;;
    *)
        echo -e "${RED}❌ Unknown option: $1${NC}"
        echo "Use --help for usage information"
        exit 1
        ;;
esac