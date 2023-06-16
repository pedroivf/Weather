//
//  ViewModel.swift
//  Weather
//
//  Created by Pedro Velazquez Fernandez on 6/15/23.
//

import Foundation

extension ContentView {
    // In WWDC 2023, there is a new "Observable" macro that can simplify this ObservableObject/Publishers and improve the app's performance.
    @MainActor class ViewModel: ObservableObject {
        @Published var selectedGeocoding: Geocoding?
    
        let apiKey = Bundle.main.infoDictionary?["APIKEY"] as? String ?? ""
        
        func updateWeather(query: String) {
            Task {
                guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(query)&appid=\(apiKey)") else {
                    print("updateWeather - Invalid URL")
                    return
                }
                let (data, response) = try await URLSession.shared.data(from:url)
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("updateWeather - Invalid Response: \(response)")
                    return
                }
                
                guard let decodedData = try? JSONDecoder().decode(Geocoding.self, from: data) else {
                    print("updateWeather - Invalidad Data")
                    return
                }
                selectedGeocoding = decodedData
                print("updateWeather - Success")
            }
        }
    }
}
