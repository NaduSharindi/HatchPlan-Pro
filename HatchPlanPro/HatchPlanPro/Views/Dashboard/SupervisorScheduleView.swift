//
//  SupervisorScheduleView.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-13.
//

import SwiftUI

struct SupervisorScheduleView: View {
    @EnvironmentObject private var session: AppSessionViewModel
    @State private var searchText = ""

    var filteredSchedules: [ScheduledBatch] {
        if searchText.isEmpty {
            return session.scheduledBatches
        }
        return session.scheduledBatches.filter { batch in
            batch.batchID.localizedCaseInsensitiveContains(searchText) ||
            batch.breed.localizedCaseInsensitiveContains(searchText)
        }
    }

    var groupedSchedules: [(date: String, batches: [ScheduledBatch])] {
        let grouped = Dictionary(grouping: filteredSchedules) { $0.dateLabel }
        return grouped.sorted { date1, date2 in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d"
            if let d1 = dateFormatter.date(from: date1.key),
               let d2 = dateFormatter.date(from: date2.key) {
                return d1 < d2
            }
            return date1.key < date2.key
        }.map { (key, value) in
            (date: key, batches: value.sorted { $0.timeLabel < $1.timeLabel })
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.hatchSurface.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // MARK: - Search Bar
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField("Search batches or breed type...", text: $searchText)
                                .textFieldStyle(.plain)
                        }
                        .padding(14)
                        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(.white))
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .padding(.horizontal, 16)

                        // MARK: - Scheduled Batches by Date
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(groupedSchedules, id: \.date) { dateGroup in
                                VStack(alignment: .leading, spacing: 12) {
                                    // Date Header
                                    Text(dateGroup.date.uppercased())
                                        .font(.caption.weight(.bold))
                                        .kerning(1)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 16)

                                    // Batch Cards for this Date
                                    VStack(spacing: 12) {
                                        ForEach(dateGroup.batches) { batch in
                                            scheduledBatchCard(batch)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }

                        // MARK: - Efficiency Forecast
                        VStack(alignment: .leading, spacing: 12) {
                            Text("EFFICIENCY FORECAST")
                                .font(.caption.weight(.bold))
                                .kerning(1)
                                .foregroundColor(.white)

                            Text(session.efficiencyForecast.title)
                                .font(.title2.bold())
                                .foregroundColor(.white)

                            HStack(spacing: 12) {
                                ProgressView(value: session.efficiencyForecast.percentage)
                                    .tint(Color(hex: "#FFD700"))
                                    .frame(height: 6)

                                Text(String(format: "%.0f%%", session.efficiencyForecast.percentage * 100))
                                    .font(.caption.weight(.semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.hatchGreen))
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Schedule")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
        }
    }

    private func scheduledBatchCard(_ batch: ScheduledBatch) -> some View {
        HStack(alignment: .center, spacing: 16) {
            // Time
            VStack(alignment: .center, spacing: 2) {
                Text(batch.time)
                    .font(.headline.bold())
                    .foregroundColor(.hatchGreen)
                Text(batch.timeOfDay)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: 50, alignment: .center)

            // Batch Details
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(batch.batchID)
                        .font(.headline)
                        .foregroundColor(.hatchGreen)

                    if !batch.status.isEmpty {
                        Text(batch.status)
                            .font(.caption2.weight(.bold))
                            .kerning(0.8)
                            .foregroundColor(.white)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 8)
                            .background(RoundedRectangle(cornerRadius: 6, style: .continuous).fill(batch.statusColor))
                    }
                }

                Text(batch.breed)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("\(batch.eggs) Eggs")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.hatchGreen)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(.white))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    SupervisorScheduleView()
        .environmentObject(AppSessionViewModel())
}
