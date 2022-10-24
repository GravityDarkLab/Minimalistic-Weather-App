//
//  WeatherData.swift
//  MinimalisticWeather
//
//  Created by Achraf Labidi on 05.09.22.
//

import Foundation

struct WeatherData : Decodable {
    let name: String
    let weather: [WeatherState] // Description & id
    let main: Main // Temperature
    let sys: CityTime // sunrise & sunset
    let wind: Wind
}

struct Main : Decodable {
    let temp: Double
    let humidity: Int
}

struct WeatherState : Decodable{
    let id: Int //TODO: To use for symboles
    let description: String // for the current description
}

struct CityTime: Decodable {
    let sunrise: TimeInterval
    let sunset: TimeInterval
}
struct Wind: Decodable {
    let speed: Double
}
