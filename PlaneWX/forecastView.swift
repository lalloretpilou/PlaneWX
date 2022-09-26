//
//  forecastView.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 05/08/2022.
//

import SwiftUI

struct forecastView: View {
    @StateObject var locationViewModel = LocationViewModel()

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
    }
}

struct forecastView_Previews: PreviewProvider {
    static var previews: some View {
        forecastView()
    }
}
