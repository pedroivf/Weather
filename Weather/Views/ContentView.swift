//
//  ContentView.swift
//  Weather
//
//  Created by Pedro Velazquez Fernandez on 6/15/23.
//

import SwiftUI
//import CoreLocation
import CoreLocationUI

struct ContentView: View {
    @State private var searchText = ""
    @StateObject private var viewModel = ViewModel()
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if let selectedGeocoding=viewModel.selectedGeocoding {
                    // From iOS 15, AsyncImage use URLCache internally to cache images
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(selectedGeocoding.weather[0].icon)@4x.png")) { image in
                        image.resizable()
                            .frame(width: 230, height: 230)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    Text(selectedGeocoding.weather[0].description).font(.headline).frame(maxWidth: .infinity, alignment: .center)
                    Text("\(selectedGeocoding.main.temp, specifier: "%.1f")°K").font(.largeTitle).frame(maxWidth: .infinity, alignment: .center)
                } else {
                    if let location = locationManager.location {
                        Text("Getting Weather for location (lat:\(location.latitude),lon\(location.longitude)")
                            .frame(maxWidth: .infinity, alignment: .center)
                        // ToDo: Call updateWeatherByLocation
                    } else {
                        // Wait for search city, no currentLocation allowed
                        Text("Please enter a City Name or")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                LocationButton {
                    locationManager.requestLocation()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                
            }
            .navigationTitle("Weather")
        }
        .searchable(text: $searchText, prompt: "City Name")
        .onSubmit(of: .search) { viewModel.updateWeather(query: searchText) }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

