import SwiftUI
import Combine

@MainActor
final class SessionManager: ObservableObject {
    @Published var isAuthenticated: Bool
    @Published var currentUser: UserProfile?

    init() {
        _isAuthenticated = Published(initialValue: false)
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
