//
//  AuthViewModel.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-11.
//
//  Manages PIN entry, biometric authentication, and Firebase Auth
//  integration. Uses KeychainHelper for secure PIN storage and
//  BiometricAuthService for Face ID / Touch ID.
//

import Foundation
import LocalAuthentication
import Combine

/// ViewModel for authentication screens (PIN entry, biometric setup).
/// Coordinates between the UI, Firebase Auth, and local biometric/PIN services.
class AuthViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var pin: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    let maxPinLength = 4
    
    /// Whether this is a first-time PIN setup (no saved PIN) or verification.
    var isSettingUpPIN: Bool {
        return !KeychainHelper.shared.hasPIN
    }
    
    // MARK: - PIN Logic
    
    /// Appends a digit to the PIN and auto-verifies when 4 digits are entered.
    func enterDigit(_ digit: String) {
        guard pin.count < maxPinLength else { return }
        pin.append(digit)
        
        // Auto-verify or auto-save when 4 digits are entered
        if pin.count == maxPinLength {
            if isSettingUpPIN {
                savePIN()
            } else {
                verifyPin()
            }
        }
    }
    
    /// Removes the last digit from the PIN.
    func deleteDigit() {
        guard !pin.isEmpty else { return }
        pin.removeLast()
    }
    
    // MARK: - PIN Verification
    
    /// Verifies the entered PIN against the Keychain-stored PIN.
    private func verifyPin() {
        isLoading = true
        
        // Short delay so the user sees the 4th dot fill in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let self = self else { return }
            
            if KeychainHelper.shared.validatePIN(self.pin) {
                self.isAuthenticated = true
                self.errorMessage = nil
            } else {
                self.errorMessage = "Incorrect PIN. Please try again."
                self.showError = true
                self.pin = ""
            }
            self.isLoading = false
        }
    }
    
    // MARK: - PIN Setup
    
    /// Saves a new PIN to the Keychain during first-time setup.
    private func savePIN() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            
            let saved = KeychainHelper.shared.savePIN(self.pin)
            if saved {
                self.isAuthenticated = true
                self.errorMessage = nil
                print("AuthViewModel: PIN saved successfully")
            } else {
                self.errorMessage = "Failed to save PIN. Please try again."
                self.showError = true
                self.pin = ""
            }
            self.isLoading = false
        }
    }
    
    // MARK: - Biometric Authentication
    
    /// Triggers Face ID or Touch ID authentication using the BiometricAuthService.
    func authenticateWithBiometrics() {
        let biometricService = BiometricAuthService.shared
        
        guard biometricService.isBiometricAvailable else {
            errorMessage = "Biometric authentication is not available on this device."
            showError = true
            return
        }
        
        isLoading = true
        
        biometricService.authenticate(
            reason: "Log in to your HatchPlan Pro account securely."
        ) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success:
                print("AuthViewModel: Biometric authentication successful")
                self.isAuthenticated = true
                self.errorMessage = nil
                
            case .failure(let error):
                print("AuthViewModel: Biometric authentication failed — \(error.localizedDescription)")
                self.errorMessage = "Biometric authentication failed. Please use your PIN."
                self.showError = true
            }
        }
    }
    
    // MARK: - Reset
    
    /// Clears the current PIN entry and error state.
    func reset() {
        pin = ""
        isAuthenticated = false
        errorMessage = nil
        showError = false
        isLoading = false
    }
}
