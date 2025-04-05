//
//  LocationMapAnnotationView.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 05/04/2025.
//

import SwiftUI
import MapKit

struct LocationMapAnnotationView: View {
    var body: some View {
        VStack(spacing: 0){
            // The pins icon
            Image(systemName: "mappin.circle")
                .resizable()
                .scaledToFit()
                .frame(width:30, height:30)
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
                .frame(width:10, height:10)
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
