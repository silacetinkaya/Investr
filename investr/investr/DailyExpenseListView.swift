import SwiftUI

struct DailyExpenseListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: DailyExpense.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DailyExpense.date, ascending: false)]
    ) var expenses: FetchedResults<DailyExpense>
    
    @State private var showAddExpense = false
    @State private var editingExpense: DailyExpense? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses) { expense in
                    VStack(alignment: .leading) {
                        Text("\(expense.category ?? "Other") • \(expense.amount, specifier: "%.2f") TL")
                            .font(.headline)
                        Text(expense.note ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        if let date = expense.date {
                            Text(date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            delete(expense)
                        } label: {
                            Label("Sil", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            editingExpense = expense
                        } label: {
                            Label("Düzenle", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .navigationTitle("Günlük Giderler")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddExpense.toggle()
                    } label: {
                        Label("Ekle", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddExpense) {
                AddDailyExpenseView()
            }
            .sheet(item: $editingExpense) { expense in
                EditDailyExpenseView(expense: expense)
            }
        }
    }
    
    private func delete(_ expense: DailyExpense) {
        viewContext.delete(expense)
        try? viewContext.save()
    }
}

