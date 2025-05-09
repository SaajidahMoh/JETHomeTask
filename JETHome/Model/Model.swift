//
//  Model.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 30/03/2025.
//

import Foundation

struct Restaurant: Decodable {
    let id: String
    let name: String
    let uniqueName: String
    let address: Address
    let rating: Rating
    let cuisines: [Cuisine]
    let logoUrl: String
    let isCollection: Bool
    let isOpenNowForCollection: Bool
    let isDelivery: Bool
    let isOpenNowForDelivery: Bool
    let deals: [Deals]
    let deliveryEtaMinutes: DeliveryEtaMinutes?
    let driveDistanceMeters: Int
    let deliveryCost: Float
    let isNew: Bool
}

struct DeliveryEtaMinutes: Decodable {
    let rangeLower: Int
    let rangeUpper: Int
}

struct Address: Decodable {
    let city: String
    let firstLine: String
    let postalCode: String
    let location: Location
}

struct Location: Decodable {
    let type: String
    let coordinates: [Float]
}

struct Rating: Decodable {
    let count: Int
    let starRating: Float
    let userRating: Float?
}

struct Cuisine: Decodable {
    let name: String
    let uniqueName: String
}

struct RestaurantResponse: Decodable {
    let restaurants: [Restaurant]
}

struct Deals: Decodable {
    let description: String
    let offerType: String
}
