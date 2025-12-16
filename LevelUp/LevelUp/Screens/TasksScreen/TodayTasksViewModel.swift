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
            addXPPoint(for: allTasks[index])
        } else {
            removeXPPoint(for: task.id)
        }
    }
    
    func addTask(title: String, date: Date, difficulty: TaskDifficulty = .medium) {
        let newTask = Task(title: title, date: date, difficulty: difficulty)
        allTasks.append(newTask)
    }
    
    func deleteTask(_ task: Task) {
        guard let index = allTasks.firstIndex(where: { $0.id == task.id }) else { return }

        if allTasks[index].isCompleted, let p = pointByTask.removeValue(forKey: task.id) {
            Statistics.shared.delXPPoint(point: p)
        }

        allTasks.remove(at: index)
    }

    func updateTask(
        _ task: Task,
        newTitle: String,
        newDescription: String,
        newTag: TaskTag?,
        newDifficulty: TaskDifficulty
    ) {
        guard let index = allTasks.firstIndex(where: { $0.id == task.id }) else { return }
        allTasks[index].title = newTitle
        allTasks[index].description = newDescription
        allTasks[index].tag = newTag
        allTasks[index].difficulty = newDifficulty

        if allTasks[index].isCompleted {
            refreshXPPoint(for: allTasks[index], previousPoint: pointByTask[task.id])
        }
    }

    private func addXPPoint(for task: Task) {
        let point = Point(date: task.date, value: task.difficulty.xpReward)
        pointByTask[task.id] = point
        Statistics.shared.addXPPoint(point: point)
    }

    private func removeXPPoint(for taskId: UUID) {
        guard let point = pointByTask.removeValue(forKey: taskId) else { return }
        Statistics.shared.delXPPoint(point: point)
    }

    private func refreshXPPoint(for task: Task, previousPoint: Point?) {
        if let previousPoint {
            Statistics.shared.delXPPoint(point: previousPoint)
        }
        let updatedPoint = Point(
            id: previousPoint?.id ?? UUID(),
            date: task.date,
            value: task.difficulty.xpReward
        )
        pointByTask[task.id] = updatedPoint
        Statistics.shared.addXPPoint(point: updatedPoint)
    }
}
