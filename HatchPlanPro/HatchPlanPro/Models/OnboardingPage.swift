//
//  OnboardingPage.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-12.
//

import Foundation

struct OnboardingPage: Identifiable {
    let id = UUID()
    let systemImage: String // We will use SF Symbols for now
    let title: String
    let description: String
}
