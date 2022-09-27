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

struct forecastView: View {
    
    @State var cityName = ""
    let locationProvider = LocationProvider()
    

    var locationManager = LocationManager()
    
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
        }
        .onAppear {
            Task {
                hapticSucess()
                getAddress()
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

struct forecastView_Previews: PreviewProvider {
    static var previews: some View {
        forecastView()
    }
}
