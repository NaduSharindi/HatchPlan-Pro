//
//  SupervisorSettingsView.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-12.
//

import SwiftUI

struct SupervisorSettingsView: View {
    @EnvironmentObject private var session: AppSessionViewModel
    @State private var lastSync: String = "Never"

    var body: some View {
        Form {
            Section(header: Text("Account")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(session.currentUser.fullName).foregroundColor(.secondary)
                }
                HStack {
                    Text("Email")
                    Spacer()
                    Text(session.currentUser.email).foregroundColor(.secondary)
                }
            }

            Section(header: Text("Sync")) {
                Button("Sync now") {
                    session.syncCurrentState { msg in
                        lastSync = msg
                    }
                }
                Text(lastSync).font(.caption).foregroundColor(.secondary)
            }

            Section {
                Button("Sign out") {
                    session.signOut()
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SupervisorSettingsView()
        .environmentObject(AppSessionViewModel())
}
