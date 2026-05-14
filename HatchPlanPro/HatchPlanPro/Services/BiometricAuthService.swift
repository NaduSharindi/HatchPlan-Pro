//
//  BiometricAuthService.swift
//  HatchPlanPro
//
//  Handles Face ID / Touch ID authentication using the LocalAuthentication
//  framework. This service checks device capability, evaluates the biometric
//  policy, and persists the user's preference via KeychainHelper.
//

import Foundation
import LocalAuthentication

/// Represents the type of biometric available on the device.
enum BiometricType {
    case none
    case faceID
    case touchID
}

/// Manages biometric authentication (Face ID / Touch ID) for HatchPlan Pro.
/// Integrates with KeychainHelper to remember the user's biometric preference.
final class BiometricAuthService {
    
    // MARK: - Singleton
    static let shared = BiometricAuthService()
    private init() {}
    
    // MARK: - Device Capability
    
    /// Returns the type of biometric hardware available on this device.
    var biometricType: BiometricType {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        switch context.biometryType {
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        case .opticID:
            return .faceID  // Treat opticID (Vision Pro) as faceID equivalent
        @unknown default:
            return .none
        }
    }
    
    /// Whether the device supports any form of biometric authentication.
    var isBiometricAvailable: Bool {
        return biometricType != .none
    }
    
    /// A user-friendly name for the biometric type (e.g. "Face ID").
    var biometricName: String {
        switch biometricType {
        case .faceID:
            return "Face ID"
        case .touchID:
            return "Touch ID"
        case .none:
            return "Biometrics"
        }
    }
    
    /// The SF Symbol name for the current biometric type.
    var biometricIconName: String {
        switch biometricType {
        case .faceID:
            return "faceid"
        case .touchID:
            return "touchid"
        case .none:
            return "lock.fill"
        }
    }
    
    // MARK: - Authentication
    
    /// Prompts the user for biometric authentication.
    /// - Parameters:
    ///   - reason: The reason string shown in the system prompt.
    ///   - completion: Called on the main thread with success/failure.
    func authenticate(reason: String = "Log in to your HatchPlan account securely.",
                      completion: @escaping (Result<Void, Error>) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometrics are available
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            let biometricError = error ?? NSError(
                domain: "BiometricAuthService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Biometric authentication is not available on this device."]
            )
            DispatchQueue.main.async { completion(.failure(biometricError)) }
            return
        }
        
        // Perform biometric evaluation
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: reason) { success, authError in
            DispatchQueue.main.async {
                if success {
                    completion(.success(()))
                } else {
                    let error = authError ?? NSError(
                        domain: "BiometricAuthService",
                        code: -2,
                        userInfo: [NSLocalizedDescriptionKey: "Biometric authentication failed."]
                    )
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Preference Management
    
    /// Enables biometric authentication and saves the preference.
    func enableBiometric() {
        KeychainHelper.shared.setBiometricEnabled(true)
    }
    
    /// Disables biometric authentication.
    func disableBiometric() {
        KeychainHelper.shared.setBiometricEnabled(false)
    }
    
    /// Whether the user has opted in to biometric authentication.
    var isEnabled: Bool {
        return KeychainHelper.shared.isBiometricEnabled
    }
}
