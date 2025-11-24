//
//  Acheevement.swift
//  LevelUp
//
//  Created by dimss on 22/11/2025.
//

import SwiftUI

struct Achievement: Identifiable {
    let id: UUID = UUID()
    let title: String
    let description: String
    let acheevedOn: Date?
    let tint: Color
    let wage: Int
    let completed: Bool
}


let achievements: [Achievement] = [
    Achievement(
        title: "Первый шаг",
        description: "Выполнена первая задача",
        acheevedOn: nil,
        tint: .blue,
        wage: 10,
        completed: true,
    ),
    Achievement(
        title: "Десятка",
        description: "Заработан 10-ый уровень",
        acheevedOn: nil,
        tint: .pink,
        wage: 100,
        completed: true,
    ),
    Achievement(
        title: "Удачный день",
        description: "Выполните все задания на день 10 раз",
        acheevedOn: nil,
        tint: .green,
        wage: 100,
        completed: false
    ),
    Achievement(
        title: "Маленькие шаги",
        description: "Выработайте первую привычку",
        acheevedOn: nil,
        tint: .green,
        wage: 100,
        completed: false,
    ),
]
