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
    @State private var selectedOption: OptionType = .delivery
    @State private var selectedCategory: CategoryType? = nil
    @State private var selectedFlavour: Set<FlavourType> = []
    @State private var selectedFilters: Set<FilterType> = []
    @State private var isPostcodeEntered: Bool = false
    @State private var showPostcodeSheet: Bool = false
    @State private var searchText: String = ""
    @State private var showNoRestaurant = false
    
    // enum defining the oprtion - delivery or collection
    enum OptionType {
        case delivery, collection
    }
    
    // enum defining the category types
    enum CategoryType: String, CaseIterable {
        case restaurant = "restaurant"
        case groceries = "groceries"
        case healthAndBeauty = "health-and-beauty"
        case convenience = "convenience"
        case alcohol = "alcohol"
        case electronics = "electronics"
    }
    
    // enum defining the flavours
    enum FlavourType : String, CaseIterable {
        case vegeterian = "vegetarian"
        case chicken = "chicken"
        case burgers = "burgers"
        case american = "american"
        case periperi = "peri-peri"
        case pizza = "pizza"
        case sandwiches = "sandwiches"
        case kebabs = "kebabs"
        case breakfast = "breakfast"
        case chinese = "chinese"
    }
    
    // enum defining the advanced filters
    enum FilterType: String, CaseIterable {
        case freeDelivery = "Free Delivery"
        case lowDeliveryFee = "Low Delivery Fee"
        case new = "New"
        case deals = "Deals"
        case halal = "Halal"
        case freebies = "Freebies"
        case stampCardRestaurants = "Stampcards"
        case fourStar = "4 star +"
        case openNow = "Open"
        case eightOff = "£8 off"
    }
    
    // Filtering the restaurant (based on user's selected criteria)
    var filteredRestaurants : [Restaurant] {
        viewModel.restaurants.filter {
            restaurant in
            
            // Checking if the restaurant matches either delivery or collection
            let matchOption: Bool
            if selectedOption == .delivery {
                matchOption = restaurant.isDelivery && restaurant.isOpenNowForDelivery
            } else {
                matchOption = restaurant.isCollection && restaurant.isOpenNowForCollection
            }
            
            // Checking if the restaurant matches the selected categories
            let matchCuisine = selectedCategory == nil || (selectedCategory == .restaurant ? !restaurant.cuisines.contains { $0.uniqueName == "groceries" || $0.uniqueName == "health-and-beauty" || $0.uniqueName == "convenience" || $0.uniqueName == "alcohol" || $0.uniqueName == "electronics" } : restaurant.cuisines.contains { $0.uniqueName == selectedCategory?.rawValue })
            
            // checking if the restaurant matches flavours selected
            let matchFlavour = selectedCategory == .restaurant ? (selectedFlavour.isEmpty || selectedFlavour.contains { flavour in
                restaurant.cuisines.contains {
                    $0.uniqueName == flavour.rawValue.lowercased()
                }
            }): true
            
            // Checking if the restaurant matches the text entered in the search
            let matchSearchText = searchText.isEmpty || restaurant.name.lowercased().contains(searchText.lowercased())
            
            // checking if the restaurant matches the selected advanced filters below
            let matchFilters = selectedFilters.isEmpty || selectedFilters.allSatisfy { filter in
                switch filter {
                case .freeDelivery:
                    return restaurant.deliveryCost == 0
                case .lowDeliveryFee:
                    return restaurant.cuisines.contains { $0.uniqueName == "low-delivery-fee" }
                case .new:
                    return restaurant.isNew == true
                case .deals:
                    return restaurant.cuisines.contains { $0.uniqueName == "deals" }
                case .halal:
                    return restaurant.cuisines.contains { $0.uniqueName == "halal" }
                case .freebies:
                    return restaurant.cuisines.contains { $0.uniqueName == "freebies" }
                case .stampCardRestaurants:
                    return restaurant.cuisines.contains { $0.uniqueName == "stampcard-restaurants" }
                case .fourStar:
                    return restaurant.rating.starRating >= 4
                case .openNow:
                    return restaurant.isOpenNowForDelivery || restaurant.isOpenNowForCollection
                case .eightOff:
                    return restaurant.cuisines.contains { $0.uniqueName == "8off" }
                }
            }
            
            // If all is met then it returns the results
            return matchOption && matchCuisine && matchFlavour && matchSearchText && matchFilters
        }
        // Sorts the restaurants in order of the distance
        .sorted { $0.driveDistanceMeters < $1.driveDistanceMeters}
    }
    
    
    
    var body: some View {
        NavigationView{
            ScrollView {
                
                // Horizontal stack for location and option buttons
                HStack {
                    
                    // Shows location alert if location services is not denied
                    HStack (spacing: 0) {
                        Button(action: {
                            if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != .denied {
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
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        
                        // Postcode field, as long as there is text entered it will perform the API call to get the restaurants based on input
                        TextField("Enter postcode", text: $viewModel.postcode)
                            .onChange(of: viewModel.postcode) { newValue in
                                isPostcodeEntered = !newValue.isEmpty
                                viewModel.fetchRestaurantInfo()
                            }
                    }
                    .padding(.leading, 20)
                    
                    // Delivery and collection button which sets the selected option to it's corresponding button clicked
                    HStack {
                        Button(action: {
                            selectedOption = .delivery
                        }) {
                            HStack {
                                Image(systemName: "bicycle")
                                if  selectedOption == .delivery {
                                    Text("Delivery")
                                }
                            }
                            .padding(6)
                            .background(selectedOption == .delivery ? Color.orange: Color.clear)
                            .cornerRadius(8)
                            .foregroundColor(selectedOption == .delivery ? Color.white : Color.primary)
                        }
                        
                        Button(action: {
                            selectedOption = .collection
                        }) {
                            HStack {
                                Image(systemName: "bag")
                                if  selectedOption == .collection {
                                    Text("Collect")
                                }
                            }
                            .padding(6)
                            .background(selectedOption == .collection ? Color.orange: Color.clear)
                            .cornerRadius(8)
                            .foregroundColor(selectedOption == .collection ? Color.white : Color.primary)
                        }
                    }
                    .font(.system(size: 15))
                    .animation(.default)
                }
                .padding()
                
                // If condition for if the postcode is entered
                if isPostcodeEntered {
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
                        TextField("Search restaurants", text: $searchText)
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
                                ForEach(CategoryType.allCases, id: \.self) { cuisine in
                                    Button(action: {
                                        selectedCategory = cuisine
                                        if selectedCategory != .restaurant {
                                            selectedFlavour.removeAll()
                                        }
                                    }) {
                                        // displays the flavour's with the image and title
                                        CategoryItemsView(image: cuisine.rawValue, title: cuisine.rawValue.replacingOccurrences(of: "-", with: " ").capitalized, isSelected: selectedCategory == cuisine)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        
                        // If the user selects the restaurant category, the "Find you flavour" section and the cuisine types are shown
                        if selectedCategory == .restaurant {
                            Text("Find your flavour")
                                .fontWeight(.bold)
                                .padding(.leading)
                            
                            // Horizontal scroll for the flavours
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    // Iterates through all the flavour types and create buttons for each
                                    ForEach(FlavourType.allCases, id: \.self) { flavour in
                                        Button(action: {
                                            // toggles the selection of the flavour and allows for multiple selection
                                            if selectedFlavour.contains(flavour) {
                                                selectedFlavour.remove(flavour)
                                            } else {
                                                selectedFlavour.insert(flavour)
                                            }
                                        }) {
                                           
                                            // Displays the flavour's with the image and title
                                            CategoryItemsView(image: flavour.rawValue, title: flavour.rawValue.replacingOccurrences(of: "-", with: " ").capitalized, isSelected: selectedFlavour.contains(flavour))
                                        }
                                    }
                                }
                            } .padding(.horizontal, 10)
                            
                        }
                        
                        // Horizontal scroll for the advanced filters
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(FilterType.allCases, id: \.self) { filter in
                                    Button(action: {
                                        // toggles the selection of the flavour and allows for multiple selection
                                        if selectedFilters.contains(filter) {
                                            selectedFilters.remove(filter)
                                        } else {
                                            selectedFilters.insert(filter)
                                        }
                                    }) {
                                        // Displays the advanced filters/ extra's with text
                                        FilteringItemsView(text: filter.rawValue.replacingOccurrences(of: "_", with: " ").capitalized, isSelected: selectedFilters.contains(filter))
                                    }
                                }
                            }
                        }
                        
                        // Vertical scroll for displaying the restaurants
                        ScrollView(.vertical) {
                            LazyVStack(alignment: .leading, spacing: 16) {
                                
                                // Iterates over the filtered restaurants and displays 10
                                ForEach (filteredRestaurants.prefix(10), id: \.id) {
                                    restaurant in
                                    RestaurantListView(restaurant: restaurant)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        // Updates the postcode when the view appears
                        .onAppear {
                            if let postcode = locationManager.postcode {
                                viewModel.updatePostcode(postcode)
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
