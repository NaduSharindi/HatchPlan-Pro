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
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: - Header
                    HStack {
                        Text("Batch History")
                            .font(.title2.bold())
                            .foregroundColor(.hatchGreen)
                        Spacer()
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title2)
                            .foregroundColor(.hatchGreen)
                    }
                    .padding(.horizontal, 20)

                    // MARK: - Quarterly Summary
                    VStack(alignment: .leading, spacing: 16) {
                        Text("QUARTERLY SUMMARY")
                            .font(.caption.weight(.bold))
                            .kerning(1)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("AVERAGE HATCH RATE")
                                .font(.caption.weight(.bold))
                                .kerning(1)
                                .foregroundColor(.secondary)

                            HStack(alignment: .top, spacing: 20) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("92.4%")
                                        .font(.system(size: 38, weight: .bold))
                                        .foregroundColor(.hatchGreen)
                                    ProgressView(value: 0.924)
                                        .tint(.hatchGreen)
                                        .frame(width: 120)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 6) {
                                    Text("TOTAL BATCHES")
                                        .font(.caption.weight(.bold))
                                        .kerning(1)
                                        .foregroundColor(.secondary)
                                    Text("142")
                                        .font(.title2.bold())
                                        .foregroundColor(.hatchGreen)
                                }
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color(hex: "#FAFAFA")))
                    }
                    .supervisorCard()
                    .padding(.horizontal, 16)

                    // MARK: - October 2023
                    batchHistoryMonth(
                        title: "OCTOBER 2023",
                        batches: [
                            (id: "#B2023-10-A", date: "Completed Oct 28, 2023", rate: "94.5%"),
                            (id: "#B2023-10-B", date: "Completed Oct 24, 2023", rate: "91.2%"),
                            (id: "#B2023-10-C", date: "Completed Oct 19, 2023", rate: "88.4%")
                        ]
                    )

                    // MARK: - September 2023
                    batchHistoryMonth(
                        title: "SEPTEMBER 2023",
                        batches: [
                            (id: "#B2023-09-E", date: "Completed Sep 30, 2023", rate: "93.8%"),
                            (id: "#B2023-09-D", date: "Completed Sep 22, 2023", rate: "95.1%")
                        ]
                    )

                    // MARK: - Load Older
                    Button(action: {}) {
                        Text("LOAD OLDER BATCHES")
                            .font(.caption.weight(.bold))
                            .kerning(1)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.hatchGreen)
                            .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color.hatchGreenSoft))
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .background(Color.hatchSurface.ignoresSafeArea())
            .navigationTitle("Batch History")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func batchHistoryMonth(title: String, batches: [(id: String, date: String, rate: String)]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.caption.weight(.bold))
                .kerning(1)

            VStack(spacing: 10) {
                ForEach(batches.indices, id: \.self) { index in
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(batches[index].id)
                                .font(.headline)
                                .foregroundColor(.hatchGreen)
                            Text(batches[index].date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(batches[index].rate)
                            .font(.headline)
                            .foregroundColor(.hatchGreen)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(.white))
                }
            }
        }
        .supervisorCard()
        .padding(.horizontal, 16)
    }
}

#Preview {
    SupervisorHistoryView()
        .environmentObject(AppSessionViewModel())
}
