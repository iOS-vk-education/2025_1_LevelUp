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
    let tint: Color
    let wage: Int
    let isCompletedNow: () -> Bool

    @Published
    private(set) var achievedOn: Date? = nil

    init(
        title: String,
        description: String,
        tint: Color,
        wage: Int,
        isCompleted: @escaping () -> Bool,
    ) {
        self.title = title
        self.description = description
        self.tint = tint
        self.wage = wage
        self.isCompletedNow = isCompleted
    }

    var isCompleted: Bool {
        get {
            return achievedOn != nil
        }
        set {
            guard newValue != (achievedOn != nil) else { return }

            achievedOn = newValue ? Date() : nil
        }
    }
    
    func recalculate() {
        guard !isCompleted else { return }
        if isCompletedNow() {
            achievedOn = Date()
        }
    }
}

let TasksLordAch = Achievement(
    title: "Покоритель задач",
    description: "Выполните первую задачу",
    tint: .blue,
    wage: 10,
    isCompleted: { !Statistics.shared.xpPoints.isEmpty }
)
        
let TasksLord2Ach = Achievement(
    title: "Покоритель задач 2",
    description: "Выполните 100 задач",
    tint: .blue,
    wage: 10,
    isCompleted: { Statistics.shared.xpPoints.count >= 100 }
)

let TasksLord3Ach = Achievement(
    title: "Покоритель задач 3",
    description: "Выполните 1000 задач",
    tint: .blue,
    wage: 10,
    isCompleted: { Statistics.shared.xpPoints.count >= 1000 }
)


let LevelUpAch = Achievement(
    title: "LevelUp",
    description: "Достигните второго уровня",
    tint: .green,
    wage: 10,
    isCompleted: { Statistics.shared.getLevelInfo().level >= 2 }
)

let LevelUp2Ach = Achievement(
    title: "LevelUp 2",
    description: "Достигните 10 уровня",
    tint: .green,
    wage: 10,
    isCompleted: { Statistics.shared.getLevelInfo().level >= 10 }
)

let LevelUp3Ach = Achievement(
    title: "LevelUp 3",
    description: "Достигните 50 уровня",
    tint: .green,
    wage: 10,
    isCompleted: { Statistics.shared.getLevelInfo().level >= 50 }
)

let ProductivemorningAch = Achievement(
    title: "Продуктивное утро",
    description: "Выполните задачу от 5:00 до 9:00 утра",
    tint: .green,
    wage: 10,
    isCompleted: {
        return Statistics.shared.xpPoints.contains { point in
            let calendar = Calendar.current
            let h = calendar.component(.hour, from: point.date)
            return 5 <= h && h <= 9
        }
    }
)


let HabitsIsAllWeHaveAch = Achievement(
    title: "Привычки наше все",
    description: "Внедрите первую привычку",
    tint: .green,
    wage: 10,
    isCompleted: {
        CompletedHabits.shared.count > 0
    }
)

let HabitsIsAllWeHave2Ach = Achievement(
    title: "Привычки наше все 2",
    description: "Внедрите 10 привычек",
    tint: .green,
    wage: 10,
    isCompleted: {
        CompletedHabits.shared.count >= 10
    }
)

let HabitsIsAllWeHave3Ach = Achievement(
    title: "Привычки наше все 3",
    description: "Внедрите 100 привычек",
    tint: .green,
    wage: 10,
    isCompleted: {
        CompletedHabits.shared.count >= 100
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
    tint: .green,
    wage: 10,
    isCompleted: {
        return countProductiveDays() > 0
    }
)

let ProductiveDay2Ach = Achievement(
    title: "Продуктивный день 2",
    description: "Заработайте за день 300 xp 10 раз",
    tint: .green,
    wage: 10,
    isCompleted: {
        return countProductiveDays() >= 10
    }
)

let ProductiveDay3Ach = Achievement(
    title: "Продуктивный день 3",
    description: "Заработайте за день 300 xp 100 раз",
    tint: .green,
    wage: 10,
    isCompleted: {
        return countProductiveDays() >= 300
    }
)


final class AchievementsStorage: ObservableObject {
    static let shared = AchievementsStorage()

    @Published var achs: [Achievement] = [
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
