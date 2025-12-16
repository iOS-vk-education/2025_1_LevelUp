//
//  CompletedHabits.swift
//  LevelUp
//
//  Created by dimss on 01/12/2025.
//

import SwiftUI

class CompletedHabits {
    static let shared = CompletedHabits()
    
    private init() {}

    @AppStorage("completedHabitsCount")
    private(set) var count: Int = 0

    func add() {
        count += 1
    }
}
