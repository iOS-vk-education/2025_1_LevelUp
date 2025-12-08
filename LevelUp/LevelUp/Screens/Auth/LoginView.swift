//
//  LoginView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/18/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject private var sessionManager: SessionManager
    
    var body: some View {
        AuthScreenContainer {
            LoginHeaderView()
            LoginFormView(
                viewModel: viewModel,
                onSuccess: { sessionManager.signIn() }
            )
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
    .environmentObject(SessionManager())
}
