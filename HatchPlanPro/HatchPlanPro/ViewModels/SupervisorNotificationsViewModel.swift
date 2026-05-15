import Foundation
import Combine
import SwiftUI

struct NotificationSectionItem: Identifiable {
    let id = UUID()
    let type: String
    let icon: String
    let iconBg: Color
    let title: String
    let time: String
}

struct NotificationSection: Identifiable {
    let id = UUID()
    let title: String
    let notifications: [NotificationSectionItem]
}

class SupervisorNotificationsViewModel: ObservableObject {
    @Published var sections: [NotificationSection] = []
    
    func loadData(from session: AppSessionViewModel) {
        let notifications = session.supervisorNotifications

        guard !notifications.isEmpty else {
            sections = []
            return
        }

        let grouped = Dictionary(grouping: notifications) { notification in
            let hoursSince = Date().timeIntervalSince(notification.timestamp) / 3600
            if hoursSince < 24 {
                return "TODAY"
            } else if hoursSince < 168 {
                return "LAST WEEK"
            } else {
                return "EARLIER"
            }
        }

        sections = ["TODAY", "LAST WEEK", "EARLIER"].compactMap { key in
            guard let items = grouped[key], !items.isEmpty else { return nil }
            return NotificationSection(title: key, notifications: items.map { notification in
                NotificationSectionItem(
                    type: notification.type.displayName,
                    icon: notification.type.iconName,
                    iconBg: notification.type == .criticalAlert ? Color(hex: "#FFA500") : (notification.type == .approvalUpdate ? .hatchGreen : Color(hex: "#A0A0A0")),
                    title: notification.title,
                    time: notification.timeLabel
                )
            })
        }
    }
}
