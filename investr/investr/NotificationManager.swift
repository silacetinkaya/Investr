import Foundation
import UserNotifications

class NotificationManager {
    
    /// Bildirim izni iste (App açılışında çağrılacak)
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    /// Her gün 21:00’da günlük hatırlatma bildirimi
    static func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Gün Sonu Hatırlatma"
        content.body = "Bugünün harcamalarını eklemeyi unutma 📌"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 21
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule daily reminder: \(error.localizedDescription)")
            }
        }
    }
    
    /// Bütçe kırmızıya döndüğünde (Over Budget!) uyarı
    static func triggerBudgetWarning() {
        let content = UNMutableNotificationContent()
        content.title = "Bütçe Uyarısı 🚨"
        content.body = "Harcama kırmızıya döndü, dikkat et!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "budgetWarning", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to trigger budget warning: \(error.localizedDescription)")
            }
        }
    }
}

