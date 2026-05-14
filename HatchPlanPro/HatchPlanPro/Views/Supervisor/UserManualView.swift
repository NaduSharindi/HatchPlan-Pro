//
//  UserManualView.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-14.
//

import SwiftUI

struct UserManualView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""

    let manualCategories: [(title: String, description: String, icon: String)] = [
        ("Getting Started", "Initial setup and workspace configuration", "play.fill"),
        ("Batch Management", "Tracking cycles from egg to hatching", "egg.fill"),
        ("Sensor Integration", "Calibrating IoT humidity and temp modes", "wifi"),
        ("Advanced Analytics", "Harnessing predictive insights and alerts", "chart.line.uptrend.xyaxis"),
        ("Troubleshooting", "Common error codes and hardware fixes", "wrench.and.screwdriver.fill")
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.hatchGreen)
                    }
                    Spacer()
                    Text("User Manual")
                        .font(.headline.bold())
                        .foregroundColor(.hatchGreen)
                    Spacer()
                    Color.clear.frame(width: 44)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(hex: "#F5F7FA"))

                ScrollView {
                    VStack(spacing: 20) {
                        // Documentation Portal Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("DOCUMENTATION PORTAL")
                                .font(.caption.weight(.bold))
                                .kerning(1.2)
                                .foregroundColor(.secondary)

                            Text("How can we help?")
                                .font(.title2.bold())
                                .foregroundColor(.hatchGreen)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)

                        // Search Bar
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            TextField("Search manuals, sensors, or batch tips...", text: $searchText)
                                .font(.body)
                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)

                        // Quick Access Cards
                        HStack(spacing: 12) {
                            NavigationLink(destination: EmptyView()) {
                                VStack(spacing: 12) {
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                    Text("Quick Start\nGuide")
                                        .font(.caption.bold())
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(20)
                                .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.hatchGreen))
                            }

                            NavigationLink(destination: ContactSupportView()) {
                                VStack(spacing: 12) {
                                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                    Text("Live\nSupport")
                                        .font(.caption.bold())
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(20)
                                .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color(hex: "#FFB74D")))
                            }
                        }
                        .padding(.horizontal, 16)

                        // Manual Categories
                        VStack(alignment: .leading, spacing: 8) {
                            Text("MANUAL CATEGORIES")
                                .font(.caption.weight(.bold))
                                .kerning(1.2)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 16)

                            VStack(spacing: 12) {
                                ForEach(manualCategories, id: \.title) { category in
                                    NavigationLink(destination: EmptyView()) {
                                        HStack(spacing: 16) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .fill(Color.hatchGreen.opacity(0.1))
                                                Image(systemName: category.icon)
                                                    .font(.system(size: 18))
                                                    .foregroundColor(.hatchGreen)
                                            }
                                            .frame(width: 50, height: 50)

                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(category.title)
                                                    .font(.headline.bold())
                                                    .foregroundColor(.black)
                                                Text(category.description)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                    .lineLimit(1)
                                            }

                                            Spacer()

                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(16)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }

                        // Editor's Pick
                        VStack(alignment: .leading, spacing: 12) {
                            Text("EDITOR'S PICK")
                                .font(.caption.weight(.bold))
                                .kerning(1.2)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 16)

                            ZStack(alignment: .bottomLeading) {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.hatchGreen)

                                Image(systemName: "building.2.crop.circle")
                                    .font(.system(size: 80))
                                    .foregroundColor(.white.opacity(0.1))
                                    .frame(maxWidth: .infinity, alignment: .topTrailing)
                                    .padding(20)

                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 8) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.hatchOrange)
                                            Text("N")
                                                .font(.caption.bold())
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 24, height: 24)
                                        Text("NEW UPDATE")
                                            .font(.caption.weight(.bold))
                                            .kerning(1.2)
                                    }
                                    .foregroundColor(.white)

                                    Text("Optimizing Humidity for Winter Cycles")
                                        .font(.headline.bold())
                                        .foregroundColor(.white)

                                    Text("Learn seasonal best-practices in our full facility guide")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(20)
                            }
                            .frame(height: 160)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    UserManualView()
}
