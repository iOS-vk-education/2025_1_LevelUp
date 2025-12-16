import SwiftUI

struct RootView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var habitViewModel = HabitViewModel()

    var body: some View {
        Group {
            if sessionManager.isAuthenticated {
                ContentView()
                    .environmentObject(habitViewModel)
            } else {
                NavigationStack {
                    AuthView()
                }
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(SessionManager())
        .environmentObject(HabitViewModel())
}
