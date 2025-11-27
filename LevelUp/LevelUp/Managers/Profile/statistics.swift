//
//  statistics.swift
//  LevelUp
//
//  Created by dimss on 27/11/2025.
//

import Foundation
import SwiftUI

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


class Statistics {
    @AppStorage("xpPoints") var xpPoints: [Point] = []
    
    func addXPPoint(point: Point) {
        xpPoints.append(point)
    }
    
    func delXPPoint(point: Point) {
        let idx = xpPoints.lastIndex { idx in idx.id == point.id }
        if let safeIdx = idx {
            xpPoints.remove(at: safeIdx)
        }
    }
}
