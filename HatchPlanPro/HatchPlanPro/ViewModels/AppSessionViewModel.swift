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
    @Published var hatchDetailSnapshots: [String: HatchDetailSnapshot] = [:]
    @Published var scannedBatches: [ScannedBatch] = []

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

    var defaultHatchDetails: [HatchDetailSnapshot] {
        [
            HatchDetailSnapshot(
                batchID: "#B7-902",
                productionUnit: "PRODUCTION UNIT 04",
                breed: "Ross 308 Superior Breed",
                criticalStatus: "CRITICAL",
                incubationStage: "Day 20 of 21 (Hatch Window Open)",
                imageName: "hatch_detail_banner",
                liveConnected: true,
                sensors: [
                    HatchSensorReading(title: "TEMP", value: "37.5", unit: "°C", trend: "STABLE", status: "STABLE", iconName: "thermometer.medium"),
                    HatchSensorReading(title: "HUMIDITY", value: "62.0", unit: "%", trend: "RISING", status: "RISING", iconName: "drop.fill")
                ],
                metricTiles: [
                    HatchMetricTile(title: "EGGS TO SET", value: "14,500", caption: "Batch target capacity", accent: "#245B24"),
                    HatchMetricTile(title: "SHAVALS NEEDED", value: "450", caption: "Estimated supply req.", accent: "#B78900")
                ],
                operationalTimeline: [
                    HatchMetricTile(title: "EGG SET DATE", value: "Oct 20, 2023", caption: "Operational timeline", accent: "#245B24"),
                    HatchMetricTile(title: "HATCH DATE", value: "Nov 10, 2023", caption: "Operational timeline", accent: "#B78900")
                ],
                sourceFlocks: [
                    SourceFlockItem(flockID: "F-902", ageWeeks: "34 weeks", allocated: "6,000", statusLabel: "ALLOCATED"),
                    SourceFlockItem(flockID: "F-815", ageWeeks: "41 weeks", allocated: "4,500", statusLabel: "ALLOCATED"),
                    SourceFlockItem(flockID: "F-722", ageWeeks: "34 weeks", allocated: "4,000", statusLabel: "ALLOCATED")
                ],
                biologicalTimeline: [
                    HatchTimelineStep(title: "Egg Setting", detail: "Day 1: 14,500 eggs placed in primary setters.", timeLabel: "COMPLETED", state: "completed"),
                    HatchTimelineStep(title: "Incubation Phase", detail: "Days 1-18: Temperature and humidity cycling active.", timeLabel: "ACTIVE", state: "active"),
                    HatchTimelineStep(title: "Transfer to Hatcher", detail: "Day 19: Transfer to hatcher baskets for final stage.", timeLabel: "UPCOMING", state: "upcoming"),
                    HatchTimelineStep(title: "Final Hatch Completion", detail: "Day 21: Pulling and quality assessment.", timeLabel: "UPCOMING", state: "upcoming")
                ],
                observations: [
                    SupervisorObservation(category: ObservationCategory.shellQuality.rawValue, note: "Egg weight loss trending at 11.2%. Batch #B7-902 is slightly ahead of schedule. Ventilator intake adjusted +5% to compensate for metabolic heat.", authorName: "Dr. Adrian Miller", authorRole: "HEAD SUPERVISOR", timeLabel: "08:15 AM TODAY", attachedPhotos: ["observation_1", "observation_2", "observation_3", "observation_4"])
                ],
                eggSetDate: "Oct 20, 2023",
                hatchDate: "Nov 10, 2023",
                co2Value: "5,420",
                co2Unit: "ppm",
                co2Bars: [0.35, 0.55, 0.8, 0.72, 0.9],
                eggsToSetLabel: "14,500",
                shavalsNeededLabel: "450"
            )
        ]
    }

    func initializeHatchDetails() {
        for detail in defaultHatchDetails {
            hatchDetailSnapshots[detail.batchID] = detail
        }
    }

    func detailSnapshot(for batch: ScheduledBatch) -> HatchDetailSnapshot {
        if let snapshot = hatchDetailSnapshots[batch.batchID] {
            return snapshot
        }

        return HatchDetailSnapshot(
            batchID: batch.batchID,
            productionUnit: "PRODUCTION UNIT 04",
            breed: batch.breed,
            criticalStatus: batch.status.isEmpty ? "ON TRACK" : batch.status,
            incubationStage: batch.dateLabel,
            imageName: "hatch_detail_banner",
            liveConnected: true,
            sensors: [
                HatchSensorReading(title: "TEMP", value: "37.5", unit: "°C", trend: "STABLE", status: "STABLE", iconName: "thermometer.medium"),
                HatchSensorReading(title: "HUMIDITY", value: "62.0", unit: "%", trend: "RISING", status: "RISING", iconName: "drop.fill")
            ],
            metricTiles: [
                HatchMetricTile(title: "EGGS TO SET", value: String(batch.eggs), caption: "Batch target capacity", accent: "#245B24"),
                HatchMetricTile(title: "SHAVALS NEEDED", value: "450", caption: "Estimated supply req.", accent: "#B78900")
            ],
            operationalTimeline: [
                HatchMetricTile(title: "EGG SET DATE", value: "Oct 20, 2023", caption: "Operational timeline", accent: "#245B24"),
                HatchMetricTile(title: "HATCH DATE", value: "Nov 10, 2023", caption: "Operational timeline", accent: "#B78900")
            ],
            sourceFlocks: [
                SourceFlockItem(flockID: "F-902", ageWeeks: "34 weeks", allocated: "6,000", statusLabel: "ALLOCATED"),
                SourceFlockItem(flockID: "F-815", ageWeeks: "41 weeks", allocated: "4,500", statusLabel: "ALLOCATED"),
                SourceFlockItem(flockID: "F-722", ageWeeks: "34 weeks", allocated: "4,000", statusLabel: "ALLOCATED")
            ],
            biologicalTimeline: [
                HatchTimelineStep(title: "Egg Setting", detail: "Day 1: eggs placed in primary setters.", timeLabel: "COMPLETED", state: "completed"),
                HatchTimelineStep(title: "Incubation Phase", detail: "Temperature and humidity cycling active.", timeLabel: "ACTIVE", state: "active"),
                HatchTimelineStep(title: "Transfer to Hatcher", detail: "Transfer to hatcher baskets for final stage.", timeLabel: "UPCOMING", state: "upcoming"),
                HatchTimelineStep(title: "Final Hatch Completion", detail: "Pulling and quality assessment.", timeLabel: "UPCOMING", state: "upcoming")
            ],
            observations: [
                SupervisorObservation(category: ObservationCategory.generalNote.rawValue, note: "Batch monitoring continues with stable readings.", authorName: "Dr. Adrian Miller", authorRole: "HEAD SUPERVISOR", timeLabel: "08:15 AM TODAY", attachedPhotos: ["observation_1", "observation_2", "observation_3", "observation_4"])
            ],
            eggSetDate: "Oct 20, 2023",
            hatchDate: "Nov 10, 2023",
            co2Value: "5,420",
            co2Unit: "ppm",
            co2Bars: [0.35, 0.55, 0.8, 0.72, 0.9],
            eggsToSetLabel: String(batch.eggs),
            shavalsNeededLabel: "450"
        )
    }

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

        // Sync hatch detail data
        syncHatchDetails()
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

    func syncHatchDetails() {
        guard !scheduledBatches.isEmpty else {
            return
        }

        for batch in scheduledBatches {
            let detail = detailSnapshot(for: batch)
            syncService.syncHatchDetail(detail) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.hatchDetailSnapshots[detail.batchID] = detail
                    case .failure(let error):
                        print("Failed to sync hatch details: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func fetchHatchDetail(for batchID: String) {
        syncService.fetchHatchDetail(batchID: batchID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self.hatchDetailSnapshots[batchID] = detail
                case .failure(let error):
                    print("Failed to fetch hatch detail: \(error.localizedDescription)")
                }
            }
        }
    }

    func saveObservation(for batchID: String,
                         category: ObservationCategory,
                         note: String,
                         attachedPhotos: [String],
                         editingObservationID: String? = nil) {
        let currentSnapshot = hatchDetailSnapshots[batchID] ?? detailSnapshot(for: scheduledBatches.first(where: { $0.batchID == batchID }) ?? ScheduledBatch(batchID: batchID, breed: "Ross 308", eggs: 0, time: "00:00", timeOfDay: "AM", dateLabel: "TODAY", status: "", statusColor: .clear))

        var updatedObservations = currentSnapshot.observations
        let newObservation = SupervisorObservation(
            category: category.rawValue,
            note: note,
            authorName: currentUser.fullName,
            authorRole: currentUser.role.shortTitle.uppercased(),
            timeLabel: DateFormatter.observationTimestamp.string(from: Date()),
            attachedPhotos: attachedPhotos
        )

        if let editingObservationID,
           let index = updatedObservations.firstIndex(where: { $0.id == editingObservationID }) {
            updatedObservations[index] = newObservation
        } else {
            updatedObservations.insert(newObservation, at: 0)
        }

        let updatedSnapshot = HatchDetailSnapshot(
            batchID: currentSnapshot.batchID,
            productionUnit: currentSnapshot.productionUnit,
            breed: currentSnapshot.breed,
            criticalStatus: currentSnapshot.criticalStatus,
            incubationStage: currentSnapshot.incubationStage,
            imageName: currentSnapshot.imageName,
            liveConnected: currentSnapshot.liveConnected,
            sensors: currentSnapshot.sensors,
            metricTiles: currentSnapshot.metricTiles,
            operationalTimeline: currentSnapshot.operationalTimeline,
            sourceFlocks: currentSnapshot.sourceFlocks,
            biologicalTimeline: currentSnapshot.biologicalTimeline,
            observations: updatedObservations,
            eggSetDate: currentSnapshot.eggSetDate,
            hatchDate: currentSnapshot.hatchDate,
            co2Value: currentSnapshot.co2Value,
            co2Unit: currentSnapshot.co2Unit,
            co2Bars: currentSnapshot.co2Bars,
            eggsToSetLabel: currentSnapshot.eggsToSetLabel,
            shavalsNeededLabel: currentSnapshot.shavalsNeededLabel
        )

        hatchDetailSnapshots[batchID] = updatedSnapshot
        syncService.syncHatchDetail(updatedSnapshot) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.hatchDetailSnapshots[batchID] = updatedSnapshot
                case .failure(let error):
                    print("Failed to save observation: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Vision Kit Scanned Batch Methods

    func saveScannedBatch(_ batch: ScannedBatch) {
        scannedBatches.append(batch)
        syncService.syncScannedBatch(batch) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Scanned batch saved successfully: \(batch.batchID)")
                case .failure(let error):
                    print("Failed to save scanned batch: \(error.localizedDescription)")
                }
            }
        }
    }

    func fetchScannedBatches() {
        syncService.fetchScannedBatches { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let batches):
                    self.scannedBatches = batches
                case .failure(let error):
                    print("Failed to fetch scanned batches: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Execute Set
    func executeSet(batchID: String, completion: @escaping (Bool) -> Void) {
        // Prepare payload
        let snapshot = hatchDetailSnapshots[batchID]
        let units = snapshot?.eggsToSetLabel ?? ""
        let payload: [String: Any] = [
            "batchID": batchID,
            "initiatedBy": currentUser.fullName,
            "units": units,
            "notes": "Executed set from supervisor app"
        ]

        syncService.syncExecuteSet(batchID: batchID, payload: payload) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // update local snapshot status
                    if let old = self.hatchDetailSnapshots[batchID] {
                        let updated = HatchDetailSnapshot(
                            batchID: old.batchID,
                            productionUnit: old.productionUnit,
                            breed: old.breed,
                            criticalStatus: "SYNCED",
                            incubationStage: old.incubationStage,
                            imageName: old.imageName,
                            liveConnected: old.liveConnected,
                            metricTiles: old.metricTiles,
                            operationalTimeline: old.operationalTimeline,
                            sourceFlocks: old.sourceFlocks,
                            biologicalTimeline: old.biologicalTimeline,
                            observations: old.observations,
                            eggSetDate: old.eggSetDate,
                            hatchDate: old.hatchDate,
                            co2Value: old.co2Value,
                            co2Unit: old.co2Unit,
                            co2Bars: old.co2Bars,
                            eggsToSetLabel: old.eggsToSetLabel,
                            shavalsNeededLabel: old.shavalsNeededLabel
                        )
                        self.hatchDetailSnapshots[batchID] = updated
                    }
                    completion(true)
                case .failure(let error):
                    print("Failed to execute set: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }

    init() {
        initializeScheduledBatches()
        initializeHatchDetails()
    }
}

private extension DateFormatter {
    static let observationTimestamp: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy • HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
