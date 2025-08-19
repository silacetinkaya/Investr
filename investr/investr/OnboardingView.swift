import SwiftUI

struct OnboardingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false

    @State private var monthlyIncome: String = ""
    @State private var targetPercentage: String = ""
    @State private var startDay: Int = 1

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Gelir Bilgileri")) {
                    TextField("Aylık Gelir (TL)", text: $monthlyIncome)
                        .keyboardType(.decimalPad)
                    TextField("Yatırım Oranı (%)", text: $targetPercentage)
                        .keyboardType(.decimalPad)
                    Stepper("Ay Başlangıç Günü: \(startDay)", value: $startDay, in: 1...28)
                }
            }
            .navigationTitle("Onboarding")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        saveProfile()
                    }
                }
            }
        }
    }

    private func saveProfile() {
        let profile = UserProfile(context: viewContext)
        profile.id = UUID()
        profile.monthlyIncome = Double(monthlyIncome) ?? 0
        profile.targetPercentage = Double(targetPercentage) ?? 0
        profile.startDay = Int16(startDay)

        try? viewContext.save()
        hasOnboarded = true
    }
}

