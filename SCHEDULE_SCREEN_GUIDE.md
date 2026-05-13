# Schedule Screen Implementation Guide

## Overview

The **Schedule Screen** (`SupervisorScheduleView`) is a dedicated interface for Hatchery Supervisors to view and manage upcoming batch hatching schedules. It displays scheduled batches organized by date with real-time status indicators and an efficiency forecast at the bottom.

## Access Path

1. Open HatchPlan Pro app
2. Authenticate as Supervisor
3. Navigate to Supervisor Dashboard (Home Tab)
4. Scroll to "Upcoming Hatches" section
5. Tap **"View Schedule"** link at top-right

## Features

### 1. Search Functionality

- **Input Field**: "Search batches or breed type..."
- **Scope**: Searches both batch ID and breed name (case-insensitive)
- **Real-Time Filtering**: Results update as user types
- **Persistent**: Search text retained while navigating within the view

### 2. Batch Organization

**Grouping**: Batches grouped by date label

- TODAY, OCT 25
- TOMORROW, OCT 26
- Other dates as scheduled

**Sorting Within Date**: Batches sorted chronologically by time (earliest first)

**Batch Card Components**:

- Time (left panel)
  - Large time display: "08:45"
  - Time period: "AM" or "PM"
- Batch Details (middle panel)
  - Batch ID: "#B7-902" (green text, #245B24)
  - Status badge (optional): "CRITICAL" or "ON DECK"
  - Breed: "Ross 308" (secondary gray text)
  - Egg count: "12,480 Eggs" (green, bold)
- Chevron (right)
  - Navigation indicator for future drill-in capability

### 3. Status Badges

Two primary statuses with color coding:

**CRITICAL** (Orange #FFB800)

- Requires immediate attention
- Example: #B7-902 at 08:45 AM

**ON DECK** (Green #245B24)

- Ready and waiting
- Example: #C2-114 at 11:30 AM

**No Badge** (Empty Status)

- Routine/upcoming batches
- Example: #A9-442 (Tomorrow)

### 4. Efficiency Forecast Card

Located at bottom of schedule list

**Design**:

- Deep green background (#245B24)
- White text
- Progress bar with gold/yellow fill (#FFD700)
- Percentage display on right

**Components**:

- **Label**: "EFFICIENCY FORECAST"
- **Title**: "Hatch window peaks in 4.5h" (or dynamic title)
- **Progress Bar**: Visual representation of forecast (0-100%)
- **Percentage**: Numeric value (e.g., "75%")

## Data Models

### ScheduledBatch

```swift
struct ScheduledBatch: Identifiable, Codable, Hashable {
    let id: String                    // UUID
    let batchID: String              // "#B7-902"
    let breed: String                // "Ross 308"
    let eggs: Int                    // 12480
    let time: String                 // "08:45"
    let timeOfDay: String            // "AM" or "PM"
    let dateLabel: String            // "TODAY, OCT 25"
    let status: String               // "CRITICAL", "ON DECK", ""
    let statusColor: Color           // Computed from status
}
```

### EfficiencyForecast

```swift
struct EfficiencyForecast: Codable, Hashable {
    let title: String               // "Hatch window peaks in 4.5h"
    let percentage: Double          // 0.75 (stored 0.0-1.0)
    let peakTime: String?           // "4.5h"
}
```

## Firebase Integration

### Collection Path: `supervisorData/schedule`

**Write Operation**:

```swift
// Triggered by session.syncScheduleData()
syncService.syncScheduledBatches(schedule: scheduledBatches,
                                 forecast: efficiencyForecast)
```

**Read Operation**:

```swift
// Manual fetch or triggered by onAppear()
session.fetchScheduledBatches()
```

### Firestore Document Structure

```json
{
  "schedule": [
    {
      "id": "uuid",
      "batchID": "#B7-902",
      "breed": "Ross 308",
      "eggs": 12480,
      "time": "08:45",
      "timeOfDay": "AM",
      "dateLabel": "TODAY, OCT 25",
      "status": "CRITICAL"
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

## UI Layout Details

### Colors (Consistent with Supervisor Theme)

- **Primary Green**: #245B24 (headings, icons, ON DECK badges)
- **Soft Green**: #EAF3EA (card backgrounds, header bar)
- **Accent Orange**: #B78900 (secondary elements)
- **Critical Orange**: #FFB800 (CRITICAL badge, forecast bar)
- **Surface Gray**: #F7F7FA (page background)
- **White**: #FFFFFF (card backgrounds)

### Typography

- **Header ("Schedule")**: System title (inline, navigation bar)
- **Date Labels ("TODAY, OCT 25")**: Caption bold, kerning 1
- **Time ("08:45")**: Headline bold, green text
- **Time Period ("AM")**: Caption, gray text
- **Batch ID ("#B7-902")**: Headline, green text
- **Status Badge**: Caption2 bold, white text, colored background
- **Breed ("Ross 308")**: Caption, gray text
- **Egg Count ("12,480 Eggs")**: Caption semibold, green text
- **Forecast Title ("EFFICIENCY FORECAST")**: Caption bold, white, kerning 1
- **Forecast Subtitle ("Hatch window peaks...")**: Title2 bold, white
- **Forecast Percentage ("75%")**: Caption semibold, white

### Spacing

- View padding: 16pt horizontal
- Section spacing: 20pt vertical between date groups
- Card spacing: 12pt between batch cards within date
- Card padding: 14pt internal
- Corner radius: 16pt (search bar), 14pt (batch cards), 20pt (forecast card)
- Shadow: 0.05 opacity black, 8pt blur

## Usage Flow

1. **View Loading**
   - SupervisorScheduleView appears with mock data from AppSessionViewModel
   - Scheduled batches initialized from AppSessionViewModel.initializeScheduledBatches()
   - Forecast displayed from AppSessionViewModel.efficiencyForecast

2. **Search**
   - User types in search bar
   - filteredSchedules computed property filters both batchID and breed
   - Results update in real-time
   - If no matches: empty list displayed

3. **Batch Grouping**
   - groupedSchedules computed property groups by dateLabel
   - Sorted chronologically (TODAY before TOMORROW)
   - Within each date, sorted by time (08:45 before 11:30)

4. **Firebase Sync** (Optional)
   - Call `session.fetchScheduledBatches()` in onAppear() to load live data
   - Or call `session.syncScheduleData()` to write to Firebase
   - Data persists in Firestore, synced across devices

## Styling Examples

### Search Bar

```swift
HStack(spacing: 12) {
    Image(systemName: "magnifyingglass")
        .foregroundColor(.secondary)
    TextField("Search batches or breed type...", text: $searchText)
        .textFieldStyle(.plain)
}
.padding(14)
.background(RoundedRectangle(cornerRadius: 16).fill(.white))
.shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
```

### Batch Card

```swift
HStack(alignment: .center, spacing: 16) {
    // Time panel
    VStack(alignment: .center, spacing: 2) {
        Text(batch.time).font(.headline.bold()).foregroundColor(.hatchGreen)
        Text(batch.timeOfDay).font(.caption).foregroundColor(.secondary)
    }
    .frame(width: 50, alignment: .center)

    // Details panel
    VStack(alignment: .leading, spacing: 6) {
        HStack(spacing: 8) {
            Text(batch.batchID).font(.headline).foregroundColor(.hatchGreen)
            if !batch.status.isEmpty {
                Text(batch.status)
                    .font(.caption2.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 8)
                    .background(RoundedRectangle(cornerRadius: 6).fill(batch.statusColor))
            }
        }
        Text(batch.breed).font(.caption).foregroundColor(.secondary)
        Text("\(batch.eggs) Eggs").font(.caption.weight(.semibold)).foregroundColor(.hatchGreen)
    }

    Spacer()
    Image(systemName: "chevron.right").foregroundColor(.secondary)
}
.padding(14)
.background(RoundedRectangle(cornerRadius: 14).fill(.white))
.shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
```

### Efficiency Forecast

```swift
VStack(alignment: .leading, spacing: 12) {
    Text("EFFICIENCY FORECAST")
        .font(.caption.weight(.bold))
        .kerning(1)
        .foregroundColor(.white)

    Text(session.efficiencyForecast.title)
        .font(.title2.bold())
        .foregroundColor(.white)

    HStack(spacing: 12) {
        ProgressView(value: session.efficiencyForecast.percentage)
            .tint(Color(hex: "#FFD700"))
            .frame(height: 6)

        Text(String(format: "%.0f%%", session.efficiencyForecast.percentage * 100))
            .font(.caption.weight(.semibold))
            .foregroundColor(.white)
    }
}
.frame(maxWidth: .infinity, alignment: .leading)
.padding(20)
.background(RoundedRectangle(cornerRadius: 20).fill(.hatchGreen))
```

## Data Flow Diagram

```
SupervisorScheduleView
    ↓
@EnvironmentObject AppSessionViewModel
    ↓
session.scheduledBatches [ScheduledBatch]
session.efficiencyForecast EfficiencyForecast
    ↓
filteredSchedules (computed, filtered by search)
    ↓
groupedSchedules (computed, grouped & sorted)
    ↓
VStack → forEach dateGroup → forEach batch → scheduledBatchCard()
    ↓
Firebase (optional)
    ↓
supervisorData/schedule document
```

## Testing Checklist

- [ ] Search filters batches by batch ID correctly
- [ ] Search filters batches by breed correctly
- [ ] Search is case-insensitive
- [ ] Batches grouped by date label
- [ ] Batches sorted by time within date
- [ ] CRITICAL badge displays in orange (#FFB800)
- [ ] ON DECK badge displays in green (#245B24)
- [ ] Empty status shows no badge
- [ ] Efficiency Forecast displays correct title
- [ ] Progress bar fills to correct percentage
- [ ] Percentage text displays with 0 decimals
- [ ] Forecast card background is green (#245B24)
- [ ] Search bar styling matches design
- [ ] Tap "View Schedule" from home → navigates correctly
- [ ] Back button returns to home
- [ ] No horizontal scroll needed
- [ ] Cards have proper shadows
- [ ] Text colors match green/orange palette

## Future Enhancements

1. **Batch Detail Screen**: Tap batch card to drill-in and view:
   - Full batch specifications
   - Temperature/humidity settings
   - Historical performance
   - Notes and alerts

2. **Advanced Filtering**: Add filters for:
   - Status (CRITICAL, ON DECK, Routine)
   - Breed type (Ross, Cobb, Hubbard)
   - Egg count range

3. **Calendar View**: Alternative view showing month calendar with batch markers

4. **Notifications**: Set reminders for critical batches

5. **Export**: Generate PDF schedule report for team

6. **Real-Time Updates**: WebSocket connection for live batch status changes

7. **Analytics**: View schedule fulfillment metrics (on-time hatch %)

## Troubleshooting

### Search Not Working?

- Verify searchText binding is connected
- Check filteredSchedules logic for case-insensitivity
- Ensure batch data contains test IDs/breeds

### Batches Out of Order?

- Verify time format is "HH:MM" (24-hour)
- Check dateLabel consistency (e.g., "TODAY, OCT 25")
- Sort function should handle date parsing

### Colors Not Showing?

- Verify Color(hex:) extension imported from SupervisorTheme
- Check .hatchGreen, .hatchOrange colors defined
- Ensure statusColor computed based on status string

### Firebase Write Fails?

- Confirm Firestore security rules allow write to supervisorData/schedule
- Check GoogleService-Info.plist included
- Verify network connectivity

### Mock Data Not Showing?

- Ensure AppSessionViewModel.initializeScheduledBatches() called in init()
- Verify scheduledBatches @Published property declared
- Check EnvironmentObject injection in app root

---

**Last Updated**: May 13, 2026
**Version**: 1.0
**Status**: Production Ready
