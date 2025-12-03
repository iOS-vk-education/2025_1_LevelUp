//
//  Acheevement.swift
//  LevelUp
//
//  Created by dimss on 22/11/2025.
//

import Foundation
import SwiftUI
import Combine


class Achievement: Identifiable, ObservableObject {
    let id = UUID()
    let title: String
    let description: String
    let goal: Int
    let tint: Color
    let icon: Image
    let wage: Int
    private let getCurrent: () -> Int

    @Published
    private(set) var achievedOn: Date? = nil

    init(
        title: String,
        description: String,
        goal: Int,
        tint: Color,
        icon: Image,
        wage: Int,
        getCurrent: @escaping () -> Int,
    ) {
        self.title = title
        self.description = description
        self.goal = goal
        self.tint = tint
        self.icon = icon
        self.wage = wage
        self.getCurrent = getCurrent
    }

    var isCompleted: Bool {
        return achievedOn != nil
    }
    
    @Published
    private var _currentScore: Int = 0
    var currentScore: Int {
        _currentScore
    }
    
    func recalculate() {
        guard !isCompleted else { return }
        _currentScore = getCurrent()
        if _currentScore >= goal {
            achievedOn = Date()
            Statistics.shared.addExtraWage(wage)
        }
    }
}

let TasksLordAch = Achievement(
    title: "Покоритель задач",
    description: "Выполните первую задачу",
    goal: 1,
    tint: .green,
    icon: Image(systemName: "checkmark.seal.fill"),
    wage: 10,
    getCurrent: { Statistics.shared.xpPoints.count }
)
        
let TasksLord2Ach = Achievement(
    title: "Покоритель задач 2",
    description: "Выполните 100 задач",
    goal: 100,
    tint: .green,
    icon: Image(systemName: "checkmark.seal.fill"),
    wage: 10,
    getCurrent: { Statistics.shared.xpPoints.count }
)

let TasksLord3Ach = Achievement(
    title: "Покоритель задач 3",
    description: "Выполните 1000 задач",
    goal: 1000,
    tint: .green,
    icon: Image(systemName: "checkmark.seal.fill"),
    wage: 10,
    getCurrent: { Statistics.shared.xpPoints.count }
)


let LevelUpAch = Achievement(
    title: "LevelUp",
    description: "Достигните второго уровня",
    goal: 2,
    tint: .yellow,
    icon: Image(systemName: "chevron.up.2"),
    wage: 10,
    getCurrent: { Statistics.shared.getLevelInfo().level }
)

let LevelUp2Ach = Achievement(
    title: "LevelUp 2",
    description: "Достигните 10 уровня",
    goal: 10,
    tint: .yellow,
    icon: Image(systemName: "chevron.up.2"),
    wage: 10,
    getCurrent: { Statistics.shared.getLevelInfo().level }
)

let LevelUp3Ach = Achievement(
    title: "LevelUp 3",
    description: "Достигните 50 уровня",
    goal: 50,
    tint: .yellow,
    icon: Image(systemName: "chevron.up.2"),
    wage: 10,
    getCurrent: { Statistics.shared.getLevelInfo().level }
)

let ProductivemorningAch = Achievement(
    title: "Продуктивное утро",
    description: "Выполните задачу от 5:00 до 9:00 утра",
    goal: 1,
    tint: .pink,
    icon: Image(systemName: "sunrise.fill"),
    wage: 10,
    getCurrent: {
        return Statistics.shared.xpPoints.count { point in
            let calendar = Calendar.current
            let h = calendar.component(.hour, from: point.date)
            return 5 <= h && h <= 9
        }
    }
)


let HabitsIsAllWeHaveAch = Achievement(
    title: "Привычки наше все",
    description: "Внедрите первую привычку",
    goal: 1,
    tint: .red,
    icon: Image(systemName: "repeat.circle.fill"),
    wage: 10,
    getCurrent: {
        CompletedHabits.shared.count
    }
)

let HabitsIsAllWeHave2Ach = Achievement(
    title: "Привычки наше все 2",
    description: "Внедрите 10 привычек",
    goal: 10,
    tint: .red,
    icon: Image(systemName: "repeat.circle.fill"),
    wage: 10,
    getCurrent: {
        CompletedHabits.shared.count
    }
)

let HabitsIsAllWeHave3Ach = Achievement(
    title: "Привычки наше все 3",
    description: "Внедрите 100 привычек",
    goal: 100,
    tint: .red,
    icon: Image(systemName: "repeat.circle.fill"),
    wage: 10,
    getCurrent: {
        CompletedHabits.shared.count
    }
)


private func countProductiveDays() -> Int {
    var count = 0
    var lastDay: DateComponents? = nil
    var currentSum = 0
    for point in Statistics.shared.xpPoints {
        let calendar = Calendar.current
        let day = calendar.dateComponents([.day, .month, .year], from: point.date)
        let xp = point.value
        if day != lastDay {
            if currentSum >= 300 {
                count += 1;
            }
            lastDay = day
            currentSum = xp
        } else {
            currentSum += xp
        }
    }
    if currentSum >= 300 {
        count += 1
    }
    return count
}

let ProductiveDayAch = Achievement(
    title: "Продуктивный день",
    description: "Заработайте за день 300 xp",
    goal: 1,
    tint: .purple,
    icon: Image(systemName: "brain.head.profile"),
    wage: 10,
    getCurrent: countProductiveDays
)

let ProductiveDay2Ach = Achievement(
    title: "Продуктивный день 2",
    description: "Заработайте за день 300 xp 10 раз",
    goal: 10,
    tint: .purple,
    icon: Image(systemName: "brain.head.profile"),
    wage: 10,
    getCurrent: countProductiveDays
)

let ProductiveDay3Ach = Achievement(
    title: "Продуктивный день 3",
    description: "Заработайте за день 300 xp 100 раз",
    goal: 100,
    tint: .purple,
    icon: Image(systemName: "brain.head.profile"),
    wage: 10,
    getCurrent: countProductiveDays
)


let AlwaysCompletedAch = Achievement(
    title: "Достижение для тестирования",
    description: "Ничего не надо делать",
    goal: 0,
    tint: .red,
    icon: Image(systemName: "party.popper.fill"),
    wage: 1000,
    getCurrent: {
        return 1
    }
)


final class AchievementsStorage: ObservableObject {
    static let shared = AchievementsStorage()

    @Published var achs: [Achievement] = [
        AlwaysCompletedAch,
        TasksLordAch,
        TasksLord2Ach,
        TasksLord3Ach,
        LevelUpAch,
        LevelUp2Ach,
        LevelUp3Ach,
        ProductivemorningAch,
        HabitsIsAllWeHaveAch,
        HabitsIsAllWeHave2Ach,
        HabitsIsAllWeHave3Ach,
        ProductiveDayAch,
        ProductiveDay2Ach,
        ProductiveDay3Ach,
    ]
    
    @Published
    private(set) var nCompleted = 0

    private init() {
        nCompleted = achs.count { ach in ach.isCompleted }
    }
    
    func recalculateAll() {
        achs.forEach { $0.recalculate() }
        nCompleted = achs.count { ach in ach.isCompleted }
    }
}
