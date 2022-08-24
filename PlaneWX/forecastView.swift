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
                Button(action: {
                    locationViewModel.requestPermission()
                }, label: {
                    Label("Allow tracking", systemImage: "location")
                })
                .padding(10)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
                Text("We need your permission to track you.".localised())
                    .foregroundColor(.gray)
                    .font(.caption)
                    .navigationBarHidden(false)
                    .navigationBarTitle("Forecast".localised(), displayMode: .large)
        }
    }
}

struct forecastView_Previews: PreviewProvider {
    static var previews: some View {
        forecastView()
    }
}
