//
//  HatchPlanProApp.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-11.
//
import SwiftUI
import CoreData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct HatchPlanProApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared
    
    // Check local storage to see if onboarding is complete
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            // Routing Logic
            if hasSeenOnboarding {
                LandingView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                OnboardingView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
