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

// Source - https://stackoverflow.com/a
// Posted by pawello2222
// Retrieved 2025-11-27, License - CC BY-SA 4.0

extension Array: @retroactive RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

class Statistics: ObservableObject {
    @AppStorage("xpPoints") var storedXpPoints: [Point] = []
    @Published var xpPoints: [Point] = [] {
        didSet {
            storedXpPoints = xpPoints
        }
    }

    static let shared = Statistics()
    
    private init() {
        xpPoints = storedXpPoints
    }
    
    func addXPPoint(point: Point) {
        xpPoints.append(point)
    }
    
    func delXPPoint(point: Point) {
        let idx = xpPoints.lastIndex { idx in idx.id == point.id }
        if let safeIdx = idx {
            xpPoints.remove(at: safeIdx)
        }
    }
    
    let xpByLevel = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
    
    struct LevelInfo {
        let level: Int
        let currentLevelXP: Int
        let nextLevelXP: Int
    }
    
    func getLevelInfo() -> LevelInfo {
        var totalXP = xpPoints.reduce(0) { a, b in a + b.value }
        for i in 0..<xpByLevel.count {
            if totalXP < xpByLevel[i] {
                return LevelInfo(level: i + 1, currentLevelXP: totalXP, nextLevelXP: xpByLevel[i])
            }
            totalXP -= xpByLevel[i]
        }
        return LevelInfo(level: xpByLevel.count + 1, currentLevelXP: 0, nextLevelXP: 0)
    }
}
