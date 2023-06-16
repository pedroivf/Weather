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
        @Published var localeTemperature : String = ""
        let apiKey = Bundle.main.infoDictionary?["APIKEY"] as? String ?? ""
        let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("LastGeocoding")
        
        init() {
            // Auto-load the last Geocoding
            do {
                let data = try Data(contentsOf: savePath)
                selectedGeocoding = try JSONDecoder().decode(Geocoding.self, from: data)
                localeTemperature = kelvinToLocaleTemperature(kelvin: selectedGeocoding?.main.temp ?? 0)
            } catch {
                selectedGeocoding = nil
            }
        }
    
        func saveGeocoding() {
            do {
                let data = try JSONEncoder().encode(selectedGeocoding)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print ("Error to save data")
            }
        }
        
        func updateWeather(query: String = "", lat: Double = 0, lon: Double = 0) {
            Task {
                // https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
                // https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
                // https://api.openweathermap.org/data/2.5/weather?q={city name},{country code}&appid={API key}
                // https://api.openweathermap.org/data/2.5/weather?q={city name},{state code},{country code}&appid={API key}
                let apiParams = query != "" ? "q=\(query)" : "lat=\(lat)&lon=\(lon)"
                guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?\(apiParams)&appid=\(apiKey)") else {
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
                localeTemperature = kelvinToLocaleTemperature(kelvin: selectedGeocoding?.main.temp ?? 0)
                saveGeocoding()
            }
        }

        func kelvinToLocaleTemperature(kelvin: Double) -> String {
            // Current kelvin Measurement
            let kevinTemp = Measurement(value: kelvin, unit: UnitTemperature.kelvin)
            // 2 decimal digits
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 2
            // Convert to String Locale Temperature
            let measurementFormatter = MeasurementFormatter()
            measurementFormatter.numberFormatter = numberFormatter
            return measurementFormatter.string(from: kevinTemp)
        }
        
    }
}
