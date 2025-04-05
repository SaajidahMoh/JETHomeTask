//
//  LocationManager.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 30/03/2025.
// https://medium.com/@desilio/getting-user-location-with-swiftui-1f79d23c2321

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
   // @Published var lastKnownLocation: CLLocationCoordinate2D?
    @Published var postcode: String? //Postcode
    var hasSetPostcode = false //ensuring postcode is set once
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var locationDisabledAlert = false
    var locationsManager: CLLocationManager?
    
    var manager = CLLocationManager()
    private var geocoder = CLGeocoder() //Geocoder
    
    override init() {
                super.init()
                manager.delegate = self
                manager.startUpdatingLocation()
                checkLocationAuthorization()
            }
    
    func checkLocationAuthorization() {
        
        manager.delegate = self
        manager.startUpdatingLocation()
        
        switch manager.authorizationStatus {
        case .notDetermined://The user choose allow or denny your app to get the location yet
            manager.requestWhenInUseAuthorization()
            
        case .restricted://The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.
            print("Location restricted")
            
        case .denied://The user dennied your app to get location or disabled the services location or the phone is in airplane mode
            print("Location denied")
            locationDisabledAlert = true
            
     //   case .authorizedAlways://This authorization allows you to use all location services and receive location events whether or not your app is in use.
                //            print("Location authorizedAlways")
            
        case .authorizedWhenInUse, .authorizedAlways://This authorization allows you to use all location services and receive location events only when your app is in use
           // print("Location authorized when in use")
            //lastKnownLocation = manager.location?.coordinate
           // reverseGeocodeLocation (coordinate: lastKnownLocation)
            if let location = manager.location?.coordinate, !hasSetPostcode {
                                       reverseGeocodeLocation(coordinate: location)
                userLocation = location
                                   }
            
        @unknown default:
            print("Location service disabled")
        
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {//Trigged every time authorization status changes
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // lastKnownLocation = locations.first?.coordinate
        if let location = manager.location?.coordinate, !hasSetPostcode {
                                   reverseGeocodeLocation(coordinate: location)
            userLocation = location
                               }
    }
    
    // get postcode by reversing geocode
    func reverseGeocodeLocation(coordinate: CLLocationCoordinate2D?){
        guard let coordinate = coordinate else { return}
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier:"en_GB")) { [weak self] placemarks, error in
                    if let error = error {
                        print("Error during reverse geocoding: \(error.localizedDescription)")
                        return
                    }
                    
                    if let placemark = placemarks?.first, let postcode = placemark.postalCode {
                        DispatchQueue.main.async {
                            self?.postcode = postcode
                        }
                    }
                }
    }
    
    // adapted to implemenet an alert and checking its not denied
    func checkIfLocationIsEnabled() {
        print ("Checking if enabled")
        // as long as it is not denied, it will show the users current location
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != .denied {
            locationsManager = CLLocationManager()
            locationsManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationsManager!.delegate = self
        } else {
            locationDisabledAlert = true
        }
    }
}
