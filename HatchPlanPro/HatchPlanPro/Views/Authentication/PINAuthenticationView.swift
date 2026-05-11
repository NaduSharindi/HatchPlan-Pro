//
//  PINAuthenticationView.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-11.
//

import SwiftUI

struct PINAuthenticationView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = AuthViewModel()
    
    // These properties make the view dynamic for both roles!
    let roleTitle: String
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
                Spacer()
            }
            
            // MARK: - Icon & Titles
            VStack(spacing: 12) {
                Image(systemName: "lock.shield.fill") // Placeholder for your Figma icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color(hex: "#20B2AA")) // Match your Figma teal/green here
                
                Text(roleTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.figmaTextDark)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // MARK: - PIN Indicator Dots
            HStack(spacing: 20) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(index < viewModel.pin.count ? Color.figmaTextDark : Color.gray.opacity(0.3))
                        .frame(width: 16, height: 16)
                }
            }
            .padding(.vertical, 20)
            
            Spacer()
            
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
                                Image(systemName: "faceid")
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
                    // Disable FaceID button if empty, delete if empty
                    .disabled(button == "faceid" ? false : (button == "delete" ? viewModel.pin.isEmpty : false))
                }
            }
            .padding(.horizontal, 40)
            
            // MARK: - Bottom Biometric Button
            Button(action: {
                viewModel.authenticateWithBiometrics()
            }) {
                Text("Use Face ID instead")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.figmaPrimary)
                    .padding(.top, 20)
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
    PINAuthenticationView(roleTitle: "Hatchery Supervisor", subtitle: "Enter your supervisor PIN")
}
