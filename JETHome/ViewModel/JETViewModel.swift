//
//  JETViewModel.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 30/03/2025.
//
import Foundation

class JETViewModel : ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var postcode: String = "" // "EC4M7RF"
    @Published var isLoading: Bool = false
    @Published var restaurantsFound: Bool = false
    
    private var locationManager = LocationManager()
    private var apiService = justEatAPIInteraction()
    
    // Performs the interaction with the API to get the restaurants information
    func fetchRestaurantInfo(){
        guard !postcode.isEmpty else {
            print ("Enter postcode")
            return
        }
        isLoading = true
        
        let APIInteraction = justEatAPIInteraction()
        APIInteraction.getRestaurantInfo(postcode:postcode){ restaurants in
            DispatchQueue.main.async {
                self.restaurants = restaurants
                //  self.isLoading = false
                self.restaurantsFound = !self.restaurants.isEmpty
            }
        }
    }
    
    func updatePostcode(_ postcode : String) {
        self.postcode = postcode
        locationManager.hasSetPostcode = true
        fetchRestaurantInfo()
    }
}


