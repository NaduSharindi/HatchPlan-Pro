//
//  LandingView.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-11.
//

import SwiftUI

struct LandingView: View {
    @EnvironmentObject private var session: AppSessionViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color from Figma
                Color.figmaBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        AppLogoView(size: 88, title: "HatchPlan Pro", subtitle: "Precision poultry management")
                        
                        Text("Select your role to continue")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    VStack(spacing: 20) {
                        NavigationLink(destination: SupervisorSplashView()) {
                            RoleSelectionButton(title: HatcheryRole.supervisor.rawValue, iconName: HatcheryRole.supervisor.displaySymbol)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel("Hatchery Supervisor")
                        .accessibilityHint("Opens the supervisor login flow")

                        NavigationLink(destination: LoginView(role: .manager)) {
                            RoleSelectionButton(title: HatcheryRole.manager.rawValue, iconName: HatcheryRole.manager.displaySymbol)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel("Hatchery Manager")
                        .accessibilityHint("Opens the manager login flow")
                    }

                    NavigationLink(destination: SignUpView(role: session.currentRole)) {
                        Text("Create a demo account")
                            .font(.footnote.weight(.semibold))
                            .foregroundColor(.gray)
                            .padding(.top, 6)
                    }
                    
                    Spacer()
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    LandingView()
}
