import XCTest
import CoreData
@testable import investr

final class DailyExpenseTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        // In-memory Core Data (disk yerine RAM kullanır, test için ideal)
        let container = NSPersistentContainer(name: "investr")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        context = container.viewContext
    }
    
    override func tearDown() {
        context = nil
        super.tearDown()
    }
    
    func testAddAndFetchDailyExpense() throws {
        // 1️⃣ Yeni günlük gider oluştur
        let expense = DailyExpense(context: context)
        expense.id = UUID()
        expense.amount = 45.5
        expense.category = "Kahve"
        expense.note = "Starbucks latte"
        expense.date = Date()
        
        try context.save()
        
        // 2️⃣ Fetch request ile geri al
        let request: NSFetchRequest<DailyExpense> = DailyExpense.fetchRequest()
        let results = try context.fetch(request)
        
        // 3️⃣ Doğrula
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.category, "Kahve")
        XCTAssertEqual(results.first?.amount, 45.5)
        XCTAssertEqual(results.first?.note, "Starbucks latte")
    }
}

