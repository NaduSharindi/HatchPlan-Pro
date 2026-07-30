//
//  SupervisorAuthFlowViews.swift
//  HatchPlanPro
//
//  Created by GitHub Copilot on 2026-05-12.
//

import SwiftUI

struct SupervisorSplashView: View {
    @EnvironmentObject private var session: AppSessionViewModel

    var body: some View {
        ZStack {
            LinearGradient(colors: [.white, .hatchGreenSoft, .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                VStack(spacing: 14) {
                    ZStack(alignment: .bottomTrailing) {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.white)
                            .frame(width: 92, height: 92)
                            .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)

                        Image(systemName: "drop.fill")
                            .font(.system(size: 40, weight: .semibold))
                            .foregroundColor(.hatchGreen)
                            .frame(width: 92, height: 92)

                        Circle()
                            .fill(Color.hatchOrange)
                            .frame(width: 18, height: 18)
                            .overlay(Image(systemName: "chart.line.uptrend.xyaxis").font(.caption2).foregroundColor(.white))
                            .offset(x: 8, y: 8)
                    }

                    Text("HatchPlan Pro")
                        .font(.system(size: 33, weight: .bold, design: .rounded))
                        .foregroundColor(.hatchGreen)
                    Text("Precision poultry management")
                        .font(.caption.weight(.semibold))
                        .kerning(2.4)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(spacing: 18) {
                    NavigationLink(destination: SupervisorLoginView()) {
                        Text("Enter supervisor flow")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.hatchGreen))
                    }

                    Text("Role-linked, secure, and audit-friendly")
                        .font(.footnote.weight(.medium))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .navigationBarHidden(true)
    }
}

struct SupervisorOnboardingView: View {
    @State private var pageIndex = 0
    @State private var goToLogin = false
    @EnvironmentObject private var session: AppSessionViewModel

    private let pages: [(title: String, body: String, image: String)] = [
        ("AI-Driven Decisions", "Optimize hatchery performance with predictive analytics and automated risk assessment tools.", "brain.head.profile"),
        ("Precision Incubation", "Monitor temperature, humidity, and batch health across every room in real time.", "oval.portrait.fill"),
        ("Instant Security", "Approve access quickly with Face ID, Touch ID, and a supervisor PIN fallback.", "lock.shield.fill")
    ]

    var body: some View {
        VStack(spacing: 20) {
            TabView(selection: $pageIndex) {
                ForEach(pages.indices, id: \.self) { index in
                    VStack(spacing: 18) {
                        Spacer()

                        ZStack {
                            Circle().fill(index == 1 ? Color.hatchOrangeSoft : Color.hatchGreenSoft).frame(width: 228, height: 228)
                            Image(systemName: pages[index].image)
                                .font(.system(size: 66, weight: .semibold))
                                .foregroundColor(index == 1 ? .hatchOrange : .hatchGreen)
                        }

                        Text(pages[index].title)
                            .font(.system(size: 31, weight: .bold, design: .rounded))
                            .foregroundColor(.hatchGreen)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Text(pages[index].body)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 28)

                        Spacer()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            HStack(spacing: 8) {
                ForEach(pages.indices, id: \.self) { index in
                    Capsule()
                        .fill(pageIndex == index ? Color.hatchGreen : Color.gray.opacity(0.2))
                        .frame(width: pageIndex == index ? 24 : 8, height: 8)
                }
            }

            Button {
                if pageIndex < pages.count - 1 {
                    withAnimation {
                        pageIndex += 1
                    }
                } else {
                    goToLogin = true
                }
            } label: {
                Text(pageIndex == pages.count - 1 ? "Continue" : "Next")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.hatchGreen))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)

            NavigationLink(destination: SupervisorLoginView(), isActive: $goToLogin) {
                EmptyView()
            }
        }
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

struct SupervisorLoginView: View {
    @EnvironmentObject private var session: AppSessionViewModel
    @State private var email = "nadunika@primahatchery.com"
    @State private var password = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                VStack(spacing: 10) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.hatchGreen)
                        .padding(18)
                        .background(Circle().fill(Color.hatchGreenSoft))
                        .accessibilityHidden(true)

                    Text("HatchPlan Pro")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.hatchGreen)
                        .accessibilityAddTraits(.isHeader)
                    Text("Precision poultry management")
                        .font(.caption.weight(.semibold))
                        .kerning(2.2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 18)

