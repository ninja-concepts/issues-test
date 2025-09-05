#!/bin/bash

# AI-Assisted Pull Request Generator  
# Uses OpenAI API to generate PR titles and descriptions following project templates

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}🤖 AI-Assisted Pull Request Generator${NC}"
echo ""

# Check if OpenAI API key is set
if [ -z "$OPENAI_API_KEY" ]; then
    echo -e "${RED}❌ OPENAI_API_KEY environment variable not set${NC}"
    echo "Please set your OpenAI API key:"
    echo "export OPENAI_API_KEY='your-api-key-here'"
    exit 1
fi

# Check if gh CLI is authenticated
echo "🔐 Checking GitHub CLI authentication..."
if ! gh auth status >/dev/null 2>&1; then
    echo -e "${RED}❌ GitHub CLI not authenticated. Please run: gh auth login${NC}"
    exit 1
fi

# Get current branch and repository info
CURRENT_BRANCH=$(git branch --show-current)
REPO_NAME=$(gh repo view --json name -q .name)
REPO_OWNER=$(gh repo view --json owner -q .owner.login)

echo "Current branch: $CURRENT_BRANCH"
echo "Repository: $REPO_OWNER/$REPO_NAME"

# Determine base branch based on Git Flow conventions
BASE_BRANCH="develop"
if [[ $CURRENT_BRANCH =~ ^(hotfix|release)/ ]]; then
    BASE_BRANCH="main"
fi

echo "Target base branch: $BASE_BRANCH"

# Extract issue number from branch name
ISSUE_NUMBER=""
if [[ $CURRENT_BRANCH =~ (feature|bugfix|hotfix)/issue-([0-9]+) ]]; then
    ISSUE_NUMBER="${BASH_REMATCH[2]}"
    echo "Detected issue number: #$ISSUE_NUMBER"
fi

# Get commit history for this branch
echo "📊 Analyzing branch changes..."
COMMIT_HISTORY=$(git log $BASE_BRANCH..HEAD --oneline --no-merges)

if [ -z "$COMMIT_HISTORY" ]; then
    echo -e "${RED}❌ No commits found on this branch compared to $BASE_BRANCH${NC}"
    echo "Make sure you've made commits and that $BASE_BRANCH exists."
    exit 1
fi

# Get detailed diff summary
DIFF_SUMMARY=$(git diff $BASE_BRANCH..HEAD --stat)
FILES_CHANGED=$(git diff $BASE_BRANCH..HEAD --name-only | wc -l)

echo "Found $(echo "$COMMIT_HISTORY" | wc -l) commits, $FILES_CHANGED files changed"

# Get issue details if issue number is available
ISSUE_TITLE=""
ISSUE_BODY=""
if [ ! -z "$ISSUE_NUMBER" ]; then
    echo "🔍 Fetching issue details..."
    ISSUE_DATA=$(gh issue view $ISSUE_NUMBER --json title,body --repo $REPO_OWNER/$REPO_NAME 2>/dev/null || echo '{}')
    ISSUE_TITLE=$(echo "$ISSUE_DATA" | jq -r '.title // ""')
    ISSUE_BODY=$(echo "$ISSUE_DATA" | jq -r '.body // ""' | head -10)
fi

# Prepare OpenAI API request
SYSTEM_PROMPT="You are an expert developer assistant helping generate GitHub pull request titles and descriptions.

Generate a PR title and description following this exact template structure:

PR TITLE: Should be concise and descriptive, following conventional commit format when appropriate (feat:, fix:, etc.)

PR DESCRIPTION should follow this structure:
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

Key requirements:
- PR title should be 50 characters or less
- Be specific about what changed and why
- Include testing steps that are actionable
- Focus on the user/business impact
- If linked to an issue, reference it appropriately"

USER_PROMPT="Generate a PR title and description for this pull request:

Branch: $CURRENT_BRANCH → $BASE_BRANCH
$(if [ ! -z "$ISSUE_NUMBER" ]; then echo "Linked Issue #$ISSUE_NUMBER: $ISSUE_TITLE"; fi)
$(if [ ! -z "$ISSUE_BODY" ]; then echo -e "\nIssue Context:\n$ISSUE_BODY"; fi)

