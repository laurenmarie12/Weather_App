//
//  DataFetcherService.swift
//  Weather
//
//  Created by Pam Wongkraivet on 04.05.2023.
//

import Foundation
import CoreLocation

class DataFetcherService {
    
    var networkDataFetcher: DataFetcher = NetworkDataFetcher()
    
    func fetchWeatherData (latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (WeatherModel?) -> Void) {
        let urlString = WeatherAPIManager.shared.getLocationCurrentWeatherURL(latitude: latitude, longitude: longitude)
        print(urlString)
        networkDataFetcher.fetchData(urlString: urlString, completion: completion)
    }
    
}
