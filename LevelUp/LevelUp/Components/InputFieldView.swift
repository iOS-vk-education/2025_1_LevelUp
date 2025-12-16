//
//  InputFieldView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import SwiftUI
import UIKit

struct InputFieldView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.formSpacing) {
            Text(title)
                .font(UIConstants.Fonts.caption)
                .foregroundColor(UIConstants.Colors.textBlack)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding()
                .background(UIConstants.Colors.backgroundGray)
                .cornerRadius(UIConstants.Sizes.cornerRadius)
        }
        .padding(.horizontal, UIConstants.Spacing.large)
    }
}

#Preview {
    InputFieldView(
        title: "Имя *",
        placeholder: "Введите имя",
        text: .constant("")
    )
}