Commit History:
$COMMIT_HISTORY

Files Changed Summary:
$DIFF_SUMMARY

Generate the PR title on the first line, then a blank line, then the PR description. Do not include any markdown formatting for the title itself."

echo "🧠 Generating PR content with AI..."

# Make API request to OpenAI
RESPONSE=$(curl -s -X POST "https://api.openai.com/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d "{
    \"model\": \"gpt-4.1-latest\",
    \"messages\": [
      {\"role\": \"system\", \"content\": \"$SYSTEM_PROMPT\"},
      {\"role\": \"user\", \"content\": \"$USER_PROMPT\"}
    ],
    \"max_tokens\": 800,
    \"temperature\": 0.3
  }")

# Check if API request was successful
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to connect to OpenAI API${NC}"
    exit 1
fi

# Extract content from response
PR_CONTENT=$(echo "$RESPONSE" | jq -r '.choices[0].message.content // empty')

if [ -z "$PR_CONTENT" ] || [ "$PR_CONTENT" = "null" ]; then
    echo -e "${RED}❌ Failed to generate PR content${NC}"
    echo "API Response:"
    echo "$RESPONSE" | jq '.'
    exit 1
fi

# Split title and description
PR_TITLE=$(echo "$PR_CONTENT" | head -1)
PR_DESCRIPTION=$(echo "$PR_CONTENT" | tail -n +3)

# Add issue closure if issue number detected and not already in description
if [ ! -z "$ISSUE_NUMBER" ]; then
    if ! echo "$PR_DESCRIPTION" | grep -q "Closes #$ISSUE_NUMBER\|Fixes #$ISSUE_NUMBER\|Resolves #$ISSUE_NUMBER"; then
        PR_DESCRIPTION="$PR_DESCRIPTION

**Closes #$ISSUE_NUMBER**"
    fi
fi

# Display generated content
echo ""
echo -e "${GREEN}✨ Generated PR content:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${YELLOW}Title:${NC} $PR_TITLE"
echo ""
echo -e "${YELLOW}Description:${NC}"
echo "$PR_DESCRIPTION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Ask for confirmation
read -p "$(echo -e ${YELLOW}Create this pull request? [Y/n/e]: ${NC})" -n 1 -r
echo
case $REPLY in
    [eE])
        # Edit the content
        TEMP_FILE=$(mktemp)
        echo "$PR_TITLE" > "$TEMP_FILE"
        echo "" >> "$TEMP_FILE"
        echo "$PR_DESCRIPTION" >> "$TEMP_FILE"
        
        ${EDITOR:-nano} "$TEMP_FILE"
        
        PR_TITLE=$(head -1 "$TEMP_FILE")
        PR_DESCRIPTION=$(tail -n +3 "$TEMP_FILE")
        
        rm "$TEMP_FILE"
        ;;
    [nN])
        echo "PR creation cancelled."
        exit 0
        ;;
    *)
        # Default to Yes
        ;;
esac

# Check if remote branch exists, push if needed
echo "🔄 Checking remote branch status..."
if ! git ls-remote --heads origin "$CURRENT_BRANCH" | grep -q "$CURRENT_BRANCH"; then
    echo "📤 Pushing branch to origin..."
    git push -u origin "$CURRENT_BRANCH"
else
    echo "📤 Updating remote branch..."
    git push origin "$CURRENT_BRANCH"
fi

# Create the pull request
echo "🚀 Creating pull request..."

# Create PR using heredoc to handle multiline description
gh pr create \
    --title "$PR_TITLE" \
    --body "$(cat <<EOF
$PR_DESCRIPTION
EOF
)" \
    --base "$BASE_BRANCH" \
    --head "$CURRENT_BRANCH"

echo ""
echo -e "${GREEN}✅ Pull request created successfully!${NC}"

# Display PR URL
PR_URL=$(gh pr view --json url -q .url 2>/dev/null || echo "")
if [ ! -z "$PR_URL" ]; then
    echo -e "${BLUE}🔗 PR URL: $PR_URL${NC}"
fi

echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "• Review the PR in GitHub"
echo "• Request reviewers if needed"
echo "• Wait for CI/CD checks to complete"
echo "• Merge when approved"