                VStack(alignment: .leading, spacing: 10) {
                    Text("EMAIL ADDRESS").font(.caption.weight(.bold)).kerning(1.2).foregroundColor(.primary)
                    TextField("nadunika@primahatchery.com", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color(hex: "#E9E9EE")))
                        .accessibilityLabel("Email address")
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("PASSWORD").font(.caption.weight(.bold)).kerning(1.2).foregroundColor(.primary)
                    SecureField("••••••••", text: $password)
                        .textContentType(.password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color(hex: "#E9E9EE")))
                        .accessibilityLabel("Password")
                }

                // Error display
                if session.showAuthError, let errorMsg = session.authErrorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                        Text(errorMsg).font(.caption).foregroundColor(.red).lineLimit(3)
                    }
                    .accessibilityElement(children: .combine)
                }

                Button {
                    session.chooseRole(.supervisor)
                    // Use Firebase Auth for real sign-in
                    session.firebaseSignIn(email: email, password: password) { success in
                        if success {
                            session.completeAuthentication(usingFaceID: false)
                        }
                    }
                } label: {
                    HStack {
                        if session.isLoadingAuth {
                            ProgressView().tint(.white)
                        }
                        Text("Sign In")
                            .font(.headline.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.hatchGreen))
                }
                .disabled(email.isEmpty || password.isEmpty || session.isLoadingAuth)
                .opacity(email.isEmpty || password.isEmpty ? 0.6 : 1.0)
                .accessibilityLabel("Sign in")

                Button {
                    if BiometricAuthService.shared.isEnabled {
                        session.chooseRole(.supervisor)
                        session.recordCredentials(email: email)
                        BiometricAuthService.shared.authenticate(reason: "Sign in to HatchPlan Pro") { result in
                            switch result {
                            case .success:
                                session.completeAuthentication(usingFaceID: true)
                            case .failure:
                                session.authErrorMessage = "Biometric authentication failed. Please use email and password."
                                session.showAuthError = true
                            }
                        }
                    } else {
                        session.authErrorMessage = "Enable biometrics in Settings first, then use this button to sign in."
                        session.showAuthError = true
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: BiometricAuthService.shared.biometricIconName)
                        Text("Sign In with \(BiometricAuthService.shared.biometricName)")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.hatchGreen)
                }
                .accessibilityLabel("Sign in with biometrics")

                VStack(spacing: 10) {
                    NavigationLink(destination: SupervisorForgotPasswordView()) {
                        Text("Forgot Password?")
                            .foregroundColor(.secondary)
                    }
                    NavigationLink(destination: SupervisorSignUpView()) {
                        Text("Don't have an account? Sign Up")
                            .fontWeight(.semibold)
                            .foregroundColor(.hatchGreen)
                    }
                }
                .padding(.top, 8)
            }
            .padding(24)
        }
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationBarHidden(true)
        .onDisappear {
            session.showAuthError = false
            session.authErrorMessage = nil
        }
    }
}


// MARK: - Supervisor Sign Up
struct SupervisorSignUpView: View {
    @EnvironmentObject private var session: AppSessionViewModel
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var localError: String?
    @Environment(\.dismiss) var dismiss

    private var isFormValid: Bool {
        !fullName.isEmpty && !email.isEmpty &&
        password.count >= 6 && password == confirmPassword
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                VStack(spacing: 10) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.hatchGreen)
                        .padding(18)
                        .background(Circle().fill(Color.hatchGreenSoft))
                        .accessibilityHidden(true)

