//
//  SecuritySettingsView.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-14.
//

import SwiftUI
import LocalAuthentication

struct SecuritySettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var faceIDEnabled = false
    @State private var touchIDEnabled = false
    @State private var showChangePasscode = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.hatchGreen)
                    }
                    Spacer()
                    Text("Security")
                        .font(.headline.bold())
                        .foregroundColor(.hatchGreen)
                    Spacer()
                    Color.clear.frame(width: 44)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(hex: "#F5F7FA"))

                ScrollView {
                    VStack(spacing: 24) {
                        // Biometric Security Card
                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .fill(Color.hatchGreen.opacity(0.1))
                                    .frame(width: 80, height: 80)

                                Image(systemName: "touchid")
                                    .font(.system(size: 40, weight: .semibold))
                                    .foregroundColor(.hatchGreen)
                            }

                            Text("Biometric Security")
                                .font(.headline.bold())
                                .foregroundColor(.black)

                            Text("Enable FaceID or TouchID to quickly and securely access your hatchery data and approve production plans.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#F5F7FA"))
                        .cornerRadius(16)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)

                        // Biometric Toggles
                        VStack(spacing: 12) {
                            // Face ID
                            HStack(spacing: 16) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(Color.hatchGreen.opacity(0.1))

                                    Image(systemName: "faceid")
                                        .font(.system(size: 20))
                                        .foregroundColor(.hatchGreen)
                                }
                                .frame(width: 50, height: 50)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Enable Face ID")
                                        .font(.headline.bold())
                                        .foregroundColor(.black)
                                    Text("Use for app entry")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Toggle("", isOn: $faceIDEnabled)
                                    .tint(.hatchGreen)
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)

                            // Touch ID
                            HStack(spacing: 16) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(Color(hex: "#F3E5F5"))

                                    Image(systemName: "touchid")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color(hex: "#9C27B0"))
                                }
                                .frame(width: 50, height: 50)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Enable Touch ID")
                                        .font(.headline.bold())
                                        .foregroundColor(.black)
                                    Text("Use for app entry")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Toggle("", isOn: $touchIDEnabled)
                                    .tint(Color(hex: "#9C27B0"))
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 16)

                        // Security Advisory
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.hatchOrange)
                                Text("SECURITY ADVISORY")
                                    .font(.caption.weight(.bold))
                                    .kerning(0.8)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.hatchGreen)
                                    Text("HatchPlan Pro uses encrypted system-level authentication")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.hatchGreen)
                                    Text("Your biometric data is never stored on our servers or shared with third parties")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(hex: "#FFF3E0"))
                        .cornerRadius(12)
                        .padding(.horizontal, 16)

                        // Secured Environment
                        ZStack(alignment: .bottomLeading) {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.hatchGreen)

                            Image(systemName: "building.2.crop.circle")
                                .font(.system(size: 80))
                                .foregroundColor(.white.opacity(0.1))
                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                                .padding(20)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("SECURED ENVIRONMENT")
                                    .font(.caption.weight(.bold))
                                    .kerning(0.8)
                                    .foregroundColor(.white.opacity(0.9))

                                Text("Industry-grade encryption protects all sensitive hatchery data")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            .padding(20)
                        }
                        .frame(height: 140)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                }

                // Footer Action
                VStack(spacing: 12) {
                    Divider()

                    NavigationLink(destination: ChangePasscodeView()) {
                        Text("Change Passcode")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.hatchGreen)
                            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(hex: "#F5F7FA")))
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    SecuritySettingsView()
}
