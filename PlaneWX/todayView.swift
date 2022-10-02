//
//  ContentView.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 05/08/2022.
//

import SwiftUI
import WeatherKit
import CoreLocation
import MapKit
import Combine

struct todayView: View {
    
    @State var temperature: String?
    @State var feelTemperature: String?
    @State var dewPoint: String?

    @State var uvIndex: UVIndex?
    
    @State var humidity: Double?
    
    @State var symbol: String?
    @State var status: String?
    @State var condition: String?

    @State var pressure: String?
    
    @State var windGust: String?

    @State var visibility: String?
    
    @State var cloudCover: Double?

    @State var date: String?
    @State var cityName = ""
    let locationProvider = LocationProvider()

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
            VStack (alignment: .leading) {
                HStack {
                    VStack (alignment: .leading) {
                        Text(cityName)
                            .foregroundColor(.gray)
                            .bold()
                            .font(Font.body)
                        HStack(alignment: .center) {
                            Text("Today".localised())
                                .font(Font.largeTitle.bold())
                            Text(Image(systemName: symbol ?? "xmark.icloud"))
                                .font(Font.largeTitle.bold())
                        }
                        Text(date ?? " ")
                            .foregroundColor(.gray)
                            .bold()
                            .font(Font.footnote)
                    }
                    Spacer()
                }.padding()
            }
            Divider()
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                if (dewPointCheck(temperature: temperature?.doubleValue() ?? 0,
                                  dewPoint: dewPoint?.doubleValue() ?? 0,
                                  humidity: humidity ?? 0))
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
                
                if (status != nil){
                    VStack (alignment: .leading){
                        HStack{
                            Image(systemName: "text.alignleft")
                            Text("Condition".localised())
                        }
                        .foregroundColor(.gray)
                        .bold()
                        .font(Font.body)
                        Text(status ?? " ".localised())
                            .font(Font.title3.bold())
                    }
                }
                if ((feelTemperature) != nil && (temperature) != nil){
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "thermometer")
                        Text("Temperature | Felt".localised())
                    }
                    .foregroundColor(.gray)
                    .bold()
                    .font(Font.body)
                        HStack {
                            Text(temperature ?? "0")
                                .font(Font.title3.bold())
                            Text(" | ")
                            Text(feelTemperature ?? "0")
                                .font(Font.title3.bold())
                        }
                        Gauge(value: temperature?.doubleValue() ?? 0, in: minTemp...maxTemp) {
                        }
                        .gaugeStyle(.accessoryLinear)
                        .tint(gradient)
                        .frame(width: 250)
                    }
                }
                if (dewPoint?.doubleValue() != nil)
                {
                    VStack (alignment: .leading){
                        HStack{
                            Image(systemName: "aqi.medium")
                            Text("Dew Point".localised())
                        }
                        .foregroundColor(.gray)
                        .bold()
                        .font(Font.body)
                        Text(dewPoint ?? "0")
                            .font(Font.title3.bold())
                        Gauge(value: dewPoint?.doubleValue() ?? 0, in: minDewPt...maxDewPt) {
                        }
                        .gaugeStyle(.accessoryLinear)
                        .tint(gradient)
                        .frame(width: 250)
                    }
                }
                if (pressure != nil) {
                    VStack (alignment: .leading){
                        HStack{
                            Image(systemName: "square.stack.3d.forward.dottedline.fill")
                            Text("Pressure".localised())
                        }
                        .foregroundColor(.gray)
                        .bold()
                        .font(Font.body)
                        Text(pressure ?? "0")
                            .font(Font.title3.bold())
                    }
                }
                if (uvIndex?.value != nil) {
                    VStack (alignment: .leading){
                        HStack{
                            Image(systemName: "sun.min")
                            Text("UV Index".localised())
                        }
                        .foregroundColor(.gray)
                        .bold()
                        .font(Font.body)
                        Text(String(uvIndex?.value ?? 0))
                            .font(Font.title3.bold())
                        Gauge(value: Double(uvIndex?.value ?? 0), in: minUV...maxUV) {
                        }
                        .gaugeStyle(.accessoryLinear)
                        .tint(gradient)
                        .frame(width: 100)
                    }
                }
                if (windGust != nil){
                    VStack (alignment: .leading){
                        HStack{
                            Image(systemName: "wind")
                            Text("Wind Gust".localised())
                        }
                        .foregroundColor(.gray)
                        .bold()
                        .font(Font.body)
                        Text(windGust ?? " ".localised())
                            .font(Font.title3.bold())
                    }
                }
                if (visibility != nil){
                    VStack (alignment: .leading){
                        HStack{
                            Image(systemName: "eye")
                            Text("Visibility".localised())
                        }
                        .foregroundColor(.gray)
                        .bold()
                        .font(Font.body)
                        Text(visibility ?? " ".localised())
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
                        Text("\(numberFormatter.string(for: cloudCover ?? 0) ?? "0")%")
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
                        Text("\(numberFormatter.string(for: humidity ?? 0) ?? "0")%")
                            .font(Font.title3.bold())
                    }
            }
            .padding()
            .onAppear {
                Task {
                    await getWeather()
                    getAddress()
                }
            }
        }
        .refreshable {
            Task {
                await getWeather()
                getAddress()
            }
        }
    }
}

extension todayView {
    
    func getAddress() {

        let locManager = CLLocationManager()
        var currentLocation: CLLocation!
        currentLocation = locManager.location
        
        let location = CLLocation(latitude: currentLocation.coordinate.latitude,
                                   longitude: currentLocation.coordinate.longitude)
         
         locationProvider.getPlace(for: location) { plsmark in
             guard let placemark = plsmark else { return }
             if let city = placemark.locality,
                let state = placemark.administrativeArea {
                 self.cityName = "\(city), \(state)"
             } else if let city = placemark.locality, let state = placemark.administrativeArea {
                 self.cityName = "\(city) \(state)"
             } else {
                 self.cityName = "Address Unknown"
             }
         }
     }
              
    func getWeather() async {
        let weatherService = WeatherService()
        
        let locManager = CLLocationManager()
        var currentLocation: CLLocation!
        currentLocation = locManager.location
        
        let coordinate = CLLocation(latitude: currentLocation.coordinate.latitude
                                    ,longitude: currentLocation.coordinate.longitude)

        
        let weather = try? await weatherService.weather(for: coordinate)

        temperature=weather?.currentWeather.temperature
            .converted(to: .celsius)
            .formatted(.measurement(width: .narrow))
            
        
        feelTemperature=weather?.currentWeather.apparentTemperature
            .converted(to: .celsius)
            .formatted(.measurement(width: .narrow))
        
        uvIndex=weather?.currentWeather.uvIndex
        symbol=weather?.currentWeather.symbolName
        status=weather?.currentWeather.condition.description
        dewPoint=weather?.currentWeather.dewPoint
            .converted(to: .celsius)
            .formatted(.measurement(width: .narrow))
        
        pressure=weather?.currentWeather.pressure
            .converted(to: .hectopascals)
            .formatted(.measurement(width: .abbreviated))
        
        windGust=weather?.currentWeather.wind.gust?
            .converted(to: .knots)
            .formatted(.measurement(width: .abbreviated))
        
        visibility=weather?.currentWeather.visibility
            .formatted(.measurement(width: .abbreviated))
        
        cloudCover=((weather?.currentWeather.cloudCover ?? 0)*100)

        humidity=((weather?.currentWeather.humidity ?? 0)*100)

        date = weather?.currentWeather.metadata.date
            .formatted(date: .abbreviated, time: .shortened)
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
        todayView()
    }
}
