//
//  SupervisorHomeView.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-12.
//

import SwiftUI

struct SupervisorHomeView: View {
    @EnvironmentObject private var session: AppSessionViewModel
    @State private var syncMessage: String = "Ready to sync"

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                header
                metrics
                upcomingHatches
                facilityHealth
                yieldProjection
            }
            .padding()
        }
        .background(background.ignoresSafeArea())
        .navigationTitle("Supervisor")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Hatchery Supervisor")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.hatchGreen)
                Text("Good morning, \(session.currentUser.fullName)")
                    .font(.title2.bold())
                    .foregroundColor(.figmaTextDark)
            }
            Spacer()
            Button {
                session.syncCurrentState { message in
                    syncMessage = message
                }
            } label: {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .padding(12)
                    .background(Circle().fill(Color.hatchGreen.opacity(0.12)))
            }
        }
        .padding()
        .supervisorCard()
    }

    private var metrics: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(session.metrics) { metric in
                VStack(alignment: .leading, spacing: 8) {
                    Text(metric.title)
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(.secondary)
                    Text(metric.value)
                        .font(.title3.bold())
                        .foregroundColor(.figmaTextDark)
                    Text(metric.change)
                        .font(.footnote)
                        .foregroundColor(metric.tint)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
            }
        }
    }

    private var upcomingHatches: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Upcoming hatches")
                    .font(.headline)
                Spacer()
                Text("See all")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            ForEach(session.batches) { batch in
                HStack {
                    VStack(alignment: .leading) {
                        Text(batch.name).font(.subheadline.weight(.semibold))
                        Text(batch.stage).font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(Int(batch.completionProgress * 100))%")
                            .font(.subheadline.weight(.semibold))
                        ProgressView(value: batch.completionProgress)
                            .tint(batch.isCritical ? .red : .hatchGreen)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
            }
        }
        .padding(.top, 6)
    }

    private var facilityHealth: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Facility health")
                .font(.headline)

            HStack(spacing: 12) {
                VStack(alignment: .leading) {
                    Text("Temp")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("37.8°C")
                        .font(.subheadline.weight(.semibold))
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Humidity")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("61%")
                        .font(.subheadline.weight(.semibold))
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Turner")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Auto")
                        .font(.subheadline.weight(.semibold))
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
        }
    }

    private var yieldProjection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Yield projection")
                .font(.headline)

            Text("Projected hatch rate: 91% — on track")
                .foregroundColor(.secondary)
                .font(.subheadline)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
        }
    }

    private var background: some View {
        LinearGradient(colors: [Color.hatchSurface, Color.white], startPoint: .top, endPoint: .bottom)
    }
}

#Preview {
    SupervisorHomeView()
        .environmentObject(AppSessionViewModel())
}
