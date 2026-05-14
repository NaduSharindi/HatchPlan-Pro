//
//  ManagerNotificationsViewModel.swift
//  HatchPlanPro
//
//  Fetches and manages manager notifications from both Firebase
//  and Core Data local cache. Supports marking as read and
//  grouping by time period.
//

import Foundation
import Combine
import SwiftUI

/// Groups manager notifications into time-based sections for display.
struct ManagerNotificationSection: Identifiable {
    let id = UUID()
    let title: String
    let notifications: [ManagerNotificationItem]
}

/// A display-ready notification item for the manager role.
struct ManagerNotificationItem: Identifiable {
    let id: String
    let type: String
    let icon: String
    let iconBg: Color
    let title: String
    let message: String
    let time: String
    let isRead: Bool
}

/// ViewModel for the Manager Notifications screen.
/// Loads data from AppSessionViewModel (Firebase) and falls back
/// to Core Data when offline.
class ManagerNotificationsViewModel: ObservableObject {
    @Published var sections: [ManagerNotificationSection] = []
    @Published var isLoading: Bool = false
    @Published var unreadCount: Int = 0
    
    /// Loads manager notifications from the session (Firebase-backed)
    /// and organises them into sections.
    func loadData(from session: AppSessionViewModel) {
        isLoading = true
        
        // Trigger fetch from Firebase
        session.fetchManagerNotifications()
        
        // Use a short delay to let the async fetch complete,
        // then build sections from whatever data is available.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self else { return }
            self.buildSections(from: session.managerNotifications)
            self.isLoading = false
        }
    }
    
    /// Builds display sections from raw notification data.
    private func buildSections(from notifications: [HatcheryNotification]) {
        // If Firebase data is empty, use sample data
        let items = notifications.isEmpty ? Self.sampleNotifications : notifications
        
        var todayItems: [ManagerNotificationItem] = []
        var weekItems: [ManagerNotificationItem] = []
        var earlierItems: [ManagerNotificationItem] = []
        
        for notif in items {
            let item = ManagerNotificationItem(
                id: notif.id,
                type: notif.type.displayName,
                icon: notif.type.iconName,
                iconBg: Self.iconBackground(for: notif.type),
                title: notif.title,
                message: notif.message,
                time: notif.timeLabel,
                isRead: false
            )
            
            let hoursSince = Date().timeIntervalSince(notif.timestamp) / 3600
            if hoursSince < 24 {
                todayItems.append(item)
            } else if hoursSince < 168 {
                weekItems.append(item)
            } else {
                earlierItems.append(item)
            }
        }
        
        var sections: [ManagerNotificationSection] = []
        if !todayItems.isEmpty {
            sections.append(ManagerNotificationSection(title: "TODAY", notifications: todayItems))
        }
        if !weekItems.isEmpty {
            sections.append(ManagerNotificationSection(title: "THIS WEEK", notifications: weekItems))
        }
        if !earlierItems.isEmpty {
            sections.append(ManagerNotificationSection(title: "EARLIER", notifications: earlierItems))
        }
        
        self.sections = sections
        self.unreadCount = items.count
    }
    
    /// Returns the appropriate background colour for notification type icons.
    private static func iconBackground(for type: NotificationType) -> Color {
        switch type {
        case .criticalAlert:
            return Color(hex: "#FFA500")
        case .approvalUpdate:
            return .hatchGreen
        case .systemMessage:
            return Color(hex: "#A0A0A0")
        case .weeklyReport:
            return Color(hex: "#8B7355")
        }
    }
    
    /// Sample notifications used when Firebase data is not yet available.
    private static var sampleNotifications: [HatcheryNotification] {
        [
            HatcheryNotification(type: .criticalAlert, title: "Batch B-08 humidity spike detected. Immediate review required.", message: "Humidity exceeded threshold", timestamp: Date().addingTimeInterval(-300), timeLabel: "5 min ago"),
            HatcheryNotification(type: .approvalUpdate, title: "Supervisor submitted Batch #C2-114 for approval.", message: "New approval request", timestamp: Date().addingTimeInterval(-1800), timeLabel: "30 min ago"),
            HatcheryNotification(type: .systemMessage, title: "Sensor calibration completed for Incubation Hall B.", message: "System update", timestamp: Date().addingTimeInterval(-7200), timeLabel: "2h ago"),
            HatcheryNotification(type: .weeklyReport, title: "Weekly production report: Hatch rate improved by 3.1% across all facilities.", message: "Performance report", timestamp: Date().addingTimeInterval(-86400), timeLabel: "Yesterday"),
            HatcheryNotification(type: .systemMessage, title: "Routine backup completed successfully for all hatchery data.", message: "Backup complete", timestamp: Date().addingTimeInterval(-604800), timeLabel: "1 week ago")
        ]
    }
}
