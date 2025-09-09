# 📱 Investr — Smart Personal Finance Tracker  

Investr is a modern iOS app built with **SwiftUI + Core Data**, designed to help individuals manage their monthly income, track expenses, and stay on top of investment goals.  

The app combines **expense recording, budgeting projections, notifications, and visual reports** into one seamless experience.  
Users always know if they are *on track*, *at risk*, or *over budget*.  

---

## ✨ Key Features  

- **Onboarding Flow**: set monthly income, investment target %, and month start day.  
- **Fixed Expenses**: manage recurring costs like rent, internet, etc.  
- **Daily Expenses**: log everyday spending with category, note, and date.  
- **Dashboard**: progress indicator, monthly overview, projection vs. target.  
- **Reports**:  
  - 📊 Category breakdown (pie chart)  
  - 📈 Daily/weekly spending trends (line chart)  
- **Notifications**:  
  - Daily reminder at 21:00  
  - Budget warning if projection exceeds income  
- **CSV Export**: share all expenses externally (AirDrop, Mail, WhatsApp…).  
- **UX Enhancements**:  
  - Quick Add button ⚡  
  - Smart category suggestions  
  - Today’s spending card  
  - Daily limit comparison  

---

## 🚀 Tech Stack  
- **SwiftUI** for modern UI  
- **Core Data** for persistent storage  
- **Swift Charts** for interactive data visualization  
- **UserNotifications** for reminders & alerts  
- **Unit Tests** with XCTest for reliability  

---

## 📅 Sprint Plan  

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


<details>
<summary>🚀 Sprint 3 — Reporting & Notifications</summary>

## 🎯 Objective  
Provide insights through visual reports and engage the user with smart notifications.  

---

## 🛠️ Implemented Features  

### 1. Reporting 📊  
- **CategoryPieChart**: shows category breakdown of both fixed and daily expenses.  
- **Daily Expense Trend (Line Chart)**: visualizes spending trend across the month.  

### 2. Notifications 🔔  
- **Daily Reminder**: scheduled at 21:00 to remind users to log expenses.  
- **Budget Warning**: triggered instantly when projection exceeds monthly income (status = red).  

---

## ✅ Acceptance Criteria  
- Reports filter data correctly per month.  
- User receives a reminder every evening.  
- User receives a push notification when budget enters red zone.  

---

## 🔜 Next Step (Sprint 4)  
- Fine-tuning: CSV export, advanced UX features, and unit tests.  

</details>


<details>
<summary>🚀 Sprint 4 — Fine-Tuning & Release Prep</summary>

## 🎯 Objective  
Polish the app with export, tests, and UX improvements to ensure smooth user experience and readiness for release.  

---

## 🛠️ Implemented Features  

### 1. Data Export 📤  
- **CSV Export**: daily and fixed expenses exported together via share sheet (AirDrop, Mail, etc).  

### 2. Unit Tests ✅  
- **FinanceManagerTests**: covers green/yellow/red scenarios.  
- **DailyExpenseTests**: verifies adding, fetching, and deleting expenses.  

### 3. UX Enhancements 🎨  
- **Quick Add Button**: fast expense entry from Dashboard.  
- **Category Suggestions**: recently used categories displayed as quick buttons.  
- **Today’s Spending Card**: shows only today’s total spending.  
- **Daily Limit Card**: compares today’s spending with average daily limit → “Good ✅” or “Limit exceeded ❌”.  

---

## ✅ Acceptance Criteria  
- App is stable and passes all unit tests.  
- User can quickly add and categorize expenses.  
- CSV export produces valid file and can be shared externally.  
- Dashboard provides clear insights (progress, today’s spending, daily limit, charts).  

---

## 🏁 Status  
**App ready for initial release 🚀**  

</details>
