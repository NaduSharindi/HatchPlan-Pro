//
//  AccessibilitySettingsView.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-14.
//

import SwiftUI

struct AccessibilitySettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var highContrastEnabled = false
    @State private var textSizeMultiplier: CGFloat = 1.0
    @State private var voiceOverEnabled = false

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
                    Text("Accessibility")
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
                        // VISION Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("VISION")
                                .font(.caption.weight(.bold))
                                .kerning(1.2)
                                .foregroundColor(.secondary)

                            // High Contrast Mode
                            HStack(spacing: 16) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(Color.hatchGreen.opacity(0.1))

                                    Image(systemName: "circle.lefthalf.filled")
                                        .font(.system(size: 20))
                                        .foregroundColor(.hatchGreen)
                                }
                                .frame(width: 50, height: 50)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("High Contrast Mode")
                                        .font(.headline.bold())
                                        .foregroundColor(.black)
                                }

                                Spacer()

                                Toggle("", isOn: $highContrastEnabled)
                                    .tint(.hatchGreen)
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)

                            // Text Size
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color(hex: "#FFF3E0"))

                                        Text("aA")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.hatchOrange)
                                    }
                                    .frame(width: 50, height: 50)

                                    Text("Text Size")
                                        .font(.headline.bold())
                                        .foregroundColor(.black)

                                    Spacer()
                                }

                                VStack(alignment: .center, spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color(hex: "#F5F7FA"))

                                        Text("The biological precision of HatchPlan Pro ensures every batch is tracked with surgical accuracy.")
                                            .font(.system(size: 14 * textSizeMultiplier))
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.center)
                                            .padding(16)
                                    }
                                    .frame(height: 80)

                                    HStack(spacing: 16) {
                                        Text("aT")
                                            .font(.system(size: 12))
                                            .foregroundColor(.secondary)

                                        Slider(value: $textSizeMultiplier, in: 0.8...1.5, step: 0.1)
                                            .tint(.hatchGreen)

                                        Text("aT")
                                            .font(.system(size: 18))
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)

                        // INTERACTION Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("INTERACTION")
                                .font(.caption.weight(.bold))
                                .kerning(1.2)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 16)

                            HStack(spacing: 16) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(Color(hex: "#F3E5F5"))

                                    Image(systemName: "waveform")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color(hex: "#9C27B0"))
                                }
                                .frame(width: 50, height: 50)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("VoiceOver")
                                        .font(.headline.bold())
                                        .foregroundColor(.black)
                                }

                                Spacer()

                                Toggle("", isOn: $voiceOverEnabled)
                                    .tint(Color(hex: "#9C27B0"))
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 16)

                            Text("VoiceOver speaks items on the screen to help you navigate without seeing them.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 16)
                        }

                        // Feature Card
                        ZStack(alignment: .bottomLeading) {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.hatchGreen)

                            Image(systemName: "building.2.crop.circle")
                                .font(.system(size: 80))
                                .foregroundColor(.white.opacity(0.1))
                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                                .padding(20)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("INDUSTRIAL PRECISION")
                                    .font(.caption.weight(.bold))
                                    .kerning(0.8)
                                    .foregroundColor(.white.opacity(0.9))

                                Text("Optimized for Every User")
                                    .font(.headline.bold())
                                    .foregroundColor(.white)
                            }
                            .padding(20)
                        }
                        .frame(height: 140)
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
    AccessibilitySettingsView()
}
