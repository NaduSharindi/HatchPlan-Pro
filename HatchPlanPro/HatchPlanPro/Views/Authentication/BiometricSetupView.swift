//
//  BiometricSetupView.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-12.
//

import SwiftUI

struct BiometricSetupView: View {
    let roleTitle: String
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: "faceid")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.figmaPrimary)
            
            VStack(spacing: 12) {
                Text("Enable Face ID")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.figmaTextDark)
                
                Text("Use Face ID to quickly and securely access your \(roleTitle) dashboard without typing your PIN.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                // Enable Button
                Button(action: {
                    print("Face ID Enabled! Routing to Dashboard...")
                    // TODO: Route to main Dashboard
                }) {
                    Text("Enable Face ID")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.figmaPrimary)
                        .cornerRadius(12)
                }
                
                // Skip Button
                Button(action: {
                    print("Skipped. Routing to Dashboard...")
                    // TODO: Route to main Dashboard
                }) {
                    Text("Skip for now")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .background(Color.figmaBackground.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}
