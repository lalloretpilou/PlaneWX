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
                        Text("Alert".localised())
                            .font(Font.largeTitle.bold())
                            .foregroundColor(.black)
                        if(weatherModel.alertNb?.count == 0)
                        {
                            Text("There are no alerts in your area.".localised())
                                .foregroundColor(.gray)
                                .bold()
                                .font(Font.body)
                        }
                    }
                    Spacer()
                }.padding()
            }
        }.onAppear{
            hapticWarning()
        }
    }
}

struct alertView_Previews: PreviewProvider {
    static var previews: some View {
        alertView(weatherModel: WeatherModel())
    }
}
