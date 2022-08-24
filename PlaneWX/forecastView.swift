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
        NavigationView {
            ScrollView {
                Section{
                    Text("")
                }
            }
            .navigationBarTitle("Forecast".localised())
        }
    }
}

struct forecastView_Previews: PreviewProvider {
    static var previews: some View {
        forecastView()
    }
}
