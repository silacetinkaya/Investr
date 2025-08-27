import SwiftUI

@main
struct InvestrApp: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false

    var body: some Scene {
        WindowGroup {
            if hasOnboarded {
                TabView {
                    DashboardView()
                        .tabItem {
                            Label("Dashboard", systemImage: "chart.pie.fill")
                        }

                    FixedExpenseListView()
                        .tabItem {
                            Label("Fixed Expenses", systemImage: "list.bullet")
                        }
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                OnboardingView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}

