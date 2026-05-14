//
//  BiometricSetupView.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-12.
//
//  Offers the user the choice to enable Face ID / Touch ID for
//  quick login. Uses BiometricAuthService to actually invoke the
//  system biometric prompt and saves the preference via Keychain.
//

import SwiftUI

struct BiometricSetupView: View {
    @EnvironmentObject private var session: AppSessionViewModel

    let role: HatcheryRole
    
    /// Dynamically detect biometric type for correct icon/label
    private let biometric = BiometricAuthService.shared
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: biometric.biometricIconName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.figmaPrimary)
                .accessibilityHidden(true)
            
            VStack(spacing: 12) {
                Text("Enable \(biometric.biometricName)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.figmaTextDark)
                    .accessibilityAddTraits(.isHeader)
                
                Text("Use \(biometric.biometricName) to quickly and securely access your \(role.rawValue) dashboard without typing your PIN.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                // Enable Button — actually triggers biometric prompt
                Button(action: {
                    biometric.enableBiometric()
                    session.completeAuthentication(usingFaceID: true)
                }) {
                    Text("Enable \(biometric.biometricName)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.figmaPrimary)
                        .cornerRadius(12)
                }
                .accessibilityLabel("Enable \(biometric.biometricName)")
                .accessibilityHint("Enables biometric authentication for quick login")
                
                // Skip Button
                Button(action: {
                    biometric.disableBiometric()
                    session.completeAuthentication(usingFaceID: false)
                }) {
                    Text("Skip for now")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                .accessibilityLabel("Skip biometric setup")
                .accessibilityHint("Continues without enabling biometric authentication")
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .background(Color.figmaBackground.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}
