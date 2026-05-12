//
//  HatcheryModels.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-12.
//

import Foundation
import SwiftUI

enum HatcheryRole: String, CaseIterable, Identifiable, Codable {
    case manager = "Hatchery Manager"
    case supervisor = "Hatchery Supervisor"

    var id: String { rawValue }

    var shortTitle: String {
        switch self {
        case .manager:
            return "Manager"
        case .supervisor:
            return "Supervisor"
        }
    }

    var displaySymbol: String {
        switch self {
        case .manager:
            return "briefcase.fill"
        case .supervisor:
            return "person.2.fill"
        }
    }

    var accentColor: Color {
        switch self {
        case .manager:
            return Color.figmaPrimary
        case .supervisor:
            return Color(hex: "#14796D")
        }
    }
}

enum HatcheryTaskState: String, Codable {
    case pending
    case inProgress
    case done

    var title: String {
        switch self {
        case .pending:
            return "Pending"
        case .inProgress:
            return "In progress"
        case .done:
            return "Complete"
        }
    }
}

struct HatcheryBatch: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let stage: String
    let eggs: Int
    let temperature: Double
    let humidity: Double
    let turnerStatus: String
    let completionProgress: Double
    let isCritical: Bool
}

struct HatcheryTask: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let state: HatcheryTaskState
    let dueLabel: String
    let iconName: String
}

struct HatcheryAlert: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let details: String
    let severity: String
    let timeLabel: String
    let iconName: String
}

struct HatcheryMetric: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let value: String
    let change: String
    let tint: Color
}

struct HatcheryUserProfile: Hashable {
    let fullName: String
    let email: String
    let role: HatcheryRole
    let preferredSecurity: String
}
