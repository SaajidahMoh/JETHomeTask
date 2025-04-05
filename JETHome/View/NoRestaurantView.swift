//
//  NoRestaurantView.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 05/04/2025.
//

/**
 * The image "NoRestaurants" was found and reused from storyset and was customised to change the colour to JustEat's brand box, #FF8000 to ensure accessibility.
 * Freepik (2025), Search engines Flat Illustrations. Place of publication: Storyset. Link available at: https://storyset.com/illustration/search-engines/rafiki
 */

import SwiftUI
// User-friendly UI for when no restaurants are found / When user does not enter a valid postcode
struct NoRestaurantView: View {
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
        }
    }
}

#Preview {
    NoRestaurantView()
}

