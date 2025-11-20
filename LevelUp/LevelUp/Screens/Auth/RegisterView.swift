//
//  RegisterView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/18/25.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        AuthScreenContainer {
            RegisterHeaderView()
            RegisterFormView(viewModel: viewModel)
            AuthFooterView(
                questionText: "Уже есть аккаунт?",
                linkText: "Войти"
            ) {
                LoginView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}

