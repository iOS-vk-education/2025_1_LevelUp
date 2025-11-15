//
//  Task.swift
//  
//
//  Created by Андрей Прибавкин on 13.11.25.
//

import Foundation


// each element must have id
struct Task: Identifiable {
    let id: UUID = UUID()
    var title: String
    var isCompleted: Bool = false
    var date: Date = Date()
}
