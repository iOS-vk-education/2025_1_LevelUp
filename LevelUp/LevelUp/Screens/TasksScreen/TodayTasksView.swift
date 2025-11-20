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
                .foregroundColor(task.isCompleted ? .secondary : .primary)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}


struct HabitsCardView: View {
    var body: some View {
        Text("Привычки")
    }
}

struct TasksCardView: View {
    let title: String
    let tasks: [Task]
    let emptyText: String
    let toggleTask: (Task) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 20, weight: .semibold))
            
            Divider()
            
            if tasks.isEmpty {
                Text(emptyText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 4)
            } else {
                VStack(spacing: 12) {
                    ForEach(tasks) { task in
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
                .shadow(color: Color.black.opacity(0.08),
                        radius: 8, x: 0, y: 4)
        )
    }
}

struct LiquidGlassCircleButton: View {
    let systemImage: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(.thinMaterial)
                    .overlay(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        tint.opacity(0.55),
                                        tint.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.6), lineWidth: 1.3)
                    )

                Image(systemName: systemImage)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.25),
                            radius: 4, x: 0, y: 1)
            }
            .frame(width: 72, height: 72)
            .shadow(color: Color.black.opacity(0.2), radius: 18, x: 0, y: 10)
            .shadow(color: Color.white.opacity(0.4), radius: 8, x: 0, y: -3)
        }
    }
}

struct TodayTasksView: View {
    @StateObject private var viewModel = TodayTasksViewModel()
    @State private var newTaskTitle: String = ""
    @State private var isAddingTask: Bool = false
    @FocusState private var isTaskFieldFocused: Bool
    let myBlue = Color(red: 0.30, green: 0.60, blue: 0.98)
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
//            Color
//                .blue
//          Как добавить кастомный задний фон???
            NavigationStack {
                VStack(spacing: 16) {
                    HeaderView()
                    ExperienceSectionView()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Карточка "Сделать"
                        TasksCardView(
                            title: "Сделать",
                            tasks: viewModel.todayTasks,
                            emptyText: "Нет задач",
                            toggleTask: { task in
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    viewModel.toggleCompletion(for: task)
                                }
                            }
                        )
                        
                        // Карточка "Сделано"
                        TasksCardView(
                            title: "Сделано",
                            tasks: viewModel.doneTasks,
                            emptyText: "Пока ничего не сделано",
                            toggleTask: { task in
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    viewModel.toggleCompletion(for: task)
                                }
                            }
                        )
                        
                        HabitsCardView()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
                .navigationBarHidden(true)
                .scrollContentBackground(.hidden)
            }
            
            LiquidGlassCircleButton(systemImage: "plus", tint: myBlue) {
                withAnimation {
                    isAddingTask = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTaskFieldFocused = true
                }
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
