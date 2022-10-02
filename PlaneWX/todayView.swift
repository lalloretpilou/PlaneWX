//
//  ContentView.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 05/08/2022.
//

import SwiftUI
import CoreLocation
import MapKit
import Combine

struct todayView: View {
    @ObservedObject var weatherModel: WeatherModel
    
    private let minTemp = -15.0
    private let maxTemp = 55.0
    
    private let minDewPt = 0.0
    private let maxDewPt = 50.0
    
    private let minUV = 0.0
    private let maxUV = 16.0
    
    var locationManager = LocationManager()
    
    let gradient = Gradient(colors: [.blue, .green, .pink])
    
    let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = .down
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter
    }()
    
    var body: some View
    {
        ScrollView {
            VStack (alignment: .leading) {
                HStack {
                    VStack (alignment: .leading) {
                        Text(weatherModel.cityName)
                            .foregroundColor(.gray)
                            .bold()
                            .font(Font.body)
                        HStack(alignment: .center) {
                            Text("Today".localised())
                                .font(Font.largeTitle.bold())
                            Text(Image(systemName: weatherModel.symbol ?? "xmark.icloud"))
                                .font(Font.largeTitle.bold())
                        }
                        Text(weatherModel.date ?? " ")
                            .foregroundColor(.gray)
                            .bold()
                            .font(Font.footnote)
                    }
                    Spacer()
                }.padding()
            }
            Divider()
            VStack(alignment: .leading, spacing: 30) {
                if (dewPointCheck(temperature: weatherModel.temperature?.doubleValue() ?? 0,
                                  dewPoint: weatherModel.dewPoint?.doubleValue() ?? 0,
                                  humidity: weatherModel.humidity ?? 0))
                {
                    VStack (alignment: .leading){
                        HStack{
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text("Drizzle/fog highly likely".localised())
                        }
                        .foregroundColor(.white)
                        .bold()
                        .font(Font.body)
                        Divider()
                            .foregroundColor(.white)
                        Spacer()
                        Text("There is a high probability that fog will form. Be careful, icing may be present.".localised())
                            .font(Font.body.italic())
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(width: 300)
                    .background(.red.opacity(0.9))
                    .cornerRadius(15)
                }
                
                if let status = weatherModel.status {
                    VStack (alignment: .leading){
                        HStack{
                            Image(systemName: "text.alignleft")
                            Text("Condition".localised())
                        }
                        .foregroundColor(.gray)
                        .bold()
                        .font(Font.body)
                        Text(status)
                            .font(Font.title3.bold())
                    }
                }
                
                if let temperature = weatherModel.temperature,
                   let feelTemperature = weatherModel.feelTemperature {
                    VStack (alignment: .leading){
                        HStack{
                            Image(systemName: "thermometer")
                            Text("Temperature | Felt".localised())
                        }
                        .foregroundColor(.gray)
                        .bold()
                        .font(Font.body)
                        HStack {
                            Text(temperature)
                                .font(Font.title3.bold())
                            Text(" | ")
                            Text(feelTemperature)
                                .font(Font.title3.bold())
                        }
                        Gauge(value: temperature.doubleValue() ?? minTemp, in: minTemp...maxTemp) {
                        }
                        .gaugeStyle(.accessoryLinear)
                        .tint(gradient)
                        .frame(width: 250)
                    }
                }
                
                if let dewPoint = weatherModel.dewPoint {
                    VStack (alignment: .leading){
                        HStack{
                            Image(systemName: "aqi.medium")
                            Text("Dew Point".localised())
                        }
                        .foregroundColor(.gray)
                        .bold()
                        .font(Font.body)
                        Text(dewPoint)
                            .font(Font.title3.bold())
                        Gauge(value: dewPoint.doubleValue() ?? 0, in: minDewPt...maxDewPt) {
                        }
                        .gaugeStyle(.accessoryLinear)
                        .tint(gradient)
                        .frame(width: 250)
                    }
                }
                
                if let pressure = weatherModel.pressure {
                    VStack (alignment: .leading){
                        HStack{
                            Image(systemName: "square.stack.3d.forward.dottedline.fill")
                            Text("Pressure".localised())
                        }
                        .foregroundColor(.gray)
                        .bold()
                        .font(Font.body)
                        Text(pressure)
                            .font(Font.title3.bold())
                    }
                }
                
                if let uvIndex = weatherModel.uvIndex {
                    VStack (alignment: .leading){
                        HStack{
                            Image(systemName: "sun.min")
                            Text("UV Index".localised())
                        }
                        .foregroundColor(.gray)
                        .bold()
                        .font(Font.body)
                        Text(String(uvIndex.value))
                            .font(Font.title3.bold())
                        Gauge(value: Double(uvIndex.value), in: minUV...maxUV) {
                        }
                        .gaugeStyle(.accessoryLinear)
                        .tint(gradient)
                        .frame(width: 100)
                    }
                }
                
                if let windGust = weatherModel.windGust {
                    VStack (alignment: .leading){
                        HStack{
                            Image(systemName: "wind")
                            Text("Wind Gust".localised())
                        }
                        .foregroundColor(.gray)
                        .bold()
                        .font(Font.body)
                        Text(windGust)
                            .font(Font.title3.bold())
                    }
                }
                
                if let visibility = weatherModel.visibility {
                    VStack (alignment: .leading){
                        HStack{
                            Image(systemName: "eye")
                            Text("Visibility".localised())
                        }
                        .foregroundColor(.gray)
                        .bold()
                        .font(Font.body)
                        Text(visibility)
                            .font(Font.title3.bold())
                    }
                }
                
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "cloud")
                        Text("Cloud Cover".localised())
                    }
                    .foregroundColor(.gray)
                    .bold()
                    .font(Font.body)
                    Text("\(numberFormatter.string(for: weatherModel.cloudCover ?? 0) ?? "0")%")
                        .font(Font.title3.bold())
                }
                
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "humidity")
                        Text("Humidity".localised())
                    }
                    .foregroundColor(.gray)
                    .bold()
                    .font(Font.body)
                    Text("\(numberFormatter.string(for: weatherModel.humidity ?? 0) ?? "0")%")
                        .font(Font.title3.bold())
                }
            }
            .padding()
        }
        .refreshable {
            Task {
                weatherModel.refresh()
            }
        }
    }
}


func dewPointCheck(temperature: Double, dewPoint: Double, humidity: Double) -> Bool
{
    let hour = Calendar.current.component(.hour, from: Date())
    
    if ((temperature - dewPoint < 5)
        && humidity > 85
        && temperature <= 8 &&
        hour >= 0 && hour < 10)
    {
        hapticWarning()
        return true
    }
    
    return false
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        todayView(weatherModel: WeatherModel())
    }
}
