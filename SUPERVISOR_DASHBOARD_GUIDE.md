# Supervisor Dashboard Implementation Guide

## Overview

The Supervisor Dashboard is a role-specific interface for HatchPlan Pro's Hatchery Supervisor users. It provides role-based authentication, themed UI with green and orange color palette, and real-time Firebase Firestore integration for monitoring hatchery operations.

## Architecture

### Role-Based Routing (ContentView.swift)

The app automatically routes supervisor vs. manager users to different dashboard layouts:

```swift
if session.currentRole == .supervisor {
    supervisorDashboard  // 5 tabs: HOME, BATCHES, HISTORY, ALERTS, SETTINGS
} else {
    managerDashboard    // 5 tabs: Dashboard, Batches, Tasks, Alerts, Profile
}
```

### Directory Structure

```
HatchPlanPro/HatchPlanPro/
├── Views/Dashboard/
│   ├── SupervisorHomeView.swift          # Main dashboard (75% progress, metrics, hatches)
│   ├── SupervisorBatchesView.swift       # Hatchery Insights (batch status by category)
│   ├── SupervisorHistoryView.swift       # Historical batch records and quarterly summary
│   ├── SupervisorSettingsView.swift      # Settings, preferences, security, support
│   ├── SupervisorNotificationsView.swift # Notifications by time period
│   └── ContentView.swift                 # Role-aware router (UPDATED)
├── Models/
│   └── HatcheryModels.swift              # New: BatchStatus, NotificationType, HatcheryNotification, BatchInsight
├── ViewModels/
│   └── AppSessionViewModel.swift         # New: notifications, insights properties + sync methods
├── Services/
│   └── HatcherySyncService.swift         # New: notification & insight sync operations
└── Utilities/
    └── SupervisorTheme.swift             # Color extensions: #245B24 (green), #B78900 (orange)
```

## UI Screens

### 1. **Home Tab** (SupervisorHomeView)

**Purpose**: Main dashboard showing hatchery status at a glance

**Components**:

- Header with greeting: "Good Morning, Ms Nadunika"
- Today's Target (circular progress ring, 75%)
- Production Velocity metrics:
  - Live Count: 12,480 (light green background)
  - Incubating: 4,200 (light orange background)
- Environmental Stats:
  - Ambient Temp: 99.5°F
  - Humidity: 54%
- Upcoming Hatches (4 batches with time, one marked CRITICAL)
- Facility Health card (deep green background) with "Check Sensors" button
- Yield Projection: 82% predicted overall yield

**Data Flow**:

- Mock data hardcoded for demo
- Firebase sync via `session.syncCurrentState()` in profile

### 2. **Batches Tab** (SupervisorBatchesView)

**Purpose**: View batch status organized by approval stage

**Sections**:

- **Approved & Ready** (2 items)
  - #B1024: Ross 308, Oct 24, 2023 - APPROVED
  - #B1028: Cobb 500, Oct 24, 2023 - APPROVED
- **Pending Manager Review** (1 item)
  - #B1029: Ross 708, Oct 24, 2023 - PENDING (orange badge)
- **Rejected / Action Required** (1 item)
  - #B1022: Lohmann Brown with error message (red badge)
  - "Target temperature too high for breed specification. Update and resubmit."
- **Calendar Synced** (1 item)
  - #B1020: Hubbard Efficiency Plus - SYNCED (green checkmark)
- **Supervisor Insight** banner (deep green background)
  - "Hatchery efficiency is up 4.2% this week."
  - Reviews by Manager Sarah & Ops Lead Mike

**Data Source**: BatchInsight structs with status enums

### 3. **History Tab** (SupervisorHistoryView)

**Purpose**: Track historical batch performance and hatch rates

**Sections**:

- **Quarterly Summary**
  - Average Hatch Rate: 92.4% (progress bar)
  - Total Batches: 142
- **October 2023** batches
  - #B2023-10-A: Completed Oct 28, 2023 - 94.5%
  - #B2023-10-B: Completed Oct 24, 2023 - 91.2%
  - #B2023-10-C: Completed Oct 19, 2023 - 88.4%
- **September 2023** batches
  - #B2023-09-E: Completed Sep 30, 2023 - 93.8%
  - #B2023-09-D: Completed Sep 22, 2023 - 95.1%
- **Load Older Batches** button

**Data Source**: BatchInsight.hatchRate field

### 4. **Alerts Tab** (SupervisorNotificationsView)

