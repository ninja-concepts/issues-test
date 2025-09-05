#!/bin/bash

# Demo: Branch Creation Status Automation
# This script demonstrates how the GitHub Actions automation works

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}🚀 Branch Creation Status Automation Demo${NC}"
echo -e "${CYAN}=========================================${NC}"
echo ""

echo -e "${BLUE}This demo shows how the automation works when branches are created:${NC}"
echo ""

# Test different branch names
test_branches=(
    "feature/issue-14-test-ai-workflow"
    "bugfix/issue-123-fix-login-bug" 
    "hotfix/issue-456-critical-security-fix"
    "feature/new-dashboard-ui"
    "main"
    "develop"
)

for branch_name in "${test_branches[@]}"; do
    echo -e "${YELLOW}📋 Testing branch: $branch_name${NC}"
    
    # Extract issue number using the same logic as our GitHub Actions
    ISSUE_NUMBER=""
    if [[ "$branch_name" == feature/issue-* ]] || [[ "$branch_name" == bugfix/issue-* ]] || [[ "$branch_name" == hotfix/issue-* ]]; then
        ISSUE_NUMBER=$(echo "$branch_name" | sed -n 's/.*issue-\([0-9]\+\).*/\1/p')
        if [ ! -z "$ISSUE_NUMBER" ]; then
            echo "  ✅ Detected issue number: #$ISSUE_NUMBER"
            echo "  🔄 Would move issue #$ISSUE_NUMBER to 'In Progress' status"
            
            # Check if issue exists (only for demo purposes)
            if [ "$ISSUE_NUMBER" = "14" ]; then
                echo "  ✅ Issue #$ISSUE_NUMBER exists in repository"
            else
                echo "  ℹ️  Issue #$ISSUE_NUMBER would need to exist for automation to work"
            fi
        else
            echo "  ❌ Branch pattern matched but no issue number found"
        fi
    else
        echo "  ℹ️  No Git Flow issue pattern detected - no action taken"
    fi
    echo ""
done

echo -e "${GREEN}🎯 Automation Summary:${NC}"
echo "✅ GitHub Actions will trigger on branch creation events"
echo "✅ Parses branch names following Git Flow convention"  
echo "✅ Extracts issue numbers from: feature/issue-N-*, bugfix/issue-N-*, hotfix/issue-N-*"
echo "✅ Updates project status to '🔄 In Progress' automatically"
echo "✅ Handles cases where issue doesn't exist gracefully"
echo ""

echo -e "${BLUE}Next Steps:${NC}"
echo "1. Set up project configuration by running: ./scripts/setup-project.sh"
echo "2. Create a new branch with pattern: feature/issue-N-description"
echo "3. GitHub Actions will automatically move the issue to 'In Progress'"
echo "4. Use ./scripts/ai-workflow.sh for local status updates"
echo ""

echo -e "${CYAN}✨ Branch creation automation is now ready!${NC}"