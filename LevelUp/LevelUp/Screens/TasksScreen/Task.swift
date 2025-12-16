import SwiftUI

enum TaskDifficulty: String, CaseIterable {
    case easy
    case medium
    case hard

    var title: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }

    var xpReward: Int {
        switch self {
        case .easy: return 50
        case .medium: return 100
        case .hard: return 200
        }
    }

    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .blue
        case .hard: return .purple
        }
    }
}

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
    var difficulty: TaskDifficulty = .medium
}
