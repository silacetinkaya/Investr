import SwiftUI

struct QuickAddExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @FetchRequest(
        entity: DailyExpense.entity(),
        sortDescriptors: []
    ) var dailyExpenses: FetchedResults<DailyExpense>
    
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var note: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Tutar")) {
                    TextField("Tutar", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Kategori")) {
                    TextField("Kategori", text: $category)
                    
                    // 🔎 Son kullanılan kategoriler önerisi
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(getRecentCategories(expenses: dailyExpenses), id: \.self) { cat in
                                Button(cat) {
                                    category = cat
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Capsule().fill(Color.orange.opacity(0.2)))
                            }
                        }
                    }
                }
                
                Section(header: Text("Not")) {
                    TextField("Not (opsiyonel)", text: $note)
                }
            }
            .navigationTitle("Hızlı Ekle")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") { saveExpense() }
                }
            }
        }
    }
    
    // 📌 Helper → son kullanılan kategoriler
    private func getRecentCategories(expenses: FetchedResults<DailyExpense>) -> [String] {
        let all = expenses.compactMap { $0.category }
        let unique = Array(Set(all))
        return unique.sorted()
    }
    
    private func saveExpense() {
        let expense = DailyExpense(context: viewContext)
        expense.id = UUID()
        expense.amount = Double(amount) ?? 0
        expense.category = category
        expense.note = note
        expense.date = Date() // bugün
        
        try? viewContext.save()
        dismiss()
    }
}

