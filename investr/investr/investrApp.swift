//
//  investrApp.swift
//  investr
//
//  Created by Sıla Çetinkaya on 19.08.2025.
//

import SwiftUI

@main
struct investrApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
