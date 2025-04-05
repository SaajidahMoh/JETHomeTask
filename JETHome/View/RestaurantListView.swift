//
//  RestaurantListView.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 31/03/2025.
//

import SwiftUI
import Kingfisher

// View to display the list of restaurants and styling
struct RestaurantListView:View {
    @StateObject private var viewModel = JETViewModel()
    let restaurant: Restaurant
    
    var body: some View {
        
        // Filter the cuisines to exlude the 'not cuisines'
        let filteredCuisines = restaurant.cuisines.filter { cuisine in
            !["low-delivery-fee", "deals", "stampcard-restaurants", "halal", "freebies", "8off"].contains(cuisine.uniqueName) }
        
        // Filter to only include the extra
        let filteredExtras =  restaurant.cuisines.filter { cuisine in
            ["low-delivery-fee", "deals", "stampcard-restaurants", "halal", "freebies", "8off"].contains(cuisine.uniqueName) }
        
        HStack(spacing: 16) {
            NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)){
                
                // KingFisher to display the restaurant's logo
                KFImage(URL(string: "\(restaurant.logoUrl)")!)
                    .resizable()
                    .frame(width:60, height:60)
                    .cornerRadius(8)
                
                VStack(alignment: .leading) {
                    HStack {
                        
                        // Displays Restaurant name
                        Text(restaurant.name)
                            .font(.headline)
                            .padding(.leading, 0)
                            .padding(.top, 10)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        Spacer()
                        HStack(spacing: 2) {
                            
                            // Displays the star rating
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 12))
                            Text(formatRating(restaurant.rating.starRating))
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            
                            // Only displays the rating if there is one, if the number of ratings is above 200 then it will display as 200+ for simplicity
                            if restaurant.rating.count > 0 {
                                Text("(\(restaurant.rating.count > 200 ? "200+" : "\(restaurant.rating.count)"))")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    // Displays the filtered cuisines
                    if !filteredCuisines.isEmpty {
                        // Text(restaurant.cuisines.map { $0.name }.joined(separator: ", "))
                        Text(restaurant.cuisines.filter { cuisine in
                            !["low-delivery-fee", "deals", "stampcard-restaurants", "halal", "freebies", "8off"].contains(cuisine.uniqueName)}.map{ $0.name }.joined(separator: ", "))
                        .font(.system(size: 13))
                        .foregroundColor(.orange)
                        .padding(.leading, 0)
                        .multilineTextAlignment(.leading)
                    }
                    
                    // Displays the additional extras
                    if !filteredExtras.isEmpty {
                        Text(restaurant.cuisines.filter { cuisine in
                            ["low-delivery-fee", "deals", "stampcard-restaurants", "halal", "freebies", "8off"].contains(cuisine.uniqueName)}.map{ $0.name }.joined(separator: ", "))
                        .font(.system(size: 12))
                        .foregroundColor(.primary)
                        .padding(.leading, 1)
                        .multilineTextAlignment(.leading)
                    }
                    
                    // Displays the address and postcode together
                    Text("\(restaurant.address.firstLine), \(restaurant.address.postalCode)")
                        .font(.system(size: 12))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        HStack {
                            if (restaurant.isDelivery && restaurant.isOpenNowForDelivery) || (restaurant.isCollection && restaurant.isOpenNowForCollection)
                            {
                                Text("Open")
                                    .font(.system(size: 12))
                                    .foregroundColor(.green)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(4)
                            } else {
                                Text("Closed")
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(4)
                            }
                            
                            // Displays the estimated delivery time range given that it is not empty
                            if (restaurant.deliveryCost >= 0) {
                                HStack(spacing: 0) {
                                    Image(systemName: "bicycle")
                                    Text("\(restaurant.deliveryEtaMinutes?.rangeLower ?? 0)-\(restaurant.deliveryEtaMinutes?.rangeUpper ?? 0) mins")
                                }
                                .font(.system(size: 10))
                                .foregroundColor(.orange)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(4)
                            }
                            
                            // Displays the distance in miles
                            if (restaurant.driveDistanceMeters > 0 ) {
                                HStack(spacing: 0) {
                                    Image(systemName: "mappin.and.ellipse")
                                    Text("\(metersToMiles(Double(restaurant.driveDistanceMeters))) miles")
                                }
                                .font(.system(size: 10))
                                .foregroundColor(.orange)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(4)
                            }
                        }
                    }
                }
            }  .padding(.bottom, 10)
        }
        .padding(.leading, 15)
        .padding(.trailing, 15)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 0)
    }
    
    // Function that converts the given ratings to a string with two decimal places
    func formatRating( _ rating: Float) -> String {
        if rating == 0 {
            return "0"
        } else {
            let ratingValue = String(format: "%.2f", rating)
            return ratingValue.trimmingCharacters(in: CharacterSet(charactersIn: "0").union(.punctuationCharacters))
        }
    }
    
    // Function that converts the given meters into miles and formating the result to two decimal places
    func metersToMiles( _ meters: Double) -> String {
        let miles = meters * 0.000621371
        let milesValue = String(format: "%.2f", miles)
        return milesValue
    }
    
}
