import SwiftUI
import Combine

@MainActor
final class SessionManager: ObservableObject {
    @Published var isAuthenticated: Bool
    @Published var currentUser: UserProfile?

    init() {
        // Проверяем текущее состояние авторизации
        checkAuthState()
        
        // Слушаем изменения состояния авторизации
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
            
            // При входе пользователя подтягиваем прогресс из Firebase,
            // чтобы опыт и достижения, полученные ранее (в том числе через "Добавить XP"),
            // восстановились.
            if user != nil {
                _Concurrency.Task {
                    try? await ProgressService.shared.loadCurrentUserProgress()
                }
            }
        }
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func checkAuthState() {
        currentUser = Auth.auth().currentUser
        isAuthenticated = currentUser != nil
    }

    func signIn() {
        isAuthenticated = true
    }

    func signOut() {
        isAuthenticated = false
        currentUser = nil
    }

    func setAuthenticated(profile: UserProfile) {
        currentUser = profile
        isAuthenticated = true
    }
}
