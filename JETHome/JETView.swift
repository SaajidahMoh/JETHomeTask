//
//  Home.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 30/03/2025.
//

import Foundation
import SwiftUI
import Kingfisher
import CoreLocation


struct JETView: View {
    
    @StateObject private var viewController = JETViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var showLocationAlert = false
    @State private var selectedOption: OptionType = .delivery
    @State private var selectedCuisine: CuisineType? = nil //.all
    //@State private var selectedFlavour: FlavourType? = nil
    @State private var selectedFlavour: Set<FlavourType> = []
    @State private var selectedFilters: Set<FilterType> = []
    @State private var isPostcodeEntered: Bool = false
    @State private var showPostcodeSheet: Bool = false
    @State private var searchText: String = ""
    @State private var showNoRestaurant = false
    
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
    
    var filteredRestaurants : [Restaurant] {
        viewController.restaurants.filter {
            restaurant in
            // let matchOption = selectedOption == .delivery ? restaurant.isDelivery : restaurant.isCollection
            let matchOption: Bool
            if selectedOption == .delivery {
                matchOption = restaurant.isDelivery && restaurant.isOpenNowForDelivery
            } else {
                matchOption = restaurant.isCollection && restaurant.isOpenNowForCollection
            }
            //let matchCuisine = selectedCuisine == nil || restaurant.cuisines.contains { $0.uniqueName == selectedCuisine?.rawValue }
            let matchCuisine = selectedCuisine == nil || (selectedCuisine == .restaurant ? !restaurant.cuisines.contains { $0.uniqueName == "groceries" || $0.uniqueName == "health-and-beauty" || $0.uniqueName == "convenience" || $0.uniqueName == "alcohol" || $0.uniqueName == "electronics" } : restaurant.cuisines.contains { $0.uniqueName == selectedCuisine?.rawValue })
            //   let matchFlavour = selectedFlavour == nil || restaurant.cuisines.contains { $0.uniqueName == selectedFlavour?.rawValue.lowercased() }
            let matchFlavour = selectedCuisine == .restaurant ? (selectedFlavour.isEmpty || selectedFlavour.contains { flavour in
                restaurant.cuisines.contains {
                    $0.uniqueName == flavour.rawValue.lowercased()
                }
            }): true
            
            let matchSearchText = searchText.isEmpty || restaurant.name.lowercased().contains(searchText.lowercased())
            
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
            
            return matchOption && matchCuisine && matchFlavour && matchSearchText && matchFilters
        }
        .sorted { $0.driveDistanceMeters < $1.driveDistanceMeters}
        
        
        // switch selectedOption {
        //  case .delivery:
        //     return viewController.restaurants.filter { $0.isDelivery}
        // case .collection:
        //      return viewController.restaurants.filter { $0.isCollection}
        //  }
    }
    
    
    
