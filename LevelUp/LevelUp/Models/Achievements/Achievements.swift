//
//  Acheevement.swift
//  LevelUp
//
//  Created by dimss on 22/11/2025.
//

import Foundation
import SwiftUI

class Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    private(set) var achievedOn: Date? = nil
    let tint: Color
    let wage: Int
    
    let isCompletedNow: () -> Bool
    private var _hasEverCompleted: Bool = false
    var isCompleted: Bool {
        get {
            if _hasEverCompleted {
                return true
            }
            _hasEverCompleted = isCompletedNow()
            if _hasEverCompleted {
                achievedOn = Date()
            }
            return _hasEverCompleted
        }
        set {
            _hasEverCompleted = newValue
            if newValue && achievedOn == nil {
                achievedOn = Date()
            } else if !newValue {
                achievedOn = nil
            }
        }
    }

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
        return false
    }
)

let HabitsIsAllWeHave2Ach = Achievement(
    title: "Привычки наше все 2",
    description: "Внедрите 10 привычек",
    tint: .green,
    wage: 10,
    isCompleted: {
        return false
    }
)

let HabitsIsAllWeHave3Ach = Achievement(
    title: "Привычки наше все 3",
    description: "Внедрите 100 привычек",
    tint: .green,
    wage: 10,
    isCompleted: {
        return false
    }
)


let ProductiveDayAch = Achievement(
    title: "Продуктивный день",
    description: "Заработайте за день 300 xp",
    tint: .green,
    wage: 10,
    isCompleted: {
        return false
    }
)

let ProductiveDay2Ach = Achievement(
    title: "Продуктивный день 2",
    description: "Заработайте за день 300 xp 10 раз",
    tint: .green,
    wage: 10,
    isCompleted: {
        return false
    }
)

let ProductiveDay3Ach = Achievement(
    title: "Продуктивный день 3",
    description: "Заработайте за день 300 xp 100 раз",
    tint: .green,
    wage: 10,
    isCompleted: {
        return false
    }
)


let achievements: [Achievement] = [
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
