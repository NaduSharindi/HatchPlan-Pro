//
//  ContentView.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-11.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var session: AppSessionViewModel
    @State private var syncMessage: String = "Ready to sync"

    var body: some View {
        if session.currentRole == .supervisor {
            supervisorDashboard
        } else {
            managerDashboard
        }
    }

    private var supervisorDashboard: some View {
        NavigationStack {
            TabView(selection: $session.selectedTabIndex) {
                SupervisorHomeView()
                    .tabItem {
                        Label("HOME", systemImage: "house.fill")
                    }
                    .tag(0)

                SupervisorBatchesView()
                    .tabItem {
                        Label("BATCHES", systemImage: "tray.full.fill")
                    }
                    .tag(1)

                SupervisorHistoryView()
                    .tabItem {
                        Label("HISTORY", systemImage: "clock.fill")
                    }
                    .tag(2)

                SupervisorNotificationsView()
                    .tabItem {
                        Label("ALERTS", systemImage: "bell.fill")
                    }
                    .tag(3)

                SupervisorSettingsView()
                    .tabItem {
                        Label("SETTINGS", systemImage: "gearshape.fill")
                    }
                    .tag(4)
            }
            .tint(.hatchGreen)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color.white, for: .tabBar)
        }
    }

    private var managerDashboard: some View {
        NavigationStack {
            TabView(selection: $session.selectedTabIndex) {
                dashboardHome
                    .tabItem {
                        Label("Dashboard", systemImage: "house.fill")
                    }
                    .tag(0)

                batchesView
                    .tabItem {
                        Label("Batches", systemImage: "tray.full.fill")
                    }
                    .tag(1)

                tasksView
                    .tabItem {
                        Label("Tasks", systemImage: "checklist")
                    }
                    .tag(2)

                alertsView
                    .tabItem {
                        Label("Alerts", systemImage: "bell.fill")
                    }
                    .tag(3)

                profileView
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle.fill")
                    }
                    .tag(4)
            }
            .tint(session.currentRole.accentColor)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color.white, for: .tabBar)
        }
    }

    private var dashboardHome: some View {
        ScrollView {
            VStack(spacing: 18) {
                headerCard
                metricsGrid
                overviewActions
                sectionCard(title: "Critical Batches", icon: "exclamationmark.triangle.fill") {
                    ForEach(session.batches) { batch in
                        HatcheryBatchRow(batch: batch)
                    }
                }

                sectionCard(title: "Today’s Focus", icon: "checklist") {
                    ForEach(session.tasks) { task in
                        HatcheryTaskRow(task: task)
                    }
                }
            }
            .padding()
        }
        .background(dashboardBackground.ignoresSafeArea())
        .navigationTitle("HatchPlan Pro")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var batchesView: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(session.batches) { batch in
                    HatcheryBatchDetailCard(batch: batch)
                }
            }
            .padding()
        }
        .background(dashboardBackground.ignoresSafeArea())
        .navigationTitle("Batches")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var tasksView: some View {
        ScrollView {
            VStack(spacing: 14) {
                ForEach(session.tasks) { task in
                    HatcheryTaskDetailCard(task: task)
                }
            }
            .padding()
        }
        .background(dashboardBackground.ignoresSafeArea())
        .navigationTitle("Tasks")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var alertsView: some View {
        ScrollView {
            VStack(spacing: 14) {
                ForEach(session.alerts) { alert in
                    HatcheryAlertCard(alert: alert)
                }
            }
            .padding()
        }
        .background(dashboardBackground.ignoresSafeArea())
        .navigationTitle("Alerts")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var profileView: some View {
        ScrollView {
            VStack(spacing: 18) {
                VStack(spacing: 12) {
                    Image(systemName: session.currentRole.displaySymbol)
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 96, height: 96)
                        .background(Circle().fill(session.currentRole.accentColor))

                    Text(session.currentUser.fullName)
                        .font(.title2.bold())
                        .foregroundColor(.figmaTextDark)

                    Text(session.currentUser.email)
                        .foregroundColor(.secondary)

                    Text("Security: \(session.currentUser.preferredSecurity)")
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(session.currentRole.accentColor)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(session.currentRole.accentColor.opacity(0.12)))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 28, style: .continuous).fill(.white))
                .shadow(color: .black.opacity(0.06), radius: 18, x: 0, y: 8)

                sectionCard(title: "Workspace") {
                    profileRow(label: "Role", value: session.currentRole.rawValue)
                    profileRow(label: "Onboarding", value: "Complete")
                    profileRow(label: "Last sync", value: session.lastSyncSummary)
                }

                Button {
                    session.signOut()
                } label: {
                    Text("Sign Out")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(session.currentRole.accentColor))
                }
                .accessibilityLabel("Sign out of the app")
            }
            .padding()
        }
        .background(dashboardBackground.ignoresSafeArea())
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(session.currentRole.rawValue)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(session.currentRole.accentColor)
                    Text("Good morning, \(session.currentUser.fullName)")
                        .font(.title2.bold())
                        .foregroundColor(.figmaTextDark)
                }
                Spacer()
                Image(systemName: session.currentRole.displaySymbol)
                    .font(.title2)
                    .foregroundColor(session.currentRole.accentColor)
                    .padding(14)
                    .background(Circle().fill(session.currentRole.accentColor.opacity(0.12)))
            }

            Text(session.todaySummary)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                session.syncCurrentState { message in
                    syncMessage = message
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text(syncMessage)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .font(.footnote.weight(.semibold))
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(session.currentRole.accentColor))
            }
            .accessibilityLabel("Sync dashboard to Firebase")
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.white, session.currentRole.accentColor.opacity(0.06)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 18, x: 0, y: 8)
    }

    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
            ForEach(Array(session.metrics.enumerated()), id: \.offset) { _, metric in
                MetricCard(metric: metric)
            }
        }
    }

    private var overviewActions: some View {
        HStack(spacing: 12) {
            QuickActionButton(title: "Record reading", symbol: "thermometer.medium", tint: session.currentRole.accentColor)
            QuickActionButton(title: "Open report", symbol: "doc.text.magnifyingglass", tint: Color(hex: "#0F4C81"))
        }
    }

    private var dashboardBackground: some View {
        LinearGradient(
            colors: [Color(hex: "#F8F9FA"), session.currentRole.accentColor.opacity(0.08), Color.white],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private func sectionCard<Content: View>(title: String, icon: String = "", @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            if icon.isEmpty == false {
                HStack {
                    Label(title, systemImage: icon)
                        .font(.headline)
                        .foregroundColor(.figmaTextDark)
                    Spacer()
                }
            } else {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.figmaTextDark)
            }
            VStack(spacing: 12) {
                content()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(.white))
        .shadow(color: .black.opacity(0.05), radius: 14, x: 0, y: 8)
    }

    private func profileRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.figmaTextDark)
        }
        .padding(.vertical, 4)
    }
}