    var body: some View {
       // VStack {
        NavigationView{
            ScrollView {
                /** -- performance issue  HStack {
                 Button(action: {
                 showPostcodeSheet = true
                 }) {
                 HStack {
                 Text(isPostcodeEntered ? viewController.postcode : "Enter Postcode")
                 .foregroundColor(.primary)
                 Image(systemName: "chevron.down")
                 .foregroundColor(.primary)
                 
                 }
                 .padding(.top, 10)
                 .padding(.bottom, 10)
                 }
                 .sheet(isPresented: $showPostcodeSheet) {
                 PostcodeView(postcode: $viewController.postcode)
                 .onDisappear {
                 isPostcodeEntered = !viewController.postcode.isEmpty
                 if isPostcodeEntered {
                 viewController.updatePostcode( viewController.postcode)
                 }
                 }
                 }
                 
                 Spacer()
                 }
                 .padding(.leading, 20) */
                
                HStack {
                    HStack (spacing: 0) {
                        Button(action: {
                            if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != .denied {
                                showLocationAlert = true
                            } else {
                                locationManager.locationDisabledAlert = true
                               // locationManager.checkLocationAuthorization()
                            }
                            //
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
                        
                        TextField("Enter postcode", text: $viewController.postcode)
                            .onChange(of: viewController.postcode) { newValue in
                                isPostcodeEntered = !newValue.isEmpty
                                viewController.fetchRestaurantInfo()
                                //    showNoRestaurant = false
                                //  DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                //      showNoRestaurant = true
                                //   }
                                
                            }
                    }
                    //   }
                        .padding(.leading, 20)
                    // .padding(.trailing, 20)
                    
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
                            // .foregroundColor(selectedOption == .delivery ? Color.white : Color.black)
                        }
                        
                        
                        
                    }
                    .font(.system(size: 15))
                    .animation(.default)
                    // .padding(.trailing, 2)
                    //.padding(.leading, 10)
                }
                .padding()
                
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
                    
                    if !viewController.restaurantsFound && showNoRestaurant {
                        noRestaurantView()
                    } else {
                        
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
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(CuisineType.allCases, id: \.self) { cuisine in
                                    Button(action: {
                                        selectedCuisine = cuisine
                                        if selectedCuisine != .restaurant {
                                            selectedFlavour.removeAll()
                                        }
                                    }) {
                                        //  CategoryItems(image: cuisine.rawValue, title: cuisine.rawValue.capitalized, isSelected: selectedCuisine == cuisine)
                                        CategoryItems(image: cuisine.rawValue, title: cuisine.rawValue.replacingOccurrences(of: "-", with: " ").capitalized, isSelected: selectedCuisine == cuisine)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        
                        if selectedCuisine == .restaurant {
                            Text("Find your flavour")
                                .fontWeight(.bold)
                                .padding(.leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(FlavourType.allCases, id: \.self) { flavour in
                                        Button(action: {
                                            //selectedFlavour = selectedFlavour == flavour ? nil : flavour
                                            if selectedFlavour.contains(flavour) {
                                                selectedFlavour.remove(flavour)
                                            } else {
                                                selectedFlavour.insert(flavour)
                                            }
                                        }) {
                                            //  CategoryItems(image: cuisine.rawValue, title: cuisine.rawValue.capitalized, isSelected: selectedCuisine == cuisine)
                                            CategoryItems(image: flavour.rawValue, title: flavour.rawValue.replacingOccurrences(of: "-", with: " ").capitalized, isSelected: selectedFlavour.contains(flavour))
                                            //isSelected: selectedFlavour == flavour)
                                        }
                                    }
                                }
                            } .padding(.horizontal, 10)
                            
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(FilterType.allCases, id: \.self) { filter in
                                    Button(action: {
                                        if selectedFilters.contains(filter) {
                                            selectedFilters.remove(filter)
                                        } else {
                                            selectedFilters.insert(filter)
                                        }
                                    }) {
                                        CategoryItems2(text: filter.rawValue.replacingOccurrences(of: "_", with: " ").capitalized, isSelected: selectedFilters.contains(filter))
                                    }
                                }
                                //    .frame(width: 60, height: 60)
                            }
                                //.frame(height: 60)
                            //   .padding(.horizontal)
                            //   .padding(.top, 15)
                        }
                        /**ScrollView(.horizontal, showsIndicators: false) {
                         HStack(spacing: 15) {
                         OptionItems(text: "Deals")
                         OptionItems(text: "StampCards")
                         OptionItems(text: "Free Delivery")
                         OptionItems(text: "4+ stars")
                         OptionItems(text: "Open now")
                         OptionItems(text: "New")
                         OptionItems(text: "Hygiene Rating 3+ / Pass")
                         OptionItems(text: "Halal")
                         
                         }
                         .padding(.horizontal)
                         .padding(.top, 15)
                         } */
                        
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
                        
                      //  .navigationTitle("Find Places")
                        //          .navigationBarTitleDisplayMode(.inline)
                        
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
                } else {
                    noPostcodeView()
                }
            }
        }
        .alert(isPresented: $locationManager.locationDisabledAlert){
            Alert(
                title: Text ("Location Disabled"),
                message: Text("Location Services is off. Please turn it on in Settings"),
                primaryButton: .default(Text("Settings"), action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }),
                secondaryButton: .cancel()
            )
        }
    }
}

struct noRestaurantView: View {
    var body: some View {
        VStack {
            Image("NoRestaurants")
                .resizable()
                .scaledToFit()
                .frame(width:300, height:350)
                .padding(.top, 50)
            
            Text("No restaurant is found")
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text("Please ensure you have entered a valid UK postcode to discover restaurants or groceries near you")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            // .padding(.top, 0.5)
        }
    }
}

struct noPostcodeView: View {
    var body: some View {
        VStack {
            Image("NoAddress")
                .resizable()
                .scaledToFit()
                .frame(width:300, height:350)
                .padding(.top, 50)
            
            Text("Enter your postcode")
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text("Enter your postcode to discover restaurants or groceries near you")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            // .padding(.top, 0.5)
        }
    }
}

struct OptionItems: View {
    // let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            //    Image(systemName: icon)
            //            .font(.system(size: 12))
            
            Text(text)
                .font(.system(size: 13))
                .fontWeight(.bold)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 5)
        .overlay (RoundedRectangle(cornerRadius: 20)
            .stroke(Color.gray, lineWidth: 1)
        )
        .padding(.bottom, 10)
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
                        .frame(width:55, height: 50)
                    //  .opacity(isSelected ? 1 : 0)
                }
                
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
                    .cornerRadius(10)
                
            }
            
            Text(title)
                .font(.caption)
            // .foregroundColor(Color.black)
            //.foregroundColor(Color(#242E30))
                .fontWeight(isSelected ? .bold : .regular)
        }
    }
}

struct CategoryItems2: View {
    // let image: String
    let text: String
    let isSelected: Bool
    
    var body: some View {
        VStack {
            ZStack {
                /**   if isSelected {
                 RoundedRectangle(cornerRadius: 15)
                 .fill(Color.orange.opacity(2))
                 //  .frame(width:55, height: 50)
                 //  .opacity(isSelected ? 1 : 0)
                 } */
                Text(text)
                    .font(.caption)
                // .foregroundColor(Color.black)
                //.foregroundColor(Color(#242E30))
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundColor(isSelected ? Color.orange : Color(.systemGray))
                
            }
        }
    }
}

#Preview {
    JETView()
}
