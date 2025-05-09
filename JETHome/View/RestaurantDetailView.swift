//
//  RestaurantDetailView.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 05/04/2025.
//

import SwiftUI
import MapKit

// The View that displays more information about the selected restaurant including a Map with the location
struct RestaurantDetailView: View {
    let restaurant: Restaurant
    @State private var region: MKCoordinateRegion
    
    // Init initalisation that sets the restaurant and map
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        
        let latitude = Double(restaurant.address.location.coordinates.last ?? 0.0)
        let longitude = Double(restaurant.address.location.coordinates.first ?? 0.0)
        
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.0035, longitudeDelta: 0.0035))
    }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    
                    // Displays the restaurant name and rating
                    HStack {
                        Text(restaurant.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text((formatRating(restaurant.rating.starRating) > "0" ? (formatRating(restaurant.rating.starRating)) : "0"))
                                .fontWeight(.semibold)
                        }
                        
                        .padding(6)
                        .background(Color.gray.opacity(0.01))
                        .cornerRadius(6)
                    }
                    
                    // Horizontal scrollview that displays the different cuisines
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(restaurant.cuisines.filter { cuisine in
                                !["low-delivery-fee", "deals", "stampcard-restaurants", "halal", "freebies", "8off"].contains(cuisine.uniqueName)
                            }, id: \.self.uniqueName) { cuisine in
                                Text(cuisine.name)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.green.opacity(0.5))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    
                    // Horizontal scrollview that displays the extras
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(restaurant.cuisines.filter { cuisine in
                                ["low-delivery-fee", "deals", "stampcard-restaurants", "halal", "freebies", "8off"].contains(cuisine.uniqueName)
                            }, id: \.self.uniqueName) { cuisine in
                                Text(cuisine.name)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.orange.opacity(0.5))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    
                    // Displays the restaurants address and postcode together
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.orange)
                        Text("\(restaurant.address.firstLine), \(restaurant.address.city), \(restaurant.address.postalCode)")
                            .font(.subheadline)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("MAP:")
                            .font(.headline)
                            .padding(.top, 8)
                        // Displays the map with the restaurants location and the current users location
                        Map(coordinateRegion: .constant(region), showsUserLocation: true, annotationItems: [Annotation(coordinate: region.center, tint: .orange)]) { annotation in
                            MapAnnotation(coordinate: annotation.coordinate) {
                                LocationMapAnnotationView()
                            }
                        }
                        .frame(height: 238)
                        .cornerRadius(10)
                    }
                    
                    // Displays the delivery and collection information
                    VStack(alignment: .leading) {
                        if restaurant.isDelivery {
                            HStack {
                                Image(systemName: "bicycle")
                                    .foregroundColor(.orange)
                                Text("Delivery")
                                    .font(.subheadline)
                                Spacer()
                                Text(restaurant.deliveryCost == 0 ? "Free" : "£\(String(format: "%.2f", restaurant.deliveryCost))")
                                    .fontWeight(.semibold)
                            }
                            .padding(.vertical, 4)
                        }
                        
                        if restaurant.isCollection {
                            HStack {
                                Image(systemName: "bag")
                                    .foregroundColor(.orange)
                                Text("Collection")
                                    .font(.subheadline)
                                Spacer()
                                //  Text("\(metersToMiles(Double(restaurant.driveDistanceMeters))) miles away")
                                Text(restaurant.driveDistanceMeters < 1000 ?
                                     "\(restaurant.driveDistanceMeters)m away" :
                                        "\(String(format: "%.1f", Double(restaurant.driveDistanceMeters)/1000))km away")
                                .fontWeight(.semibold)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    
                    // Displays the restaurants operating status (delivery and collection)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Operating Status:")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        if restaurant.isOpenNowForDelivery {
                            Text("Open now for delivery")
                                .foregroundColor(.green)
                                .font(.subheadline)
                        } else {
                            Text("Closed for delivery")
                                .foregroundColor(.red)
                                .font(.subheadline)
                        }
                        
                        if restaurant.isOpenNowForCollection {
                            Text("Open now for collection")
                                .foregroundColor(.green)
                                .font(.subheadline)
                        } else {
                            Text("Closed for collection")
                                .foregroundColor(.red)
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .padding(.leading)
                .padding(.trailing)
            }
        }
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
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

// The Annotation Struct below was generated from Generative AI to support with the associated compile check error
struct Annotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let tint: Color
}

