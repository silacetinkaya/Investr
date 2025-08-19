import SwiftUI

@main
struct InvestrApp: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false

    var body: some Scene {
        WindowGroup {
            if hasOnboarded {
                FixedExpenseListView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                OnboardingView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}

