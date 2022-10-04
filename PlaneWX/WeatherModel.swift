//
//  WeatherModel.swift
//  PlaneWX
//
//  Created by Richard Smith on 02/10/2022.
//

import Foundation
import CoreLocation
import WeatherKit
import SwiftUI

@MainActor
class WeatherModel: ObservableObject {
    let locationProvider = LocationProvider()

    @Published var temperature: String?
    @Published var feelTemperature: String?
    @Published var dewPoint: String?

    @Published var uvIndex: UVIndex?
    
    @Published var humidity: Double?
    
    @Published var symbol: String?
    @Published var status: String?
    @Published var condition: String?

    @Published var pressure: String?
    
    @Published var windGust: String?

    @Published var visibility: String?
    
    @Published var cloudCover: Double?

    @Published var date: String?
    @Published var cityName = ""

    func refresh() {
        Task {
            await getWeather()
            getAddress()
        }
    }
    
    private func getAddress() {

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
              
    private func getWeather() async {
        let weatherService = WeatherService()
        
        let locManager = CLLocationManager()
        var currentLocation: CLLocation!
        currentLocation = locManager.location
        
        let coordinate = CLLocation(latitude: currentLocation.coordinate.latitude
                                    ,longitude: currentLocation.coordinate.longitude)

        
        let weather = try? await weatherService.weather(for: coordinate)

        temperature=weather?.currentWeather.temperature
            .converted(to: .celsius)
            .formatted(.measurement(width: .narrow))
            
        feelTemperature=weather?.currentWeather.apparentTemperature
            .converted(to: .celsius)
            .formatted(.measurement(width: .narrow))
        
        uvIndex=weather?.currentWeather.uvIndex
        symbol=weather?.currentWeather.symbolName
        status=weather?.currentWeather.condition.accessibilityDescription

        dewPoint=weather?.currentWeather.dewPoint
            .converted(to: .celsius)
            .formatted(.measurement(width: .narrow))
        
        pressure=weather?.currentWeather.pressure
            .converted(to: .hectopascals)
            .formatted(.measurement(width: .abbreviated))
        
        windGust=weather?.currentWeather.wind.gust?
            .converted(to: .knots)
            .formatted(.measurement(width: .abbreviated))
        
        visibility=weather?.currentWeather.visibility
            .formatted(.measurement(width: .abbreviated))
        
        cloudCover=((weather?.currentWeather.cloudCover ?? 0)*100)

        humidity=((weather?.currentWeather.humidity ?? 0)*100)

        date = weather?.currentWeather.metadata.date
            .formatted(date: .abbreviated, time: .shortened)
        
        
    }
}
