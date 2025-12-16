import SwiftUI
import Combine
import FirebaseAuth

@MainActor
final class SessionManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?

    init() {
        // Проверяем текущее состояние авторизации
        checkAuthState()
        
        // Слушаем изменения состояния авторизации
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isAuthenticated = user != nil
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
        // Метод вызывается после успешной авторизации
        // Состояние обновится автоматически через listener
        checkAuthState()
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            isAuthenticated = false
        } catch {
            print("Ошибка при выходе: \(error.localizedDescription)")
        }
    }
}
