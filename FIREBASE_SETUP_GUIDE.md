# Firebase Setup Guide for Supervisor Dashboard

## Firestore Security Rules

Add these rules to your Firestore database to allow supervisor data sync:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write their own dashboard snapshot
    match /dashboardSnapshots/{roleDocument} {
      allow read, write: if request.auth != null;
    }

    // Allow authenticated supervisors to read/write supervisor-specific data
    match /supervisorData/{document=**} {
      allow read, write: if request.auth != null &&
                           request.auth.token.role == 'supervisor';
    }

    // Default deny all other access
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

## Database Structure

### Collection: `dashboardSnapshots`

**Purpose**: Snapshot of dashboard state (batches, tasks) synced from device

**Documents**:

- `Hatchery Manager` - Manager's dashboard snapshot
- `Hatchery Supervisor` - Supervisor's dashboard snapshot

**Fields**:

```
{
  "role": string (e.g., "Hatchery Supervisor")
  "updatedAt": timestamp (server time when synced)
  "batches": [
    {
      "name": string
      "stage": string
      "eggs": number
      "temperature": number
      "humidity": number
      "turnerStatus": string
      "progress": number
      "critical": boolean
    }
  ]
  "tasks": [
    {
      "title": string
      "subtitle": string
      "state": string (pending|inProgress|done)
      "dueLabel": string
      "iconName": string
    }
  ]
  "securityTheme": {
    "primary": string (hex color)
    "accent": string (hex color)
  }
  "supervisorProfile": {
    "name": string
    "workflow": string
  }
}
```

### Collection: `supervisorData`

**Purpose**: Supervisor-specific operational data

#### Document: `notifications`

**Stores**: All notifications for supervisor dashboard

**Fields**:

```
{
  "notifications": [
    {
      "id": string (UUID)
      "type": string (CRITICAL_ALERT|APPROVAL_UPDATE|SYSTEM_MESSAGE|WEEKLY_REPORT)
      "title": string (notification headline)
      "message": string (detailed message)
      "timestamp": timestamp (when notification occurred)
      "timeLabel": string (human-readable time, e.g., "2m ago")
    }
  ]
  "updatedAt": timestamp (server time when last updated)
}
```

**Sample Data**:

```json
{
  "notifications": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "type": "CRITICAL_ALERT",
      "title": "Batch #B1024 is 24 hours from hatching. Resource allocation required.",
      "message": "Critical resource needed",
      "timestamp": 1715514000,
      "timeLabel": "2m ago"
    },
    {
      "id": "550e8400-e29b-41d4-a716-446655440001",
      "type": "APPROVAL_UPDATE",
      "title": "Plan for Batch #B1030 has been Approved by Manager Aruni.",
      "message": "Batch approved",
      "timestamp": 1715510400,
      "timeLabel": "1h ago"
    }
  ],
  "updatedAt": 1715514120
}
```

#### Document: `batchInsights`

**Stores**: Historical batch data and insights

**Fields**:

```
{
  "insights": [
    {
      "id": string (UUID)
      "batchID": string (e.g., "#B1024")
      "breed": string (e.g., "Ross 308")
      "date": string (e.g., "Oct 24, 2023")
      "status": string (APPROVED|PENDING|REJECTED|SYNCED)
      "hatchRate": string or null (e.g., "94.5%")
    }
  ]
  "updatedAt": timestamp (server time when last updated)
}
```

**Sample Data**:

```json
{
  "insights": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440010",
      "batchID": "#B1024",
      "breed": "Ross 308",
      "date": "Oct 24, 2023",
      "status": "APPROVED",
      "hatchRate": null
    },
    {
      "id": "550e8400-e29b-41d4-a716-446655440011",
      "batchID": "#B1029",
      "breed": "Ross 708",
      "date": "Oct 24, 2023",
      "status": "PENDING",
      "hatchRate": null
    },
    {
      "id": "550e8400-e29b-41d4-a716-446655440012",
      "batchID": "#B2023-10-A",
      "breed": "Cobb 500",
      "date": "Oct 28, 2023",
      "status": "SYNCED",
      "hatchRate": "94.5%"
    },
    {
      "id": "550e8400-e29b-41d4-a716-446655440013",
      "batchID": "#B2023-10-B",
      "breed": "Cobb 500",
      "date": "Oct 24, 2023",
      "status": "SYNCED",
      "hatchRate": "91.2%"
    }
  ],
  "updatedAt": 1715514120
}
```

#### Document: `schedule`

**Stores**: Scheduled batch information and efficiency forecast

**Fields**:

```
{
  "schedule": [
    {
      "id": string (UUID)
      "batchID": string (e.g., "#B7-902")
      "breed": string (e.g., "Ross 308")
      "eggs": number (e.g., 12480)
      "time": string (HH:MM format, e.g., "08:45")
      "timeOfDay": string ("AM" or "PM")
      "dateLabel": string (e.g., "TODAY, OCT 25")
      "status": string (e.g., "CRITICAL", "ON DECK", "")
    }
  ]
  "forecast": {
    "title": string (e.g., "Hatch window peaks in 4.5h")
    "percentage": number (0.0 to 1.0)
    "peakTime": string or null (e.g., "4.5h")
  }
  "updatedAt": timestamp (server time when last updated)
}
```

**Sample Data**:

