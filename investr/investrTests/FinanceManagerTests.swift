import XCTest
import CoreData
@testable import investr

final class FinanceManagerTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    var profile: UserProfile!
    
    override func setUp() {
        super.setUp()
        
        let container = NSPersistentContainer(name: "investr")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        context = container.viewContext
        
        profile = UserProfile(context: context)
        profile.id = UUID()
        profile.monthlyIncome = 30000
        profile.targetPercentage = 20
        profile.startDay = 1
    }
    
    override func tearDown() {
        profile = nil
        context = nil
        super.tearDown()
    }
    
    func testStats_WhenExpensesLow_ShouldBeGreen() {
        let rent = FixedExpense(context: context)
        rent.id = UUID()
        rent.name = "Kira"
        rent.amount = 5000
        
        let coffee = DailyExpense(context: context)
        coffee.id = UUID()
        coffee.amount = 200
        coffee.date = Date()
        
        let stats = FinanceManager.calculateStats(
            profile: profile,
            fixedExpenses: [rent],
            dailyExpenses: [coffee]
        )
        
        XCTAssertEqual(stats.color, .green)
        XCTAssertEqual(stats.statusText, "On Track")
    }
    
    func testStats_WhenExpensesHigh_ShouldBeRed() {
        let car = FixedExpense(context: context)
        car.id = UUID()
        car.name = "Araba Kredisi"
        car.amount = 40000  // geliri aşacak
        
        let stats = FinanceManager.calculateStats(
            profile: profile,
            fixedExpenses: [car],
            dailyExpenses: []
        )
        
        XCTAssertEqual(stats.color, .red)
        XCTAssertEqual(stats.statusText, "Over Budget!")
    }
    
    func testStats_WhenNearLimit_ShouldBeYellow() {
        let travel = FixedExpense(context: context)
        travel.id = UUID()
        travel.name = "Tatil"
        travel.amount = 28000  // gelir: 30.000 → %93, yani sarı
        
        let stats = FinanceManager.calculateStats(
            profile: profile,
            fixedExpenses: [travel],
            dailyExpenses: []
        )
        
        XCTAssertEqual(stats.color, .yellow)
        XCTAssertEqual(stats.statusText, "At Risk")
    }
}

