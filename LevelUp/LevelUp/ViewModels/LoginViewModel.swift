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

    func login(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let phoneCopy = phone

        // Здесь должен быть твой реальный логин (по телефону/паролю, через код и т.п.)
        // Пока что используем FirebaseAuth по email/паролю как пример структуры.
        Auth.auth().signIn(withEmail: phoneCopy, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            Task {
                do {
                    let profile = try await UserProfileService.shared.ensureCurrentUserProfile(phone: phoneCopy)
                    completion(.success(profile))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    var isFormValid: Bool {
        !phone.isEmpty && !password.isEmpty
    }
}
