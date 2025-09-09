import SwiftUI
import Charts

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // Core Data fetch requests
    @FetchRequest(entity: FixedExpense.entity(), sortDescriptors: [])
    var fixedExpenses: FetchedResults<FixedExpense>
    
    @FetchRequest(
        entity: DailyExpense.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DailyExpense.date, ascending: true)]
    ) var dailyExpenses: FetchedResults<DailyExpense>
    
    @FetchRequest(entity: UserProfile.entity(), sortDescriptors: [])
    var profiles: FetchedResults<UserProfile>
    
    @State private var showAddExpense = false
    @State private var showQuickAdd = false
    @State private var showProfileEdit = false
    
    // CSV export state
    @State private var exportData: Data? = nil
    @State private var showingShareSheet = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 20) {
                        
                        if let profile = profiles.first {
                            let stats = FinanceManager.calculateStats(
                                profile: profile,
                                fixedExpenses: Array(fixedExpenses),
                                dailyExpenses: Array(dailyExpenses)
                            )
                            
                            // 📊 Progress Circle
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
                                    Text(stats.statusText)
                                        .font(.subheadline)
                                }
                            }
                            .frame(width: 200, height: 200)
                            .padding(.top)
                            
                            // 💵 Projection Row
                            HStack {
                                Text("Projection:").bold()
                                Spacer()
                                Text("\(Int(stats.spentSoFar + stats.fixedTotal))/\(Int(profile.monthlyIncome)) ₺")
                            }
                            .padding(.horizontal)
                            
                            // 📋 Details Box
                            VStack(alignment: .leading, spacing: 12) {
                                rowItem(label: "Income", value: "\(Int(profile.monthlyIncome)) ₺")
                                rowItem(label: "Fixed", value: "\(Int(stats.fixedTotal)) ₺")
                                rowItem(label: "Daily", value: "\(Int(stats.spentSoFar)) ₺")
                                rowItem(
                                    label: "Remaining",
                                    value: "\(Int(profile.monthlyIncome - (stats.fixedTotal + stats.spentSoFar))) ₺ - \(stats.remainingDays) days",
                                    boldValue: true
                                )
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                            .padding(.horizontal)
                            
                            // 📅 Bugünün Harcaması Kutusu
                            let todayTotal = todayExpenses().map { $0.amount }.reduce(0, +)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Bugün Harcama")
                                    .font(.headline)
                                Text("\(Int(todayTotal)) ₺")
                                    .font(.title3)
                                    .bold()
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemYellow).opacity(0.2)))
                            .padding(.horizontal)
                            
                            // 📊 Ortalama Günlük Limit Kutusu
                            let dailyLimitInfo = calculateDailyLimit(profile: profile, stats: stats, todaySpent: todayTotal)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Ortalama Günlük Limit")
                                    .font(.headline)
                                Text(dailyLimitInfo.message)
                                    .font(.subheadline)
                                    .foregroundColor(dailyLimitInfo.over ? .red : .green)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBlue).opacity(0.2)))
                            .padding(.horizontal)
                            
                            // 🥧 Category Breakdown (Pie Chart)
                            let categoryTotals = calculateCategoryTotals(
                                daily: Array(dailyExpenses),
                                fixed: Array(fixedExpenses)
                            )
                            
                            CategoryPieChart(data: categoryTotals)
                                .padding(.horizontal)
                            
                            // 📈 Daily Expense Trend (Line Chart, sadece bu ay)
                            VStack(alignment: .leading) {
                                Text("Daily Expense Trend")
                                    .font(.headline)
                                
                                Chart {
                                    ForEach(filteredCurrentMonthExpenses(), id: \.objectID) { expense in
                                        LineMark(
                                            x: .value("Day", expense.date ?? Date(), unit: .day),
                                            y: .value("Amount", expense.amount)
                                        )
                                        .foregroundStyle(.blue)
                                        .symbol(Circle())
                                    }
                                }
                                .frame(height: 200)
                            }
                            .padding(.horizontal)
                            
                            // 📤 Export CSV Button
                            Button("Export CSV") {
                                let dailyCSV = CSVExporter.exportDailyExpenses(expenses: Array(dailyExpenses))
                                let fixedCSV = CSVExporter.exportFixedExpenses(expenses: Array(fixedExpenses))
                                let combined = "=== Daily Expenses ===\n" + dailyCSV + "\n\n=== Fixed Expenses ===\n" + fixedCSV
                                
                                if let data = combined.data(using: .utf8) {
                                    showShareSheet(data: data)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .padding()
                            
                            // 🔄 Yeni Aya Başla Butonu
                            Button(role: .destructive) {
                                resetMonth()
                            } label: {
                                Label("Yeni Aya Başla (Tüm günlük giderleri sil)", systemImage: "trash")
                            }
                            .padding()
                        }
                        
                        Spacer(minLength: 50)
                    }
                }
                
                // ➕ Floating Add Buttons
                VStack {
                    // ⚡ Quick Add Button
                    Button(action: { showQuickAdd.toggle() }) {
                        Image(systemName: "bolt.fill")
                            .font(.title2)
                            .padding()
                            .background(Circle().fill(Color.orange))
                            .foregroundColor(.white)
                            .shadow(color: .gray.opacity(0.4), radius: 6, x: 0, y: 4)
                    }
                    .padding(.bottom, 10)
                    .sheet(isPresented: $showQuickAdd) {
                        QuickAddExpenseView()
                    }
                    
                    // ➕ Full Add Button
                    Button(action: { showAddExpense.toggle() }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .padding()
                            .background(Circle().fill(Color.blue))
                            .foregroundColor(.white)
                            .shadow(color: .gray.opacity(0.4), radius: 6, x: 0, y: 4)
                    }
                    .sheet(isPresented: $showAddExpense) {
                        AddDailyExpenseView()
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .toolbar {
                // 👤 Profil Düzenle Butonu
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let profile = profiles.first {
                        Button {
                            showProfileEdit.toggle()
                        } label: {
                            Image(systemName: "person.circle")
                        }
                        .sheet(isPresented: $showProfileEdit) {
                            ProfileEditView(profile: profile)
                        }
                    }
                }
            }
            // 🔔 Bildirim tetikleme (Over Budget!)
            .onAppear {
                if let profile = profiles.first {
                    let stats = FinanceManager.calculateStats(
                        profile: profile,
                        fixedExpenses: Array(fixedExpenses),
                        dailyExpenses: Array(dailyExpenses)
                    )
                    if stats.statusText == "Over Budget!" {
                        NotificationManager.triggerBudgetWarning()
                    }
                }
            }
            // 📤 CSV Share Sheet
            .sheet(isPresented: $showingShareSheet) {
                if let exportData = exportData {
                    ShareSheet(data: exportData, fileName: "expenses.csv")
                }
            }
        }
    }
    
    // 📌 Helper for rows
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
    
    // 📌 Günlük harcamaları sadece bu ay için filtrele
    private func filteredCurrentMonthExpenses() -> [DailyExpense] {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        return dailyExpenses.filter { expense in
            if let date = expense.date {
                let month = calendar.component(.month, from: date)
                let year = calendar.component(.year, from: date)
                return month == currentMonth && year == currentYear
            }
            return false
        }
    }
    
    // 📌 Bugünün harcamalarını getir
    private func todayExpenses() -> [DailyExpense] {
        let calendar = Calendar.current
        return dailyExpenses.filter { expense in
            if let date = expense.date {
                return calendar.isDateInToday(date)
            }
            return false
        }
    }
    
    // 📌 Ortalama günlük limit hesaplama
    private func calculateDailyLimit(profile: UserProfile, stats: FinanceStats, todaySpent: Double) -> (message: String, over: Bool) {
        let totalDays = Calendar.current.range(of: .day, in: .month, for: Date())?.count ?? 30
        let available = profile.monthlyIncome - stats.fixedTotal - stats.targetAmount
        let dailyLimit = available / Double(totalDays)
        
        if todaySpent > dailyLimit {
            return ("Bugün \(Int(todaySpent)) ₺ harcadın. Limitin \(Int(dailyLimit)) ₺ → Limit aşıldı ❌", true)
        } else {
            return ("Bugün \(Int(todaySpent)) ₺ harcadın. Limitin \(Int(dailyLimit)) ₺ → İyi gidiyorsun ✅", false)
        }
    }
    
    // 📌 Ay sıfırlama (tüm günlük giderleri sil)
    private func resetMonth() {
        let fetchRequest = DailyExpense.fetchRequest()
        if let expenses = try? viewContext.fetch(fetchRequest) {
            for expense in expenses {
                viewContext.delete(expense)
            }
            try? viewContext.save()
        }
    }
    
    // 📌 ShareSheet çağırma helper
    private func showShareSheet(data: Data) {
        exportData = data
        showingShareSheet = true
    }
}

