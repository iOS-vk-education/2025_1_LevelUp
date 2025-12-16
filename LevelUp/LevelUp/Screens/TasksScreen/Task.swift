import SwiftUI

enum TaskTag: String, CaseIterable {
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

struct Task: Identifiable, Equatable {
    let id: UUID = UUID()
    var title: String
    var description: String = ""
    var isCompleted: Bool = false
    var date: Date = Date()
    var tag: TaskTag? = nil
}
