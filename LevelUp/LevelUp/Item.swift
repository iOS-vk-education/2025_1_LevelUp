//
//  Item.swift
//  LevelUp
//
//  Created by Андрей Прибавкин on 9.11.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
