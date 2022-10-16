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

    @Published var alertNb: String?

    @Published var date: String?
    @Published var cityName = ""

    @Published var alerts: [WeatherAlertInfo] = []
    
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
        
        if let currentLocation {
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
              
    private func getWeather() async {
        let weatherService = WeatherService()
                
        let locManager = CLLocationManager()
        var currentLocation: CLLocation!
        currentLocation = locManager.location
        
        let weather: Weather?
        
        if let currentLocation {
            let coordinate = CLLocation(latitude: currentLocation.coordinate.latitude
                                        ,longitude: currentLocation.coordinate.longitude)
            weather = try? await weatherService.weather(for: coordinate)
        } else {
            weather = nil
        }

        alertNb = weather?.weatherAlerts?.count.formatted()
        
        alerts = weather?.weatherAlerts ?? []
        
        // This sets up a test of alerts and should be removed for production.
//        alerts = [
//            WeatherAlertTest(region: "Region 1", severity: .minor, summary: "Summary 1", detailsURL: URL(string: "https://www.bbc.co.uk")!, source: "Source 1"),
//            WeatherAlertTest(region: "Region 2", severity: .moderate, summary: "Summary 2", detailsURL: URL(string: "https://www.bbc.co.uk")!, source: "Source 2"),
//            WeatherAlertTest(region: "Region 3", severity: .severe, summary: "Summary 3", detailsURL: URL(string: "https://www.bbc.co.uk")!, source: "Source 3"),
//            WeatherAlertTest(region: "Region 4", severity: .extreme, summary: "Summary 4", detailsURL: URL(string: "https://www.bbc.co.uk")!, source: "Source 4"),
//            WeatherAlertTest(region: "Region 5", severity: .unknown, summary: "Summary 5", detailsURL: URL(string: "https://www.bbc.co.uk")!, source: "Source 5")
//        ]
        
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

protocol WeatherAlertInfo {
    // There is no way to create the metadata so it can't be included in the protocol
//    var metadata: WeatherMetadata { get }
    var region: String? { get }
    var severity: WeatherSeverity { get }
    var summary: String { get }
    var detailsURL: URL { get }
    var source: String { get }
}

extension WeatherAlert: WeatherAlertInfo {}

struct WeatherAlertTest: WeatherAlertInfo {
    let region: String?
    let severity: WeatherSeverity
    let summary: String
    let detailsURL: URL
    let source: String
    
    init(region: String?, severity: WeatherSeverity, summary: String, detailsURL: URL, source: String) {
        self.region = region
        self.severity = severity
        self.summary = summary
        self.detailsURL = detailsURL
        self.source = source
    }
}
