//
//  forecastView.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 05/08/2022.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct forecastView: View {
    
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
                        Text("Forecast".localised())
                            .font(Font.largeTitle.bold())
                    }
                    Spacer()
                }.padding()
            }
        }
        Divider()
    }
}

struct forecastView_Previews: PreviewProvider {
    static var previews: some View {
        forecastView()
    }
}
