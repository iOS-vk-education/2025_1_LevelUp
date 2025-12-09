import SwiftUI

enum HabitTag: String, CaseIterable {
    case primary
    case secondary
    case light

    var title: String {
        switch self {
        case .primary: return "Primary"
        case .secondary: return "Secondary"
        case .light: return "Light"
        }
    }

    var color: Color {
        switch self {
        case .primary: return .red
        case .secondary: return .orange
        case .light: return .green
        }
    }
}

