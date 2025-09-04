#!/bin/bash

# GitHub Labels Setup Script
# Creates standardized labels for your GitHub repository

set -e

REPO_OWNER=${REPO_OWNER:-$(gh repo view --json owner -q .owner.login)}
REPO_NAME=${REPO_NAME:-$(gh repo view --json name -q .name)}
REPO="$REPO_OWNER/$REPO_NAME"

echo "🏷️  Setting up standardized labels for $REPO"

# Function to create or update label
create_or_update_label() {
    local name="$1"
    local color="$2" 
    local description="$3"
    
    if gh label list -R "$REPO" --search "$name" --json name -q '.[].name' | grep -q "^$name$"; then
        echo "  ✏️  Updating existing label: $name"
        gh label edit "$name" -R "$REPO" --color "$color" --description "$description" 2>/dev/null || {
            echo "    ⚠️  Could not update $name (may be in use)"
        }
    else
        echo "  ✨ Creating new label: $name"
        gh label create "$name" -R "$REPO" --color "$color" --description "$description"
    fi
}

# Priority Labels
echo "📌 Creating priority labels..."
create_or_update_label "priority:critical" "d73a49" "🔥 Critical priority - urgent issues blocking major functionality"
create_or_update_label "priority:high" "fb8c00" "⚠️ High priority - important issues that should be addressed soon"
create_or_update_label "priority:medium" "ffd600" "📝 Medium priority - normal priority issues"
create_or_update_label "priority:low" "6c757d" "📌 Low priority - nice-to-have improvements"

# Issue Type Labels
echo "🏗️  Creating issue type labels..."
create_or_update_label "feature" "28a745" "✨ New feature or enhancement"
create_or_update_label "bug" "d73a49" "🐛 Bug fix required"
create_or_update_label "technical" "0366d6" "🔧 Technical task, refactoring, or infrastructure"
create_or_update_label "documentation" "6c757d" "📖 Documentation updates or improvements"
create_or_update_label "research" "9c27b0" "📚 Research and investigation tasks"

# Status Labels
echo "📊 Creating status labels..."
create_or_update_label "needs-estimation" "fbca04" "🤔 Needs story point estimation"
create_or_update_label "needs-triage" "e99695" "🔍 Needs initial review and triage"
create_or_update_label "ready-for-dev" "28a745" "🚀 Ready to be picked up by developer"
create_or_update_label "in-progress" "fbca04" "🔄 Currently being worked on"
create_or_update_label "testing" "9c27b0" "🧪 Ready for or currently in testing"
create_or_update_label "needs-rework" "e91e63" "🔁 Failed testing, needs additional work"
create_or_update_label "completed" "4caf50" "✅ Successfully completed and tested"

# Workflow Labels  
echo "⚙️  Creating workflow labels..."
create_or_update_label "blocked" "f44336" "🚫 Blocked by external dependency or issue"
create_or_update_label "duplicate" "cfd3d7" "👥 Duplicate of another issue"
create_or_update_label "wontfix" "6c757d" "❌ Will not be fixed or implemented"
create_or_update_label "help-wanted" "159818" "🙋 Community help wanted"
create_or_update_label "good-first-issue" "7057ff" "👋 Good for newcomers"

# Team Labels
echo "👥 Creating team labels..."
create_or_update_label "team:frontend" "007bff" "🎨 Frontend team responsibility"
create_or_update_label "team:backend" "28a745" "⚙️ Backend team responsibility"  
create_or_update_label "team:devops" "ff6b35" "🚀 DevOps team responsibility"
create_or_update_label "team:design" "9c27b0" "🎨 Design team responsibility"
create_or_update_label "team:qa" "ffd600" "🧪 QA team responsibility"

# Effort Labels (T-Shirt Sizing)
echo "📏 Creating effort estimation labels..."
create_or_update_label "size:xs" "c2e0c6" "👕 Extra Small (1-2 hours)"
create_or_update_label "size:s" "91d5ff" "👕 Small (0.5 day)"
create_or_update_label "size:m" "ffd666" "👕 Medium (1-2 days)"
create_or_update_label "size:l" "ffb366" "👕 Large (3-5 days)" 
create_or_update_label "size:xl" "ff9999" "👕 Extra Large (1-2 weeks)"
create_or_update_label "size:xxl" "ff6b6b" "👕 Extra Extra Large (2+ weeks)"

# Epic/Initiative Labels
echo "🎯 Creating epic labels..."
create_or_update_label "epic:authentication" "6f42c1" "🔐 Authentication system epic"
create_or_update_label "epic:dashboard" "3742fa" "📊 Dashboard improvements epic"
create_or_update_label "epic:api-v2" "2f3542" "🔌 API v2 development epic"
create_or_update_label "epic:mobile" "20bf6b" "📱 Mobile experience epic"

# Special Labels
echo "⭐ Creating special labels..."
create_or_update_label "dependencies" "0366d6" "📦 External dependencies or upgrades"
create_or_update_label "security" "b60205" "🔒 Security related issue"
create_or_update_label "performance" "ff9500" "⚡ Performance optimization"
create_or_update_label "accessibility" "00d084" "♿ Accessibility improvements"
create_or_update_label "breaking-change" "d73a49" "💥 Breaking change that affects API consumers"

echo ""
echo "✅ Label setup complete!"
echo ""
echo "📋 Created/updated labels in categories:"
echo "  - 4 Priority levels (critical, high, medium, low)"
echo "  - 5 Issue types (feature, bug, technical, documentation, research)"
echo "  - 7 Status indicators"
echo "  - 5 Team assignments"
echo "  - 6 Effort estimations (XS to XXL)"
echo "  - 4 Epic categories"
echo "  - 6 Special purpose labels"
echo ""
echo "🔗 View labels: gh label list"
echo "📚 Usage tips:"
echo "  - Use priority: labels for business priority"
echo "  - Use size: labels for effort estimation"
echo "  - Use team: labels for assignment"
echo "  - Combine labels for better organization"