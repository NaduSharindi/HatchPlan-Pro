//
//  LoginView.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-12.
//
//  Authenticates existing users via Firebase Auth (email + password),
//  then navigates to the PIN screen for secondary verification.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var session: AppSessionViewModel

    let role: HatcheryRole
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToPIN = false
    
    var body: some View {
        VStack(spacing: 30) {
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
                .accessibilityHint("Returns to the previous screen")
                Spacer()
            }
            
            // MARK: - Titles
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.figmaTextDark)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityAddTraits(.isHeader)
                
                Text("Log in to your \(role.rawValue) account")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 24)
            
            // MARK: - Input Fields
            VStack(spacing: 20) {
                // Email Field
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.gray)
                    TextField("Email Address", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .accessibilityLabel("Email address")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                
                // Password Field
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .accessibilityLabel("Password")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal, 24)
            
            // MARK: - Error Message
            if session.showAuthError, let errorMsg = session.authErrorMessage {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(errorMsg)
                        .font(.caption)
                        .foregroundColor(.red)
                        .lineLimit(3)
                }
                .padding(.horizontal, 24)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Error: \(errorMsg)")
            }
            
            // MARK: - Login Button
            Button {
                session.chooseRole(role)
                // Attempt Firebase sign-in
                session.firebaseSignIn(email: email, password: password) { success in
                    if success {
                        navigateToPIN = true
                    }
                }
            } label: {
                HStack {
                    if session.isLoadingAuth {
                        ProgressView()
                            .tint(.white)
                    }
                    Text("Sign In")
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
            .disabled(email.isEmpty || password.isEmpty || session.isLoadingAuth)
            .opacity(email.isEmpty || password.isEmpty ? 0.6 : 1.0)
            .padding(.horizontal, 24)
            .padding(.top, 10)
            .accessibilityLabel("Sign in button")
            .accessibilityHint("Signs in with your email and password")

            NavigationLink(
                destination: PINAuthenticationView(role: role, subtitle: "Set up a 4-digit quick access PIN"),
                isActive: $navigateToPIN,
                label: { EmptyView() }
            )

            NavigationLink(destination: SignUpView(role: role)) {
                Text("Need an account? Create one")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.figmaPrimary)
            }
            .accessibilityLabel("Create account")
            .accessibilityHint("Navigates to the sign up screen")
            
            Spacer()
        }
        .background(Color.figmaBackground.ignoresSafeArea())
        .navigationBarHidden(true)
        .onDisappear {
            session.showAuthError = false
            session.authErrorMessage = nil
        }
    }
}

