import Foundation
import SwiftUI

struct FinanceStats {
    let progress: Double
    let color: Color
    let statusText: String
    let fixedTotal: Double
    let spentSoFar: Double
    let remainingDays: Int
    let targetAmount: Double
}

class FinanceManager {
    static func calculateStats(
        profile: UserProfile,
        fixedExpenses: [FixedExpense],
        dailyExpenses: [DailyExpense]
    ) -> FinanceStats {
        
        let income = profile.monthlyIncome
        let targetAmount = income * (profile.targetPercentage / 100.0)
        let fixedTotal = fixedExpenses.reduce(0) { $0 + $1.amount }
        let spentSoFar = dailyExpenses.reduce(0) { $0 + $1.amount }
        
        let calendar = Calendar.current
        let today = Date()
        let range = calendar.range(of: .day, in: .month, for: today)!
        let totalDays = range.count
        let currentDay = calendar.component(.day, from: today)
        let remainingDays = totalDays - currentDay
        
        let avgDaily = currentDay > 0 ? spentSoFar / Double(currentDay) : 0
        let projected = Double(remainingDays) * avgDaily + spentSoFar + fixedTotal + targetAmount
        
        // Progress logic
        let utilization = projected / income
        let progress = min(utilization, 1.0)
        
        var color: Color = .green
        var status = "On Track"
        if projected > income {
            color = .red
            status = "Over Budget!"
        } else if utilization > 0.9 {
            color = .yellow
            status = "At Risk"
        }
        
        return FinanceStats(
            progress: progress,
            color: color,
            statusText: status,
            fixedTotal: fixedTotal,
            spentSoFar: spentSoFar,
            remainingDays: remainingDays,
            targetAmount: targetAmount
        )
    }
}

