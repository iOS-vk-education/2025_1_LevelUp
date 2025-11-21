//
//  AuthButton.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import SwiftUI

enum AuthButtonStyle {
    case primary
    case secondary
}

struct AuthButton: View {
    let style: AuthButtonStyle
    let title: String
    let destination: AnyView
    
    init(style: AuthButtonStyle, title: String, destination: () -> some View) {
        self.style = style
        self.title = title
        self.destination = AnyView(destination())
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(UIConstants.Fonts.button)
                .foregroundColor(style == .primary ? .white : Color("LoginColorText"))
                .frame(width: UIConstants.Sizes.buttonWidth, height: UIConstants.Sizes.buttonHeight)
                .background(backgroundView)
                .cornerRadius(UIConstants.Sizes.buttonCornerRadius)
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        if style == .primary {
            Color("ButColor")
        } else {
            Rectangle()
                .fill(.ultraThinMaterial)
        }
    }
}

#Preview {
    NavigationStack {
        VStack {
            AuthButton(style: .primary, title: "Зарегистрироваться") {
                Text("Register")
            }
            AuthButton(style: .secondary, title: "Войти") {
                Text("Login")
            }
        }
    }
}

