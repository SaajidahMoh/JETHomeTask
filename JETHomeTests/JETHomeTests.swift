//
//  JETHomeTests.swift
//  JETHomeTests
//
//  Created by Mohamed, Saajidah on 30/03/2025.
//

import Testing
import XCTest
@testable import JETHome

struct JETHomeTests {
    
    func postcodeValidation(_ postcode: String ) -> Bool {
        let postcodeRegex = "^([A-Za-z]{2}[\\d]{1,2}[A-Za-z]?)[\\s]+([\\d][A-Za-z]{2})$ "
        let postcodeCheck = NSPredicate(format: "SELF MATCHES %@",postcodeRegex)
        return postcodeCheck.evaluate(with: postcode)
    }
    
    @Test func example() async throws {
        let viewModel = JETViewModel()
        let sortingRestaurant : [Restaurant] = [Restaurant(
            id: "123603",
            name: "McDonald's® - City Road",
            uniqueName: "mcdonalds-cityroad",
            address: Address(
                city: "London",
                firstLine: "241 City Road",
                postalCode: "EC1V 1JQ",
                location: Location(type: "Point", coordinates: [-0.094651, 51.529572])
            ),
            rating: Rating(count: 6734, starRating: 3.3, userRating: nil),
            cuisines: [Cuisine(name: "Burgers", uniqueName: "burgers")],
            logoUrl: "https://example.com/logo1.gif",
            isCollection: false,
            isOpenNowForCollection: false,
            isDelivery: true,
            isOpenNowForDelivery: true,
            deals: [Deals(description: "Meal deal", offerType: "Notification")],
            deliveryEtaMinutes: DeliveryEtaMinutes(rangeLower: 15, rangeUpper: 30),
            driveDistanceMeters: 614,
            deliveryCost: 0.99,
            isNew: false
        ), Restaurant(
            id: "120455",
            name: "McDonald's® - Islington",
            uniqueName: "mcdonalds-islington",
            address: Address(
                city: "London",
                firstLine: "65-67 Chapel Market",
                postalCode: "N1 9ER",
                location: Location(type: "Point", coordinates: [-0.108522, 51.533451])
            ),
            rating: Rating(count: 5006, starRating: 3.5, userRating: nil),
            cuisines: [Cuisine(name: "Burgers", uniqueName: "burgers")],
            logoUrl: "https://example.com/logo2.gif",
            isCollection: false,
            isOpenNowForCollection: false,
            isDelivery: true,
            isOpenNowForDelivery: true,
            deals: [Deals(description: "Meal deal", offerType: "Notification")],
            deliveryEtaMinutes: DeliveryEtaMinutes(rangeLower: 15, rangeUpper: 30),
            driveDistanceMeters: 722,
            deliveryCost: 0.99,
            isNew: false
        ), Restaurant(
            id: "119798",
            name: "McDonald's® - Dalston",
            uniqueName: "mcdonalds-dalston",
            address: Address(
                city: "London",
                firstLine: "36/42 Kingsland High Street",
                postalCode: "E8 2JP",
                location: Location(type: "Point", coordinates: [-0.075447, 51.54726])
            ),
            rating: Rating(count: 10639, starRating: 3.3, userRating: nil),
            cuisines: [Cuisine(name: "Burgers", uniqueName: "burgers")],
            logoUrl: "https://example.com/logo3.gif",
            isCollection: false,
            isOpenNowForCollection: false,
            isDelivery: true,
            isOpenNowForDelivery: true,
            deals: [Deals(description: "Meal deal", offerType: "Notification")],
            deliveryEtaMinutes: DeliveryEtaMinutes(rangeLower: 10, rangeUpper: 25),
            driveDistanceMeters: 2884,
            deliveryCost: 0.99,
            isNew: false
        ), Restaurant(
            id: "256652",
            name: "Ecco Pizza - Covent Garden",
            uniqueName: "ecco-pizza---covent-garden-london",
            address: Address(
                city: "London",
                firstLine: "186 Drury Lane",
                postalCode: "WC2B 5QD",
                location: Location(type: "Point", coordinates: [-0.123907, 51.515987])
            ),
            rating: Rating(count: 9, starRating: 3.3, userRating: nil),
            cuisines: [
                Cuisine(name: "Pizza", uniqueName: "pizza"),
                Cuisine(name: "Italian", uniqueName: "italian")
            ],
            logoUrl: "https://d30v2pzvrfyzpo.cloudfront.net/uk/images/restaurants/256652.gif",
            isCollection: true,
            isOpenNowForCollection: true,
            isDelivery: true,
            isOpenNowForDelivery: true,
            deals: [
                Deals(description: "£8 off when you spend £25", offerType: "Notification"),
                Deals(description: "Save 10% • Spend £15", offerType: "Percent"),
                Deals(description: "", offerType: "StampCard")
            ],
            deliveryEtaMinutes: DeliveryEtaMinutes(rangeLower: 20, rangeUpper: 35),
            driveDistanceMeters: 1960,
            deliveryCost: 0.99,
            isNew: false
        )]
        
        let sortedRestaurants = viewModel.sortRestaurant(sortingRestaurant)
        
        // Number of sorted restaurants
        XCTAssertEqual(sortedRestaurants.count, 4)
        
        // The sorted restaurants should be in the following order:
        XCTAssertEqual(sortedRestaurants[0].id, "120455")
        XCTAssertEqual(sortedRestaurants[0].name, "McDonald's® - Islington")
        
        XCTAssertEqual(sortedRestaurants[1].id, "123603")
        XCTAssertEqual(sortedRestaurants[1].name, "McDonald's® - City Road")
        
        XCTAssertEqual(sortedRestaurants[2].id, "119798")
        XCTAssertEqual(sortedRestaurants[2].name,"McDonald's® - Dalston")
        
        XCTAssertEqual(sortedRestaurants[3].id, "256652")
        XCTAssertEqual(sortedRestaurants[3].name, "Ecco Pizza - Covent Garden")
        
        
        let validPostcodes = ["EC1V 0HB", "EC4M7RF", "CR0  0JS", " BS14DJ", "EN26AJ"]
        
        let invalidPostcodes = ["EC1HB", "CR00JSS", "HB12 0jH", "EN128BJ"]
        
        for postcode in validPostcodes {
            XCTAssertTrue(postcodeValidation(postcode), "Valid UK postcode")
        }
        
        for postcode in invalidPostcodes {
            XCTAssertFalse(postcodeValidation(postcode), "Invalid UK postcode")
        }
    }
    
}
