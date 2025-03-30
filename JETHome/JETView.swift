//
//  Home.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 30/03/2025.
//

import Foundation
import SwiftUI


struct JETView: View {
    
    @StateObject private var viewController = JETViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                Image(systemName: "globe")
                VStack(alignment: .leading) {
                    ForEach(viewController.restaurants.prefix(10), id: \.id){
                        restaurant in
                        VStack(alignment: .leading) {
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
            viewController.fetchRestaurantInfo()
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
}

#Preview {
    JETView()
}
