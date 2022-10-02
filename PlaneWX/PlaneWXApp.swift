//
//  PlaneWXApp.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 05/08/2022.
//

import SwiftUI

@main
struct PlaneWXApp: App {
    
    //I would Like to execute getWeather and getAdress at launch App. Can you fix it please ? this function are in todayView file.
    init() {
        await getWeather()
        getAddress()
    }
    
    var body: some Scene {
        WindowGroup {
          ContentView()
        }
    }
}

struct ContentView: View {
  @State private var selection = 2

  var body: some View {
        TabView(selection: $selection) {
//            alertView().tag(1)
//            todayView().tag(2)
//            forecastView().tag(3)
            todayView().tag(1)
            forecastView().tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .onAppear
        {
            UIPageControl.appearance().currentPageIndicatorTintColor = .black
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        }
  }
}
