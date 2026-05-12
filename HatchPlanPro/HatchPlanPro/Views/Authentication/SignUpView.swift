//
//  SignUpView.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-12.
//
import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    let roleTitle: String // e.g., "Hatchery Manager"
    
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
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
                Spacer()
            }
            
            // MARK: - Title
            VStack(alignment: .leading, spacing: 8) {
                // Dynamically creates "Create Manager Account" or "Create Supervisor Account"
                let shortRole = roleTitle.replacingOccurrences(of: "Hatchery ", with: "")
                Text("Create \(shortRole) Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.figmaTextDark)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 24)
            
            // MARK: - Input Fields
            VStack(spacing: 16) {
                // Full Name Field
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    TextField("Full Name", text: $fullName)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                
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
                
                // Confirm Password Field
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                    SecureField("Confirm Password", text: $confirmPassword)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal, 24)
            
            // MARK: - Sign Up Button (Navigates to PIN Screen)
            NavigationLink(destination: PINAuthenticationView(roleTitle: roleTitle, subtitle: "Enter your \(roleTitle.lowercased().contains("manager") ? "manager" : "supervisor") PIN")) {
                Text("Sign Up")
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
            
            Spacer()
            
            // MARK: - Bottom Login Link
            NavigationLink(destination: LoginView(roleTitle: roleTitle)) {
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    Text("Log In")
                        .fontWeight(.bold)
                        .foregroundColor(.figmaPrimary)
                }
                .font(.subheadline)
            }
            .padding(.bottom, 20)
        }
        .background(Color.figmaBackground.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

#Preview {
    SignUpView(roleTitle: "Hatchery Manager")
}
