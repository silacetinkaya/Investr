import SwiftUI

@main
struct InvestrApp: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false

    init() {
        // Bildirim izni iste
        NotificationManager.requestPermission()
    }

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

                    DailyExpenseListView()
                        .tabItem {
                            Label("Daily Expenses", systemImage: "calendar")
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

