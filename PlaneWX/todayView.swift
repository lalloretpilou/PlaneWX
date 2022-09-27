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
    @State var dewPoint: String?
    @State var pressure: String?
    @State var windGust: String?

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
                        HStack(alignment: .center) {
                            Text("Today".localised())
                                .font(Font.largeTitle.bold())
                            Text(Image(systemName: symbol ?? "exclamationmark.icloud"))
                                .font(Font.largeTitle.bold())
                        }
                    }
                    Spacer()
                }.padding()
            }
            VStack(alignment: .leading, spacing: 30) {
                
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "text.alignleft")
                        Text("Condition".localised())
                    }
                    .foregroundColor(.gray)
                    .bold()
                    .font(Font.body)
                    Text(status ?? "Loading weather information".localised())
                        .font(Font.title3.bold())

                }
                
                
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "thermometer")
                        Text("Temperature".localised())
                    }
                    .foregroundColor(.gray)
                    .bold()
                    .font(Font.body)
                    Text(temperature ?? "Loading weather information".localised())                        .font(Font.title3.bold())

                }
                
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "sun.min")
                        Text("UV Index".localised())
                    }
                    .foregroundColor(.gray)
                    .bold()
                    .font(Font.body)
                    Text("UV index " + String(uvIndex?.value ?? 0))
                      .font(Font.title3.bold())

                }
                
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "aqi.medium")
                        Text("Dew Point".localised())
                    }
                    .foregroundColor(.gray)
                    .bold()
                    .font(Font.body)
                    Text(dewPoint ?? "Loading weather information".localised())
                      .font(Font.title3.bold())

                }
                
                
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "aqi.medium")
                        Text("Pressure".localised())
                    }
                    .foregroundColor(.gray)
                    .bold()
                    .font(Font.body)
                    Text(pressure ?? "Loading weather information".localised())
                      .font(Font.title3.bold())

                }
                
                
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "wind")
                        Text("Wind Gust".localised())
                    }
                    .foregroundColor(.gray)
                    .bold()
                    .font(Font.body)
                    Text(windGust ?? "Loading weather information".localised())
                      .font(Font.title3.bold())

                }
            }
            .padding()
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

        temperature=weather?.currentWeather.temperature
            .converted(to: .celsius)
            .formatted(.measurement(usage: .asProvided))
        
        uvIndex=weather?.currentWeather.uvIndex
        symbol=weather?.currentWeather.symbolName
        status=weather?.currentWeather.condition.rawValue
        dewPoint=weather?.currentWeather.dewPoint
            .converted(to: .celsius)
            .formatted(.measurement(usage: .asProvided))
        pressure=weather?.currentWeather.pressure
            .converted(to: .hectopascals)
            .formatted()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        todayView()
    }
}
