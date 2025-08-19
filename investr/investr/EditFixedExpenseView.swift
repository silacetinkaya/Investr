import SwiftUI

struct EditFixedExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss

    @ObservedObject var expense: FixedExpense

    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var recurrence: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Ad", text: $name)
                TextField("Tutar", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("Kategori", text: $category)
                TextField("Yinelenme", text: $recurrence)
            }
            .navigationTitle("Gider Düzenle")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        saveChanges()
                    }
                }
            }
            .onAppear {
                // var olan değerleri form alanlarına yükle
                name = expense.name ?? ""
                amount = String(expense.amount)
                category = expense.category ?? ""
                recurrence = expense.recurrence ?? ""
            }
        }
    }

    private func saveChanges() {
        expense.name = name
        expense.amount = Double(amount) ?? 0
        expense.category = category
        expense.recurrence = recurrence

        try? viewContext.save()
        dismiss()
    }
}

