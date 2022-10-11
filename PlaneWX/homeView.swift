//
//  homeView.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 03/10/2022.
//

import SwiftUI
import WeatherKit

struct homeView: View {
    @ObservedObject var weatherModel: WeatherModel
    @State private var hour = Calendar.current.component(.hour, from: Date())
    
    @State private var weather: Weather?
    var hourlyWeatherData: [HourWeather] {
        if let weather {
            return Array(weather.hourlyForecast.filter { hourlyWeather in
                return hourlyWeather.date.timeIntervalSince(Date()) >= 0
            })
        } else {
            return []
        }
    }
    
    var body: some View {
        VStack
        {
            Gauge(value: Double(hour.formatted(.number)) ?? 0, in: 0...24) {
                Image(systemName: "gauge.medium")
                    .font(.system(size: 50.0))
            } currentValueLabel: {
                Text(Image(systemName: weatherModel.symbol ?? "xmark.icloud"))
                
            }
            .gaugeStyle(SpeedometerGaugeStyle())
            .padding()

            HStack{
                Label {
                    Text(weatherModel.temperature ?? "0")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.gray)
                } icon: {
                    Image(systemName: "thermometer")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.gray)
                }
            }
            .padding()

            ScrollView(.horizontal, showsIndicators: false)
            {
                HStack{
                    
                    if (Calculations.dewPointCheck(temperature: weatherModel.temperature?.doubleValue() ?? 0,
                                       dewPoint: weatherModel.dewPoint?.doubleValue() ?? 0,
                                       humidity: weatherModel.humidity ?? 0,
                                       pressure: weatherModel.pressure?.doubleValue() ?? 0))
                    {
                        messageBox(title: "Drizzle/fog highly likely".localised(),
                                   description: "There is a high probability that fog will form. Be careful, icing may be present.".localised(),
                                   icon: "cloud.fog.fill",
                                   background: .red.opacity(0.9))
                    }

                    if (Calculations.coldTemperature(temperature: weatherModel.temperature?.doubleValue() ?? 0))
                    {
                        messageBox(title: "Cold temperature".localised(),
                                   description: "The temperature is cold in your area. Check out for engine and fuselage icing.".localised(),
                                   icon: "thermometer",
                                   background: .blue.opacity(0.9))
                    }
                        
                }
                .frame(height: 180)
            }
            .padding()
        }
    }
}

struct SpeedometerGaugeStyle: GaugeStyle {
    private var blueGradient = LinearGradient(gradient: Gradient(colors: [Color("AppGradientStart"),Color("AppGradientEnd")]), startPoint: .trailing, endPoint: .leading)

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
 
            Circle()
                .foregroundColor(Color(.systemGray6))
 
            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(blueGradient, lineWidth: 20)
                .rotationEffect(.degrees(135))
 
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(Color.black, style: StrokeStyle(lineWidth: 10, lineCap: .butt, lineJoin: .round, dash: [1, 34], dashPhase: 0.0))
                .rotationEffect(.degrees(135))
 
            VStack {
                configuration.currentValueLabel
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
            }
 
        }
        .frame(width: 300, height: 300)
 
    }
 
}

struct homeView_Previews: PreviewProvider {
    static var previews: some View {
        homeView(weatherModel: WeatherModel())
    }
}
