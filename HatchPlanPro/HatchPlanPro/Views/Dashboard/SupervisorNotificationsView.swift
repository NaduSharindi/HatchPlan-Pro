//
//  SupervisorNotificationsView.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-12.
//

import SwiftUI

struct SupervisorNotificationsView: View {
    @EnvironmentObject private var session: AppSessionViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: - Header
                    HStack {
                        Text("Notifications")
                            .font(.title2.bold())
                            .foregroundColor(.hatchGreen)
                        Spacer()
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title2)
                            .foregroundColor(.hatchGreen)
                    }
                    .padding(.horizontal, 20)

                    // MARK: - Today Section
                    notificationSection(
                        title: "TODAY",
                        notifications: [
                            (type: "CRITICAL ALERT", icon: "exclamationmark.circle.fill", iconBg: Color(hex: "#FFA500"), title: "Batch #B1024 is 24 hours from hatching. Resource allocation required.", time: "2m ago"),
                            (type: "APPROVAL UPDATE", icon: "checkmark.circle.fill", iconBg: .hatchGreen, title: "Plan for Batch #B1030 has been Approved by Manager Aruni.", time: "1h ago")
                        ]
                    )

                    // MARK: - Last Week Section
                    notificationSection(
                        title: "LAST WEEK",
                        notifications: [
                            (type: "SYSTEM MESSAGE", icon: "gearshape.fill", iconBg: Color(hex: "#A0A0A0"), title: "Sensor Calibration Sync completed for Incubation Hall B.", time: "Yesterday"),
                            (type: "WEEKLY REPORT", icon: "chart.bar.fill", iconBg: Color(hex: "#8B7355"), title: "Performance summary for Hall A is now available. Hatch rate increased by 4.2%.", time: "2 days ago")
                        ]
                    )

                    // MARK: - Earlier Section
                    notificationSection(
                        title: "EARLIER",
                        notifications: [
                            (type: "SYSTEM MESSAGE", icon: "gearshape.fill", iconBg: Color(hex: "#A0A0A0"), title: "Sensor Calibration Sync completed for Incubation Hall B.", time: "Yesterday"),
                            (type: "WEEKLY REPORT", icon: "chart.bar.fill", iconBg: Color(hex: "#8B7355"), title: "Performance summary for Hall A is now available. Hatch rate increased by 4.2%.", time: "2 days ago")
                        ]
                    )
                    .padding(.bottom, 20)
                }
            }
            .background(Color.hatchSurface.ignoresSafeArea())
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func notificationSection(
        title: String,
        notifications: [(type: String, icon: String, iconBg: Color, title: String, time: String)]
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.caption.weight(.bold))
                .kerning(1)
                .foregroundColor(.secondary)

            VStack(spacing: 10) {
                ForEach(notifications.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: notifications[index].icon)
                            .font(.title3)
                            .foregroundColor(notifications[index].type == "CRITICAL ALERT" ? .white : .hatchGreen)
                            .padding(10)
                            .background(Circle().fill(notifications[index].iconBg))

                        VStack(alignment: .leading, spacing: 6) {
                            Text(notifications[index].type)
                                .font(.caption.weight(.bold))
                                .kerning(0.8)
                                .foregroundColor(notifications[index].type == "CRITICAL ALERT" ? Color(hex: "#FFA500") : .hatchGreen)

                            Text(notifications[index].title)
                                .font(.caption)
                                .foregroundColor(.hatchGreen)
                                .lineLimit(3)
                        }

                        Spacer()

                        Text(notifications[index].time)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(.white))
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color(hex: "#FAFAFA")))
        .padding(.horizontal, 16)
    }
}

#Preview {
    SupervisorNotificationsView()
        .environmentObject(AppSessionViewModel())
}
