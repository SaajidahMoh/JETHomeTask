//
//  PostcodeView.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 31/03/2025.
//
/*
import SwiftUI

struct PostcodeView:View {
    @StateObject private var viewController = JETViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var showLocationAlert = false
    @Binding var postcode: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            HStack {
                Spacer()
                
                TextField("Enter postcode", text: $viewController.postcode)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.leading, 10)
                    .padding(.horizontal, 20)
                    
                
                HStack {
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
                                    //viewController.updatePostcode(postcode)
                                    self.postcode = postcode
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                .padding(.horizontal)
                // .padding(.trailing, 20)
            }
            .padding(.top, 20)
        }
        Button(action: {
            //viewController.fetchRestaurantInfo()
            presentationMode.wrappedValue.dismiss()
            
        }) {
            Text("Search")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color.orange)
                .cornerRadius(10)
               
                
            
        }
        .padding(.horizontal)
        .padding(.top,10)
                Spacer()
                
    
            .navigationBarTitle("Enter Postcode", displayMode: .inline)
                        .navigationBarItems(leading: Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        })
                    }
                }
    

#Preview {
   // PostcodeView()
}
*/
