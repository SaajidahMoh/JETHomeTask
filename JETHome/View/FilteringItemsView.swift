//
//  FilteringItemsView.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 05/04/2025.
//

import SwiftUI

// User-friendly interaction that changes the colour of the text to orange and makes it bold when that corresponding filter is selected
struct FilteringItemsView: View {
    let text: String
    let isSelected: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Text(text)
                    .font(.caption)
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundColor(isSelected ? Color.orange : Color(.systemGray))
            }
        }
    }
}
