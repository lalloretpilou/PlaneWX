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
    
    var hourlyWeatherData: [HourWeather] {
        if let weather {
            return Array(weather.hourlyForecast.filter { hourlyWeather in
                return hourlyWeather.date.timeIntervalSince(Date()) >= 0
            }.prefix(24))
        } else {
            return []
        }
    }
    
    
    
    var body: some View {
        ScrollView{
            VStack (alignment: .leading) {
                HStack {
                    VStack (alignment: .leading) {
                        Text(cityName)
                            .foregroundColor(.gray)
                            .bold()
                            .font(Font.body)
                        Text("Forecast".localised())
                            .font(Font.largeTitle.bold())
                    }
                    Spacer()
                }.padding()
            }
            Divider()
            VStack(alignment: .leading, spacing: 30) {
                if let weather {
                    
                    HourlyForcastView(hourWeatherList: hourlyWeatherData)
                    
                    HourlyForecastChartView(hourlyWeatherData: hourlyWeatherData)
                    
                    TenDayForcastView(dayWeatherList: weather.dailyForecast.forecast)
                }
            }
        }
        .onAppear {
            Task {
                hapticSucess()
                getAddress()
                
                let locManager = CLLocationManager()
                var currentLocation: CLLocation!
                currentLocation = locManager.location
                let location = CLLocation(latitude: currentLocation.coordinate.latitude,
                                          longitude: currentLocation.coordinate.longitude)
                do {
                    self.weather =  try await weatherService.weather(for: location)

                    print("toto")
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
               let state = placemark.administrativeArea {
                self.cityName = "\(city), \(state)"
            } else if let city = placemark.locality, let state = placemark.administrativeArea {
                self.cityName = "\(city) \(state)"
            } else {
                self.cityName = "Address Unknown"
            }
        }
    }
}






struct HourlyForcastView: View {
    
    let hourWeatherList: [HourWeather]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("HOURLY FORECAST")
                .font(.caption)
                .opacity(0.5)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(hourWeatherList, id: \.date) { hourWeatherItem in
                        VStack(spacing: 20) {
                            Text(hourWeatherItem.date.formatAsAbbreviatedTime())
                            Image(systemName: "\(hourWeatherItem.symbolName).fill")
                                .foregroundColor(.yellow)
                            Text(hourWeatherItem.temperature.formatted())
                                .fontWeight(.medium)
                        }.padding()
                    }
                }
            }
        }.padding().background {
            Color.blue
        }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            .foregroundColor(.white)
    }
    
}

struct TenDayForcastView: View {
    
    let dayWeatherList: [DayWeather]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("10-DAY FORCAST")
                .font(.caption)
                .opacity(0.5)
            
            List(dayWeatherList, id: \.date) { dailyWeather in
                HStack {
                    Text(dailyWeather.date.formatAsAbbreviatedDay())
                        .frame(maxWidth: 50, alignment: .leading)
                    
                    Image(systemName: "\(dailyWeather.symbolName)")
                        .foregroundColor(.yellow)
                    
                    Text(dailyWeather.lowTemperature.formatted())
                        .frame(maxWidth: .infinity)
                    
                    Text(dailyWeather.highTemperature.formatted())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }.listRowBackground(Color.blue)
            }.listStyle(.plain)
        }
        .frame(height: 300).padding()
        .background(content: {
            Color.blue
        })
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        .foregroundColor(.white)
    }
    
}

struct HourlyForecastChartView: View {
    
    let hourlyWeatherData: [HourWeather]
    
    var body: some View {
        Chart {
            ForEach(hourlyWeatherData.prefix(10), id: \.date) { hourlyWeather in
                LineMark(x: .value("Hour", hourlyWeather.date.formatAsAbbreviatedTime()), y: .value("Temperature", hourlyWeather.temperature.converted(to: .fahrenheit).value))
            }
        }
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
