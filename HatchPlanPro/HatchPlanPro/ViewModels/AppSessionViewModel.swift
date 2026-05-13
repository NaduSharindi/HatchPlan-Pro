//
//  AppSessionViewModel.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-12.
//

import Foundation
import Combine
import SwiftUI

final class AppSessionViewModel: ObservableObject {
    @Published var currentRole: HatcheryRole = .manager
    @Published var currentUser = HatcheryUserProfile(
        fullName: "Nadunika Sharindi",
        email: "nadunika@hatchplanpro.com",
        role: .manager,
        preferredSecurity: "PIN + Face ID"
    )
    @Published var isPINVerified = false
    @Published var isAuthenticated = false
    @Published var preferredSecurityMethod = "PIN"
    @Published var lastSyncSummary = "Local draft"
    @Published var selectedTabIndex = 0
    @Published var supervisorNotifications: [HatcheryNotification] = []
    @Published var batchInsights: [BatchInsight] = []
    @Published var scheduledBatches: [ScheduledBatch] = []
    @Published var efficiencyForecast = EfficiencyForecast(title: "Hatch window peaks in 4.5h", percentage: 0.75)

    private let syncService = HatcherySyncService()

    let managerBatches: [HatcheryBatch] = [
        HatcheryBatch(name: "Batch A-24", stage: "Incubation Day 7", eggs: 1200, temperature: 37.8, humidity: 58, turnerStatus: "Auto-turning", completionProgress: 0.62, isCritical: false),
        HatcheryBatch(name: "Batch B-08", stage: "Hatch Prep", eggs: 980, temperature: 38.2, humidity: 64, turnerStatus: "Needs check", completionProgress: 0.84, isCritical: true),
        HatcheryBatch(name: "Batch C-11", stage: "Brooding", eggs: 760, temperature: 37.5, humidity: 55, turnerStatus: "Stable", completionProgress: 0.45, isCritical: false)
    ]

    let supervisorBatches: [HatcheryBatch] = [
        HatcheryBatch(name: "Hatch Room 1", stage: "Monitoring", eggs: 450, temperature: 37.6, humidity: 61, turnerStatus: "Manual follow-up", completionProgress: 0.52, isCritical: false),
        HatcheryBatch(name: "Incubator 3", stage: "Critical Alert", eggs: 310, temperature: 39.1, humidity: 68, turnerStatus: "Door opened", completionProgress: 0.91, isCritical: true),
        HatcheryBatch(name: "Incubator 5", stage: "Cooling Down", eggs: 540, temperature: 37.4, humidity: 56, turnerStatus: "Normal", completionProgress: 0.37, isCritical: false)
    ]

    let managerTasks: [HatcheryTask] = [
        HatcheryTask(title: "Approve batch transfer", subtitle: "Review movement from Brooder 2 to Brooder 3", state: .pending, dueLabel: "Due 10:30 AM", iconName: "checklist"),
        HatcheryTask(title: "Share production report", subtitle: "Export daily performance to stakeholder email", state: .inProgress, dueLabel: "Due today", iconName: "square.and.arrow.up"),
        HatcheryTask(title: "Schedule maintenance", subtitle: "Confirm humidifier service window", state: .done, dueLabel: "Completed", iconName: "wrench.and.screwdriver")
    ]

    let supervisorTasks: [HatcheryTask] = [
        HatcheryTask(title: "Confirm temperature log", subtitle: "Record readings for every active incubator", state: .inProgress, dueLabel: "Due now", iconName: "thermometer.medium"),
        HatcheryTask(title: "Review hatch tray count", subtitle: "Compare tray numbers with night shift log", state: .pending, dueLabel: "Due 2:00 PM", iconName: "tray.full"),
        HatcheryTask(title: "Escalate alert to manager", subtitle: "Send the latest anomaly report", state: .done, dueLabel: "Completed", iconName: "exclamationmark.triangle")
    ]

