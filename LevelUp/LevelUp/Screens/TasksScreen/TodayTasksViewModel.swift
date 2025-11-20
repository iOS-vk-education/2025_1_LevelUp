//
//  TodayTasksViewModel.swift
//  
//
//  Created by Андрей Прибавкин on 13.11.25.
//

import Foundation
import Combine

final class TodayTasksViewModel: ObservableObject {
    @Published private(set) var allTasks: [Task] = []
    @Published var selectedDate: Date = Date()
    
    private let calendar = Calendar.current
    
    var todayTasks: [Task] {
        tasks(for: selectedDate, completed: false)
    }
    
    var doneTasks: [Task] {
        tasks(for: selectedDate, completed: true)
    }
    
    init() {
        // Временные тестовые данные
        allTasks = [
            Task(title:"Walk the dog"),
            Task(title:"Eat"),
            Task(title:"Sleep")
        ]
    }
    
    func tasks(for date: Date, completed: Bool) -> [Task] {
        allTasks.filter { task in
            calendar.isDate(task.date, inSameDayAs: date) &&
            task.isCompleted == completed
        }
    }
    
    func toggleCompletion(for task:Task) {
        guard let index = allTasks.firstIndex(where: { $0.id == task.id }) else { return }
        allTasks[index].isCompleted.toggle()
    }
    
    func addTask(title: String) {
        let newTask = Task(title: title)
        allTasks.append(newTask)
    }
}
