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
        // Ideally mapped from session.supervisorNotifications, 
        // using mock structured data here for the UI match
        self.sections = [
            NotificationSection(title: "TODAY", notifications: [
                NotificationSectionItem(type: "CRITICAL ALERT", icon: "exclamationmark.circle.fill", iconBg: Color(hex: "#FFA500"), title: "Batch #B1024 is 24 hours from hatching. Resource allocation required.", time: "2m ago"),
                NotificationSectionItem(type: "APPROVAL UPDATE", icon: "checkmark.circle.fill", iconBg: .hatchGreen, title: "Plan for Batch #B1030 has been Approved by Manager Aruni.", time: "1h ago")
            ]),
            NotificationSection(title: "LAST WEEK", notifications: [
                NotificationSectionItem(type: "SYSTEM MESSAGE", icon: "gearshape.fill", iconBg: Color(hex: "#A0A0A0"), title: "Sensor Calibration Sync completed for Incubation Hall B.", time: "Yesterday"),
                NotificationSectionItem(type: "WEEKLY REPORT", icon: "chart.bar.fill", iconBg: Color(hex: "#8B7355"), title: "Performance summary for Hall A is now available. Hatch rate increased by 4.2%.", time: "2 days ago")
            ]),
            NotificationSection(title: "EARLIER", notifications: [
                NotificationSectionItem(type: "SYSTEM MESSAGE", icon: "gearshape.fill", iconBg: Color(hex: "#A0A0A0"), title: "Routine backup completed successfully.", time: "1 week ago")
            ])
        ]
    }
}