    let managerAlerts: [HatcheryAlert] = [
        HatcheryAlert(title: "Batch B-08 humidity spike", details: "Humidity rose above the upper threshold for 8 minutes.", severity: "Critical", timeLabel: "5 min ago", iconName: "drop.triangle.fill"),
        HatcheryAlert(title: "Maintenance window ready", details: "Equipment service can be scheduled after 3:00 PM.", severity: "Info", timeLabel: "18 min ago", iconName: "calendar.badge.clock")
    ]

    let supervisorAlerts: [HatcheryAlert] = [
        HatcheryAlert(title: "Incubator 3 door open", details: "Immediate attention is required to stabilise the chamber.", severity: "Critical", timeLabel: "2 min ago", iconName: "door.left.hand.open"),
        HatcheryAlert(title: "Brooder temperature steady", details: "Readings have been stable for the last 30 minutes.", severity: "Info", timeLabel: "12 min ago", iconName: "thermometer.sun.fill")
    ]

    func initializeScheduledBatches() {
        scheduledBatches = [
            // Today, Oct 25
            ScheduledBatch(
                batchID: "#B7-902",
                breed: "Ross 308",
                eggs: 12480,
                time: "08:45",
                timeOfDay: "AM",
                dateLabel: "TODAY, OCT 25",
                status: "CRITICAL",
                statusColor: Color(hex: "#FFB800")
            ),
            ScheduledBatch(
                batchID: "#C2-114",
                breed: "Cobb 500",
                eggs: 8200,
                time: "11:30",
                timeOfDay: "AM",
                dateLabel: "TODAY, OCT 25",
                status: "ON DECK",
                statusColor: .hatchGreen
            ),
            // Tomorrow, Oct 26
            ScheduledBatch(
                batchID: "#A9-442",
                breed: "Ross 308",
                eggs: 15000,
                time: "06:00",
                timeOfDay: "AM",
                dateLabel: "TOMORROW, OCT 26",
                status: "",
                statusColor: .clear
            ),
            ScheduledBatch(
                batchID: "#B3-008",
                breed: "Hubbard",
                eggs: 5600,
                time: "02:15",
                timeOfDay: "PM",
                dateLabel: "TOMORROW, OCT 26",
                status: "",
                statusColor: .clear
            )
        ]
    }

    var batches: [HatcheryBatch] {
        currentRole == .manager ? managerBatches : supervisorBatches
    }

    var tasks: [HatcheryTask] {
        currentRole == .manager ? managerTasks : supervisorTasks
    }

    var alerts: [HatcheryAlert] {
        currentRole == .manager ? managerAlerts : supervisorAlerts
    }

    var metrics: [HatcheryMetric] {
        switch currentRole {
        case .manager:
            return [
                HatcheryMetric(title: "Hatch rate", value: "92%", change: "+4.2%", tint: Color(hex: "#14796D")),
                HatcheryMetric(title: "Active batches", value: "3", change: "1 critical", tint: Color.figmaPrimary),
                HatcheryMetric(title: "Avg. temp.", value: "37.8°C", change: "Stable", tint: Color(hex: "#0F4C81"))
            ]
        case .supervisor:
            return [
                HatcheryMetric(title: "Rooms monitored", value: "5", change: "1 urgent", tint: Color(hex: "#14796D")),
                HatcheryMetric(title: "Tasks complete", value: "8/10", change: "+2 today", tint: Color.figmaPrimary),
                HatcheryMetric(title: "Alert response", value: "2m", change: "Fast", tint: Color(hex: "#0F4C81"))
            ]
        }
    }

    var todaySummary: String {
        switch currentRole {
        case .manager:
            return "Track production, review critical batches, and keep hatch rates predictable."
        case .supervisor:
            return "Monitor incubators, capture readings, and escalate anomalies before they spread."
        }
    }

    func chooseRole(_ role: HatcheryRole) {
        currentRole = role
        currentUser = HatcheryUserProfile(
            fullName: role == .manager ? "Hatchery Manager" : "Hatchery Supervisor",
            email: role == .manager ? "manager@hatchplanpro.com" : "supervisor@hatchplanpro.com",
            role: role,
            preferredSecurity: preferredSecurityMethod
        )
    }

