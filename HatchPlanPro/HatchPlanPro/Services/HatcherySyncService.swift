//
//  HatcherySyncService.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-12.
//

import Foundation
import FirebaseFirestore

final class HatcherySyncService {
    private let database = Firestore.firestore()

    func syncDashboardSnapshot(role: HatcheryRole,
                               batches: [HatcheryBatch],
                               tasks: [HatcheryTask],
                               completion: @escaping (Result<Void, Error>) -> Void) {
        let batchPayload = batches.map { batch in
            [
                "name": batch.name,
                "stage": batch.stage,
                "eggs": batch.eggs,
                "temperature": batch.temperature,
                "humidity": batch.humidity,
                "turnerStatus": batch.turnerStatus,
                "progress": batch.completionProgress,
                "critical": batch.isCritical
            ] as [String: Any]
        }

        let taskPayload = tasks.map { task in
            [
                "title": task.title,
                "subtitle": task.subtitle,
                "state": task.state.rawValue,
                "dueLabel": task.dueLabel,
                "iconName": task.iconName
            ] as [String: Any]
        }

        let payload: [String: Any] = [
            "role": role.rawValue,
            "updatedAt": FieldValue.serverTimestamp(),
            "batches": batchPayload,
            "tasks": taskPayload,
            "securityTheme": [
                "primary": "#245B24",
                "accent": "#B78900"
            ],
            "supervisorProfile": [
                "name": role == .supervisor ? "Hatchery Supervisor" : "Hatchery Manager",
                "workflow": role == .supervisor ? "Supervisor flow" : "Manager flow"
            ]
        ]

        database.collection("dashboardSnapshots").document(role.rawValue).setData(payload, merge: true) { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func syncSupervisorNotifications(notifications: [HatcheryNotification],
                                      completion: @escaping (Result<Void, Error>) -> Void) {
        let notificationPayload = notifications.map { notification in
            [
                "id": notification.id,
                "type": notification.type.rawValue,
                "title": notification.title,
                "message": notification.message,
                "timestamp": notification.timestamp,
                "timeLabel": notification.timeLabel
            ] as [String: Any]
        }

        let payload: [String: Any] = [
            "notifications": notificationPayload,
            "updatedAt": FieldValue.serverTimestamp()
        ]

        database.collection("supervisorData").document("notifications").setData(payload, merge: true) { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func syncBatchInsights(insights: [BatchInsight],
                          completion: @escaping (Result<Void, Error>) -> Void) {
        let insightPayload = insights.map { insight in
            [
                "id": insight.id,
                "batchID": insight.batchID,
                "breed": insight.breed,
                "date": insight.date,
                "status": insight.status.rawValue,
                "hatchRate": insight.hatchRate ?? ""
            ] as [String: Any]
        }

        let payload: [String: Any] = [
            "insights": insightPayload,
            "updatedAt": FieldValue.serverTimestamp()
        ]

        database.collection("supervisorData").document("batchInsights").setData(payload, merge: true) { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func fetchSupervisorNotifications(completion: @escaping (Result<[HatcheryNotification], Error>) -> Void) {
        database.collection("supervisorData").document("notifications").getDocument { snapshot, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data = snapshot?.data(),
                  let notificationsData = data["notifications"] as? [[String: Any]] else {
                completion(.success([]))
                return
            }

            let notifications = notificationsData.compactMap { notifDict in
                guard let id = notifDict["id"] as? String,
                      let typeString = notifDict["type"] as? String,
                      let type = NotificationType(rawValue: typeString),
                      let title = notifDict["title"] as? String,
                      let message = notifDict["message"] as? String,
                      let timestamp = notifDict["timestamp"] as? Timestamp,
                      let timeLabel = notifDict["timeLabel"] as? String else {
                    return nil
                }
                return HatcheryNotification(type: type, title: title, message: message, timestamp: timestamp.dateValue(), timeLabel: timeLabel)
            }

            completion(.success(notifications))
        }
    }

    func fetchBatchInsights(completion: @escaping (Result<[BatchInsight], Error>) -> Void) {
        database.collection("supervisorData").document("batchInsights").getDocument { snapshot, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data = snapshot?.data(),
                  let insightsData = data["insights"] as? [[String: Any]] else {
                completion(.success([]))
                return
            }

            let insights = insightsData.compactMap { insightDict in
                guard let id = insightDict["id"] as? String,
                      let batchID = insightDict["batchID"] as? String,
                      let breed = insightDict["breed"] as? String,
                      let date = insightDict["date"] as? String,
                      let statusString = insightDict["status"] as? String,
                      let status = BatchStatus(rawValue: statusString) else {
                    return nil
                }
                let hatchRate = insightDict["hatchRate"] as? String
                return BatchInsight(batchID: batchID, breed: breed, date: date, status: status, hatchRate: hatchRate)
            }

            completion(.success(insights))
        }
    }
}
