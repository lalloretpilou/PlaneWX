//
//  ContentView.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 05/08/2022.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct todayView: View {
    
    @State var temperature: String?
    @State var uvIndex: UVIndex?
    @State var symbol: String?
    @State var status: String?
    
    var locationManager = LocationManager()

    var body: some View {
        
        VStack(spacing: 10) {
            
            Image(systemName: symbol ?? "")
            
            Text("Jakarta")
                .font(.title)
            
            Text(status ?? "Getting the weather")
            
            Text(temperature ?? "Getting the temp")
            
            Text("UV index " + String(uvIndex?.value ?? 0))
            Text(uvIndex?.category.rawValue ?? "NaN")
            
        }
        .onAppear {
            Task {
                await getWeather()
            }
        }
    }

}


extension todayView {
              
    func getWeather() async {
        let weatherService = WeatherService()
        let jakarta = CLLocation(latitude: locationManager.location?.latitude ?? 0
                                 ,longitude: locationManager.location?.longitude ?? 0)
        let weather = try? await weatherService.weather(for: jakarta)
        

        temperature=weather?.currentWeather.temperature
            .converted(to: .celsius)
            .formatted(.measurement(usage: .asProvided))
        
        uvIndex=weather?.currentWeather.uvIndex
        symbol=weather?.currentWeather.symbolName
        status=weather?.currentWeather.condition.rawValue
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        todayView()
    }
}
