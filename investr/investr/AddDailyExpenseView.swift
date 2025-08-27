import SwiftUI

struct AddDailyExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var note: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("Category", text: $category)
                TextField("Note", text: $note)
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .navigationTitle("New Expense")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveExpense() }
                }
            }
        }
    }
    
    private func saveExpense() {
        let expense = DailyExpense(context: viewContext)
        expense.id = UUID()
        expense.amount = Double(amount) ?? 0
        expense.category = category
        expense.note = note
        expense.date = date
        
        try? viewContext.save()
        dismiss()
    }
}

