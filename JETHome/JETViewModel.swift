//
//  JETViewModel.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 30/03/2025.
//
import Foundation

class JETViewModel : ObservableObject {
    @Published var restaurants: [Restaurant] = []
    
    func fetchRestaurantInfo(){
        let APIInteraction = justEatAPIInteraction()
        APIInteraction.getRestaurantInfo{ restaurants in
            DispatchQueue.main.async {
                self.restaurants = restaurants
            
            }
        }
    }
}


