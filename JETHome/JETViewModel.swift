//
//  JETViewModel.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 30/03/2025.
//
import Foundation

class JETViewModel : ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var postcode: String = ""
    //"EC4M7RF"
    @Published var isLoading: Bool = false
    @Published var restaurantsFound: Bool = false
    
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
        fetchRestaurantInfo()
    }
}


