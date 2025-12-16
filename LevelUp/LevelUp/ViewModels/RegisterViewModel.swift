//
//  RegisterViewModel.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var phone = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var showPassword = false
    @Published var showConfirmPassword = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    func togglePasswordVisibility() {
        showPassword.toggle()
    }
    
    func toggleConfirmPasswordVisibility() {
        showConfirmPassword.toggle()
    }
    
    func register(completion: @escaping (Bool) -> Void) {
        guard isFormValid else {
            if password != confirmPassword {
                errorMessage = "Пароли не совпадают"
            } else {
                errorMessage = "Заполните все поля"
            }
            showError = true
            completion(false)
            return
        }
        
        // Проверка минимальной длины пароля
        guard password.count >= 6 else {
            errorMessage = "Пароль должен содержать минимум 6 символов"
            showError = true
            completion(false)
            return
        }
        
        isLoading = true
        errorMessage = nil
        showError = false
        
        // Конвертируем телефон в email
        let email = convertPhoneToEmail(phone)
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = self.getErrorMessage(from: error)
                    self.showError = true
                    completion(false)
                } else if let user = authResult?.user {
                    // Обновляем профиль пользователя с именем
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = self.name
                    changeRequest.commitChanges { profileError in
                        DispatchQueue.main.async {
                            if let profileError = profileError {
                                print("Ошибка при обновлении профиля: \(profileError.localizedDescription)")
                            }
                            completion(true)
                        }
                    }
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
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                return "Аккаунт с таким телефоном уже существует"
            case AuthErrorCode.invalidEmail.rawValue:
                return "Неверный формат телефона"
            case AuthErrorCode.weakPassword.rawValue:
                return "Пароль слишком слабый"
            case AuthErrorCode.networkError.rawValue:
                return "Ошибка сети. Проверьте подключение"
            default:
                return "Ошибка регистрации: \(error.localizedDescription)"
            }
        }
        return error.localizedDescription
    }
    
    var isFormValid: Bool {
        !name.isEmpty &&
        !phone.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty
    }
    
    var passwordsMatch: Bool {
        password == confirmPassword
    }
}

