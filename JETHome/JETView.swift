//
//  Home.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 30/03/2025.
//

import Foundation
import SwiftUI


struct JETView: View {
    
    @StateObject private var viewController = JETViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                Image(systemName: "globe")
                VStack {
                    ForEach(viewController.restaurants.prefix(10), id: \.id){
                        restaurant in
                        VStack(alignment: .leading) {
                            Text(restaurant.name)
                                .font(.title)
                        }
                        
                    }
                }
                .padding()
            }
            
        }
        .onAppear {
            viewController.fetchRestaurantInfo()
        }
    }
}

#Preview {
    JETView()
}
