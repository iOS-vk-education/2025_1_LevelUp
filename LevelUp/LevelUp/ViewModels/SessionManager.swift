import SwiftUI
import Combine

@MainActor
final class SessionManager: ObservableObject {
    @Published var isAuthenticated: Bool

    init() {
        _isAuthenticated = Published(initialValue: false)
    }

    func signIn() {
        isAuthenticated = true
    }

    func signOut() {
        isAuthenticated = false
    }
}
