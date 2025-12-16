//
//  Acheevement.swift
//  LevelUp
//
//  Created by dimss on 22/11/2025.
//

import Foundation
import SwiftUI
import Combine


@Observable
class Achievement: Identifiable {
    let id: Int
    let title: String
    let description: String
    let goal: Int
    let tint: Color
    let icon: Image
    let wage: Int
    private let getCurrent: () -> Int

    private(set) var achievedOn: Date? = nil {
        didSet {
            defaults.set(achievedOn, forKey: "achievedOn_\(id)")
        }
    }
    private(set) var currentScore: Int = 0 {
        didSet {
            defaults.set(currentScore, forKey: "currentScore_\(id)")
        }
    }
    
    @ObservationIgnored
    private let defaults = UserDefaults.standard
    
    fileprivate init(
        id: Int,
        title: String,
        description: String,
        goal: Int,
        tint: Color,
        icon: Image,
        wage: Int,
        getCurrent: @escaping () -> Int,
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.goal = goal
        self.tint = tint
        self.icon = icon
        self.wage = wage
        self.getCurrent = getCurrent

        if let value = defaults.object(forKey: "achievedOn_\(id)") as? Date {
            achievedOn = value
        }
        currentScore = defaults.integer(forKey: "currentScore_\(id)")
    }

    var isCompleted: Bool {
        return achievedOn != nil
    }
    
    func recalculate() {
        guard !isCompleted else { return }
        currentScore = getCurrent()
        if currentScore >= goal {
            achievedOn = Date()
            Statistics.shared.addExtraWage(wage)
            AchievementsStorage.shared.nCompleted += 1
        }
    }
}

let TasksLordAch = Achievement(
    id: 1,
    title: "Покоритель задач",
    description: "Выполните первую задачу",
    goal: 1,
    tint: .green,
    icon: Image(systemName: "checkmark.seal.fill"),
    wage: 10,
    getCurrent: { Statistics.shared.xpPoints.count }
)

let TasksLord2Ach = Achievement(
    id: 2,
    title: "Покоритель задач 2",
    description: "Выполните 100 задач",
    goal: 100,
    tint: .green,
    icon: Image(systemName: "checkmark.seal.fill"),
    wage: 10,
    getCurrent: { Statistics.shared.xpPoints.count }
)

let TasksLord3Ach = Achievement(
    id: 3,
    title: "Покоритель задач 3",
    description: "Выполните 1000 задач",
    goal: 1000,
    tint: .green,
    icon: Image(systemName: "checkmark.seal.fill"),
    wage: 10,
    getCurrent: { Statistics.shared.xpPoints.count }
)


func getCurrentLevel() -> Int {
    return Statistics.shared.getLevelInfo().level
}

let LevelUpAch = Achievement(
    id: 4,
    title: "LevelUp",
    description: "Достигните второго уровня",
    goal: 2,
    tint: .orange,
    icon: Image(systemName: "chevron.up.2"),
    wage: 10,
    getCurrent: getCurrentLevel
)

let LevelUp2Ach = Achievement(
    id: 5,
    title: "LevelUp 2",
    description: "Достигните 10 уровня",
    goal: 10,
    tint: .orange,
    icon: Image(systemName: "chevron.up.2"),
    wage: 10,
    getCurrent: getCurrentLevel
)

let LevelUp3Ach = Achievement(
    id: 6,
    title: "LevelUp 3",
    description: "Достигните 50 уровня",
    goal: 50,
    tint: .orange,
    icon: Image(systemName: "chevron.up.2"),
    wage: 10,
    getCurrent: getCurrentLevel
)

let ProductivemorningAch = Achievement(
    id: 7,
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
    id: 8,
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
    id: 9,
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
    id: 10,
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
    id: 11,
    title: "Продуктивный день",
    description: "Заработайте за день 300 xp",
    goal: 1,
    tint: .purple,
    icon: Image(systemName: "brain.head.profile"),
    wage: 10,
    getCurrent: countProductiveDays
)

let ProductiveDay2Ach = Achievement(
    id: 12,
    title: "Продуктивный день 2",
    description: "Заработайте за день 300 xp 10 раз",
    goal: 10,
    tint: .purple,
    icon: Image(systemName: "brain.head.profile"),
    wage: 10,
    getCurrent: countProductiveDays
)

let ProductiveDay3Ach = Achievement(
    id: 13,
    title: "Продуктивный день 3",
    description: "Заработайте за день 300 xp 100 раз",
    goal: 100,
    tint: .purple,
    icon: Image(systemName: "brain.head.profile"),
    wage: 10,
    getCurrent: countProductiveDays
)


let AlwaysCompletedAch = Achievement(
    id: 14,
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


@Observable
final class AchievementsStorage {
    static let shared = AchievementsStorage()

    var achs: [Achievement] = [
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
    
    fileprivate(set) var nCompleted: Int = 0

    private init() {
    #if DEBUG
        achs.insert(AlwaysCompletedAch, at: 0)
    #endif
    }
}
