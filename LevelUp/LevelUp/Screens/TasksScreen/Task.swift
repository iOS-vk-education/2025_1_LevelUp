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
    let id: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    var date: Date
    var tag: TaskTag?
    var minutesSpent: Int

    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        isCompleted: Bool = false,
        date: Date = Date(),
        tag: TaskTag? = nil,
        minutesSpent: Int = 0
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.date = date
        self.tag = tag
        self.minutesSpent = minutesSpent
    }
}