    func recordCredentials(email: String, name: String? = nil) {
        currentUser = HatcheryUserProfile(
            fullName: name?.isEmpty == false ? name! : currentUser.fullName,
            email: email,
            role: currentRole,
            preferredSecurity: preferredSecurityMethod
        )
    }

    func markPINVerified() {
        isPINVerified = true
    }

    func completeAuthentication(usingFaceID: Bool) {
        preferredSecurityMethod = usingFaceID ? "Face ID" : "PIN"
        currentUser = HatcheryUserProfile(
            fullName: currentUser.fullName,
            email: currentUser.email,
            role: currentRole,
            preferredSecurity: usingFaceID ? "Face ID" : "PIN"
        )
        isAuthenticated = true
    }

    func signOut() {
        isPINVerified = false
        isAuthenticated = false
        selectedTabIndex = 0
    }

    func syncCurrentState(completion: @escaping (String) -> Void) {
        syncService.syncDashboardSnapshot(role: currentRole, batches: batches, tasks: tasks) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.lastSyncSummary = "Synced to Firebase just now"
                    completion(self.lastSyncSummary)
                case .failure(let error):
                    self.lastSyncSummary = "Sync failed: \(error.localizedDescription)"
                    completion(self.lastSyncSummary)
                }
            }
        }
    }

    func fetchSupervisorNotifications() {
        syncService.fetchSupervisorNotifications { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let notifications):
                    self.supervisorNotifications = notifications
                case .failure(let error):
                    print("Failed to fetch notifications: \(error.localizedDescription)")
                }
            }
        }
    }

    func fetchBatchInsights() {
        syncService.fetchBatchInsights { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let insights):
                    self.batchInsights = insights
                case .failure(let error):
                    print("Failed to fetch batch insights: \(error.localizedDescription)")
                }
            }
        }
    }

    func syncSupervisorData() {
        // Create sample notifications and insights for supervisor
        let sampleNotifications: [HatcheryNotification] = [
            HatcheryNotification(type: .criticalAlert, title: "Batch #B1024 is 24 hours from hatching. Resource allocation required.", message: "Critical resource needed", timestamp: Date().addingTimeInterval(-120), timeLabel: "2m ago"),
            HatcheryNotification(type: .approvalUpdate, title: "Plan for Batch #B1030 has been Approved by Manager Aruni.", message: "Batch approved", timestamp: Date().addingTimeInterval(-3600), timeLabel: "1h ago")
        ]

        syncService.syncSupervisorNotifications(notifications: sampleNotifications) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.supervisorNotifications = sampleNotifications
                case .failure(let error):
                    print("Failed to sync notifications: \(error.localizedDescription)")
                }
            }
        }

        // Create sample batch insights
        let sampleInsights: [BatchInsight] = [
            BatchInsight(batchID: "#B1024", breed: "Ross 308", date: "Oct 24, 2023", status: .approvedReady, hatchRate: nil),
            BatchInsight(batchID: "#B1029", breed: "Ross 708", date: "Oct 24, 2023", status: .pendingReview, hatchRate: nil),
            BatchInsight(batchID: "#B2023-10-A", breed: "Cobb 500", date: "Oct 28, 2023", status: .synced, hatchRate: "94.5%")
        ]

        syncService.syncBatchInsights(insights: sampleInsights) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.batchInsights = sampleInsights
                case .failure(let error):
                    print("Failed to sync batch insights: \(error.localizedDescription)")
                }
            }
        }

        // Sync schedule data
        syncScheduleData()
    }

    func syncScheduleData() {
        syncService.syncScheduledBatches(schedule: scheduledBatches, forecast: efficiencyForecast) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Schedule synced to Firebase")
                case .failure(let error):
                    print("Failed to sync schedule: \(error.localizedDescription)")
                }
            }
        }
    }

    func fetchScheduledBatches() {
        syncService.fetchScheduledBatches { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (batches, forecast)):
                    self.scheduledBatches = batches
                    self.efficiencyForecast = forecast
                case .failure(let error):
                    print("Failed to fetch scheduled batches: \(error.localizedDescription)")
                }
            }
        }
    }

    override init() {
        super.init()
        initializeScheduledBatches()
    }
}
