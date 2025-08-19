import SwiftUI

struct FixedExpenseListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: FixedExpense.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FixedExpense.name, ascending: true)]
    ) var expenses: FetchedResults<FixedExpense>

    @State private var showAddExpense = false
    @State private var editingExpense: FixedExpense? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(expenses) { expense in
                    VStack(alignment: .leading) {
                        Text(expense.name ?? "Bilinmiyor")
                            .font(.headline)
                        Text("\(expense.amount, specifier: "%.2f") TL • \(expense.category ?? "")")
                            .font(.subheadline)
                    }
                    .swipeActions(edge: .trailing) {  // sola kaydır
                        Button(role: .destructive) {
                            delete(expense)
                        } label: {
                            Label("Sil", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {  // sağa kaydır
                        Button {
                            editingExpense = expense
                        } label: {
                            Label("Düzenle", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .navigationTitle("Sabit Giderler")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddExpense.toggle() }) {
                        Label("Ekle", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddExpense) {
                AddFixedExpenseView()
            }
            .sheet(item: $editingExpense) { expense in
                EditFixedExpenseView(expense: expense)
            }
        }
    }

    private func delete(_ expense: FixedExpense) {
        viewContext.delete(expense)
        try? viewContext.save()
    }
}

