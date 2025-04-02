//
//  RestaurantRow.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 31/03/2025.
//

import SwiftUI
import Kingfisher

struct RestaurantListView:View {
    @StateObject private var viewController = JETViewModel()
    let restaurant: Restaurant
    
    var body: some View {
        HStack(spacing: 16) {
            
            KFImage(URL(string: "\(restaurant.logoUrl)")!)
                .resizable()
                .frame(width:60, height:60)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    
                    Text(restaurant.name)
                        .font(.headline)
                        .padding(.top, 10)
                    
                    Spacer()
                    Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                        Text(formatRating(restaurant.rating.starRating))
                            .font(.system(size: 16, weight: .medium))
                        // Text("(\(restaurant.rating.count))")
                        if restaurant.rating.count > 0 {
                            Text("(\(restaurant.rating.count > 200 ? "200+" : "\(restaurant.rating.count)"))")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                    
                }
                
                Text(restaurant.cuisines.map { $0.name }.joined(separator: ", "))
                    .font(.subheadline)
                //  Text("\(formatRating(restaurant.rating.starRating)) (\(restaurant.rating.count))")
                //  Text("\(formatRating(restaurant.driveDistance))")
                //     Text(restaurant.address.location)
                Text("\(restaurant.address.firstLine), \(restaurant.address.postalCode)")
                    .font(.system(size: 14))
                    .padding(.bottom, 10)
                // Text(" \(restaurant.isCollection == true ? "Collection" : "")")
                // Text(" \(restaurant.isDelivery == true ? "Delivery" : "")")
                
                /**  if restaurant.isDelivery || restaurant.isCollection {
                 if restaurant.isDelivery { Text("Delivery")}
                 if restaurant.isCollection {
                 Text("Collection")}
                 } */
                // Text(restaurant.isDelivery)
                
                //  Text("[\(restaurant.address.location.coordinates.first.map{"\($0)"} ?? "0.0"), \(restaurant.address.location.coordinates.last.map{"\($0)"} ?? "0.0")]")
   //             Text (restaurant.deals.description)
             //   Text (restaurant.deals.offerType)
            }
        }
        .padding(.leading, 15)
        .padding(.trailing, 15)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 0)
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
