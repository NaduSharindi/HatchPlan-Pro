//
//  SupervisorHistoryView.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-12.
//

import SwiftUI

struct SupervisorHistoryView: View {
    @EnvironmentObject private var session: AppSessionViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                ForEach(sampleHistory(), id: \ .self) { entry in
                    historyRow(entry: entry)
                }
            }
            .padding()
        }
        .background(LinearGradient(colors: [Color.hatchSurface, Color.white], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func historyRow(entry: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(entry).font(.subheadline.weight(.semibold))
                Text("Details available")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("View")
                .font(.footnote.weight(.semibold))
                .foregroundColor(.hatchGreen)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
    }

    private func sampleHistory() -> [String] {
        [
            "Daily temperature log — Room 1",
            "Hatch completion summary — Batch A-24",
            "Alert resolution — Incubator 3",
            "Maintenance record — Turner 2"
        ]
    }
}

#Preview {
    SupervisorHistoryView()
        .environmentObject(AppSessionViewModel())
}
