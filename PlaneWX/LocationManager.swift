//
//  LocationManager.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 23/09/2022.
//

import Foundation
import CoreLocation
import MapKit

//class LocationManager: NSObject {
//    private let locationManager = CLLocationManager()
//    @Published var location: CLLocation? = nil
//
//    override init() {
//        super.init()
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
//    }
//}
//
//
//// MARK: - Core Location Delegate
//extension LocationManager: CLLocationManagerDelegate {
//
//
//    func locationManager(_ manager: CLLocationManager,
//                         didChangeAuthorization status: CLAuthorizationStatus) {
//
//        switch status {
//
//        case .notDetermined         : print("notDetermined")        // location permission not asked for yet
//        case .authorizedWhenInUse   : print("authorizedWhenInUse")  // location authorized
//        case .authorizedAlways      : print("authorizedAlways")     // location authorized
//        case .restricted            : print("restricted")           // TODO: handle
//        case .denied                : print("denied")               // TODO: handle
//        @unknown default:
//            fatalError()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        guard let location = locations.last else {
//            return
//        }
//        self.location = location
//    }
//}
//
//// MARK: - Get Placemark
//extension LocationManager {
//
//
//    func getPlace(for location: CLLocation,
//                  completion: @escaping (CLPlacemark?) -> Void) {
//
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(location) { placemarks, error in
//
//            guard error == nil else {
//                print("*** Error in \(#function): \(error!.localizedDescription)")
//                completion(nil)
//                return
//            }
//
//            guard let placemark = placemarks?[0] else {
//                print("*** Error in \(#function): placemark is nil")
//                completion(nil)
//                return
//            }
//
//            completion(placemark)
//        }
//    }
//}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    @Published var region: MKCoordinateRegion
    @Published var location: CLLocationCoordinate2D?
    @Published var name: String = ""

    override init() {
        let latitude = 0
        let longitude = 0
        self.region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude:
                                                                        CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)), span:
                                            MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
        super.init()
        manager.delegate = self
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
        
    }
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        update()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }
    func update() {
        let latitude = location?.latitude ?? 0
        let longitude = location?.longitude ?? 0

        self.region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude:
                                                                        CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)), span:
                                            MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in

            guard let placemark = placemarks?.first else {
                let errorString = error?.localizedDescription ?? "Unexpected Error"
                print("Unable to reverse geocode the given location. Error: \(errorString)")
                return
            }

            let reversedGeoLocation = GeoLocation(with: placemark)
            self.name = reversedGeoLocation.name
        }
    }
    func reverseUpdate() {
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(name) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                return
            }
            let coord = placemark.location?.coordinate ?? CLLocationCoordinate2D(latitude:
                                                                                    CLLocationDegrees(0), longitude: CLLocationDegrees(0))
            self.region = MKCoordinateRegion(center: coord, span:
                                                MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            self.location = CLLocationCoordinate2D(latitude: placemark.location?.coordinate.latitude ?? 0, longitude: placemark.location?.coordinate.longitude ?? 0)
            
        }

    }
    
}

struct GeoLocation {
    let name: String
    let streetName: String
    let city: String
    let state: String
    let zipCode: String
    let country: String
    init(with placemark: CLPlacemark) {
            self.name           = placemark.name ?? ""
            self.streetName     = placemark.thoroughfare ?? ""
            self.city           = placemark.locality ?? ""
            self.state          = placemark.administrativeArea ?? ""
            self.zipCode        = placemark.postalCode ?? ""
            self.country        = placemark.country ?? ""
        }

}
