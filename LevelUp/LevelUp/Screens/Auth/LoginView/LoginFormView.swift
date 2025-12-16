//
//  LoginFormView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import SwiftUI

struct LoginFormView: View {
    @ObservedObject var viewModel: LoginViewModel
    let onSuccess: () -> Void
    
    var body: some View {
        VStack(spacing: UIConstants.Spacing.medium) {
            PhoneInputView(
                title: "Телефон *",
                placeholder: "+7 987 123-23-23",
                text: $viewModel.phone
            )
            .disabled(viewModel.isLoading)
            
            PasswordInputView(
                title: "Пароль *",
                placeholder: "Введите пароль",
                text: $viewModel.password,
                isVisible: $viewModel.showPassword
            )
            .disabled(viewModel.isLoading)
            
            if viewModel.showError, let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            FormButton(title: viewModel.isLoading ? "Вход..." : "Войти") {
                viewModel.login { success in
                    if success {
                        onSuccess()
                    }
                }
            }
            .disabled(viewModel.isLoading || !viewModel.isFormValid)
        }
    }
}

#Preview {
    LoginFormView(viewModel: LoginViewModel(), onSuccess: {})
}