                    Text("Create Account")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.hatchGreen)
                        .accessibilityAddTraits(.isHeader)
                    Text("Supervisor registration")
                        .font(.caption.weight(.semibold))
                        .kerning(2.2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 18)

                VStack(alignment: .leading, spacing: 10) {
                    Text("FULL NAME").font(.caption.weight(.bold)).kerning(1.2).foregroundColor(.primary)
                    TextField("Nadunika Sharindi", text: $fullName)
                        .textContentType(.name)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color(hex: "#E9E9EE")))
                        .accessibilityLabel("Full name")
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("EMAIL ADDRESS").font(.caption.weight(.bold)).kerning(1.2).foregroundColor(.primary)
                    TextField("nadunika@primahatchery.com", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color(hex: "#E9E9EE")))
                        .accessibilityLabel("Email address")
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("PASSWORD").font(.caption.weight(.bold)).kerning(1.2).foregroundColor(.primary)
                    SecureField("Min. 6 characters", text: $password)
                        .textContentType(.newPassword)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color(hex: "#E9E9EE")))
                        .accessibilityLabel("Password")
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("CONFIRM PASSWORD").font(.caption.weight(.bold)).kerning(1.2).foregroundColor(.primary)
                    SecureField("Re-enter password", text: $confirmPassword)
                        .textContentType(.newPassword)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color(hex: "#E9E9EE")))
                        .accessibilityLabel("Confirm password")
                }

                // Error display
                if let errorMsg = localError ?? (session.showAuthError ? session.authErrorMessage : nil) {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                        Text(errorMsg).font(.caption).foregroundColor(.red).lineLimit(3)
                    }
                    .accessibilityElement(children: .combine)
                }

                Button {
                    localError = nil
                    guard !fullName.isEmpty else { localError = "Please enter your full name."; return }
                    guard !email.isEmpty else { localError = "Please enter your email."; return }
                    guard password.count >= 6 else { localError = "Password must be at least 6 characters."; return }
                    guard password == confirmPassword else { localError = "Passwords do not match."; return }

                    session.chooseRole(.supervisor)
                    session.firebaseSignUp(email: email, password: password, fullName: fullName) { success in
                        if success {
                            session.completeAuthentication(usingFaceID: false)
                        }
                    }
                } label: {
                    HStack {
                        if session.isLoadingAuth {
                            ProgressView().tint(.white)
                        }
                        Text("Create Account")
                            .font(.headline.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.hatchGreen))
                }
                .disabled(!isFormValid || session.isLoadingAuth)
                .opacity(isFormValid ? 1.0 : 0.6)
                .accessibilityLabel("Create account")

                NavigationLink(destination: SupervisorLoginView()) {
                    HStack(spacing: 4) {
                        Text("Already have an account?").foregroundColor(.secondary)
                        Text("Sign In").fontWeight(.semibold).foregroundColor(.hatchGreen)
                    }
                    .font(.subheadline)
                }
                .padding(.top, 8)
            }
            .padding(24)
        }
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationBarHidden(true)
        .onDisappear {
            session.showAuthError = false
            session.authErrorMessage = nil
        }
    }
}

struct SupervisorBiometricIntroView: View {
    @EnvironmentObject private var session: AppSessionViewModel
    private let biometric = BiometricAuthService.shared

