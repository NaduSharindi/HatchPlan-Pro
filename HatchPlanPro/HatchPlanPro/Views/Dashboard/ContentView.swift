import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var session: AppSessionViewModel

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
                ManagerHomeView()
                    .tabItem {
                        Label("Dashboard", systemImage: "house.fill")
                    }
                    .tag(0)

                ManagerBatchesView()
                    .tabItem {
                        Label("Batches", systemImage: "tray.full.fill")
                    }
                    .tag(1)

                ManagerTasksView()
                    .tabItem {
                        Label("Tasks", systemImage: "checklist")
                    }
                    .tag(2)

                ManagerAlertsView()
                    .tabItem {
                        Label("Alerts", systemImage: "bell.fill")
                    }
                    .tag(3)

                ManagerProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle.fill")
                    }
                    .tag(4)
            }
            .tint(Color.figmaPrimary)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color.white, for: .tabBar)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppSessionViewModel())
}
