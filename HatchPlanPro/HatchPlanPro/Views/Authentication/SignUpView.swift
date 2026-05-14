//
//  SignUpView.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-12.
//
//  Creates a new user account via Firebase Auth, validates inputs,
//  and navigates to PIN setup on success.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var session: AppSessionViewModel

    let role: HatcheryRole
    
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var navigateToPIN = false
    @State private var localError: String?
    
    /// Client-side validation before Firebase call
    private var isFormValid: Bool {
        !fullName.isEmpty && !email.isEmpty &&
        password.count >= 6 && password == confirmPassword
    }
    
    var body: some View {
        VStack(spacing: 25) {
            // MARK: - Back Button Header
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
            
            // MARK: - Title
            VStack(alignment: .leading, spacing: 8) {
                let shortRole = role.rawValue.replacingOccurrences(of: "Hatchery ", with: "")
                Text("Create \(shortRole) Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.figmaTextDark)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityAddTraits(.isHeader)
            }
            .padding(.horizontal, 24)
            
            // MARK: - Input Fields
            VStack(spacing: 16) {
                inputField(icon: "person.fill", placeholder: "Full Name", text: $fullName, label: "Full name")
                
                inputField(icon: "envelope.fill", placeholder: "Email Address", text: $email, label: "Email address")
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                
                HStack {
                    Image(systemName: "lock.fill").foregroundColor(.gray)
                    SecureField("Password (min 6 chars)", text: $password)
                        .textContentType(.newPassword)
                        .accessibilityLabel("Password, minimum 6 characters")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                
                HStack {
                    Image(systemName: "lock.fill").foregroundColor(.gray)
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textContentType(.newPassword)
                        .accessibilityLabel("Confirm password")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal, 24)
            
            // MARK: - Validation / Error Messages
            if let errorMsg = localError ?? session.authErrorMessage {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                    Text(errorMsg).font(.caption).foregroundColor(.red).lineLimit(3)
                }
                .padding(.horizontal, 24)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Error: \(errorMsg)")
            }
            
            // MARK: - Sign Up Button
            Button {
                localError = nil
                // Client-side validation
                guard !fullName.isEmpty else { localError = "Please enter your full name."; return }
                guard !email.isEmpty else { localError = "Please enter your email."; return }
                guard password.count >= 6 else { localError = "Password must be at least 6 characters."; return }
                guard password == confirmPassword else { localError = "Passwords do not match."; return }
                
                session.chooseRole(role)
                session.firebaseSignUp(email: email, password: password, fullName: fullName) { success in
                    if success {
                        navigateToPIN = true
                    }
                }
            } label: {
                HStack {
                    if session.isLoadingAuth {
                        ProgressView().tint(.white)
                    }
                    Text("Sign Up")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.figmaPrimary)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .disabled(!isFormValid || session.isLoadingAuth)
            .opacity(isFormValid ? 1.0 : 0.6)
            .padding(.horizontal, 24)
            .padding(.top, 10)
            .accessibilityLabel("Sign up button")

            NavigationLink(
                destination: PINAuthenticationView(role: role, subtitle: "Enter your \(role.shortTitle.lowercased()) PIN"),
                isActive: $navigateToPIN,
                label: { EmptyView() }
            )
            
            Spacer()
            
            // MARK: - Bottom Login Link
            NavigationLink(destination: LoginView(role: role)) {
                HStack(spacing: 4) {
                    Text("Already have an account?").foregroundColor(.gray)
                    Text("Log In").fontWeight(.bold).foregroundColor(.figmaPrimary)
                }
                .font(.subheadline)
            }
            .accessibilityLabel("Already have an account? Log in")
            .padding(.bottom, 20)
        }
        .background(Color.figmaBackground.ignoresSafeArea())
        .navigationBarHidden(true)
        .onDisappear {
            session.showAuthError = false
            session.authErrorMessage = nil
        }
    }
    
    /// Reusable styled input field
    private func inputField(icon: String, placeholder: String, text: Binding<String>, label: String) -> some View {
        HStack {
            Image(systemName: icon).foregroundColor(.gray)
            TextField(placeholder, text: text)
                .accessibilityLabel(label)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    SignUpView(role: .manager)
}
