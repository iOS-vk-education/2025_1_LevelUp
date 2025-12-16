//
//  PrimaryButton.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    @Environment(\.isEnabled) private var isEnabled
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(UIConstants.Fonts.button)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: UIConstants.Sizes.buttonHeight)
        }
        .background(isEnabled ? Color("ButColor") : Color.gray.opacity(0.5))
        .cornerRadius(UIConstants.Sizes.buttonCornerRadius)
    }
}

#Preview {
    PrimaryButton(title: "Button") {
        print("Tapped")
    }
    .padding()
}

