//
//  SupervisorSettingsView.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-12.
//

import SwiftUI

struct SupervisorSettingsView: View {
    @EnvironmentObject private var session: AppSessionViewModel
    @State private var notificationsEnabled = true
    @State private var hapticEnabled = true
    @State private var siriEnabled = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: - Header
                    HStack {
                        Text("Settings")
                            .font(.title2.bold())
                            .foregroundColor(.hatchGreen)
                        Spacer()
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title2)
                            .foregroundColor(.hatchGreen)
                    }
                    .padding(.horizontal, 20)

                    // MARK: - Profile Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "person.fill")
                                .font(.title3)
                                .foregroundColor(.hatchGreen)
                                .padding(10)
                                .background(Circle().fill(Color.hatchGreenSoft))

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Supervisor")
                                    .font(.headline)
                                    .foregroundColor(.hatchGreen)
                                Text("lead.agronomist@hatchplan.pro")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                    .supervisorCard()
                    .padding(.horizontal, 16)

                    // MARK: - Preferences Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("PREFERENCES")
                            .font(.caption.weight(.bold))
                            .kerning(1)

                        settingRow(icon: "bell.fill", title: "System Notifications", enabled: $notificationsEnabled)
                        settingRow(icon: "iphone.gen1.radiowaves.left.and.right", title: "Haptic Feedback", enabled: $hapticEnabled)
                        settingRow(icon: "waveform.mic", title: "Siri & Search", enabled: $siriEnabled)
                        
                        NavigationLink(destination: SupervisorAccessibilityView()) {
                            settingRowStatic(icon: "figure.dress", title: "Accessibility")
                        }
                    }
                    .supervisorCard()
                    .padding(.horizontal, 16)

                    // MARK: - Security Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SECURITY")
                            .font(.caption.weight(.bold))
                            .kerning(1)

                        NavigationLink(destination: SupervisorBiometricSettingsView()) {
                            settingRowStatic(icon: "faceid", title: "Biometric Authentication")
                        }
                        NavigationLink(destination: SupervisorChangePasscodeView()) {
                            settingRowStatic(icon: "lock.fill", title: "Change Passcode")
                        }
                    }
                    .supervisorCard()
                    .padding(.horizontal, 16)

                    // MARK: - Support Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SUPPORT")
                            .font(.caption.weight(.bold))
                            .kerning(1)

                        NavigationLink(destination: SupervisorUserManualView()) {
                            supportRow(icon: "book.fill", title: "User Manual")
                        }
                        NavigationLink(destination: SupervisorContactSupportView()) {
                            supportRow(icon: "headphones", title: "Contact Support")
                        }
                        NavigationLink(destination: SupervisorTermsView()) {
                            supportRow(icon: "gavel.fill", title: "Terms of Service")
                        }
                        NavigationLink(destination: SupervisorPrivacyView()) {
                            supportRow(icon: "hand.raised.fill", title: "Privacy Policy")
                        }
                    }
                    .supervisorCard()
                    .padding(.horizontal, 16)

                    // MARK: - Footer
                    VStack(spacing: 4) {
                        Text("HatchPlan Pro")
                            .font(.caption.weight(.semibold))
                        Text("v2.4.0")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }
            }
            .background(Color.hatchSurface.ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func settingRow(icon: String, title: String, enabled: Binding<Bool>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.hatchGreen)
                .padding(8)
                .background(Circle().fill(Color.hatchGreenSoft))

            Text(title)
                .font(.body)
                .foregroundColor(.hatchGreen)

            Spacer()

            Toggle("", isOn: enabled)
                .tint(.hatchGreen)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color(hex: "#FAFAFA")))
    }

    private func settingRowStatic(icon: String, title: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.hatchGreen)
                .padding(8)
                .background(Circle().fill(Color.hatchGreenSoft))

            Text(title)
                .font(.body)
                .foregroundColor(.hatchGreen)

            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color(hex: "#FAFAFA")))
    }

    private func supportRow(icon: String, title: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color(hex: "#B78900"))
                .padding(8)
                .background(Circle().fill(Color.hatchOrangeSoft))

            Text(title)
                .font(.body)
                .foregroundColor(.hatchGreen)

            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color(hex: "#FAFAFA")))
    }
}

struct SupervisorAccessibilityView: View {
    var body: some View {
        VStack {
            Text("Accessibility Settings")
                .font(.title2.bold())
                .foregroundColor(.hatchGreen)
            Spacer()
        }
        .padding()
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationTitle("Accessibility")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SupervisorBiometricSettingsView: View {
    var body: some View {
        VStack {
            Text("Biometric Settings")
                .font(.title2.bold())
                .foregroundColor(.hatchGreen)
            Spacer()
        }
        .padding()
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationTitle("Biometric Authentication")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SupervisorChangePasscodeView: View {
    var body: some View {
        VStack {
            Text("Change Passcode")
                .font(.title2.bold())
                .foregroundColor(.hatchGreen)
            Spacer()
        }
        .padding()
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationTitle("Change Passcode")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SupervisorUserManualView: View {
    var body: some View {
        VStack {
            Text("User Manual")
                .font(.title2.bold())
                .foregroundColor(.hatchGreen)
            Spacer()
        }
        .padding()
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationTitle("User Manual")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SupervisorContactSupportView: View {
    var body: some View {
        VStack {
            Text("Contact Support")
                .font(.title2.bold())
                .foregroundColor(.hatchGreen)
            Spacer()
        }
        .padding()
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationTitle("Contact Support")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SupervisorTermsView: View {
    var body: some View {
        VStack {
            Text("Terms of Service")
                .font(.title2.bold())
                .foregroundColor(.hatchGreen)
            Spacer()
        }
        .padding()
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SupervisorPrivacyView: View {
    var body: some View {
        VStack {
            Text("Privacy Policy")
                .font(.title2.bold())
                .foregroundColor(.hatchGreen)
            Spacer()
        }
        .padding()
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SupervisorSettingsView()
        .environmentObject(AppSessionViewModel())
}
