<details>
<summary>🚀 Sprint 1 — Basic Setup & Data Model</summary>

## 🎯 Objective  
Set up the core structure of the iOS app, design the data model, and implement the initial user flow: onboarding + fixed expenses management.  

---

## 🛠️ Implemented Features  

### 1. Project Setup  
- iOS project created with **SwiftUI + Core Data**.  
- `PersistenceController` configured for permanent data storage.  

### 2. Data Model (Core Data Entities)  
- **UserProfile**  
  - `monthlyIncome: Double`  
  - `targetPercentage: Double`  
  - `startDay: Int16`  
- **FixedExpense**  
  - `name: String`  
  - `amount: Double`  
  - `category: String`  
  - `recurrence: String`  
- **DailyExpense** *(prepared for Sprint 2)*  
  - `amount: Double`  
  - `category: String`  
  - `date: Date`  
  - `note: String`  

### 3. Onboarding Flow 👤  
- First launch → user enters **monthly income, target investment percentage, and month start day**.  
- Data is saved into Core Data.  
- `@AppStorage("hasOnboarded")` ensures onboarding runs only once.  

### 4. Fixed Expenses CRUD 💸  
- **List**: All fixed expenses are displayed.  
- **Add**: New expense form implemented.  
- **Delete**: Swipe to delete enabled.  
- **Edit**: Swipe action opens edit form, changes are saved.  

---

## ✅ Acceptance Criteria  
- User profile is **persistently stored** after onboarding.  
- Fixed expenses can be **added, deleted, edited**, and data is preserved after app restart.  

---

## 🔜 Next Step (Sprint 2)  
- Dashboard screen with:  
  - 📊 Progress indicator (green / yellow / red)  
  - 💵 Monthly overview (income, fixed expenses, spending projection)  
  - 📈 Graphs for daily spending  

</details>


<details>
<summary>🚀 Sprint 2 — Expense Recording & Dashboard</summary>

## 🎯 Objective  
Implement daily expense entry and dashboard with financial overview, projections, and risk indicators.  

---

## 🛠️ Implemented Features  

### 1. Daily Expense Recording  
- **AddDailyExpenseView**: form for amount, category, note, and date.  
- Data saved to Core Data and instantly reflected in Dashboard.  

### 2. Dashboard Overview 📊  
- Displays **income, fixed expenses, daily spent, remaining days, and target investment**.  
- Progress indicator with **color (green / yellow / red)** and percentage.  
- Projection row showing **current vs. projected spending**.  
- **Bar chart** of daily expenses (using Swift Charts).  

### 3. Projection & Risk Manager ⚙️  
- **FinanceManager service** created to calculate:  
  - Fixed total, daily spent, remaining days  
  - Spending projection vs. income  
  - Risk status → *On Track / At Risk / Over Budget*  

---

## ✅ Acceptance Criteria  
- Dashboard updates dynamically as daily expenses are added.  
- Progress color and text change based on projection.  
- Data persists with Core Data integration.  

---

## 🔜 Next Step (Sprint 3)  
- **Reporting**: category breakdown (pie chart) & daily trend (line chart).  
- **Notifications**: daily reminder to log expenses.  

</details>
