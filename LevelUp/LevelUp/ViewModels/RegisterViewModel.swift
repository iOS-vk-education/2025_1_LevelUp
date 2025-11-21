//
//  RegisterViewModel.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var phone = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var showPassword = false
    @Published var showConfirmPassword = false
    
    func togglePasswordVisibility() {
        showPassword.toggle()
    }
    
    func toggleConfirmPasswordVisibility() {
        showConfirmPassword.toggle()
    }
    
    func register() {
        print("Registering user: \(name), phone: \(phone)")
    }
    
    var isFormValid: Bool {
        !name.isEmpty &&
        !phone.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        password == confirmPassword
    }
}

