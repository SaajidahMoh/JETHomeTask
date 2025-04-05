//
//  NoPostcodeView.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 05/04/2025.
//

/**
 * The image "NoAddress" was found and reused from storyset and was customised to change the colour to JustEat's brand box, #FF8000 to ensure accessibility.
 * Freepik (2025), Address Disproportionate Illustrations. Place of publication: Storyset. Link available at: https://storyset.com/illustration/address/cuate
 */

import SwiftUI

// User-friendly UI for when no postcode is entered
struct NoPostcodeView: View {
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
        }
    }
}
