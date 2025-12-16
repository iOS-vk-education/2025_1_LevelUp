//
//  statistics.swift
//  LevelUp
//
//  Created by dimss on 27/11/2025.
//

import Foundation
import SwiftUI
import Combine


struct Point: Codable {
    var id: UUID = UUID()
    
    let date: Date
    let value: Int
}


struct LevelInfo {
    let level: Int
    let currentLevelXP: Int
    let nextLevelXP: Int
}

@Observable
class Statistics {
    @ObservationIgnored
    let defaults = UserDefaults.standard
    
    var xpPoints: [Point] = [] {
        didSet {
            if let data = try? JSONEncoder().encode(xpPoints) {
                defaults.set(data, forKey: "xpPoints")
            }
        }
    }
    
    var extraXpWage: Int = 0 {
        didSet {
            defaults.set(extraXpWage, forKey: "extraXpWage")
        }
    }
    
    static let shared = Statistics()
    
    private init() {
        if let data = defaults.object(forKey: "xpPoints") as? Data {
            xpPoints = (try? JSONDecoder().decode([Point].self, from: data)) ?? []
        }
        
        extraXpWage = defaults.integer(forKey: "extraXpWage")
    }
    
    func addXPPoint(point: Point) {
        xpPoints.append(point)
    }
    
    func delXPPoint(point: Point) {
        if let idx = xpPoints.lastIndex(where: { idx in idx.id == point.id }) {
            xpPoints.remove(at: idx)
        }
    }
    
    @ObservationIgnored
    private var xpForNextLvl: [Int] {
        var xp: [Int] = [30, 60, 120]
        for _ in 5...10 {
            xp.append(xp.last! + 30)
        }
        assert(xp.last! == 300)
        xp += [420, 780, 1500, 1560]
        for _ in 15...40 {
            xp.append(xp.last! + 300)
        }
        assert(xp.last! == 9360)
        return xp
    }
    
    func getLevelInfo() -> LevelInfo {
        var totalXP = cheatXp
        
        totalXP += xpPoints.reduce(0) { a, b in a + b.value }
        totalXP += extraXpWage
        for i in 0..<xpForNextLvl.count {
            if totalXP < xpForNextLvl[i] {
                return LevelInfo(level: i + 1, currentLevelXP: totalXP, nextLevelXP: xpForNextLvl[i])
            }
            totalXP -= xpForNextLvl[i]
        }
        return LevelInfo(level: xpForNextLvl.count + 1, currentLevelXP: 0, nextLevelXP: 0)
    }
    
    func addExtraWage(_ amount: Int) {
        extraXpWage += amount
    }
    
    // :MARK: for debug only
    var cheatXp: Int = 0
    
    func addCheatXp(_ amount: Int) {
        cheatXp += amount
    }
}
