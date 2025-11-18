//
//  Task.swift
//  
//
//  Created by Андрей Прибавкин on 13.11.25.
//

import Foundation

struct Task: Identifiable {
    let id: UUID = UUID()
    var title: String
    var isCompleted: Bool = false
    var date: Date = Date()
}
