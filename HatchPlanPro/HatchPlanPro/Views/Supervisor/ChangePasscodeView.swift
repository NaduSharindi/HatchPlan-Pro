//
//  ChangePasscodeView.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-14.
//

import SwiftUI

struct ChangePasscodeView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentPasscode = ""
    @State private var newPasscode = ""
    @State private var confirmPasscode = ""
    @State private var showPassword = false
    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var errorMessage = ""

    private var isFormValid: Bool {
        !currentPasscode.isEmpty &&
        newPasscode.count >= 6 &&
        newPasscode == confirmPasscode &&
        newPasscode != currentPasscode
    }

    private var passcodeStrength: (text: String, color: Color) {
        if newPasscode.isEmpty {
            return ("", .gray)
        }
        
        let hasNumbers = newPasscode.rangeOfCharacter(from: .decimalDigits) != nil
        let hasLetters = newPasscode.rangeOfCharacter(from: .letters) != nil
        let isLong = newPasscode.count >= 8
        
        if !hasNumbers || !hasLetters {
            return ("Weak", .hatchOrange)
        } else if isLong {
            return ("Strong", .hatchGreen)
        } else {
            return ("Medium", Color(hex: "#FFB74D"))
        }
    }

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
                    Text("Change Passcode")
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
                        // Icon Section
                        ZStack {
                            Circle()
                                .fill(Color.hatchGreen.opacity(0.1))
                                .frame(width: 70, height: 70)

                            Image(systemName: "lock.rotation.open")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(.hatchGreen)
                        }
                        .padding(.top, 20)

                        // Title and Description
                        VStack(spacing: 8) {
                            Text("Change Passcode")
                                .font(.headline.bold())
                                .foregroundColor(.black)

                            Text("Ensure your hatchery data remains secure by updating your access code regularly.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        // Current Passcode
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CURRENT PASSCODE")
                                .font(.caption.weight(.bold))
                                .kerning(0.8)
                                .foregroundColor(.secondary)

                            HStack(spacing: 12) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)

                                if showPassword {
                                    TextField("••••••", text: $currentPasscode)
                                        .font(.system(.body, design: .monospaced))
                                } else {
                                    SecureField("••••••", text: $currentPasscode)
                                        .font(.system(.body, design: .monospaced))
                                }
                            }
                            .padding(12)
                            .background(Color(hex: "#F5F7FA"))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal, 16)

                        // New Passcode
                        VStack(alignment: .leading, spacing: 8) {
                            Text("NEW PASSCODE")
                                .font(.caption.weight(.bold))
                                .kerning(0.8)
                                .foregroundColor(.secondary)

                            HStack(spacing: 12) {
                                Image(systemName: "lock")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)

                                if showPassword {
                                    TextField("••••••", text: $newPasscode)
                                        .font(.system(.body, design: .monospaced))
                                } else {
                                    SecureField("••••••", text: $newPasscode)
                                        .font(.system(.body, design: .monospaced))
                                }
                            }
                            .padding(12)
                            .background(Color(hex: "#F5F7FA"))
                            .cornerRadius(10)

                            if !newPasscode.isEmpty {
                                HStack(spacing: 8) {
                                    Text(passcodeStrength.text)
                                        .font(.caption.weight(.semibold))
                                        .foregroundColor(passcodeStrength.color)
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal, 16)

                        // Confirm New Passcode
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CONFIRM NEW PASSCODE")
                                .font(.caption.weight(.bold))
                                .kerning(0.8)
                                .foregroundColor(.secondary)

                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.seal")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)

                                if showPassword {
                                    TextField("••••••", text: $confirmPasscode)
                                        .font(.system(.body, design: .monospaced))
                                } else {
                                    SecureField("••••••", text: $confirmPasscode)
                                        .font(.system(.body, design: .monospaced))
                                }
                            }
                            .padding(12)
                            .background(Color(hex: "#F5F7FA"))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal, 16)

                        // Show Password Toggle
                        HStack(spacing: 12) {
                            Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)

                            Text(showPassword ? "Hide" : "Show")
                                .font(.caption.weight(.medium))
                                .foregroundColor(.hatchGreen)

                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { showPassword.toggle() }
                        .padding(.horizontal, 16)

                        // Password Requirements
                        VStack(alignment: .leading, spacing: 12) {
                            Text("PASSWORD REQUIREMENTS")
                                .font(.caption.weight(.bold))
                                .kerning(0.8)
                                .foregroundColor(.secondary)

                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: newPasscode.count >= 6 ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 12))
                                        .foregroundColor(newPasscode.count >= 6 ? .hatchGreen : .secondary)
                                    Text("At least 6 characters")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                HStack(spacing: 8) {
                                    Image(systemName: (newPasscode.rangeOfCharacter(from: .decimalDigits) != nil) ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 12))
                                        .foregroundColor((newPasscode.rangeOfCharacter(from: .decimalDigits) != nil) ? .hatchGreen : .secondary)
                                    Text("At least one number")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(12)
                        .background(Color(hex: "#FFF3E0"))
                        .cornerRadius(10)
                        .padding(.horizontal, 16)

                        if !errorMessage.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.hatchOrange)
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.hatchOrange)
                                Spacer()
                            }
                            .padding(12)
                            .background(Color(hex: "#FFF3E0"))
                            .cornerRadius(10)
                            .padding(.horizontal, 16)
                        }

                        Spacer()

                        // Confirm Button
                        Button(action: {
                            isLoading = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                isLoading = false
                                showSuccess = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    dismiss()
                                }
                            }
                        }) {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Confirm Passcode")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(isFormValid ? Color.hatchGreen : Color.gray.opacity(0.5)))
                        .disabled(!isFormValid)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ChangePasscodeView()
}
