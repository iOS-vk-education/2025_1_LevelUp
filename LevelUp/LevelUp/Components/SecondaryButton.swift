//
//  SecondaryButton.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(UIConstants.Fonts.button)
                .foregroundColor(Color("LoginColorText"))
                .frame(maxWidth: .infinity)
                .frame(height: UIConstants.Sizes.buttonHeight)
        }
        .background(.ultraThinMaterial)
        .cornerRadius(UIConstants.Sizes.buttonCornerRadius)
    }
}

#Preview {
    SecondaryButton(title: "Button") {
        print("Tapped")
    }
    .padding()
}

