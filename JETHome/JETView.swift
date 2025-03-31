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
    @State private var selectedOption: OptionType = .delivery
    
    enum OptionType {
        case delivery, collection
    }
    
    var filteredRestaurants : [Restaurant] {
        switch selectedOption {
        case .delivery:
            return viewController.restaurants.filter { $0.isDelivery}
        case .collection:
            return viewController.restaurants.filter { $0.isCollection}
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter postcode", text: $viewController.postcode)
                
                Spacer()
                Button(action: {
                    showLocationAlert = true
                }) {
                    Image(systemName: "location")
                        .font(.system(size: 20))
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
            .padding(.leading, 20)
            // .padding(.trailing, 20)
            
            Button(action: {
                viewController.fetchRestaurantInfo()
            }) {
                Text("Get Restaurants")
            }
            
            HStack {
                Button(action: {
                    selectedOption = .delivery
                }) {
                    Text("Delivery")
                }
                
                Button(action: {
                    selectedOption = .collection
                }) {
                    Text("Collection")
                }
                
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    CategoryItems(image: "european", title: "Restaurants")
                    CategoryItems(image: "groceries", title: "Groceries")
                    CategoryItems(image: "health-and-beauty", title: "Health & Beauty")
                    CategoryItems(image: "convenience", title: "Convenience")
                    CategoryItems(image: "alcohol", title: "Alcohol")
                    CategoryItems(image: "electronics", title: "electronics")
                }
                
                ScrollView {
                    // Image(systemName: "globe")
                    
                    // VStack(alignment: .leading) {
                    LazyVStack(spacing: 16) {
                        // ForEach(viewController.restaurants.prefix(10), id: \.id){
                        ForEach (filteredRestaurants, id: \.id) {
                            restaurant in
                            RestaurantListView(restaurant: restaurant)
                            
                        }
                    }
                }
            }
            //.background(Color(.systemGroupedBackground).ignoresSafeArea())
            .onAppear {
                if let postcode = locationManager.postcode {
                    viewController.updatePostcode(postcode)
                }
                //viewController.fetchRestaurantInfo()
            }
            // .padding(.leading, 20)
            //  .padding(.trailing, 20)
            .padding(.leading, 20)
            .padding(.trailing, 20)
        }
    }
    
}


struct CategoryItems: View {
    let image: String
    let title: String
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            
            Text(title)
                .font(.caption)
        }
    }
}

#Preview {
    JETView()
}
