//
//  LoginViewModel.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var phone = ""
    @Published var password = ""
    @Published var showPassword = false

    func login() {
        print("Logging in user with phone: \(phone)")
    }
    
    var isFormValid: Bool {
        !phone.isEmpty && !password.isEmpty
    }
}
