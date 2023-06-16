//
//  Weather.swift
//  Weather
//
//  Created by Pedro Velazquez Fernandez on 6/15/23.
//

import Foundation


struct Geocoding: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Temp
}

struct Coord: Codable {
    let lat: Double
    let lon: Double
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct Temp: Codable {
    let temp: Double
}
