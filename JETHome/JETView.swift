//
//  Home.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 30/03/2025.
//

import Foundation
import SwiftUI
import Kingfisher


struct JETView: View {
    
    @StateObject private var viewController = JETViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var showLocationAlert = false
    
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter postcode", text: $viewController.postcode)
                
                Button(action: {
                                        showLocationAlert = true
                                    }) {
                                        Image(systemName: "location")
                                            .font(.title)
                                            .padding(.trailing)
                                    }
                                    .alert(isPresented: $showLocationAlert) {
                                        Alert(
                                            title: Text("Share Your Location"),
                                            message: Text("Would you like to share your location to find nearby restaurants?"),
                                            primaryButton: .default(Text("Yes")) {
                                                if let postcode = locationManager.postcode {
                                                    viewController.updatePostcode(postcode)
                                                }
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
            }
          
            Button(action: {
                viewController.fetchRestaurantInfo()
            }) {
                Text("Get Restaurants")
            }
            
            ScrollView {
               // Image(systemName: "globe")
                
                VStack(alignment: .leading) {
                    
                    ForEach(viewController.restaurants.prefix(10), id: \.id){
                        restaurant in
                        VStack(alignment: .leading) {
                            KFImage(URL(string: "\(restaurant.logoUrl)")!)
                            Text(restaurant.name)
                                .font(.title)
                            
                            Text(restaurant.cuisines.map { $0.name }.joined(separator: ", "))
                            Text("\(formatRating(restaurant.rating.starRating)) (\(restaurant.rating.count))")
        
                        }
                        
                    }
                }
                .padding()
            }
        }
        
        .onAppear {
            if let postcode = locationManager.postcode {
                          viewController.updatePostcode(postcode)
                      }
            //viewController.fetchRestaurantInfo()
        }
    }
}

func formatRating( _ rating: Float) -> String {
    if rating == 0 {
        return "0"
    } else {
        let ratingValue = String(format: "%.2f", rating)
        return ratingValue.trimmingCharacters(in: CharacterSet(charactersIn: "0").union(.punctuationCharacters))
    }
}

#Preview {
    JETView()
}
