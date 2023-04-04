//
//  GreenThumbApp.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/4/23.
//

import SwiftUI

@main
struct GreenThumbApp: App {
    @AppStorage("darkMode") private var darkMode = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let managedObjectContext = PersistenceController.shared.persistentContainer.viewContext
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            // ContentView is the root view to be shown first upon app launch
            ContentView()
                // Change the color mode of the entire app to Dark or Light
                .preferredColorScheme(darkMode ? .dark : .light)
                .environment(\.managedObjectContext, managedObjectContext)
                .environmentObject(DatabaseChange())
        }
        .onChange(of: scenePhase) { _ in
            PersistenceController.shared.saveContext()
        }
    }
    
}
