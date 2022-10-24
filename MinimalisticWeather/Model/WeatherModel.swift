//
//  WeatherModel.swift
//  MinimalisticWeather
//
//  Created by Achraf Labidi on 05.09.22.
//

import Foundation
struct WeatherModel {
    // MARK: - sunrise
    let sunRiseSeconds: TimeInterval
    var sunRiseString: String {
        let time = Date(timeIntervalSince1970: sunRiseSeconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: time)
    }
    // MARK: - sunset
    let sunSetSeconds: TimeInterval
    var sunSetString: String {
        let time = Date(timeIntervalSince1970: sunSetSeconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: time)
    }
    // MARK: - description & city
    let description: String
    let cityName: String
    
    // MARK: - id and related icon
    let conditionID: Int
    var conditionName: String {
        //TODO: change icons
        switch (conditionID/100) {
        case 2:
            return "cloud.bolt.rain"
        case 3:
            return "cloud.drizzle"
        case 5:
            return "cloud.rain"
        case 6:
            return "cloud.snow"
        case 7:
            return "sun.dust"
        case 8:
            if conditionID == 800 {
                return "sun.max"
            }
            return "cloud.sun"
        default:
            return "xxx"
        }
    }
    // MARK: - temperature, humidity and Wind speed
    let temperature: Double
    var temperatureString: String {
        String(format: "%0.0f", temperature)
    }
    let humidity: Int
    var humidityString: String {
        return "\(humidity)%"
    }
    let wind: Double
    var windSpeedString: String {
        String(format: "%0.0fkm/h", wind)
    }
    
}
