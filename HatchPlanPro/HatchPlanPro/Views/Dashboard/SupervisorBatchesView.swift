//
//  SupervisorBatchesView.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-12.
//

import SwiftUI

struct SupervisorBatchesView: View {
    @EnvironmentObject private var session: AppSessionViewModel
    @State private var selectedStatus = "all"

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: - Header
                    HStack {
                        Text("Hatchery Insights")
                            .font(.title2.bold())
                            .foregroundColor(.hatchGreen)
                        Spacer()
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title2)
                            .foregroundColor(.hatchGreen)
                    }
                    .padding(.horizontal, 20)

                    // MARK: - Approved & Ready
                    batchSection(
                        title: "APPROVED & READY",
                        count: "2 Items",
                        batches: [
                            (id: "#B1024", breed: "Ross 308", date: "Oct 24, 2023", status: "APPROVED", statusColor: .hatchGreen),
                            (id: "#B1028", breed: "Cobb 500", date: "Oct 24, 2023", status: "APPROVED", statusColor: .hatchGreen)
                        ]
                    )

                    // MARK: - Pending Manager Review
                    batchSection(
                        title: "PENDING MANAGER REVIEW",
                        count: "1 Item",
                        batches: [
                            (id: "#B1029", breed: "Ross 708", date: "Oct 24, 2023", status: "PENDING", statusColor: Color(hex: "#FFA500"))
                        ]
                    )

                    // MARK: - Rejected / Action Required
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("REJECTED / ACTION REQUIRED")
                                .font(.caption.weight(.bold))
                                .kerning(1)
                            Spacer()
                            Text("1 Item")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        VStack(spacing: 12) {
                            HStack(alignment: .top, spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("#B1022")
                                        .font(.headline)
                                    Text("Lohmann Brown")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("Oct 24, 2023")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("REJECTED")
                                    .font(.caption2.weight(.bold))
                                    .kerning(0.8)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 10)
                                    .background(RoundedRectangle(cornerRadius: 6, style: .continuous).fill(Color(hex: "#FF6B6B")))
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color(hex: "#FAFAFA")))

                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Target temperature too high for breed specification. Update and resubmit.")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                Spacer()
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.hatchGreen)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(hex: "#FAFAFA")))
                        }
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.white))
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
                    .padding(.horizontal, 16)

                    // MARK: - Calendar Synced
                    batchSection(
                        title: "CALENDAR SYNCED",
                        count: "1 Item",
                        batches: [
                            (id: "#B1020", breed: "Hubbard Efficiency Plus", date: "Oct 24, 2023", status: "SYNCED", statusColor: .hatchGreen)
                        ]
                    )

                    // MARK: - Supervisor Insight
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SUPERVISOR INSIGHT")
                            .font(.caption.weight(.bold))
                            .kerning(1)
                            .foregroundColor(.white)
                        Text("Hatchery efficiency is up 4.2% this week.")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        HStack(spacing: 8) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.caption)
                                .foregroundColor(.hatchGreen)
                            Text("Reviews by Manager Sarah & Ops Lead Mike")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.hatchGreen))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .background(Color.hatchSurface.ignoresSafeArea())
            .navigationTitle("Hatchery Insights")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func batchSection(title: String, count: String, batches: [(id: String, breed: String, date: String, status: String, statusColor: Color)]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.caption.weight(.bold))
                    .kerning(1)
                Spacer()
                Text(count)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 10) {
                ForEach(batches.indices, id: \.self) { index in
                    HStack(alignment: .center, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(batches[index].id)
                                .font(.headline)
                            Text(batches[index].breed)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(batches[index].date)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(batches[index].status)
                            .font(.caption2.weight(.bold))
                            .kerning(0.8)
                            .foregroundColor(.white)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 10)
                            .background(RoundedRectangle(cornerRadius: 6, style: .continuous).fill(batches[index].statusColor))
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color(hex: "#FAFAFA")))
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.white))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }
}

#Preview {
    SupervisorBatchesView()
        .environmentObject(AppSessionViewModel())
}
