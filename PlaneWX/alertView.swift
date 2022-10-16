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
        VStack (alignment: .leading) {
            HStack {
                VStack (alignment: .leading) {
                    Text("Alert".localised())
                        .font(Font.largeTitle.bold())
                        .foregroundColor(.black)
                    
                    if(weatherModel.alerts.isEmpty) {
                        Text("There are no alerts in your area.".localised())
                            .foregroundColor(.gray)
                            .bold()
                            .font(Font.body)
                    } else {
                        List {
                            ForEach(weatherModel.alerts) { alert in
                                Text("Add view to display alert here")
                            }
                        }
                        .listStyle(.plain)
                    }
                }
                Spacer()
            }.padding()
        }
        .onAppear{
            hapticWarning()
        }
    }
}

struct alertView_Previews: PreviewProvider {
    static var previews: some View {
        alertView(weatherModel: WeatherModel())
    }
}
