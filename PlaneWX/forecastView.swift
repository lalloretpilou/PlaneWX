//
//  forecastView.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 05/08/2022.
//

import SwiftUI
import WeatherKit
import CoreLocation
import Combine
import Charts

struct forecastView: View {
    
    @State var cityName = ""
    let locationProvider = LocationProvider()
    
    let weatherService = WeatherService.shared
    var locationManager = LocationManager()
    @State private var weather: Weather?
    
    @State var validity: String?
    
    var hourlyWeatherData: [HourWeather] {
        if let weather {
            return Array(weather.hourlyForecast.filter { hourlyWeather in
                return hourlyWeather.date.timeIntervalSince(Date()) >= 0
            }.prefix(6))
        } else {
            return []
        }
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                VStack (alignment: .leading) {
                    Text(cityName)
                        .foregroundColor(.gray)
                        .bold()
                        .font(Font.body)
                    Text("Forecast".localised())
                        .font(Font.largeTitle.bold())
                    Text(validity ?? "")
                        .foregroundColor(.gray)
                        .bold()
                        .font(Font.footnote)
                }
                Spacer()
            }
            
            Divider()
            
            if weather != nil {
                
                VStack(alignment: .leading, spacing: 30) {
                    HourlyForcastView(hourWeatherList: hourlyWeatherData)
                    //TenDayForcastView(dayWeatherList: weather.dailyForecast.forecast)
                    ScrollView{
                        HourlyForecastChartView(hourlyWeatherData: hourlyWeatherData)
                    }
                }
                .frame(width: 350)
            }
        }
        .padding()
        .onAppear {
            Task {
                getAddress()
                
                let locManager = CLLocationManager()
                var currentLocation: CLLocation!
                currentLocation = locManager.location
                let location = CLLocation(latitude: currentLocation.coordinate.latitude,
                                          longitude: currentLocation.coordinate.longitude)
                do {
                    self.weather =  try await weatherService.weather(for: location)
                } catch {
                    print(error)
                }
            }
        }
    }
}

extension forecastView {
    
    func getAddress() {
        
        let locManager = CLLocationManager()
        var currentLocation: CLLocation!
        currentLocation = locManager.location
        
        let location = CLLocation(latitude: currentLocation.coordinate.latitude,
                                  longitude: currentLocation.coordinate.longitude)
        
        locationProvider.getPlace(for: location) { plsmark in
            guard let placemark = plsmark else { return }
            if let city = placemark.locality,
               let state = placemark.administrativeArea{
                self.cityName = "\(city), \(state)"
            } else if let city = placemark.locality, let state = placemark.administrativeArea {
                self.cityName = "\(city) \(state)"
            } else {
                self.cityName = "Address Unknown"
            }
        }
    }
    func getWeather() async {
        let weatherService = WeatherService()
        
        let locManager = CLLocationManager()
        var currentLocation: CLLocation!
        currentLocation = locManager.location
        
        let coordinate = CLLocation(latitude: currentLocation.coordinate.latitude
                                    ,longitude: currentLocation.coordinate.longitude)
        
        
        let weather = try? await weatherService.weather(for: coordinate)
        
        validity = weather?.hourlyForecast.metadata.expirationDate.formatted(date: .abbreviated, time: .shortened)
        
    }
}


struct HourlyForcastView: View {
    
    let hourWeatherList: [HourWeather]
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("HOURLY FORECAST".localised())
                .font(Font.title3.bold())
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(hourWeatherList, id: \.date) { hourWeatherItem in
                        VStack(spacing: 10) {
                            Text(hourWeatherItem.date.formatAsAbbreviatedTime())
                            Image(systemName: "\(hourWeatherItem.symbolName).fill")
                                .fontWeight(.bold)
                            Text(hourWeatherItem.temperature.formatted())
                                .fontWeight(.medium)
                        }.padding()
                    }
                }
            }
        }.padding()
        Divider()
    }
    
}

struct TenDayForcastView: View {
    
    let dayWeatherList: [DayWeather]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("10-DAY FORCAST".localised())
                .font(Font.title3.bold())
            
            List(dayWeatherList, id: \.date) { dailyWeather in
                HStack {
                    Text(dailyWeather.date.formatAsAbbreviatedDay())
                        .frame(maxWidth: 50, alignment: .leading)
                    
                    Image(systemName: "\(dailyWeather.symbolName)")
                        .fontWeight(.bold)
                    
                }
            }.listStyle(.plain)
        }
        .frame(height: 300)
        .padding()
    }
    
}

struct HourlyForecastChartView: View {
    
    let hourlyWeatherData: [HourWeather]
    
    var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [Color("AppGradientStart"),Color("AppGradientEnd")])
                       , startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        
        let curColor = Color("AppGradientEnd")
        let stColor = Color("AppGradientStart")
        let curGradient = LinearGradient(
            gradient: Gradient (
                colors: [
                    curColor.opacity(0.5),
                    curColor.opacity(0.2),
                    curColor.opacity(0.05),
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )

        VStack(alignment: .leading) {
            Text("Temperature".localised())
                .font(Font.title3.bold())
            Chart {
                ForEach(hourlyWeatherData.prefix(8), id: \.date) { hourlyWeather in
                    LineMark(x: .value("Hour".localised(), hourlyWeather.date.formatAsAbbreviatedTime()),
                             y: .value("Temperature".localised(), hourlyWeather.temperature.converted(to: .celsius).value))
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth:3))
                    
                    AreaMark(x: .value("Hour".localised(), hourlyWeather.date.formatAsAbbreviatedTime()),
                             y: .value("Temperature".localised(), hourlyWeather.temperature.converted(to: .celsius).value))
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(curGradient)
                    .foregroundStyle(by: .value("Hour".localised(), "Temperature".localised()))
                    
                }
            }
        }
        .padding()
        Divider()
        VStack(alignment: .leading) {
            Text("Precipitation Chance".localised())
                .font(Font.title3.bold())
            Chart {
                ForEach(hourlyWeatherData.prefix(8), id: \.date) { hourlyWeather in
                    BarMark(x: .value("Hour".localised(), hourlyWeather.date.formatAsAbbreviatedTime()),
                            y: .value("precipitationChance".localised(), hourlyWeather.precipitationChance))
                    .foregroundStyle(gradient)
                }
            }
        }
        .padding()
        Divider()
        VStack(alignment: .leading) {
            Text("Wind Speed".localised())
                .font(Font.title3.bold())
            Chart {
                ForEach(hourlyWeatherData.prefix(10), id: \.date) { hourlyWeather in
                    LineMark(x: .value("Hour".localised(), hourlyWeather.date.formatAsAbbreviatedTime()),
                             y: .value("Wind Speed".localised(), hourlyWeather.wind.speed.converted(to: .knots).value))
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth:3))
                    
                    AreaMark(x: .value("Hour".localised(), hourlyWeather.date.formatAsAbbreviatedTime()),
                             y: .value("Wind Speed".localised(), hourlyWeather.wind.speed.converted(to: .knots).value))
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(curGradient)
                    .foregroundStyle(by: .value("Hour".localised(), "Wind Speed".localised()))
                }
            }
        }
        .padding()
    }
}


extension Date {
    func formatAsAbbreviatedDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
    
    func formatAsAbbreviatedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: self)
    }
}

struct forecastView_Previews: PreviewProvider {
    static var previews: some View {
        forecastView()
    }
}