    var body: some View {
        VStack(spacing: 22) {
            Spacer()

            VStack(spacing: 14) {
                Image(systemName: biometric.biometricIconName)
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(.hatchGreen)
                    .padding(28)
                    .background(Circle().fill(Color.white))
                    .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)

                Text("Enable \(biometric.biometricName)")
                    .font(.title2.bold())
                    .foregroundColor(.black)
                Text("Secure access via \(biometric.biometricName) to your hatchery analytics and biological windows.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 28)
            }
            .supervisorCard()
            .padding(.horizontal, 18)

            Button {
                session.completeAuthentication(usingFaceID: true)
            } label: {
                Label("Enable \(biometric.biometricName)", systemImage: biometric.biometricIconName)
                    .font(.headline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.hatchGreen))
            }
            .padding(.horizontal, 24)

            Button {
                session.completeAuthentication(usingFaceID: false)
            } label: {
                Text("Skip for now")
                    .fontWeight(.semibold)
                    .foregroundColor(.hatchGreen)
            }

            Spacer()
        }
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

struct SupervisorForgotPasswordView: View {
    @State private var email = ""
    @State private var isSending = false
    @State private var showSuccess = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Image(systemName: "lock.rotation")
                    .font(.title2)
                    .padding(18)
                    .background(Circle().fill(Color.hatchGreenSoft))
                    .foregroundColor(.hatchGreen)
                Spacer()
            }

            Text("Forgot Password")
                .font(.largeTitle.bold())
                .foregroundColor(.hatchGreen)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Enter your registered email address to receive a password reset link for your HatchPlan account.")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 10) {
                Text("EMAIL ADDRESS").font(.caption.weight(.bold)).kerning(1.2)
                TextField("nadunika@primahatchery.com", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color(hex: "#E9E9EE")))
                    .accessibilityLabel("Email address")
            }
            .supervisorCard()

            if showSuccess {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.hatchGreen)
                    Text("Password reset email sent! Check your inbox.")
                        .font(.caption).foregroundColor(.hatchGreen)
                }
            }

            if let errorMsg = errorMessage {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                    Text(errorMsg).font(.caption).foregroundColor(.red).lineLimit(3)
                }
            }

            Button {
                guard !email.isEmpty else {
                    errorMessage = "Please enter your email address."
                    return
                }
                isSending = true
                errorMessage = nil
                showSuccess = false
                FirebaseAuthService.shared.resetPassword(email: email) { result in
                    isSending = false
                    switch result {
                    case .success:
                        showSuccess = true
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            } label: {
                HStack {
                    if isSending { ProgressView().tint(.white) }
                    Text("Send Reset Link")
                        .font(.headline.weight(.semibold))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.hatchGreen))
            }
            .disabled(email.isEmpty || isSending)
            .opacity(email.isEmpty ? 0.6 : 1.0)

            NavigationLink(destination: SupervisorLoginView()) {
                Text("Back to Sign In")
                    .fontWeight(.semibold)
                    .foregroundColor(.hatchGreen)
            }

            HStack {
                infoMiniCard(title: "ENCRYPTED", body: "Bank-grade security protocols for all reset requests.", icon: "shield.fill")
                infoMiniCard(title: "INSTANT", body: "Password reset link delivered via Firebase Auth.", icon: "bolt.fill")
            }

            Spacer()
        }
        .padding(24)
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationTitle("Forgot Password")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func infoMiniCard(title: String, body: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.hatchGreen)
            Text(title).font(.caption.weight(.bold)).kerning(1)
            Text(body).font(.footnote).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(.white))
    }
}

struct SupervisorVerificationCodeView: View {
    @State private var code = Array(repeating: "0", count: 6)

