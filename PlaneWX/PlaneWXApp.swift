//
//  PlaneWXApp.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 05/08/2022.
//

import SwiftUI

@main
struct PlaneWXApp: App {
    let weatherModel: WeatherModel
    
    init() {
        self.weatherModel = WeatherModel()

        weatherModel.refresh()
    }
    
    var body: some Scene {
        WindowGroup {
          ContentView(weatherModel: weatherModel)
        }
    }
}

struct ContentView: View {
    let weatherModel: WeatherModel
    
  @State private var selection = 2

  var body: some View {
        TabView(selection: $selection) {
//            alertView(weatherModel: weatherModel).tag(1)
//            todayView(weatherModel: weatherModel).tag(2)
//            forecastView().tag(3)
            todayView(weatherModel: weatherModel).tag(1)
            homeView(weatherModel: weatherModel).tag(2)
            forecastView(weatherModel: weatherModel).tag(3)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .onAppear
        {
            UIPageControl.appearance().currentPageIndicatorTintColor = .black
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        }
  }
}
