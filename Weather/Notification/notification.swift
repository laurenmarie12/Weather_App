//
//  notification.swift
//  Weathermain
//
//  Created by Lauren Mangla on 5/10/23.
//

import Foundation
import UserNotifications
import CoreLocation

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
        }
    }

    func scheduleDailyQuoteNotification(quote: String) {
        let content = UNMutableNotificationContent()
        content.title = "Daily Quote"
        content.body = quote
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true)

        let request = UNNotificationRequest(identifier: "dailyQuote", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    func scheduleDailyWeatherNotification(weather: String) {
        let content = UNMutableNotificationContent()
        content.title = "Daily Weather Alert"
        content.body = weather
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true)

        let request = UNNotificationRequest(identifier: "dailyWeather", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
