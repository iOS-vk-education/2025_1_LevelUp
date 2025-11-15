//
//  TodayTasksViewModel.swift
//  
//
//  Created by Андрей Прибавкин on 13.11.25.
//

import Foundation
import Combine

final class TodayTasksViewModel: ObservableObject {
    @Published private(set) var todayTasks: [Task] = []
    
    private var allTasks: [Task] = [] {
        didSet {
            filterTodayTasks()
        }
    }
    
    init() {
        // Временные тестовые данные
        allTasks = [
            Task(title:"Walk the dog"),
            Task(title:"Eat"),
            Task(title:"Sleep")
        ]
    }
    
    func toggleCompletion(for task:Task) {
        guard let index = allTasks.firstIndex(where: { $0.id == task.id }) else { return }
        allTasks[index].isCompleted.toggle()
    }
    
    func addTask(title: String) {
        let newTask = Task(title: title)
        allTasks.append(newTask)
    }
    
    private func filterTodayTasks() {
        let calendar = Calendar.current
        let today = Date()
        
        todayTasks = allTasks.filter { task in
            calendar.isDate(task.date, inSameDayAs: today)
        }
    }
}
