//
//  LoginViewModel.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth

@MainActor
class LoginViewModel: ObservableObject {
    @Published var phone = ""
    @Published var password = ""
    @Published var showPassword = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    func login(completion: @escaping (Bool) -> Void) {
        guard isFormValid else {
            errorMessage = "Заполните все поля"
            showError = true
            completion(false)
            return
        }
        
        isLoading = true
        errorMessage = nil
        showError = false
        
        // Конвертируем телефон в email (или используем телефон напрямую, если настроен Phone Auth)
        // Для простоты используем email формат: phone@levelup.app
        let email = convertPhoneToEmail(phone)
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = self.getErrorMessage(from: error)
                    self.showError = true
                    completion(false)
                } else if authResult != nil {
                    completion(true)
                } else {
                    self.errorMessage = "Неизвестная ошибка"
                    self.showError = true
                    completion(false)
                }
            }
        }
    }
    
    private func convertPhoneToEmail(_ phone: String) -> String {
        // Убираем все нецифровые символы
        let cleanedPhone = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return "\(cleanedPhone)@levelup.app"
    }
    
    private func getErrorMessage(from error: Error) -> String {
        if let authError = error as NSError? {
            switch authError.code {
            case AuthErrorCode.userNotFound.rawValue:
                return "Пользователь не найден"
            case AuthErrorCode.wrongPassword.rawValue:
                return "Неверный пароль"
            case AuthErrorCode.invalidEmail.rawValue:
                return "Неверный формат телефона"
            case AuthErrorCode.userDisabled.rawValue:
                return "Аккаунт заблокирован"
            case AuthErrorCode.networkError.rawValue:
                return "Ошибка сети. Проверьте подключение"
            case AuthErrorCode.tooManyRequests.rawValue:
                return "Слишком много попыток. Попробуйте позже"
            default:
                return "Ошибка авторизации: \(error.localizedDescription)"
            }
        }
        return error.localizedDescription
    }
    
    var isFormValid: Bool {
        !phone.isEmpty && !password.isEmpty
    }
}
