//
//  APIManager.swift
//  Weather
//
//  Created by Pam Wongkraivet on 04.05.2023.
//

import Foundation
import CoreLocation

class WeatherAPIManager {
    static let shared = WeatherAPIManager()

    private init() {}

    func getLocationCurrentWeatherURL(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> String {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.path + "/onecall"
        components.queryItems = [URLQueryItem(name: "lat", value: String(latitude)),
                                 URLQueryItem(name: "lon", value: String(longitude)),
                                 URLQueryItem(name: "exclude", value: "minutely"),
                                 URLQueryItem(name: "units", value: "metric"),
                                 URLQueryItem(name: "appid", value: OpenWeatherAPI.key)]
        guard let componentsString = components.string else { return "" }
        return componentsString
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (String?) -> Void) {
        let urlString = getLocationCurrentWeatherURL(latitude: latitude, longitude: longitude)

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let currentWeather = json["current"] as? [String: Any],
                       let weatherArray = currentWeather["weather"] as? [[String: Any]],
                       let weather = weatherArray.first?["description"] as? String {
                        completion(weather)
                    } else {
                        completion(nil)
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                    completion(nil)
                }
            } else {
                print("Error fetching weather: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
    }
}

