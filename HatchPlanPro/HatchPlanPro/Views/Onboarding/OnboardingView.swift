//
//  OnboardingView.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-12.
//

import SwiftUI

struct OnboardingView: View {
    // This saves a boolean to the iPhone's storage so it only shows once!
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    @State private var currentPage = 0
    
    // The data matching your 4 Figma screens
    let pages: [OnboardingPage] = [
        OnboardingPage(systemImage: "egg.fill", title: "Welcome to HatchPlan Pro", description: "Your intelligent poultry hatchery management solution."),
        OnboardingPage(systemImage: "thermometer.sun.fill", title: "Monitor Batches", description: "Track temperature, humidity, and egg turner status in real-time."),
        OnboardingPage(systemImage: "bell.badge.fill", title: "Instant Notifications", description: "Get alerts for critical environmental changes and task reminders."),
        OnboardingPage(systemImage: "chart.line.uptrend.xyaxis", title: "Predict & Optimize", description: "Leverage data-driven insights to improve hatch rates and efficiency.")
    ]
    
    var body: some View {
        ZStack {
            Color.figmaBackground.ignoresSafeArea()
            
            VStack {
                // MARK: - Swipeable Carousel
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 24) {
                            Spacer()
                            
                            // Placeholder icon until you add custom Figma images
                            Image(systemName: pages[index].systemImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.figmaPrimary)
                                .padding(.bottom, 30)
                                .accessibilityHidden(true)
                            
                            Text(pages[index].title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.figmaTextDark)
                                .multilineTextAlignment(.center)
                                .accessibilityAddTraits(.isHeader)
                            
                            Text(pages[index].description)
                                .font(.body)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                            
                            Spacer()
                        }
                        .accessibilityElement(children: .combine)
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default dots to use our custom ones
                
                // MARK: - Custom Dot Indicators
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(currentPage == index ? Color.figmaPrimary : Color.gray.opacity(0.3))
                            .frame(width: currentPage == index ? 24 : 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.bottom, 30)
                
                // MARK: - Dynamic Next / Get Started Button
                Button(action: {
                    if currentPage < pages.count - 1 {
                        // Go to next page
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        // Finish onboarding and go to LandingView!
                        hasSeenOnboarding = true
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.figmaPrimary)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .accessibilityLabel(currentPage == pages.count - 1 ? "Get started" : "Next page")
                .accessibilityHint(currentPage == pages.count - 1 ? "Completes onboarding and opens the app" : "Goes to the next onboarding page")
            }
        }
    }
}

#Preview {
    OnboardingView()
}