    var body: some View {
        VStack(spacing: 22) {
            Image(systemName: "lock.fill")
                .font(.title)
                .foregroundColor(.hatchGreen)
                .padding(20)
                .background(Circle().fill(Color.hatchGreenSoft))

            Text("Check your email")
                .font(.title.bold())
            Text("Enter the 6-digit code sent to your email")
                .foregroundColor(.secondary)

            HStack(spacing: 10) {
                ForEach(code.indices, id: \.self) { index in
                    TextField("0", text: Binding(
                        get: { code[index] },
                        set: { code[index] = $0.prefix(1).description }
                    ))
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.title2.weight(.bold))
                    .frame(width: 48, height: 64)
                    .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color(hex: "#E9E9EE")))
                }
            }

            NavigationLink(destination: SupervisorResetPasswordView()) {
                Text("Verify & Continue")
                    .font(.headline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.hatchGreen))
            }

            Button("RESEND CODE") { }
                .fontWeight(.bold)
                .foregroundColor(.hatchGreen)

            Spacer()

            NavigationLink(destination: SupervisorHelpCardView()) {
                HStack {
                    Image(systemName: "headphones")
                        .foregroundColor(.hatchGreen)
                    VStack(alignment: .leading) {
                        Text("Need help?").font(.headline)
                        Text("Contact our agronomist support team").font(.footnote).foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .supervisorCard()
            }
        }
        .padding(24)
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationTitle("Verification Code")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SupervisorResetPasswordView: View {
    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Text("New Password")
                    .font(.largeTitle.bold())
                Text("Secure your account by choosing a high-strength password for your hatchery operations.")
                    .foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 16) {
                    passwordField(title: "NEW PASSWORD", text: $password)
                    passwordField(title: "CONFIRM NEW PASSWORD", text: $confirmPassword)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("REQUIREMENTS").font(.caption.weight(.bold)).kerning(1.2)
                        requirementRow(text: "Minimum 8 characters", met: true)
                        requirementRow(text: "Include numbers and symbols", met: true)
                        requirementRow(text: "Passwords must match", met: false)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.white))
                }

                NavigationLink(destination: SupervisorPasswordSuccessView()) {
                    Text("Reset Password")
                        .font(.headline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.hatchGreen))
                }
            }
            .padding(24)
        }
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationTitle("Reset Password")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func passwordField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.caption.weight(.bold)).kerning(1.2).foregroundColor(.hatchGreen)
            SecureField("••••••••", text: text)
                .padding()
                .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color(hex: "#E9E9EE")))
        }
    }

    private func requirementRow(text: String, met: Bool) -> some View {
        HStack(spacing: 12) {
            Image(systemName: met ? "checkmark.circle.fill" : "circle")
                .foregroundColor(met ? .hatchGreen : .secondary)
            Text(text).foregroundColor(.secondary)
            Spacer()
        }
    }
}

struct SupervisorPasswordSuccessView: View {
    var body: some View {
        VStack(spacing: 18) {
            Spacer()

            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 62, weight: .bold))
                .foregroundColor(.hatchGreen)
                .padding(28)
                .background(Circle().fill(Color.hatchGreenSoft))

            Text("Password Reset Successful")
                .font(.title.bold())
            Text("Your password has been updated. You can now use your new password to sign in to your account.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            NavigationLink(destination: SupervisorLoginView()) {
                Text("Sign In")
                    .font(.headline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.hatchGreen))
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .padding()
        .background(Color.hatchSurface.ignoresSafeArea())
    }
}

struct SupervisorFaceIDSetupView: View {
    @EnvironmentObject private var session: AppSessionViewModel
    private let biometric = BiometricAuthService.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                Image(systemName: biometric.biometricIconName)
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(.hatchGreen)
                    .padding(24)
                    .background(Circle().fill(Color.white))
                    .shadow(color: .black.opacity(0.07), radius: 16, x: 0, y: 8)

                Text("\(biometric.biometricName) Ready")
                    .font(.largeTitle.bold())
                Text("You can now use \(biometric.biometricName) to securely sign in and approve plans in HatchPlan Pro.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 10) {
                    Label("Secure protocol", systemImage: "shield.fill")
                        .font(.caption.weight(.bold)).kerning(1.2)
                    Text("Your biometric data is encrypted and never leaves your device.")
                        .foregroundColor(.secondary)
                }
                .supervisorCard()

