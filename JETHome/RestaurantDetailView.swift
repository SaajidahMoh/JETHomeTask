//
//  RestaurantDetailView.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 05/04/2025.
//

import SwiftUI
import MapKit
import Kingfisher

struct RestaurantDetailView: View {
    let restaurant: Restaurant
    @State private var region: MKCoordinateRegion
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        
        let latitude = Double(restaurant.address.location.coordinates.last ?? 0.0)
        let longitude = Double(restaurant.address.location.coordinates.first ?? 0.0)
        let initialRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.0035, longitudeDelta: 0.0035))
        
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.0035, longitudeDelta: 0.0035))
    }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    // Restaurant name and rating
                    HStack {
                        Text(restaurant.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", restaurant.rating.starRating))
                                .fontWeight(.semibold)
                        }
                        .padding(6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                    }
                    
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
                    // Address
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.orange)
                        Text("\(restaurant.address.firstLine), \(restaurant.address.postalCode)")
                            .font(.subheadline)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("MAP:")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        Map(coordinateRegion: .constant(region), showsUserLocation: true, annotationItems: [Annotation(coordinate: region.center, tint: .orange)]) { annotation in
                            MapAnnotation(coordinate: annotation.coordinate) {
                                LocationMapAnnotationView()
                            }
                        }
                        .frame(height: 200)
                        .cornerRadius(10)
                    }
                    
                    // Delivery and collection info
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
                                Text(restaurant.driveDistanceMeters < 1000 ?
                                     "\(restaurant.driveDistanceMeters)m away" :
                                        "\(String(format: "%.1f", Double(restaurant.driveDistanceMeters)/1000))km away")
                                .fontWeight(.semibold)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    
                    // Restaurant open
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
            }
        }
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Annotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let tint: Color
}

