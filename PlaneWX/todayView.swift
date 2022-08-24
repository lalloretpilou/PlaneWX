//
//  ContentView.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 05/08/2022.
//

import SwiftUI

struct todayView: View {
    @StateObject var locationViewModel = LocationViewModel()

    var body: some View {
        NavigationView {
            Section{
            Text("SwiftUI tutorials")
            }
            .navigationBarTitle("Master view")
            .navigationBarItems(leading:
                    Button(action: {
                        print("SF Symbol button pressed...")
                    }) {
                        Image(systemName: "calendar.circle").imageScale(.large)
                    },
                trailing:
                    Button(action: {
                        print("Edit button pressed...")
                    }) {
                        Text("Edit")
                    }
            )
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        todayView()
    }
}
