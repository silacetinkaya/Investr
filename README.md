# 🚀 Sprint 1 — Basic Setup & Data Model  

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
