//
//  LoginView.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-12.
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
                Spacer()
            }
            
            // MARK: - Titles
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.figmaTextDark)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
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
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal, 24)
            
            // MARK: - Login Button
            // This navigates to the PIN screen next!
            Button {
                session.chooseRole(role)
                session.recordCredentials(email: email)
                navigateToPIN = true
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.figmaPrimary)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)

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
            
            Spacer()
        }
        .background(Color.figmaBackground.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

