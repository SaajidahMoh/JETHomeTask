//
//  JETViewModel.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 30/03/2025.
//
import Foundation

class JETViewModel : ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var postcode: String = "" // "EC4M7RF"
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var restaurantsFound: Bool = false
    @Published var selectedOption: OptionType = .delivery
    @Published var selectedCategory: CategoryType? = nil
    @Published var selectedFlavour: Set<FlavourType> = []
    @Published var selectedFilters: Set<FilterType> = []
    
    private var locationManager = LocationManager()
    private var apiService = justEatAPIInteraction()
    
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
       restaurants.filter {
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
        .sorted {
            if $0.rating.starRating == $1.rating.starRating {
                return $0.rating.count > $1.rating.count
            } else {
                return $0.rating.starRating > $1.rating.starRating }
         //   $0.driveDistanceMeters < $1.driveDistanceMeters}
        }
    }
    
    // Performs the interaction with the API to get the restaurants information
    @MainActor
    func fetchRestaurantInfo(){
        guard !postcode.isEmpty else {
            print ("Enter postcode")
            return
        }
        isLoading = true
        
        let APIInteraction = justEatAPIInteraction()
        Task { do
        {
            let restaurants = try await
            APIInteraction.getRestaurantInfo(postcode:postcode) //{ restaurants in
            DispatchQueue.main.async {
                self.restaurants = restaurants
                //  self.isLoading = false
                self.restaurantsFound = !self.restaurants.isEmpty
            }
        }
            catch {
                print("Error getting restaurant information: \(error)")
            }
        }
    }
    
    @MainActor func updatePostcode(_ postcode : String) {
        self.postcode = postcode
        locationManager.hasSetPostcode = true
        fetchRestaurantInfo()
    }
    
    func sortRestaurant(_ restaurant : [Restaurant]) -> [Restaurant] {
        restaurant.sorted {
            if $0.rating.starRating == $1.rating.starRating {
                return $0.rating.count > $1.rating.count
            } else {
                return $0.rating.starRating > $1.rating.starRating }
            //$0.driveDistanceMeters < $1.driveDistanceMeters}
        }
    }
}


