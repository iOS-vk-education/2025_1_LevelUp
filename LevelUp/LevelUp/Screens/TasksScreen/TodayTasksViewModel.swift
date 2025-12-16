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
    
    var pointByTask: [UUID:Point] = [:]
    
    func toggleCompletion(for task:Task) {
        guard let index = allTasks.firstIndex(where: { $0.id == task.id }) else { return }
        allTasks[index].isCompleted.toggle()
        
        if allTasks[index].isCompleted {
            let p = Point(date: task.date, value: 100)
            pointByTask[task.id] = p
            Statistics.shared.addXPPoint(point: p)
        } else {
            if let p = pointByTask.removeValue(forKey: task.id) {
                Statistics.shared.delXPPoint(point: p)
            }
        }
    }
    
    func addTask(title: String, date: Date) {
        let newTask = Task(title: title, date: date)
        allTasks.append(newTask)
    }
    
    func deleteTask(_ task: Task) {
        guard let index = allTasks.firstIndex(where: { $0.id == task.id }) else { return }

        if allTasks[index].isCompleted, let p = pointByTask.removeValue(forKey: task.id) {
            Statistics.shared.delXPPoint(point: p)
        }

        allTasks.remove(at: index)
    }

    func updateTask(_ task: Task, newTitle: String, newDescription: String, newTag: TaskTag?) {
        guard let index = allTasks.firstIndex(where: { $0.id == task.id }) else { return }
        allTasks[index].title = newTitle
        allTasks[index].description = newDescription
        allTasks[index].tag = newTag
    }
}
