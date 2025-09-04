#!/bin/bash

# Sample Issues Generator for GitHub Projects Demo
# This script creates realistic sample issues to showcase your templates and project setup

set -e

# Configuration
REPO_OWNER=${REPO_OWNER:-$(gh repo view --json owner -q .owner.login)}
REPO_NAME=${REPO_NAME:-$(gh repo view --json name -q .name)}
REPO="$REPO_OWNER/$REPO_NAME"

echo "🚀 Generating sample issues for $REPO"

# Feature Issues
echo "📝 Creating feature issues..."

gh issue create --title "[FEATURE] User Authentication System" \
  --body-file - --label "feature,priority:high" << 'EOF'
## Figma Link
https://www.figma.com/file/sample123/user-auth-flow

## Design Status
- [x] Approved by Design Team

## Feature Description
Implement a comprehensive user authentication system with login, registration, and password recovery functionality. This will serve as the foundation for user management across the platform.

## Acceptance Criteria
- [ ] Users can register with email and password
- [ ] Users can log in with valid credentials  
- [ ] Password reset functionality via email
- [ ] Session management and token-based auth
- [ ] Form validation and error handling
- [ ] Integration with existing user database

## Testing Criteria
- [ ] Unit tests for authentication service
- [ ] Integration tests for API endpoints
- [ ] UI tests for login/register forms
- [ ] Security testing for password handling
- [ ] Email delivery testing for password reset

## Story Points
8

## Blocked by
None
EOF

gh issue create --title "[FEATURE] Dashboard Analytics Widget" \
  --body-file - --label "feature,priority:medium" << 'EOF'
## Figma Link
https://www.figma.com/file/sample456/dashboard-analytics

## Design Status
- [x] Approved by Design Team

## Feature Description
Create an interactive analytics widget for the main dashboard that displays key metrics including user engagement, conversion rates, and performance indicators.

## Acceptance Criteria
- [ ] Display real-time user metrics
- [ ] Interactive charts with drill-down capability
- [ ] Responsive design for mobile devices
- [ ] Data export functionality
- [ ] Customizable time ranges
- [ ] Loading states and error handling

## Testing Criteria
- [ ] Unit tests for data processing logic
- [ ] Integration tests for API data fetching
- [ ] UI tests for chart interactions
- [ ] Performance testing with large datasets
- [ ] Cross-browser compatibility testing

## Story Points
5

## Blocked by
None
EOF

gh issue create --title "[FEATURE] Real-time Notifications" \
  --body-file - --label "feature,priority:medium" << 'EOF'
## Figma Link
https://www.figma.com/file/sample789/notifications-system

## Design Status
- [x] Approved by Design Team

## Feature Description
Implement a real-time notification system using WebSockets to deliver instant updates to users about important events and activities.

## Acceptance Criteria
- [ ] WebSocket connection management
- [ ] Toast notifications for real-time updates
- [ ] Notification history panel
- [ ] User preferences for notification types
- [ ] Badge counts for unread notifications
- [ ] Fallback to polling when WebSocket fails

## Testing Criteria
- [ ] Unit tests for notification service
- [ ] Integration tests for WebSocket connections
- [ ] UI tests for notification components
- [ ] Load testing for concurrent connections
- [ ] Network failure recovery testing

## Story Points
8

## Blocked by
None
EOF

# Bug Issues
echo "🐛 Creating bug issues..."

gh issue create --title "[BUG] Login Form Validation Not Working on Mobile" \
  --body-file - --label "bug,priority:high" << 'EOF'
## Bug Description
The login form validation is not triggering properly on mobile devices, allowing users to submit forms with invalid data and causing backend errors.

## Priority
High

## Steps to Reproduce
1. Open the application on a mobile browser (iOS Safari or Android Chrome)
2. Navigate to the login page
3. Enter invalid email format (e.g., "notanemail")
4. Leave password field empty
5. Tap submit button
6. Observe that form submits without validation

## Expected Behavior
The form should validate input fields before submission and display appropriate error messages for invalid email format and empty password field.

## Acceptance Criteria
- [ ] Email validation works on all mobile browsers
- [ ] Password validation prevents empty submissions
- [ ] Error messages display correctly on mobile screens
- [ ] Form cannot be submitted with invalid data
- [ ] User experience is consistent across devices

