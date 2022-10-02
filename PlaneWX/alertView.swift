//
//  alertView.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 05/08/2022.
//

import SwiftUI
import CoreLocation
import Combine

struct alertView: View {
    @ObservedObject var weatherModel: WeatherModel
    
    @State var title: String?
    
    var locationManager = LocationManager()
    
    var body: some View {
        ScrollView{
            VStack (alignment: .leading) {
                HStack {
                    VStack (alignment: .leading) {
                        Text(weatherModel.cityName)
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
    }
}

struct alertView_Previews: PreviewProvider {
    static var previews: some View {
        alertView(weatherModel: WeatherModel())
    }
}
