//
//  CategoryItemsView.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 05/04/2025.
//

import SwiftUI
// User-friendly interaction that highlights the image and makes the text bold when the filter is selected
struct CategoryItemsView: View {
    let image: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack {
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.orange.opacity(0.3))
                        .frame(width:55, height: 50)
                }
                
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
                    .cornerRadius(10)
                
            }
            
            Text(title)
                .font(.caption)
                .fontWeight(isSelected ? .bold : .regular)
        }
    }
}