## Testing Criteria
- [ ] Test on iOS Safari (multiple versions)
- [ ] Test on Android Chrome (multiple versions)
- [ ] Test on various screen sizes
- [ ] Verify accessibility of error messages
- [ ] Confirm backend error reduction

## Story Points
3

## Blocked by
None
EOF

gh issue create --title "[BUG] Dashboard Charts Not Loading for New Users" \
  --body-file - --label "bug,priority:critical" << 'EOF'
## Bug Description
New users experience infinite loading states on dashboard charts, with no data displaying even after waiting several minutes. This affects user onboarding and first impressions.

## Priority
Critical

## Steps to Reproduce
1. Create a new user account
2. Complete registration process
3. Navigate to dashboard page
4. Observe charts section showing loading spinners indefinitely
5. Check browser console for errors

## Expected Behavior
Dashboard should show either empty state with helpful messaging for new users or sample data to demonstrate functionality.

## Acceptance Criteria
- [ ] New users see appropriate empty states
- [ ] Loading states don't persist indefinitely
- [ ] Error handling for missing user data
- [ ] Helpful onboarding messages for new users
- [ ] Graceful fallback when data is unavailable

## Testing Criteria
- [ ] Test with completely new user accounts
- [ ] Verify error handling and logging
- [ ] Test with various network conditions
- [ ] Confirm empty state UI/UX
- [ ] Performance testing for first-time load

## Story Points
5

## Blocked by
None
EOF

# Technical Issues
echo "🔧 Creating technical task issues..."

gh issue create --title "[TECH] Migrate Database to PostgreSQL 15" \
  --body-file - --label "technical,priority:medium" << 'EOF'
## Task Type
Infrastructure

## Task Description
Upgrade the production database from PostgreSQL 13 to PostgreSQL 15 to take advantage of performance improvements, security updates, and new features.

## Current State
Currently running PostgreSQL 13.8 in production with several custom extensions and stored procedures. Database size is approximately 2TB with daily backups.

## Desired State
PostgreSQL 15.x running in production with all existing functionality maintained, improved query performance, and updated extensions compatibility.

## Acceptance Criteria
- [ ] PostgreSQL 15 successfully deployed to staging
- [ ] All existing queries and stored procedures work correctly
- [ ] Database extensions updated and compatible
- [ ] Performance benchmarks meet or exceed current levels
- [ ] Zero-downtime migration strategy implemented
- [ ] Rollback plan documented and tested

## Testing Criteria
- [ ] Full application regression testing on staging
- [ ] Performance testing with production data volume
- [ ] Extension compatibility verification
- [ ] Backup and restore procedures tested
- [ ] Migration rollback procedures tested

## Story Points
8

## Priority
Medium

## Blocked by
None
EOF

gh issue create --title "[TECH] Implement API Rate Limiting" \
  --body-file - --label "technical,priority:high" << 'EOF'
## Task Type
Security

## Task Description
Implement comprehensive rate limiting across all API endpoints to prevent abuse, ensure fair usage, and protect against DDoS attacks.

## Current State
No rate limiting implemented on API endpoints, making the system vulnerable to abuse and potential performance degradation during high traffic periods.

## Desired State
Robust rate limiting system with different tiers for authenticated vs unauthenticated users, configurable limits per endpoint, and proper error responses.

## Acceptance Criteria
- [ ] Rate limiting middleware implemented
- [ ] Different limits for authenticated/unauthenticated users
- [ ] Redis-based rate limit storage
- [ ] Configurable limits per endpoint type
- [ ] Proper HTTP 429 responses with retry headers
- [ ] Admin interface for managing rate limits
- [ ] Monitoring and alerting for rate limit violations

## Testing Criteria
- [ ] Load testing to verify rate limiting works
- [ ] Test different user authentication levels
- [ ] Verify proper error responses and headers
- [ ] Test rate limit reset functionality
- [ ] Security testing against various attack patterns

## Story Points
5

## Priority
High

## Blocked by
None
EOF

echo "✨ Sample issues created successfully!"
echo ""
echo "📊 Summary:"
echo "- 3 Feature issues created"
echo "- 2 Bug issues created"  
echo "- 2 Technical task issues created"
echo ""
echo "🔗 View issues: gh issue list"
echo "📋 Next steps:"
echo "  1. Run ./scripts/setup-project.sh to create the project board"
echo "  2. Configure GitHub Actions variables for automation"
echo "  3. Test the workflows by moving issues through different states"