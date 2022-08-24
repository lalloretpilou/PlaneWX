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
            Text("")
            }
            .navigationBarTitle("Today".localised())
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        todayView()
    }
}
