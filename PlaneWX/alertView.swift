//
//  alertView.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 05/08/2022.
//

import SwiftUI
import CoreLocation
import Combine
import WeatherKit

struct alertView: View {

    @State var cityName = ""
    let locationProvider = LocationProvider()
    
    @State var title: String?

    
    let weatherService = WeatherService.shared
    var locationManager = LocationManager()
    @State private var weather: Weather?
    

    
    
    var body: some View {
        ScrollView{
            VStack (alignment: .leading) {
                HStack {
                    VStack (alignment: .leading) {
                        Text(cityName)
                            .foregroundColor(.gray)
                            .bold()
                            .font(Font.body)
                        Text("Alert".localised())
                            .font(Font.largeTitle.bold())
                    }
                    Spacer()
                }.padding()
            }
        }
        .onAppear {
            Task {
                getAddress()
            }
        }
    }
}

extension alertView {
    
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
    
    func getWeather() async {
        let weatherService = WeatherService()
        
        let locManager = CLLocationManager()
        var currentLocation: CLLocation!
        currentLocation = locManager.location
        
        let coordinate = CLLocation(latitude: currentLocation.coordinate.latitude
                                    ,longitude: currentLocation.coordinate.longitude)

        
        //let weather = try? await weatherService.weather(for: coordinate)
        //uvIndex=weather?.currentWeather.uvIndex

    }
}




struct alertView_Previews: PreviewProvider {
    static var previews: some View {
        alertView()
    }
}
