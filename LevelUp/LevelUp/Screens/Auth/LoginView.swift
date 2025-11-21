//
//  LoginView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/18/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        AuthScreenContainer {
            LoginHeaderView()
            LoginFormView(viewModel: viewModel)
            AuthFooterView(
                questionText: "Все еще нет аккаунта?",
                linkText: "Зарегистрироваться"
            ) {
                RegisterView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}

