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
            
            PhoneInputView(
                title: "Телефон *",
                placeholder: "+7 987 123-23-23",
                text: $viewModel.phone
            )
            
            PasswordInputView(
                title: "Пароль *",
                placeholder: "Введите пароль",
                text: $viewModel.password,
                isVisible: $viewModel.showPassword
            )
            
            PasswordInputView(
                title: "Подтверждение пароля *",
                placeholder: "Повторите пароль",
                text: $viewModel.confirmPassword,
                isVisible: $viewModel.showConfirmPassword
            )
            
            FormButton(title: "Создать аккаунт") {
                viewModel.register()
                if viewModel.isFormValid {
                    onSuccess()
                }
            }
        }
    }
}

#Preview {
    RegisterFormView(viewModel: RegisterViewModel(), onSuccess: {})
}
