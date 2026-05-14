//
//  ContactSupportView.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-14.
//

import SwiftUI

struct ContactSupportView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showLiveChat = false
    @State private var showEmailSupport = false
    @State private var showRequestCall = false

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
                    Text("Contact Support")
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
                        // Specialist Card
                        VStack(spacing: 16) {
                            ZStack(alignment: .topTrailing) {
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .fill(Color.hatchGreen)

                                VStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white.opacity(0.2))
                                            .frame(width: 70, height: 70)

                                        Image(systemName: "person.crop.circle.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                    }

                                    Text("Talk to a Specialist")
                                        .font(.headline.bold())
                                        .foregroundColor(.white)

                                    Text("Our industrial poultry experts are online and ready to assist with your hatchery optimization.")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.9))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(24)
                            }
                            .frame(height: 220)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)

                        // Direct Channels
                        VStack(alignment: .leading, spacing: 12) {
                            Text("DIRECT CHANNELS")
                                .font(.caption.weight(.bold))
                                .kerning(1.2)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 16)

                            // Live Chat
                            Button(action: { showLiveChat = true }) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color(hex: "#E8F5E9"))
                                        Image(systemName: "message.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(.hatchGreen)
                                    }
                                    .frame(width: 50, height: 50)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Live Chat")
                                            .font(.headline.bold())
                                            .foregroundColor(.black)
                                        Text("Response time: ~2 mins")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.secondary)
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            .padding(.horizontal, 16)

                            // Email Support
                            Button(action: { showEmailSupport = true }) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color(hex: "#FFF3E0"))
                                        Image(systemName: "envelope.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(.hatchOrange)
                                    }
                                    .frame(width: 50, height: 50)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Email Support")
                                            .font(.headline.bold())
                                            .foregroundColor(.black)
                                        Text("For detailed technical inquiries")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.secondary)
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            .padding(.horizontal, 16)

                            // Request a Call
                            Button(action: { showRequestCall = true }) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color(hex: "#F3E5F5"))
                                        Image(systemName: "phone.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(Color(hex: "#9C27B0"))
                                    }
                                    .frame(width: 50, height: 50)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Request a Call")
                                            .font(.headline.bold())
                                            .foregroundColor(.black)
                                        Text("Available 09:00 - 18:00 GMT")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.secondary)
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            .padding(.horizontal, 16)
                        }

                        // Send Message Section
                        Button(action: {}) {
                            HStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                                Text("Search Help Center...")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(12)
                            .background(Color(hex: "#F5F7FA"))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ContactSupportView()
}
