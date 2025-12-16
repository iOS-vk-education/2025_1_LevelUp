//
//  PasswordInputView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import SwiftUI

struct PasswordInputView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.formSpacing) {
            Text(title)
                .font(UIConstants.Fonts.caption)
                .foregroundColor(UIConstants.Colors.textBlack)
            
            HStack {
                if isVisible {
                    TextField(placeholder, text: $text)
                } else {
                    SecureField(placeholder, text: $text)
                }
                
                Button(action: {
                    isVisible.toggle()
                }) {
                    Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(UIConstants.Colors.textGray)
                }
            }
            .padding()
            .background(UIConstants.Colors.backgroundGray)
            .cornerRadius(UIConstants.Sizes.cornerRadius)
        }
        .padding(.horizontal, UIConstants.Spacing.large)
    }
}

#Preview {
    PasswordInputView(
        title: "Пароль *",
        placeholder: "Введите пароль",
        text: .constant(""),
        isVisible: .constant(false)
    )
}

