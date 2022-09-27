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
    @State var uvIndex: UVIndex?
    @State var symbol: String?
    @State var status: String?
    @State var dewPoint: String?
    @State var pressure: String?
    @State var windGust: String?

    @State var currentAddress = ""
    let locationProvider = LocationProvider()

    private let minTemp = -15.0
    private let maxTemp = 55.0
    
    private let minDewPt = 0.0
    private let maxDewPt = 50.0
    
    private let minUV = 0.0
    private let maxUV = 16.0
    
    var locationManager = LocationManager()

    let gradient = Gradient(colors: [.blue, .green, .pink])

    var body: some View
    {
        ScrollView {
            VStack (alignment: .leading) {
                HStack {
                    VStack (alignment: .leading) {
                        Text(currentAddress)
                            .foregroundColor(.gray)
                            .bold()
                            .font(Font.body)
                        HStack(alignment: .center) {
                            Text("Today".localised())
                                .font(Font.largeTitle.bold())
                            Text(Image(systemName: symbol ?? "exclamationmark.icloud"))
                                .font(Font.largeTitle.bold())
                        }
                    }
                    Spacer()
                }.padding()
            }
            Divider()
            VStack(alignment: .leading, spacing: 30) {
                
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "text.alignleft")
                        Text("Condition".localised())
                    }
                    .foregroundColor(.gray)
                    .bold()
                    .font(Font.body)
                    Text(status ?? "Loading weather information".localised())
                        .font(Font.title3.bold())
                }

                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "thermometer")
                        Text("Temperature".localised())
                    }
                    .foregroundColor(.gray)
                    .bold()
                    .font(Font.body)
                    Text(temperature ?? "Loading weather information".localised())
                        .font(Font.title3.bold())
                    Gauge(value: 17, in: minTemp...maxTemp) {
                    }
                    .gaugeStyle(.accessoryLinear)
                    .tint(gradient)
                    .frame(width: 300)
                }
                
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "aqi.medium")
                        Text("Dew Point".localised())
                    }
                    .foregroundColor(.gray)
                    .bold()
                    .font(Font.body)
                    Text(dewPoint ?? "Loading weather information".localised())
                      .font(Font.title3.bold())
                    Gauge(value: 10, in: minDewPt...maxDewPt) {
                    }
                    .gaugeStyle(.accessoryLinear)
                    .tint(gradient)
                    .frame(width: 300)
                }
                
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "square.stack.3d.forward.dottedline.fill")
                        Text("Pressure".localised())
                    }
                    .foregroundColor(.gray)
                    .bold()
                    .font(Font.body)
                    Text(pressure ?? "Loading weather information".localised())
                      .font(Font.title3.bold())
                }

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
                    .frame(width: 300)

                }
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "wind")
                        Text("Wind Gust".localised())
                    }
                    .foregroundColor(.gray)
                    .bold()
                    .font(Font.body)
                    Text(windGust ?? "Loading weather information".localised())
                      .font(Font.title3.bold())
                }
            }
            .padding()
            .onAppear {
                Task {
                    await getWeather()
                    hapticSucess()
                    getAddress()
                }
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
                 self.currentAddress = "\(city), \(state)"
             } else if let city = placemark.locality, let state = placemark.administrativeArea {
                 self.currentAddress = "\(city) \(state)"
             } else {
                 self.currentAddress = "Address Unknown"
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
            .formatted(.measurement(usage: .asProvided))
        
        uvIndex=weather?.currentWeather.uvIndex
        symbol=weather?.currentWeather.symbolName
        status=weather?.currentWeather.condition.rawValue
        dewPoint=weather?.currentWeather.dewPoint
            .converted(to: .celsius)
            .formatted(.measurement(usage: .asProvided))
        pressure=weather?.currentWeather.pressure
            .converted(to: .hectopascals)
            .formatted(.measurement(width: .abbreviated))
        windGust=weather?.currentWeather.wind.gust?
            .converted(to: .knots)
            .formatted(.measurement(width: .abbreviated))
    }
}

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

func dewPoint(temperature: String?, dewPoint: String?) -> Bool
{
    
    return false
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        todayView()
    }
}






/**
 A Combine-based CoreLocation provider.
 
 On every update of the device location from a wrapped `CLLocationManager`,
 it provides the latest location as a published `CLLocation` object and
 via a `PassthroughSubject<CLLocation, Never>` called `locationWillChange`.
 */
public class LocationProvider: NSObject, ObservableObject {
    
