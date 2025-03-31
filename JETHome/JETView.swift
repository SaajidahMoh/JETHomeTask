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
    @State private var selectedCuisine: CuisineType? = nil //.all
    
    enum OptionType {
        case delivery, collection
    }
    
    enum CuisineType: String, CaseIterable {
        // case all = "all"
        case restaurant = "restaurant"
        case groceries = "groceries"
        case healthAndBeauty = "health-and-beauty"
        case convenience = "convenience"
        case alcohol = "alcohol"
        case electronics = "electronics"
    }
    
    var filteredRestaurants : [Restaurant] {
        viewController.restaurants.filter {
            restaurant in
            let matchOption = selectedOption == .delivery ? restaurant.isDelivery : restaurant.isCollection
            
            //let matchCuisine = selectedCuisine == nil || restaurant.cuisines.contains { $0.uniqueName == selectedCuisine?.rawValue }
            let matchCuisine = selectedCuisine == nil || (selectedCuisine == .restaurant ? !restaurant.cuisines.contains { $0.uniqueName == "groceries" || $0.uniqueName == "health-and-beauty" || $0.uniqueName == "convenience" || $0.uniqueName == "alcohol" || $0.uniqueName == "electronics" } : restaurant.cuisines.contains { $0.uniqueName == selectedCuisine?.rawValue })
            
            return matchOption && matchCuisine
        }
        
        
        // switch selectedOption {
        //  case .delivery:
        //     return viewController.restaurants.filter { $0.isDelivery}
        // case .collection:
        //      return viewController.restaurants.filter { $0.isCollection}
        //  }
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
                    ForEach(CuisineType.allCases, id: \.self) { cuisine in
                        Button(action: {
                            selectedCuisine = cuisine
                        }) {
                            //  CategoryItems(image: cuisine.rawValue, title: cuisine.rawValue.capitalized, isSelected: selectedCuisine == cuisine)
                            CategoryItems(image: cuisine.rawValue, title: cuisine.rawValue.replacingOccurrences(of: "-", with: " ").capitalized, isSelected: selectedCuisine == cuisine)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
            }
            /** ScrollView(.horizontal, showsIndicators: false) {
             HStack(spacing: 15) {
             CategoryItems(image: "european", title: "Restaurants", isSelected: false)
             CategoryItems(image: "groceries", title: "Groceries", isSelected: false)
             CategoryItems(image: "health-and-beauty", title: "Health & Beauty", isSelected: false)
             CategoryItems(image: "convenience", title: "Convenience", isSelected: false)
             CategoryItems(image: "alcohol", title: "Alcohol", isSelected: false)
             CategoryItems(image: "electronics", title: "electronics", isSelected: false)
             }
             
             */
            
            ScrollView(.vertical) {
                // Image(systemName: "globe")
                
                // VStack(alignment: .leading) {
                LazyVStack(alignment: .leading, spacing: 16) {
                    // ForEach(viewController.restaurants.prefix(10), id: \.id){
                    ForEach (filteredRestaurants.prefix(10), id: \.id) {
                        restaurant in
                        RestaurantListView(restaurant: restaurant)
                            .frame(maxWidth: .infinity)
                        
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
    let isSelected: Bool
    
    var body: some View {
        VStack {
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.orange.opacity(0.3))
                        .frame(width:70, height: 70)
                    //  .opacity(isSelected ? 1 : 0)
                }
                
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
                
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(Color.black)
            //.foregroundColor(Color(#242E30))
                .fontWeight(isSelected ? .bold : .regular)
        }
    }
}

#Preview {
    JETView()
}
