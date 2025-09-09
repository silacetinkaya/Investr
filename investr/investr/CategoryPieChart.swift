import SwiftUI
import Charts

// Veri modeli (kategori + toplam tutar)
struct CategoryTotal: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
}

// Pie Chart View
struct CategoryPieChart: View {
    var data: [CategoryTotal]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Category Breakdown")
                .font(.headline)
                .padding(.bottom, 8)
            
            Chart(data) { item in
                SectorMark(
                    angle: .value("Amount", item.amount),
                    innerRadius: .ratio(0.5),    // donut görünümü
                    angularInset: 1
                )
                .foregroundStyle(by: .value("Category", item.name))
            }
            .frame(height: 250)
        }
        .padding()
    }
}

// Helper fonksiyon → Core Data'dan gelen verileri kategori bazında grupla
func calculateCategoryTotals(
    daily: [DailyExpense],
    fixed: [FixedExpense]
) -> [CategoryTotal] {
    var totals: [String: Double] = [:]
    
    daily.forEach { expense in
        totals[expense.category ?? "Other", default: 0] += expense.amount
    }
    
    fixed.forEach { expense in
        totals[expense.category ?? "Other", default: 0] += expense.amount
    }
    
    return totals.map { CategoryTotal(name: $0.key, amount: $0.value) }
}

