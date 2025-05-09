//
//  LocationManager.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 30/03/2025.

/**The following was code reused and adapted from the "Getting User Location with SwiftUI"  article to get the users postcode form their current location
 * Link Available at : https://medium.com/@desilio/getting-user-location-with-swiftui-1f79d23c2321 to get the users postcode from their current location */

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    // @Published var lastKnownLocation: CLLocationCoordinate2D?
    @Published var postcode: String? //Postcode
    var hasSetPostcode = false //ensuring postcode is set once
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var locationDisabledAlert = false
    @Published var isLocationShared = false
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
       // manager.delegate = self
       // manager.startUpdatingLocation()
        
        switch manager.authorizationStatus {
        case .notDetermined://The user choose allow or denny your app to get the location yet
            manager.requestWhenInUseAuthorization()
            
        case .restricted, .denied: //The user denied your app to get location or disabled the services location or the phone is in airplane mode
            print("Location denied")
            locationDisabledAlert = true
            isLocationShared = false
            
        case .authorizedWhenInUse, .authorizedAlways://This authorization allows you to use all location services and receive location events only when your app is in use
            //lastKnownLocation = manager.location?.coordinate
            // reverseGeocodeLocation (coordinate: lastKnownLocation)
            if let location = manager.location?.coordinate, !hasSetPostcode {
             //   reverseGeocodeLocation(coordinate: location)
                userLocation = location
            }
            isLocationShared = true
            
        @unknown default:
            print("Location service disabled")
            isLocationShared = false
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {//Trigged every time authorization status changes
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // lastKnownLocation = locations.first?.coordinate
        if let location = manager.location?.coordinate, !hasSetPostcode {
         //   reverseGeocodeLocation(coordinate: location)
            userLocation = location
        }
    }
    
    // Gets the user's postcode by reversing geocode
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
                    if !self!.hasSetPostcode {
                        self?.postcode = postcode
                    }
                }
            }
        }
    }
    
    // Adapted to implemenet an alert and checking it is not denied
    func checkIfLocationIsEnabled() {
        print ("Checking if enabled")
        // As long as it is not denied, it will show the users current location
        if CLLocationManager.locationServicesEnabled() && manager.authorizationStatus != .denied {
            locationsManager = CLLocationManager()
            locationsManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationsManager!.delegate = self
        } else {
            locationDisabledAlert = true
        }
    }
}