```json
{
  "schedule": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440020",
      "batchID": "#B7-902",
      "breed": "Ross 308",
      "eggs": 12480,
      "time": "08:45",
      "timeOfDay": "AM",
      "dateLabel": "TODAY, OCT 25",
      "status": "CRITICAL"
    },
    {
      "id": "550e8400-e29b-41d4-a716-446655440021",
      "batchID": "#C2-114",
      "breed": "Cobb 500",
      "eggs": 8200,
      "time": "11:30",
      "timeOfDay": "AM",
      "dateLabel": "TODAY, OCT 25",
      "status": "ON DECK"
    },
    {
      "id": "550e8400-e29b-41d4-a716-446655440022",
      "batchID": "#A9-442",
      "breed": "Ross 308",
      "eggs": 15000,
      "time": "06:00",
      "timeOfDay": "AM",
      "dateLabel": "TOMORROW, OCT 26",
      "status": ""
    },
    {
      "id": "550e8400-e29b-41d4-a716-446655440023",
      "batchID": "#B3-008",
      "breed": "Hubbard",
      "eggs": 5600,
      "time": "02:15",
      "timeOfDay": "PM",
      "dateLabel": "TOMORROW, OCT 26",
      "status": ""
    }
  ],
  "forecast": {
    "title": "Hatch window peaks in 4.5h",
    "percentage": 0.75,
    "peakTime": "4.5h"
  },
  "updatedAt": 1715514120
}
```

## Setup Instructions

### 1. Update Firestore Security Rules

1. Go to Firebase Console → Your Project
2. Navigate to Firestore Database → Rules
3. Replace existing rules with the rules provided above
4. Click "Publish"

### 2. Create Collections in Firestore (Optional - Auto-created)

Firestore will auto-create collections when first write occurs. To pre-populate:

1. In Firebase Console, go to Firestore Database
2. Click "Start collection" → name it `supervisorData`
3. Create document `notifications` with the sample notifications data
4. Create document `batchInsights` with the sample batch insights data
5. Create document `schedule` with the sample schedule data

### 3. Enable Authentication

1. Go to Firebase Console → Authentication
2. Enable Email/Password provider if not already enabled
3. Create test user:
   - Email: `supervisor@hatchplanpro.com`
   - Password: `TestPass123!`
   - Set custom claim (optional): `"role": "supervisor"`

### 4. Test Data Sync in App

```swift
// In SwiftUI view or onAppear():
@EnvironmentObject var session: AppSessionViewModel

// Sync sample supervisor data
session.syncSupervisorData()

// Or fetch existing data
session.fetchSupervisorNotifications()
session.fetchBatchInsights()
```

## Monitoring in Firebase Console

### Real-Time Dashboard

1. Go to Firestore Database
2. View `supervisorData/notifications` document
3. Watch for updates as app syncs data
4. Verify timestamp updates to current server time

### Query Data

1. Click on `supervisorData` collection
2. Click on `notifications` document
3. Expand arrays to view individual notification objects
4. Verify structure matches expected schema

### Check Write Operations

1. Go to Firebase Console → Cloud Functions (if set up)
2. Or check Admin SDK logs if backend processing notifications

## Common Issues & Solutions

### Issue: Write fails with "Permission denied"

**Solution**:

- Verify user is authenticated
- Check security rules allow writes to `supervisorData/*`
- Ensure custom claims or role field is set correctly
- Try temporarily relaxing rules to `allow read, write: if request.auth != null;`

### Issue: Data appears but doesn't load in app

**Solution**:

- Ensure @Published properties in AppSessionViewModel are declared
- Call fetch methods from onAppear() or via buttons
- Check console logs for Firestore errors
- Verify Codable conformance on data models

### Issue: Timestamps show incorrect time

**Solution**:

- Firebase uses server timestamps (Timestamp type)
- Ensure device time is correct
- Convert Timestamp to Date in Codable decode:
  ```swift
  let timestamp = data["timestamp"] as? Timestamp
  let date = timestamp?.dateValue() ?? Date()
  ```

### Issue: Collection doesn't exist error

**Solution**:

- Collections are created on first write - either write from app or manually create in console
- If manually creating, add at least one document with sample data
- If issues persist, delete and recreate the entire database

## Performance Optimization

### Batch Writes

For multiple notifications/insights, use batch write:

```swift
let batch = database.batch()
let docRef1 = database.collection("supervisorData").document("notifications")
batch.setData(notificationPayload, forDocument: docRef1, merge: true)
let docRef2 = database.collection("supervisorData").document("batchInsights")
batch.setData(insightPayload, forDocument: docRef2, merge: true)
batch.commit { error in
    // Handle completion
}
```

### Indexing

For complex queries, Firestore may suggest creating indexes. Enable auto-indexing in console for production.

### Pagination

If batch history grows, implement pagination:

```swift
let query = database.collection("supervisorData")
    .document("batchInsights")
    .collection("historicalBatches")
    .limit(to: 20)
    .order(by: "date", descending: true)
```

## Testing Checklist

- [ ] App compiles without errors
- [ ] Supervisor login routes to supervisor dashboard
- [ ] All 5 tabs render correctly
- [ ] Tab navigation works smoothly
- [ ] Mock data displays in all screens
- [ ] Colors match green/orange theme
- [ ] Sync button sends data to Firebase
- [ ] Firestore console shows updated data with server timestamp
- [ ] Fetch methods retrieve data from Firestore
- [ ] No compilation warnings about Codable
- [ ] No runtime crashes on screen transitions