                Button {
                    session.completeAuthentication(usingFaceID: true)
                } label: {
                    Text("Enable \(biometric.biometricName)")
                        .font(.headline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.hatchGreen))
                }

                Button {
                    session.completeAuthentication(usingFaceID: false)
                } label: {
                    Text("Skip for now")
                        .fontWeight(.semibold)
                        .foregroundColor(.hatchGreen)
                }
            }
            .padding(24)
        }
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationTitle("\(biometric.biometricName) Setup")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SupervisorTouchIDScanView: View {
    var body: some View {
        VStack(spacing: 22) {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.white)
                    .frame(width: 280, height: 280)
                    .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 8)
                Image(systemName: "touchid")
                    .font(.system(size: 88, weight: .semibold))
                    .foregroundColor(.hatchGreen)
            }
            Text("Scanning Face...")
                .font(.title2.bold())
            Text("Move your head slowly in a circle to show all angles of your face.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            ProgressView(value: 0.75)
                .tint(.hatchGreen)
                .padding(.horizontal, 48)

            HStack {
                smallStatCard(title: "Depth sensor", value: "Optimized")
                smallStatCard(title: "Lighting", value: "Ambient")
            }
            .padding(.horizontal, 24)
            Spacer()
        }
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationTitle("FaceID Setup")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func smallStatCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased()).font(.caption2.weight(.bold)).kerning(1.1).foregroundColor(.hatchGreen)
            Text(value).font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(.white))
    }
}

struct SupervisorTouchIDReadyView: View {
    @EnvironmentObject private var session: AppSessionViewModel

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64, weight: .bold))
                .foregroundColor(.hatchGreen)
            Text("TouchID Ready")
                .font(.largeTitle.bold())
            Text("You can now use your fingerprint to securely sign in and approve plans in HatchPlan Pro.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 26)
            Button {
                session.completeAuthentication(usingFaceID: true)
            } label: {
                Text("Done")
                    .font(.headline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.hatchGreen))
                    .padding(.horizontal, 24)
            }
            Spacer()
        }
        .background(Color.hatchSurface.ignoresSafeArea())
    }
}

struct SupervisorProfilePhotoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 92, weight: .regular))
                    .foregroundColor(.hatchGreen)
                    .padding(18)
                    .background(Circle().fill(Color.white))
                    .shadow(color: .black.opacity(0.07), radius: 14, x: 0, y: 8)

                Text("Profile Photo")
                    .font(.title.bold())
                Text("Add a clear profile photo for identity verification and security checks.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: 14) {
                    Label("Job Title", systemImage: "briefcase.fill")
                        .foregroundColor(.hatchGreen)
                    Text("Senior Hatchery Lead")
                        .font(.title3)
                    Divider()
                    Label("Employee ID", systemImage: "person.text.rectangle")
                        .foregroundColor(.hatchGreen)
                    Text("HP-99234-X")
                        .font(.title3)
                }
                .supervisorCard()

                VStack(alignment: .leading, spacing: 14) {
                    Label("Hatchery Location", systemImage: "mappin.and.ellipse")
                        .foregroundColor(.hatchGreen)
                    Text("Meegoda Prim").font(.title3)
                }
                .supervisorCard()

                VStack(alignment: .leading, spacing: 14) {
                    Label("Email Address", systemImage: "envelope.fill")
                        .foregroundColor(.hatchGreen)
                    Text("nadunika@primahatchery.com").font(.title3)
                    Divider()
                    Label("Phone Number", systemImage: "phone.fill")
                        .foregroundColor(.hatchGreen)
                    Text("+94 00 000 00 00").font(.title3)
                }
                .supervisorCard()
            }
            .padding(24)
        }
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationTitle("Profile Photo")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SupervisorHelpCardView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "person.crop.circle.badge.questionmark")
                .font(.system(size: 56, weight: .bold))
                .foregroundColor(.hatchGreen)
            Text("Support team ready")
                .font(.title.bold())
            Text("Contact your hatchery support team if the verification code did not arrive.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Spacer()
        }
        .padding()
        .background(Color.hatchSurface.ignoresSafeArea())
    }
}
