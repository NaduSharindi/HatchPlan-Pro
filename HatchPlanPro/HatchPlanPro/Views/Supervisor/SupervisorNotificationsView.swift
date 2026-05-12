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
        ScrollView {
            VStack(spacing: 12) {
                ForEach(session.alerts) { alert in
                    notificationRow(alert: alert)
                }
            }
            .padding()
        }
        .background(LinearGradient(colors: [Color.hatchSurface, Color.white], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func notificationRow(alert: HatcheryAlert) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: alert.iconName)
                .foregroundColor(alert.severity == "Critical" ? .red : .hatchGreen)
                .frame(width: 40, height: 40)
                .background(Circle().fill((alert.severity == "Critical" ? Color.red : Color.hatchGreen).opacity(0.12)))

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(alert.title).font(.subheadline.weight(.semibold))
                    Spacer()
                    Text(alert.timeLabel).font(.caption).foregroundColor(.secondary)
                }
                Text(alert.details).font(.caption).foregroundColor(.secondary)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
    }
}

#Preview {
    SupervisorNotificationsView()
        .environmentObject(AppSessionViewModel())
}
