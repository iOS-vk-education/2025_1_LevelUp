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
            
            PasswordInputView(
                title: "Пароль *",
                placeholder: "Введите пароль",
                text: $viewModel.password,
                isVisible: $viewModel.showPassword
            )
            
            FormButton(title: "Войти") {
                guard viewModel.isFormValid else { return }
                viewModel.login { result in
                    switch result {
                    case .success:
                        onSuccess()
                    case .failure(let error):
                        print("Login error:", error.localizedDescription)
                    }
                }
            }
        }
    }
}

#Preview {
    LoginFormView(viewModel: LoginViewModel(), onSuccess: {})
}
