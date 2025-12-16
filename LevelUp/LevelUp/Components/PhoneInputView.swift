//
//  PhoneInputView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import SwiftUI

struct PhoneInputView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.formSpacing) {
            Text(title)
                .font(UIConstants.Fonts.caption)
                .foregroundColor(UIConstants.Colors.textBlack)
            
            TextField(placeholder, text: $text)
                .keyboardType(.phonePad)
                .padding()
                .background(UIConstants.Colors.backgroundGray)
                .cornerRadius(UIConstants.Sizes.cornerRadius)
        }
        .padding(.horizontal, UIConstants.Spacing.large)
    }
}

#Preview {
    PhoneInputView(
        title: "Телефон *",
        placeholder: "+7 987 123-23-23",
        text: .constant("")
    )
}

