import SwiftUI

struct Habit: Identifiable {
    let id: UUID
    var title: String
    var description: String
    var isDone: Bool
    let createdOn: Date
    var repeatDays: Set<Int> // 1...7 (Calendar.weekday)
    var skipDates: Set<Date>
    var endDate: Date?
    let iconName: String
    let tint: Color
    var minutesSpent: Int

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        isDone: Bool = false,
        createdOn: Date,
        repeatDays: Set<Int>,
        skipDates: Set<Date> = [],
        endDate: Date? = nil,
        iconName: String,
        tint: Color,
        minutesSpent: Int = 0
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isDone = isDone
        self.createdOn = createdOn
        self.repeatDays = repeatDays
        self.skipDates = skipDates
        self.endDate = endDate
        self.iconName = iconName
        self.tint = tint
        self.minutesSpent = minutesSpent
    }
}
