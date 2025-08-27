import SwiftUI
import Charts

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fixed expenses
    @FetchRequest(
        entity: FixedExpense.entity(),
        sortDescriptors: []
    ) var fixedExpenses: FetchedResults<FixedExpense>
    
    // Daily expenses
    @FetchRequest(
        entity: DailyExpense.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DailyExpense.date, ascending: true)]
    ) var dailyExpenses: FetchedResults<DailyExpense>
    
    // User profile
    @FetchRequest(
        entity: UserProfile.entity(),
        sortDescriptors: []
    ) var profiles: FetchedResults<UserProfile>
    
    @State private var showAddExpense = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 20) {
                    
                    if let profile = profiles.first {
                        // ✅ Artık FinanceManager çağrılıyor
                        let stats = FinanceManager.calculateStats(
                            profile: profile,
                            fixedExpenses: Array(fixedExpenses),
                            dailyExpenses: Array(dailyExpenses)
                        )
                        
                        // Progress Circle (Investment Indicator)
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                            Circle()
                                .trim(from: 0.0, to: CGFloat(stats.progress))
                                .stroke(stats.color, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut, value: stats.progress)
                            VStack {
                                Text("\(Int(stats.progress * 100))%")
                                    .font(.largeTitle)
                                    .bold()
                                Text("This Month’s Investment")
                                    .font(.subheadline)
                            }
                        }
                        .frame(width: 200, height: 200)
                        .padding(.top)
                        
                        // Projection Row
                        HStack {
                            Text("Projection:").bold()
                            Spacer()
                            Text("\(Int(stats.spentSoFar + stats.fixedTotal))/\(Int(profile.monthlyIncome)) TL")
                        }
                        .padding(.horizontal)
                        
                        // Details Box
                        VStack(alignment: .leading, spacing: 12) {
                            rowItem(label: "Income", value: "\(Int(profile.monthlyIncome)) TL")
                            rowItem(label: "Fixed", value: "\(Int(stats.fixedTotal)) TL")
                            rowItem(label: "Daily", value: "\(Int(stats.spentSoFar)) TL")
                            rowItem(label: "Remaining", value: "\(Int(profile.monthlyIncome - (stats.fixedTotal + stats.spentSoFar))) TL - \(stats.remainingDays) days", boldValue: true)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                        .padding(.horizontal)
                        
                        // Bar Chart
                        Chart {
                            ForEach(dailyExpenses, id: \.id) { expense in
                                BarMark(
                                    x: .value("Day", expense.date ?? Date(), unit: .day),
                                    y: .value("Amount", expense.amount)
                                )
                                .foregroundStyle(Color.blue.gradient)
                            }
                        }
                        .frame(height: 180)
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                
                // Floating Add Button
                Button(action: { showAddExpense.toggle() }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .foregroundColor(.white)
                        .shadow(color: .gray.opacity(0.4), radius: 6, x: 0, y: 4)
                }
                .padding()
                .sheet(isPresented: $showAddExpense) {
                    AddDailyExpenseView()
                }
            }
            .navigationTitle("Dashboard")
        }
    }
    
    // Helper for rows
    private func rowItem(label: String, value: String, boldValue: Bool = false) -> some View {
        HStack {
            Text(label)
            Spacer()
            if boldValue {
                Text(value).bold()
            } else {
                Text(value)
            }
        }
    }
}

