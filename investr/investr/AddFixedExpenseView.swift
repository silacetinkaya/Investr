import SwiftUI

struct AddFixedExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss

    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var recurrence: String = "Aylık"

    var body: some View {
        NavigationView {
            Form {
                TextField("Ad", text: $name)
                TextField("Tutar", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("Kategori", text: $category)
                TextField("Yinelenme", text: $recurrence)
            }
            .navigationTitle("Yeni Gider")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        saveExpense()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveExpense() {
        let expense = FixedExpense(context: viewContext)
        expense.id = UUID()
        expense.name = name
        expense.amount = Double(amount) ?? 0
        expense.category = category
        expense.recurrence = recurrence

        try? viewContext.save()
        dismiss()
    }
}

