//
//  NotificationManager.swift
//  DiscAppline
//
//  Created by Aram Gokce on 7/5/26.
//

import UserNotifications

final class NotificationManager {
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    static func scheduleNotification(title: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Time to complete your routine."
        content.sound = .default

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}
