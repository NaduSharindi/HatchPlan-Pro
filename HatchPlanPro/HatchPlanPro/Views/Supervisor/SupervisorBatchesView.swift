//
//  SupervisorBatchesView.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-12.
//

import SwiftUI

struct SupervisorBatchesView: View {
    @EnvironmentObject private var session: AppSessionViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(session.batches) { batch in
                    batchCard(batch: batch)
                }
            }
            .padding()
        }
        .background(LinearGradient(colors: [Color.hatchSurface, Color.white], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
        .navigationTitle("Batches")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func batchCard(batch: HatcheryBatch) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(batch.name).font(.headline)
                Spacer()
                Text(batch.stage).font(.caption).foregroundColor(.secondary)
            }

            HStack {
                VStack(alignment: .leading) {
                    Text("Eggs: \(batch.eggs)")
                    Text("Temp: \(batch.temperature, specifier: "%.1f")°C")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(batch.isCritical ? "Critical" : "Stable")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(batch.isCritical ? .red : .hatchGreen)
                    ProgressView(value: batch.completionProgress)
                        .tint(batch.isCritical ? .red : .hatchGreen)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 6)
    }
}

#Preview {
    SupervisorBatchesView()
        .environmentObject(AppSessionViewModel())
}
