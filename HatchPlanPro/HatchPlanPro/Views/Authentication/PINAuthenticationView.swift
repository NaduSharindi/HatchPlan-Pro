//
//  PINAuthenticationView.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-11.
//
//  Provides a 4-digit PIN entry screen with Face ID / Touch ID fallback.
//  PINs are securely stored and verified via KeychainHelper. On first
//  use the PIN is saved; on subsequent uses it is verified.
//

import SwiftUI

struct PINAuthenticationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var session: AppSessionViewModel
    @StateObject private var viewModel = AuthViewModel()
    
    // These properties make the view dynamic for both roles!
    let role: HatcheryRole
    let subtitle: String
    
    // The layout for our keypad
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let keypadButtons = [
        "1", "2", "3",
        "4", "5", "6",
        "7", "8", "9",
        "faceid", "0", "delete"
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            // MARK: - Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.figmaTextDark)
                        .padding()
                }
                .accessibilityLabel("Go back")
                Spacer()
            }
            
            // MARK: - Icon & Titles
            VStack(spacing: 12) {
                Image(systemName: "lock.shield.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color(hex: "#20B2AA"))
                    .accessibilityHidden(true)
                
                Text(role.rawValue)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.figmaTextDark)
                    .accessibilityAddTraits(.isHeader)
                
                Text(viewModel.isSettingUpPIN ? "Create a 4-digit PIN" : subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // MARK: - PIN Indicator Dots
            HStack(spacing: 20) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(index < viewModel.pin.count ? Color.figmaTextDark : Color.gray.opacity(0.3))
                        .frame(width: 16, height: 16)
                        .scaleEffect(index < viewModel.pin.count ? 1.2 : 1.0)
                        .animation(.spring(response: 0.2), value: viewModel.pin.count)
                }
            }
            .padding(.vertical, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(viewModel.pin.count) of 4 digits entered")
            .accessibilityValue(viewModel.pin.count == 4 ? "PIN complete" : "\(4 - viewModel.pin.count) digits remaining")
            
            // MARK: - Error Message
            if viewModel.showError, let errorMsg = viewModel.errorMessage {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                    Text(errorMsg)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .transition(.opacity)
                .animation(.easeInOut, value: viewModel.showError)
                .accessibilityElement(children: .combine)
            }
            
            Spacer()
            
            // MARK: - Hidden Navigation to Biometric Setup
            NavigationLink(
                destination: BiometricSetupView(role: role),
                isActive: $viewModel.isAuthenticated,
                label: { EmptyView() }
            )
            
            // MARK: - Number Pad
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(keypadButtons, id: \.self) { button in
                    Button(action: {
                        handleKeyPress(button)
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.05))
                                .frame(width: 75, height: 75)
                            
                            if button == "faceid" {
                                Image(systemName: BiometricAuthService.shared.biometricIconName)
                                    .font(.title)
                            } else if button == "delete" {
                                Image(systemName: "delete.backward")
                                    .font(.title)
                            } else {
                                Text(button)
                                    .font(.title)
                                    .fontWeight(.medium)
                            }
                        }
                        .foregroundColor(.figmaTextDark)
                    }
                    .disabled(button == "faceid" ? !BiometricAuthService.shared.isBiometricAvailable : (button == "delete" ? viewModel.pin.isEmpty : false))
                    .accessibilityLabel(button == "faceid" ? BiometricAuthService.shared.biometricName : (button == "delete" ? "Delete" : "Digit \(button)"))
                }
            }
            .padding(.horizontal, 40)
            
            // MARK: - Bottom Biometric Button
            if BiometricAuthService.shared.isBiometricAvailable {
                Button(action: {
                    viewModel.authenticateWithBiometrics()
                }) {
                    Text("Use \(BiometricAuthService.shared.biometricName) instead")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.figmaPrimary)
                        .padding(.top, 20)
                }
                .accessibilityLabel("Use \(BiometricAuthService.shared.biometricName) instead of PIN")
            }
            
            Spacer()
        }
        .background(Color.figmaBackground.ignoresSafeArea())
        .navigationBarHidden(true)
    }
    
    // Helper function to route keypad presses
    private func handleKeyPress(_ button: String) {
        if button == "delete" {
            viewModel.deleteDigit()
        } else if button == "faceid" {
            viewModel.authenticateWithBiometrics()
        } else {
            viewModel.enterDigit(button)
        }
    }
}

// Preview to test it without running the app
#Preview {
    PINAuthenticationView(role: .supervisor, subtitle: "Enter your supervisor PIN")
}