**Purpose**: View system notifications organized by time

**Sections**:

- **TODAY**
  - Critical Alert: "Batch #B1024 is 24 hours from hatching..." (2m ago)
  - Approval Update: "Plan for Batch #B1030 has been Approved by Manager Aruni." (1h ago)
- **LAST WEEK**
  - System Message: "Sensor Calibration Sync completed..." (Yesterday)
  - Weekly Report: "Performance summary for Hall A is now available..." (2 days ago)
- **EARLIER**
  - Additional historical notifications

**Icons & Colors**:

- CRITICAL_ALERT: Red warning icon, orange background
- APPROVAL_UPDATE: Green checkmark, green background
- SYSTEM_MESSAGE: Gray gear icon, gray background
- WEEKLY_REPORT: Brown chart icon, brown background

### 5. **Settings Tab** (SupervisorSettingsView)

**Purpose**: User preferences, security, and support

**Sections**:

- **Profile** (read-only display)
  - Role: Supervisor
  - Email: lead.agronomist@hatchplan.pro
- **Preferences**
  - System Notifications (toggle enabled)
  - Haptic Feedback (toggle enabled)
  - Siri & Search (toggle enabled)
  - Accessibility (navigation to detail screen)
- **Security**
  - Biometric Authentication (navigation)
  - Change Passcode (navigation)
- **Support**
  - User Manual (orange icon)
  - Contact Support (orange icon)
  - Terms of Service (orange icon)
  - Privacy Policy (orange icon)
- **Footer**: Version v2.4.0

**Navigation Stubs**: All detail screens are placeholder views with titles

## Data Models

### BatchStatus Enum

```swift
enum BatchStatus: String, Codable {
    case approvedReady = "APPROVED"      // Green color
    case pendingReview = "PENDING"       // Orange color
    case rejected = "REJECTED"           // Red color
    case synced = "SYNCED"               // Green color
}
```

### NotificationType Enum

```swift
enum NotificationType: String, Codable {
    case criticalAlert = "CRITICAL_ALERT"
    case approvalUpdate = "APPROVAL_UPDATE"
    case systemMessage = "SYSTEM_MESSAGE"
    case weeklyReport = "WEEKLY_REPORT"
}
```

### HatcheryNotification Struct

```swift
struct HatcheryNotification: Identifiable, Codable, Hashable {
    let id: String                    // UUID
    let type: NotificationType
    let title: String                 // Notification headline
    let message: String               // Detailed message
    let timestamp: Date               // When it occurred
    let timeLabel: String            // "2m ago", "1h ago", etc.
}
```

### BatchInsight Struct

```swift
struct BatchInsight: Identifiable, Codable, Hashable {
    let id: String                    // UUID
    let batchID: String              // e.g., "#B1024"
    let breed: String                // e.g., "Ross 308"
    let date: String                 // e.g., "Oct 24, 2023"
    let status: BatchStatus          // APPROVED, PENDING, REJECTED, SYNCED
    let hatchRate: String?           // Optional, e.g., "94.5%"
}
```

## Firebase Integration

### Firestore Collections

#### `dashboardSnapshots/{role}` (Existing)

Syncs dashboard state whenever user signs in or taps "Sync" button:

```json
{
  "role": "Hatchery Supervisor",
  "updatedAt": Timestamp,
  "batches": [...],
  "tasks": [...],
  "securityTheme": {
    "primary": "#245B24",
    "accent": "#B78900"
  },
  "supervisorProfile": {
    "name": "Hatchery Supervisor",
    "workflow": "Supervisor flow"
  }
}
```

#### `supervisorData/notifications` (New)

Stores supervisor notifications:

```json
{
  "notifications": [
    {
      "id": "uuid",
      "type": "CRITICAL_ALERT",
      "title": "Batch #B1024 is 24 hours from hatching...",
      "message": "Critical resource needed",
      "timestamp": Timestamp,
      "timeLabel": "2m ago"
    }
  ],
  "updatedAt": Timestamp
}
```

#### `supervisorData/batchInsights` (New)

Stores batch history and status:

```json
{
  "insights": [
    {
      "id": "uuid",
      "batchID": "#B1024",
      "breed": "Ross 308",
      "date": "Oct 24, 2023",
      "status": "APPROVED",
      "hatchRate": null
    }
  ],
  "updatedAt": Timestamp
}
```

### Sync Methods (HatcherySyncService)

