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
