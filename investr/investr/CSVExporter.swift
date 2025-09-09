import Foundation
import CoreData

class CSVExporter {
    static func exportDailyExpenses(expenses: [DailyExpense]) -> String {
        var csv = "Date,Category,Amount,Note\n"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        for exp in expenses {
            let date = exp.date != nil ? formatter.string(from: exp.date!) : ""
            let category = exp.category ?? ""
            let amount = String(exp.amount)
            let note = exp.note ?? ""
            
            csv += "\(date),\(category),\(amount),\(note)\n"
        }
        return csv
    }
    
    static func exportFixedExpenses(expenses: [FixedExpense]) -> String {
        var csv = "Name,Category,Amount,Recurrence\n"
        for exp in expenses {
            let name = exp.name ?? ""
            let category = exp.category ?? ""
            let amount = String(exp.amount)
            let recurrence = exp.recurrence ?? ""
            
            csv += "\(name),\(category),\(amount),\(recurrence)\n"
        }
        return csv
    }
}

