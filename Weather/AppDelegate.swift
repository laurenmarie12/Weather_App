//
//  Weather
//
//  Created by Pam Wongkraivet on 04.05.2023.
//

import UIKit
import CoreLocation
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Request notification authorization
        NotificationManager.shared.requestAuthorization()
        
        // Set the notification center delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Request location authorization
        requestLocationAuthorization()
        
        // Schedule a daily quote notification
        QuotesAPIManager.shared.fetchRandomQuote { quote in
            if let quote = quote {
                NotificationManager.shared.scheduleDailyQuoteNotification(quote: quote)
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    // MARK: Location Manager Delegate

    func requestLocationAuthorization() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            WeatherAPIManager.shared.fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { weatherDescription in
                if let weatherDescription = weatherDescription {
                    DispatchQueue.main.async {
                        NotificationManager.shared.scheduleDailyWeatherNotification(weather: weatherDescription)
                    }
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error requesting location: \(error)")
    }

    // MARK: Notification Center Delegate

    // Handle incoming notifications when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show the notification to the user
        completionHandler([.banner, .sound])
    }

    // Handle incoming notifications when the app is in the background or not running
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the user's action for the notification
        completionHandler()
    }
}

