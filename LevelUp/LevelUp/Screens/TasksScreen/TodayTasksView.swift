//
//  TodayTasksView.swift
//
//
//  Created by Андрей Прибавкин on 13.11.25.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        Text("Сегодня")
            .font(.system(size: 32, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct ExperienceSectionView: View {
    let progress: Double = 0.6
    var body: some View {
        Text("Твой опыт за сегодня")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 18, weight: .medium))
        ProgressView(value: progress)
            .tint(.blue)
            
    }
}

struct TaskRowView: View {
    let task: Task
    let toggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: toggle) {
                Image(task.isCompleted ? "checkbox_checked" : "checkbox_unchecked")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            Text(task.title)
                .font(.body)
                .strikethrough(task.isCompleted)
                .foregroundColor(task.isCompleted ? .secondary : .primary)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct TasksCardView: View {
    let todoTasks: [Task]
    let doneTasks: [Task]
    let toggleTask: (Task) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Сделать")
                .font(.system(size: 20, weight: .semibold))
            
            Divider()
            
            if todoTasks.isEmpty {
                Text("Нет задач")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 4)
            } else {
                VStack(spacing: 12) {
                    ForEach(todoTasks) { task in
                        TaskRowView(task: task) {
                        toggleTask(task)
                        }
                    }
                }
            }
            
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
}

struct HabitsCardView: View {
    var body: some View {
        Text("Привычки")
    }
}


struct TodayTasksView: View {
    @StateObject private var viewModel = TodayTasksViewModel()
    @State private var newTaskTitle: String = ""
    @State private var isAddingTask: Bool = false
    @FocusState private var isTaskFieldFocused: Bool
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 16) {
                        HeaderView()
                        ExperienceSectionView()
                        
                        TasksCardView(
                            todoTasks: viewModel.todayTasks,
                            doneTasks: viewModel.doneTasks,
                            toggleTask: { task in
                                viewModel.toggleCompletion(for: task)
                            }
                        )
                        
                        HabitsCardView()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
                .navigationBarHidden(true)
            }
            
            // плавающая кнопка "+"
            Button {
                withAnimation {
                    isAddingTask = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTaskFieldFocused = true
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(20)
                    .background(
                        Circle().fill(Color.blue)
                    )
                    .shadow(color: Color.black.opacity(0.2),
                            radius: 8, x: 0, y: 4)
            }
            .padding(.trailing, 26)
            .padding(.bottom, 40)
        }
        .safeAreaInset(edge: .bottom) {
            if isAddingTask {
                HStack(spacing: 12) {
                    TextField("Какие у тебя планы?", text: $newTaskTitle)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.white)
                        )
                        .font(.system(size: 16))
                        .submitLabel(.done)
                        .focused($isTaskFieldFocused)
                        .onSubmit(addTask)
                    
                    Button(action: addTask) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 8)
                .background(Color(.systemGray6))
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
    
    private func addTask() {
        let trimmed = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        viewModel.addTask(title: trimmed)
        newTaskTitle = ""
        
        withAnimation {
            isAddingTask = false
        }
        isTaskFieldFocused = false
    }
}
#Preview {
    TodayTasksView()
}
