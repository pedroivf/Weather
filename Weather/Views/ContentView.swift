//
//  ContentView.swift
//  Weather
//
//  Created by Pedro Velazquez Fernandez on 6/15/23.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // From iOS 15, AsyncImage use URLCache internally to cache images
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(viewModel.selectedGeocoding?.weather[0].icon ?? "01d")@4x.png")) { image in
                    image.resizable()
                        .frame(width: 230, height: 230)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                Text(viewModel.selectedGeocoding?.weather.description ?? "-").font(.largeTitle).frame(maxWidth: .infinity, alignment: .center)
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

