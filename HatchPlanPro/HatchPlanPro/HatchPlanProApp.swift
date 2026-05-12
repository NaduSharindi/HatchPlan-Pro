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
    @StateObject private var session = AppSessionViewModel()
    
    // Check local storage to see if onboarding is complete
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            Group {
                if hasSeenOnboarding {
                    if session.isAuthenticated {
                        ContentView()
                    } else {
                        LandingView()
                    }
                } else {
                    OnboardingView()
                }
            }
            .environmentObject(session)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
