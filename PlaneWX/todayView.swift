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
        
        ScrollView{
            VStack (alignment: .leading) {
                HStack {
                    VStack (alignment: .leading) {
                        Text("Paris")
                            .foregroundColor(.gray)
                            .bold()
                            .font(Font.body)
                        Text("Today".localised())
                            .font(Font.largeTitle.bold())
                    }
                    Spacer()
                }.padding()
            }
            VStack(spacing: 10) {

                Image(systemName: symbol ?? "")
                    .font(.title)
                    .fontWeight(.black)
                
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
            .padding()
        }
    }
}


extension todayView {
              
    func getWeather() async {
        let weatherService = WeatherService()
        let coordinate = CLLocation(latitude: self.locationManager.location?.coordinate.latitude ?? 0
                                    ,longitude: self.locationManager.location?.coordinate.latitude ?? 0)
        
        let weather = try? await weatherService.weather(for: coordinate)

        print("toto")
        print(coordinate)

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
