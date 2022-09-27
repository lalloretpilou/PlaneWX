//
//  ContentView.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 05/08/2022.
//

import SwiftUI
import WeatherKit
import CoreLocation
import MapKit

struct todayView: View {
    
    @State var temperature: String?
    @State var uvIndex: UVIndex?
    @State var symbol: String?
    @State var status: String?
    @State var dewPoint: String?
    @State var pressure: String?
    @State var windGust: String?

    private let minTemp = -15.0
    private let maxTemp = 55.0
    
    private let minDewPt = 0.0
    private let maxDewPt = 50.0
    
    private let minUV = 0.0
    private let maxUV = 16.0
    
    var locationManager = LocationManager()

    let gradient = Gradient(colors: [.blue, .green, .pink])

    var body: some View
    {
        ScrollView {
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
            Divider()
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
                    Text(temperature ?? "Loading weather information".localised())
                        .font(Font.title3.bold())
                    Gauge(value: 17, in: minTemp...maxTemp) {
                    }
                    .gaugeStyle(.accessoryLinear)
                    .tint(gradient)
                    .frame(width: 300)
                }
                
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "sun.min")
                        Text("UV Index".localised())
                    }
                    .foregroundColor(.gray)
                    .bold()
                    .font(Font.body)
                    Text(String(uvIndex?.value ?? 0))
                      .font(Font.title3.bold())
                    Gauge(value: Double(uvIndex?.value ?? 0), in: minUV...maxUV) {
                    }
                    .gaugeStyle(.accessoryLinear)
                    .tint(gradient)
                    .frame(width: 300)

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
                    Gauge(value: 10, in: minDewPt...maxDewPt) {
                    }
                    .gaugeStyle(.accessoryLinear)
                    .tint(gradient)
                    .frame(width: 300)
                }
                
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "square.stack.3d.forward.dottedline.fill")
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
                    hapticSucess()
                }
            }
        }
    }
}

extension todayView {
              
    func getWeather() async {
        let weatherService = WeatherService()
        let coordinate = CLLocation(latitude: self.locationManager.location?.latitude ?? 0
                                    ,longitude: self.locationManager.location?.longitude ?? 0)

        
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
            .formatted(.measurement(width: .abbreviated))
        windGust=weather?.currentWeather.wind.gust?
            .converted(to: .knots)
            .formatted(.measurement(width: .abbreviated))
    }
}

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

func dewPoint(temperature: String?, dewPoint: String?) -> Bool {
    
    return false
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        todayView()
    }
}
