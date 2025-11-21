//
//  AuthButtonsView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import SwiftUI

struct AuthButtonsView: View {
    var body: some View {
        VStack(spacing: UIConstants.Spacing.medium) {
            AuthButton(style: .primary, title: "Зарегистрироваться") {
                RegisterView()
            }
            
            AuthButton(style: .secondary, title: "Войти") {
                LoginView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        AuthButtonsView()
    }
}