    private let lm = CLLocationManager()
    
    /// Is emitted when the `location` property changes.
    public let locationWillChange = PassthroughSubject<CLLocation, Never>()
    
    /**
     The latest location provided by the `CLLocationManager`.
     
     Updates of its value trigger both the `objectWillChange` and the `locationWillChange` PassthroughSubjects.
     */
    @Published public private(set) var location: CLLocation? {
        willSet {
            locationWillChange.send(newValue ?? CLLocation())
        }
    }
    
    /// The authorization status for CoreLocation.
    @Published public var authorizationStatus: CLAuthorizationStatus?
    
    /// A function that is executed when the `CLAuthorizationStatus` changes to `Denied`.
    public var onAuthorizationStatusDenied : ()->Void = {presentLocationSettingsAlert()}
    
    /// The LocationProvider intializer.
    ///
    /// Creates a CLLocationManager delegate and sets the CLLocationManager properties.
    public override init() {
        super.init()
        self.lm.delegate = self
        self.lm.desiredAccuracy = kCLLocationAccuracyBest
        self.lm.activityType = .fitness
        self.lm.distanceFilter = 10
        self.lm.allowsBackgroundLocationUpdates = true
        self.lm.pausesLocationUpdatesAutomatically = false
        self.lm.showsBackgroundLocationIndicator = true
    }
    
    /**
     Request location access from user.
     
     In case, the access has already been denied, execute the `onAuthorizationDenied` closure.
     The default behavior is to present an alert that suggests going to the settings page.
     */
    public func requestAuthorization() -> Void {
        if self.authorizationStatus == CLAuthorizationStatus.denied {
            onAuthorizationStatusDenied()
        }
        else {
            self.lm.requestWhenInUseAuthorization()
        }
    }
    
    /// Start the Location Provider.
    public func start() throws -> Void {
        self.requestAuthorization()
        
        if let status = self.authorizationStatus {
            guard status == .authorizedWhenInUse || status == .authorizedAlways else {
                throw LocationProviderError.noAuthorization
            }
        }
        else {
            /// no authorization set by delegate yet
#if DEBUG
            print(#function, "No location authorization status set by delegate yet. Try to start updates anyhow.")
#endif
            /// In principle, this should throw an error.
            /// However, this would prevent start() from running directly after the LocationProvider is initialized.
            /// This is because the delegate method `didChangeAuthorization`,
            /// setting `authorizationStatus` runs only after a brief delay after initialization.
            //throw LocationProviderError.noAuthorization
        }
        self.lm.startUpdatingLocation()
    }
    
    /// Stop the Location Provider.
    public func stop() -> Void {
        self.lm.stopUpdatingLocation()
    }
    
    // todo deal with errors
    public func getPlace(for location: CLLocation, completion: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("=====> Error \(error!.localizedDescription)")
                completion(nil)
                return
            }
            guard let placemark = placemarks?.first else {
                print("=====> Error placemark is nil")
                completion(nil)
                return
            }
            completion(placemark)
        }
    }
    
}

/// Present an alert that suggests to go to the app settings screen.
public func presentLocationSettingsAlert(alertText : String? = nil) -> Void {
    let alertController = UIAlertController (title: "Enable Location Access", message: alertText ?? "The location access for this app is set to 'never'. Enable location access in the application settings. Go to Settings now?", preferredStyle: .alert)
    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
        guard let settingsUrl = URL(string:UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsUrl)
    }
    alertController.addAction(settingsAction)
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    alertController.addAction(cancelAction)
    UIApplication.shared.windows[0].rootViewController?.present(alertController, animated: true, completion: nil)
}


/// Error which is thrown for lacking localization authorization.
public enum LocationProviderError: Error {
    case noAuthorization
}

extension LocationProvider: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
#if DEBUG
        print(#function, status.name)
#endif
        //print()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clErr = error as? CLError {
            switch clErr {
            case CLError.denied : do {
                print(#function, "Location access denied by user.")
                self.stop()
                self.requestAuthorization()
            }
            case CLError.locationUnknown : print(#function, "Location manager is unable to retrieve a location.")
            default: print(#function, "Location manager failed with unknown CoreLocation error.")
            }
        }
        else {
            print(#function, "Location manager failed with unknown error", error.localizedDescription)
        }
    }
}

extension CLAuthorizationStatus {
    /// String representation of the CLAuthorizationStatus
    var name: String {
        switch self {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
}
