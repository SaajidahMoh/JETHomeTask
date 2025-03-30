//
//  JETViewModel.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 30/03/2025.
//
import Foundation

class JETViewModel : ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var postcode: String = "E10 6EQ"
        //"EC4M7RF"
    
    func fetchRestaurantInfo(){
        let APIInteraction = justEatAPIInteraction()
        APIInteraction.getRestaurantInfo(postcode:postcode){ restaurants in
            DispatchQueue.main.async {
                self.restaurants = restaurants
            
            }
        }
    }
}


