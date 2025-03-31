//
//  PostcodeView.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 31/03/2025.
//

import SwiftUI

struct PostcodeView:View {
    @StateObject private var viewController = JETViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var showLocationAlert = false
    
    var body: some View {
        HStack {
            TextField("Enter postcode", text: $viewController.postcode)
            
            Spacer()
            Button(action: {
                                    showLocationAlert = true
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
        }
        .padding(.leading, 20)
       // .padding(.trailing, 20)
      
        Button(action: {
            viewController.fetchRestaurantInfo()
        }) {
            Text("Get Restaurants")
        } 
    }
    
}

#Preview {
    PostcodeView()
}
