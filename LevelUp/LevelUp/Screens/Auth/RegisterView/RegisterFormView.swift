//
//  RegisterFormView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/18/25.
//

import SwiftUI

struct RegisterFormView: View {
    @ObservedObject var viewModel: RegisterViewModel
    let onSuccess: () -> Void
    
    var body: some View {
        VStack(spacing: UIConstants.Spacing.medium) {
            InputFieldView(
                title: "Имя *",
                placeholder: "Введите имя",
                text: $viewModel.name
            )
            .disabled(viewModel.isLoading)
            
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
            
            PasswordInputView(
                title: "Подтверждение пароля *",
                placeholder: "Повторите пароль",
                text: $viewModel.confirmPassword,
                isVisible: $viewModel.showConfirmPassword
            )
            .disabled(viewModel.isLoading)
            
            if viewModel.showError, let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            FormButton(title: viewModel.isLoading ? "Регистрация..." : "Создать аккаунт") {
                viewModel.register { success in
                    if success {
                        onSuccess()
                    }
                }
            }
            .disabled(viewModel.isLoading || !viewModel.isFormValid)
            
            if !viewModel.confirmPassword.isEmpty && !viewModel.passwordsMatch {
                Text("Пароли не совпадают")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    RegisterFormView(viewModel: RegisterViewModel(), onSuccess: {})
}
