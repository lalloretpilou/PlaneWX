//
//  PlaneWXApp.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 05/08/2022.
//

import SwiftUI

@main
struct PlaneWXApp: App {
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
            alertView().tag(1)
            todayView().tag(2)
            forecastView().tag(3)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .onAppear
        {
            UIPageControl.appearance().currentPageIndicatorTintColor = .black
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        }
  }
}
