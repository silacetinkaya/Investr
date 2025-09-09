import SwiftUI

struct EditDailyExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var expense: DailyExpense
    
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var note: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Tutar", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("Kategori", text: $category)
                TextField("Not", text: $note)
                DatePicker("Tarih", selection: $date, displayedComponents: .date)
            }
            .navigationTitle("Gider Düzenle")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") { saveChanges() }
                }
            }
            .onAppear {
                amount = String(expense.amount)
                category = expense.category ?? ""
                note = expense.note ?? ""
                date = expense.date ?? Date()
            }
        }
    }
    
    private func saveChanges() {
        expense.amount = Double(amount) ?? 0
        expense.category = category
        expense.note = note
        expense.date = date
        
        try? viewContext.save()
        dismiss()
    }
}

