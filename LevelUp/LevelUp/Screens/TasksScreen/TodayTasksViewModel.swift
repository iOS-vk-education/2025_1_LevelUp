//
//  TodayTasksViewModel.swift
//  
//
//  Created by Андрей Прибавкин on 13.11.25.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

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
        // При наличии авторизованного пользователя пробуем загрузить задачи и прогресс из Firebase
        _Concurrency.Task {
            try? await ProgressService.shared.loadCurrentUserProgress()
            let tasks = try? await TasksService.shared.loadCurrentUserTasks()
            if let tasks {
                await MainActor.run {
                    self.allTasks = tasks
                }
            }
        }
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

        _Concurrency.Task {
            try? await ProgressService.shared.saveCurrentUserProgress()
            try? await TasksService.shared.saveCurrentUserTasks(self.allTasks)
        }
    }
    
    func addTask(title: String, date: Date, minutesSpent: Int = 0) -> Task {
        let newTask = Task(title: title, date: date, minutesSpent: max(minutesSpent, 0))
        allTasks.append(newTask)

        _Concurrency.Task {
            try? await TasksService.shared.saveCurrentUserTasks(self.allTasks)
        }
        
        return newTask
    }
    
    func addTask(_ task: Task) {
        allTasks.append(task)

        _Concurrency.Task {
            try? await TasksService.shared.saveCurrentUserTasks(self.allTasks)
        }
    }
    
    func deleteTask(_ task: Task) {
        guard let index = allTasks.firstIndex(where: { $0.id == task.id }) else { return }

        if allTasks[index].isCompleted, let p = pointByTask.removeValue(forKey: task.id) {
            Statistics.shared.delXPPoint(point: p)
        }

        allTasks.remove(at: index)

        _Concurrency.Task {
            try? await ProgressService.shared.saveCurrentUserProgress()
            try? await TasksService.shared.saveCurrentUserTasks(self.allTasks)
        }
    }

    func updateTask(
        _ task: Task,
        newTitle: String,
        newDescription: String,
        newTag: TaskTag?,
        newMinutes: Int
    ) {
        guard let index = allTasks.firstIndex(where: { $0.id == task.id }) else { return }
        allTasks[index].title = newTitle
        allTasks[index].description = newDescription
        allTasks[index].tag = newTag
        allTasks[index].minutesSpent = max(newMinutes, 0)

        if allTasks[index].isCompleted {
            refreshXPPoint(for: allTasks[index])
        }
    }

    private func addXPPoint(for task: Task) {
        let value = max(task.minutesSpent, 0)
        guard value > 0 else { return }
        let point = Point(date: task.date, value: value)
        pointByTask[task.id] = point
        Statistics.shared.addXPPoint(point: point)
    }

    private func removeXPPoint(for taskId: UUID) {
        guard let point = pointByTask.removeValue(forKey: taskId) else { return }
        Statistics.shared.delXPPoint(point: point)
    }

    private func refreshXPPoint(for task: Task) {
        if let previous = pointByTask[task.id] {
            Statistics.shared.delXPPoint(point: previous)
            pointByTask.removeValue(forKey: task.id)
        }
        addXPPoint(for: task)
    }
}
