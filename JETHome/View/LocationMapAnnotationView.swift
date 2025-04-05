//
//  LocationMapAnnotationView.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 05/04/2025.
//

/**
 * The locationMap Annotation view is the design of the locations pin. The code was reused from the video below, with adaptations of only the icon design and color.
 * Sarno, N. (2021), Swiftful Thinking - Custom Map Annotation Pins for SwiftUI MapKit Map | SwiftUI Map App #6. Link available at : https://www.youtube.com/watch?v=javFZbCYGfc&t=13s&ab_channel=SwiftfulThinking
 */

import SwiftUI
import MapKit

// The design of the restaurant's location pin
struct LocationMapAnnotationView: View {
    var body: some View {
        VStack(spacing: 0){
            
            // The pins icon
            Image(systemName: "mappin.circle")
                .resizable()
                .scaledToFit()
                .frame(width:25, height:25)
                .font(.headline)
                .foregroundColor(.white)
                .padding(6)
                .background(.orange)
                .cornerRadius(36)
            
            // The bottom part of the pin
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.orange)
                .frame(width:9, height:9)
                .rotationEffect(Angle(degrees:180))
                .offset(y: -3)
                .padding(.bottom, 40)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        LocationMapAnnotationView()
    }
}
