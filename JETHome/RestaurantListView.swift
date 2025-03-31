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
                        Text("(\(restaurant.rating.count > 200 ? "200+" : "\(restaurant.rating.count)"))")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
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
                
              //  Text("[\(restaurant.address.location.coordinates.first.map{"\($0)"} ?? "0.0"), \(restaurant.address.location.coordinates.last.map{"\($0)"} ?? "0.0")]")
               
            }
        }
        .padding(.leading, 15)
        .padding(.trailing, 15)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 0)
    }
    
}