```swift
// Write notifications to Firebase
func syncSupervisorNotifications(notifications: [HatcheryNotification],
                                completion: @escaping (Result<Void, Error>) -> Void)

// Write batch insights to Firebase
func syncBatchInsights(insights: [BatchInsight],
                      completion: @escaping (Result<Void, Error>) -> Void)

// Fetch notifications from Firebase
func fetchSupervisorNotifications(completion: @escaping (Result<[HatcheryNotification], Error>) -> Void)

// Fetch batch insights from Firebase
func fetchBatchInsights(completion: @escaping (Result<[BatchInsight], Error>) -> Void)
```

### AppSessionViewModel Methods

```swift
// Fetch live notifications from Firebase
session.fetchSupervisorNotifications()

// Fetch live batch insights from Firebase
session.fetchBatchInsights()

// Sync all supervisor data to Firebase (sample data)
session.syncSupervisorData()
```

## Color Theme

### Supervisor Colors (SupervisorTheme.swift)

- **Primary Green**: `#245B24` (Deep forest green)
- **Deep Green**: `#143814` (Darker variant)
- **Soft Green**: `#EAF3EA` (Light background)
- **Accent Orange**: `#B78900` (Gold/amber)
- **Soft Orange**: `#F7E7B6` (Light background)
- **Surface**: `#F7F7FA` (Light gray background)

### Applied To

- Tab tint: Deep green (#245B24)
- Card backgrounds: White with soft shadows
- Card section titles: Dark green text
- Buttons: Green backgrounds with white text
- Alerts/Critical items: Orange or red badges
- Progress bars/rings: Green fills

## How to Test

### 1. Run the App

```bash
cd HatchPlanPro
open HatchPlanPro.xcodeproj
# Select scheme "HatchPlanPro" and run on simulator
```

### 2. Test Supervisor Flow

1. Tap "Supervisor" on landing screen
2. Navigate through supervisor onboarding screens
3. Enter credentials and PIN (any 4 digits)
4. Set up biometric (Face ID/Touch ID)
5. View supervisor dashboard with 5 tabs

### 3. Test Data Sync

1. Tap profile (Settings tab)
2. Use session.syncCurrentState() or session.syncSupervisorData() to send to Firebase
3. Check Firestore console to verify data in collections

### 4. Test Navigation

- Swipe or tap to navigate between tabs
- Tap batch items to drill into details
- Tap setting items to navigate to detail screens

## Integration Checklist

- ✅ 5 supervisor dashboard screens created
- ✅ Green/orange color theme applied
- ✅ Firebase data models defined (BatchStatus, NotificationType, Notification, BatchInsight)
- ✅ Firestore sync methods implemented
- ✅ AppSessionViewModel updated with notification/insight properties
- ✅ ContentView routing updated for role-aware dashboard
- ✅ Mock data created for preview and testing
- ⏳ Real-time listeners for Firestore updates (TODO)
- ⏳ Unit tests for notification sync (TODO)
- ⏳ Accessibility labels for VoiceOver (TODO)
- ⏳ GitHub repository setup (TODO)

## Future Enhancements

1. **Real-Time Updates**: Add Firestore real-time listeners to update UI when data changes
2. **Interactive Charts**: Add Charts library for detailed hatch rate visualizations
3. **Offline Support**: Cache data locally using Core Data for offline access
4. **Notifications**: Implement UNUserNotificationCenter for push alerts
5. **Detailed Screens**: Build drill-down screens for batch details, temperature logs, etc.
6. **Export**: Add PDF/CSV export of batch history and reports
7. **Analytics**: Track supervisor actions and performance metrics
8. **Dark Mode**: Add dark mode support with theme switching

## Troubleshooting

### Views Not Appearing?

- Check that `AppSessionViewModel` is injected via `.environmentObject(session)` at app root
- Verify `currentRole == .supervisor` in ContentView routing logic

### Firebase Write Fails?

- Confirm Firestore security rules allow writes to `dashboardSnapshots/{role}` and `supervisorData/*`
- Check that GoogleService-Info.plist is added to project
- Verify network connectivity

### Color Not Applied?

- Check that `Color(hex: "#245B24")` is correctly imported from `SupervisorTheme.swift`
- Ensure SupervisorTheme extension is part of compile target

### Mock Data Not Showing?

- Mock data is hardcoded in AppSessionViewModel properties
- For live data, call `session.fetchSupervisorNotifications()` and `session.fetchBatchInsights()`
- Subscribe to `@Published` properties to auto-update UI