private struct MetricCard: View {
    let metric: HatcheryMetric

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(metric.title)
                    .font(.footnote.weight(.medium))
                    .foregroundColor(.secondary)
                Spacer()
                Circle()
                    .fill(metric.tint.opacity(0.18))
                    .frame(width: 12, height: 12)
            }

            Text(metric.value)
                .font(.title2.bold())
                .foregroundColor(.figmaTextDark)

            Text(metric.change)
                .font(.footnote.weight(.semibold))
                .foregroundColor(metric.tint)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(.white))
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
}

private struct QuickActionButton: View {
    let title: String
    let symbol: String
    let tint: Color

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: symbol)
                .font(.title3)
                .foregroundColor(tint)
                .frame(width: 46, height: 46)
                .background(Circle().fill(tint.opacity(0.12)))
            Text(title)
                .font(.footnote.weight(.semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.figmaTextDark)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.white))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
    }
}

private struct HatcheryBatchRow: View {
    let batch: HatcheryBatch

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: batch.isCritical ? "exclamationmark.triangle.fill" : "shippingbox.fill")
                .foregroundColor(batch.isCritical ? .red : .figmaPrimary)
                .frame(width: 42, height: 42)
                .background(Circle().fill((batch.isCritical ? Color.red : Color.figmaPrimary).opacity(0.12)))

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(batch.name)
                        .font(.headline)
                    Spacer()
                    Text(batch.stage)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(batch.isCritical ? .red : .secondary)
                }
                Text("\(batch.eggs) eggs • \(batch.turnerStatus)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                ProgressView(value: batch.completionProgress)
                    .tint(batch.isCritical ? .red : .figmaPrimary)
                HStack {
                    Text("Temp \(batch.temperature, specifier: "%.1f")°C")
                    Spacer()
                    Text("Humidity \(batch.humidity, specifier: "%.0f")%")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color(hex: "#FAFAFA")))
    }
}

private struct HatcheryBatchDetailCard: View {
    let batch: HatcheryBatch

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(batch.name)
                    .font(.headline)
                Spacer()
                Text(batch.isCritical ? "Critical" : "Stable")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(batch.isCritical ? .red : .green)
            }

            Text(batch.stage)
                .foregroundColor(.secondary)

            ProgressView(value: batch.completionProgress)
                .tint(batch.isCritical ? .red : .figmaPrimary)

            HStack {
                Label("\(batch.eggs) eggs", systemImage: "egg.fill")
                Spacer()
                Label("\(batch.temperature, specifier: "%.1f")°C", systemImage: "thermometer.medium")
                Spacer()
                Label("\(batch.humidity, specifier: "%.0f")%", systemImage: "drop.fill")
            }
            .font(.footnote)
            .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(.white))
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
}

private struct HatcheryTaskRow: View {
    let task: HatcheryTask

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: task.iconName)
                .foregroundColor(.white)
                .frame(width: 38, height: 38)
                .background(Circle().fill(task.state == .done ? Color(hex: "#14796D") : Color.figmaPrimary))

            VStack(alignment: .leading, spacing: 3) {
                Text(task.title)
                    .font(.subheadline.weight(.semibold))
                Text(task.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(task.state.title)
                .font(.caption.weight(.semibold))
                .foregroundColor(task.state == .done ? .green : .secondary)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color(hex: "#FAFAFA")))
    }
}

private struct HatcheryTaskDetailCard: View {
    let task: HatcheryTask

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: task.iconName)
                    .foregroundColor(.figmaPrimary)
                Text(task.title)
                    .font(.headline)
                Spacer()
                Text(task.state.title)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(task.state == .done ? .green : .secondary)
            }
            Text(task.subtitle)
                .foregroundColor(.secondary)
            HStack {
                Text(task.dueLabel)
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.figmaPrimary)
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(.white))
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
}

private struct HatcheryAlertCard: View {
    let alert: HatcheryAlert

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: alert.iconName)
                .foregroundColor(alert.severity == "Critical" ? .red : .figmaPrimary)
                .frame(width: 38, height: 38)
                .background(Circle().fill((alert.severity == "Critical" ? Color.red : Color.figmaPrimary).opacity(0.12)))

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(alert.title)
                        .font(.headline)
                    Spacer()
                    Text(alert.timeLabel)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text(alert.details)
                    .foregroundColor(.secondary)
                Text(alert.severity)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(alert.severity == "Critical" ? .red : .figmaPrimary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(.white))
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppSessionViewModel())
}
