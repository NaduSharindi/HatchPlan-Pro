//
//  LandingView.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-11.
//

import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background color from Figma
                Color.figmaBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    
                    Spacer()
                    
                    // MARK: - Header Section
                    VStack(spacing: 8) {
                        // Add your Figma Logo Image here later
                        Image(systemName: "bird.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.figmaPrimary)
                        
                        Text("HatchPlan Pro")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.figmaTextDark)
                        
                        Text("Select your role to continue")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // MARK: - Role Selection Buttons
                    // MARK: - Role Selection Buttons
                    VStack(spacing: 20) {
                        NavigationLink(destination: LoginView(roleTitle: "Hatchery Manager")) {
                            RoleSelectionButton(title: "Hatchery Manager", iconName: "briefcase.fill")
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        NavigationLink(destination: LoginView(roleTitle: "Hatchery Supervisor")) {
                            RoleSelectionButton(title: "Hatchery Supervisor", iconName: "person.2.fill")
                        }
                        .buttonStyle(PlainButtonStyle())
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
