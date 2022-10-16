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
    @State private var isSheetPresented = false

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
            VStack (alignment: .leading) {
                HStack {
                    VStack (alignment: .leading) {
                        Text("Now".localised())
                            .font(Font.largeTitle.bold())
                    }
                }
            }
            .padding()
            
            Gauge(value: Double(hour.formatted(.number)) ?? 0, in: 0...24) {
                Image(systemName: "gauge.medium")
                    .font(.system(size: 50.0))
            } currentValueLabel: {
                Text(Image(systemName: weatherModel.symbol ?? "xmark.icloud"))
                
            }
            .gaugeStyle(SpeedometerGaugeStyle())
            .padding()

            VStack(alignment: .leading){
                VStack (alignment: .leading){
                    HStack{
                        HStack{
                            Image(systemName: "exclamationmark.triangle")
                            Text("Warning".localised())
                        }
                        .foregroundColor(.gray)
                        .bold()
                        .font(Font.body)
                        Spacer()

                        Button("WX alerts".localised()) {
                            isSheetPresented.toggle()
                        }
                        .sheet(isPresented: $isSheetPresented) {
                            alertView(weatherModel: weatherModel)
                                .presentationDetents([.medium, .large])
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(.blue)
                    }
                }
                .padding()
                Divider()
                
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
                        if (Calculations.rainForcast(pressure: weatherModel.pressure?.doubleValue() ?? 0, visibility: weatherModel.visibility?.doubleValue() ?? 0, cloudCoverage: weatherModel.cloudCover ?? 0))
                        {
                            messageBox(title: "Likely rain".localised(),
                                       description: "Rain is expected or in progress in your area.Visibility may be affected as well as flight performance.".localised(),
                                       icon: "cloud.rain.fill",
                                       background: Color("rain"))
                        }
            
                    }
                    .frame(height: 180)
                    
                }
                .padding()
            }
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
 
            VStack {
                configuration.currentValueLabel
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
            }
 
        }
        .frame(width: 300, height: 300)
 
    }
 
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}

struct homeView_Previews: PreviewProvider {
    static var previews: some View {
            homeView(weatherModel: WeatherModel())
        }
}
