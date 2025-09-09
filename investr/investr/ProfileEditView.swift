import SwiftUI

struct ProfileEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var profile: UserProfile
    
    @State private var monthlyIncome: String = ""
    @State private var targetPercentage: String = ""
    @State private var startDay: Int = 1
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profil Bilgileri")) {
                    TextField("Aylık Gelir (TL)", text: $monthlyIncome)
                        .keyboardType(.decimalPad)
                    TextField("Yatırım Oranı (%)", text: $targetPercentage)
                        .keyboardType(.decimalPad)
                    Stepper("Ay Başlangıç Günü: \(startDay)", value: $startDay, in: 1...28)
                }
                
                Section {
                    Button(role: .destructive) {
                        resetMonth()
                    } label: {
                        Label("Yeni Aya Başla (Tüm günlük giderleri sil)", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Profili Düzenle")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") { saveChanges() }
                }
            }
            .onAppear {
                monthlyIncome = String(profile.monthlyIncome)
                targetPercentage = String(profile.targetPercentage)
                startDay = Int(profile.startDay)
            }
        }
    }
    
    private func saveChanges() {
        profile.monthlyIncome = Double(monthlyIncome) ?? 0
        profile.targetPercentage = Double(targetPercentage) ?? 0
        profile.startDay = Int16(startDay)
        try? viewContext.save()
        dismiss()
    }
    
    private func resetMonth() {
        let fetchRequest = DailyExpense.fetchRequest()
        if let expenses = try? viewContext.fetch(fetchRequest) {
            for expense in expenses {
                viewContext.delete(expense)
            }
            try? viewContext.save()
        }
    }
}

