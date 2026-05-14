//
//  TermsOfServiceView.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-14.
//

import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.dismiss) var dismiss
    @State private var hasAccepted = false

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
                    Text("Terms of Service")
                        .font(.headline.bold())
                        .foregroundColor(.hatchGreen)
                    Spacer()
                    Color.clear.frame(width: 44)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(hex: "#F5F7FA"))

                // Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Welcome Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome to HatchPlan Pro")
                                .font(.headline.bold())
                                .foregroundColor(.hatchGreen)
                            Text("These terms and conditions outline the rules and regulations for the use of HatchPlan Pro's Web Site and Mobile Application.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                        }

                        // Acceptance of Terms
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.hatchGreen)
                                Text("Acceptance of Terms")
                                    .font(.headline.bold())
                                    .foregroundColor(.hatchGreen)
                                Spacer()
                            }
                            Text("By accessing and using this website and mobile application, you acknowledge that you have read and agree to be bound by all of the terms and conditions stated here.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                        }

                        // User Responsibilities
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.hatchGreen)
                                Text("User Responsibilities")
                                    .font(.headline.bold())
                                    .foregroundColor(.hatchGreen)
                                Spacer()
                            }
                            Text("You agree to use this website only for lawful purposes and in a way that does not infringe upon the rights of others or restrict their use and enjoyment of the website.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                        }

                        // Service Availability
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                Image(systemName: "cloud.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.hatchGreen)
                                Text("Service Availability")
                                    .font(.headline.bold())
                                    .foregroundColor(.hatchGreen)
                                Spacer()
                            }
                            Text("While we strive for 99.9% uptime, we do not guarantee uninterrupted service. We are not responsible for any lost or corrupted data due to service interruptions.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                        }

                        // Data Ownership
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.hatchGreen)
                                Text("Data Ownership & Intellectual Property")
                                    .font(.headline.bold())
                                    .foregroundColor(.hatchGreen)
                                Spacer()
                            }
                            Text("All content and data created within HatchPlan Pro remains the intellectual property of HatchPlan Pro. Users retain ownership of hatchery operational data.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                        }

                        // Limitation of Liability
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.hatchOrange)
                                Text("Limitation of Liability")
                                    .font(.headline.bold())
                                    .foregroundColor(.hatchGreen)
                                Spacer()
                            }
                            Text("HatchPlan Pro shall not be liable for any indirect, incidental, special, consequential or punitive damages resulting from your use of or inability to use the service.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                        }
                    }
                    .padding(20)
                }

                Divider()

                // Footer Actions
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: hasAccepted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 20))
                            .foregroundColor(hasAccepted ? .hatchGreen : .secondary)
                        Text("I have read and agree to the Terms of Service")
                            .font(.caption.weight(.medium))
                            .foregroundColor(.hatchGreen)
                        Spacer()
                    }
                    .onTapGesture {
                        hasAccepted.toggle()
                    }

                    Button(action: { dismiss() }) {
                        Text("I Accept")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(hasAccepted ? Color.hatchGreen : Color.gray.opacity(0.5)))
                    }
                    .disabled(!hasAccepted)
                }
                .padding(16)
                .background(Color(hex: "#F5F7FA"))
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    TermsOfServiceView()
}
