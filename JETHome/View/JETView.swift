//
//  JETView.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 30/03/2025.
//

import Foundation
import SwiftUI
import Kingfisher
import CoreLocation

struct JETView: View {
    
    @StateObject private var viewModel = JETViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var showLocationAlert = false
    @State private var isPostcodeEntered: Bool = false
    @State private var showPostcodeSheet: Bool = false
    @State private var showNoRestaurant = false
    @AppStorage("savedPostcode") var savedPostcode: String = ""
    
    var body: some View {
        NavigationView{
            ScrollView {
                
                // Horizontal stack for location and option buttons
                HStack {
                    
                    // Shows location alert if location services is not denied
                    HStack (spacing: 0) {
                        Button(action: {
                            if locationManager.isLocationShared == true {
                                showLocationAlert = true
                            } else {
                                locationManager.locationDisabledAlert = true
                                // locationManager.checkLocationAuthorization()
                            }
                        }) {
                            Image(systemName: "location")
                                .font(.system(size: 20))
                                .padding(.trailing)
                        }
                        
                        // Location alert where if user selects yes, the field will update with the current users postcode (from geocoding)
                        .alert(isPresented: $showLocationAlert) {
                            Alert(
                                title: Text("Share Your Location"),
                                message: Text("Would you like to share your location to find nearby restaurants?"),
                                primaryButton: .default(Text("Yes")) {
                                    if let postcode = locationManager.postcode {
                                        viewModel.updatePostcode(postcode)
                                        savedPostcode = postcode
                                    }
                                    locationManager.reverseGeocodeLocation(coordinate: locationManager.userLocation)
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        
                        // Postcode field, as long as there is text entered it will perform the API call to get the restaurants based on input
                        TextField("Enter postcode", text: $viewModel.postcode)
                            .onChange(of: viewModel.postcode) { oldValue, newValue in
                                isPostcodeEntered = !newValue.isEmpty
                                viewModel.fetchRestaurantInfo()
                                savedPostcode = newValue
                            }
                    }
                    .padding(.leading, 20)
                    
                    // Delivery and collection button which sets the selected option to it's corresponding button clicked
                    HStack {
                        withAnimation(.default) {
                            Button(action: {
                                viewModel.selectedOption = .delivery
                            }) {
                                HStack {
                                    Image(systemName: "bicycle")
                                    if  viewModel.selectedOption == .delivery {
                                        Text("Delivery")
                                    }
                                }
                                .padding(6)
                                .background(viewModel.selectedOption == .delivery ? Color.orange: Color.clear)
                                .cornerRadius(8)
                                .foregroundColor(viewModel.selectedOption == .delivery ? Color.white : Color.primary)
                            }
                        }
                        
                        withAnimation(.default) {
                            Button(action: {
                            viewModel.selectedOption = .collection
                        }) {
                            HStack {
                                Image(systemName: "bag")
                                if  viewModel.selectedOption == .collection {
                                    Text("Collect")
                                }
                            }
                            .padding(6)
                            .background(viewModel.selectedOption == .collection ? Color.orange: Color.clear)
                            .cornerRadius(8)
                            .foregroundColor(viewModel.selectedOption == .collection ? Color.white : Color.primary)
                        }
                    }
                    }
                    .font(.system(size: 15))
                    //.animation(.default)
                }
                .padding()
                
                // If condition for if the postcode is entered
              //  if isPostcodeEntered {
                if !savedPostcode.isEmpty {
                    /**Button(action: {
                     viewController.fetchRestaurantInfo()
                     showNoRestaurant = false
                     DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                     showNoRestaurant = true
                     }
                     }) {
                     Text("Get Restaurants")
                     } */
                    
                    // shows the noRestuarantView if no restaurants are found
                    if !viewModel.restaurantsFound && showNoRestaurant {
                        NoRestaurantView()
                    } else {
                        
                        // The search text field for the restaurant
                        TextField("Search restaurants", text: $viewModel.searchText)
                            .padding(.leading, 30)
                            .background(
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .frame(width:15, height:15)
                                        .foregroundColor(Color.orange)
                                        .padding(.leading, 5)
                                    Spacer()
                                }
                            )
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                        
                        // Horizontal scroll for different type of the categories
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                               
                                // Iterates through all the category types and create buttons for each
                                ForEach(JETViewModel.CategoryType.allCases, id: \.self) { cuisine in
                                    Button(action: {
                                        viewModel.selectedCategory = cuisine
                                        if viewModel.selectedCategory != .restaurant {
                                            viewModel.selectedFlavour.removeAll()
                                        }
                                    }) {
                                        // displays the flavour's with the image and title
                                        CategoryItemsView(image: cuisine.rawValue, title: cuisine.rawValue.replacingOccurrences(of: "-", with: " ").capitalized, isSelected: viewModel.selectedCategory == cuisine)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        
                        // If the user selects the restaurant category, the "Find you flavour" section and the cuisine types are shown
                        if viewModel.selectedCategory == .restaurant {
                            Text("Find your flavour")
                                .fontWeight(.bold)
                                .padding(.leading)
                            
                            // Horizontal scroll for the flavours
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    // Iterates through all the flavour types and create buttons for each
                                    ForEach(JETViewModel.FlavourType.allCases, id: \.self) { flavour in
                                        Button(action: {
                                            // toggles the selection of the flavour and allows for multiple selection
                                            if viewModel.selectedFlavour.contains(flavour) {
                                                viewModel.selectedFlavour.remove(flavour)
                                            } else {
                                                viewModel.selectedFlavour.insert(flavour)
                                            }
                                        }) {
                                           
                                            // Displays the flavour's with the image and title
                                            CategoryItemsView(image: flavour.rawValue, title: flavour.rawValue.replacingOccurrences(of: "-", with: " ").capitalized, isSelected: viewModel.selectedFlavour.contains(flavour))
                                        }
                                    }
                                }
                            } .padding(.horizontal, 10)
                            
                        }
                        
                        // Horizontal scroll for the advanced filters
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(JETViewModel.FilterType.allCases, id: \.self) { filter in
                                    Button(action: {
                                        // toggles the selection of the flavour and allows for multiple selection
                                        if viewModel.selectedFilters.contains(filter) {
                                            viewModel.selectedFilters.remove(filter)
                                        } else {
                                            viewModel.selectedFilters.insert(filter)
                                        }
                                    }) {
                                        // Displays the advanced filters/ extra's with text
                                        FilteringItemsView(text: filter.rawValue.replacingOccurrences(of: "_", with: " ").capitalized, isSelected: viewModel.selectedFilters.contains(filter))
                                    }
                                }
                            }
                        }
                        
                        // Vertical scroll for displaying the restaurants
                        ScrollView(.vertical) {
                            LazyVStack(alignment: .leading, spacing: 16) {
                                
                                // Iterates over the filtered restaurants and displays 10
                                ForEach (viewModel.filteredRestaurants.prefix(10), id: \.id) {
                                    restaurant in
                                    RestaurantListView(restaurant: restaurant)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        // Updates the postcode when the view appears
                        .onAppear { if !savedPostcode.isEmpty {
                            viewModel.updatePostcode(savedPostcode)
                            // if let postcode = locationManager.postcode {
                               // viewModel.updatePostcode(postcode)
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    }
                } else {
                    // Displays the noPostcodeView if no psotcode is entered
                    NoPostcodeView()
                }
            }
        }
        // Displays alert to notify user that the location services are disabled
        .alert(isPresented: $locationManager.locationDisabledAlert){
            Alert(
                title: Text ("Location Disabled"),
                message: Text("Location Services is off. Please turn it on in Settings"),
                // Opens the Settings application to enhable the user to output location services
                primaryButton: .default(Text("Settings"), action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }),
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    JETView()
}
