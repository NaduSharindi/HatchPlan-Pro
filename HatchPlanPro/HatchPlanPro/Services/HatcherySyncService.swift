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
}
