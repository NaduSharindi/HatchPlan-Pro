//
//  AuthViewModel.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-11.
//
import Swift
import Foundation
import LocalAuthentication
import Combine

class AuthViewModel: ObservableObject {
    @Published var pin: String = ""
    let maxPinLength = 4
    
    // MARK: - PIN Logic
    func enterDigit(_ digit: String) {
        if pin.count < maxPinLength {
            pin.append(digit)
            
            // Automatically verify when 4 digits are entered
            if pin.count == maxPinLength {
                verifyPin()
            }
        }
    }
    
    func deleteDigit() {
        if !pin.isEmpty {
            pin.removeLast()
        }
    }
    
    private func verifyPin() {
        // TODO: We will connect this to Firebase Auth in the next step!
        print("Verifying PIN: \(pin)")
    }
    
    // MARK: - Biometric Authentication (Advanced Coursework Feature)
    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        
        // Check if the device has Face ID / Touch ID enabled
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Log in to your HatchPlan account securely."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        print("Biometric Auth Successful! Navigating to Dashboard...")
                        // TODO: Trigger navigation to the respective dashboard
                    } else {
                        print("Biometric Auth Failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        } else {
            print("Biometrics not available on this device.")
        }
    }
}
