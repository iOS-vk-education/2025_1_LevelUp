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
            .foregroundStyle(.primary)
    }
}

struct ExperienceSectionView: View {
    let progress: Double = 0.6
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Твой опыт за сегодня")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 18, weight: .medium))
            AppProgressView(progress: progress)
                .frame(height: 14)
        }
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
    let habits: [Habit]
    let isDone: (Habit) -> Bool
    let toggle: (Habit) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Привычки")
                .font(.system(size: 20, weight: .semibold))

            Divider()

            if habits.isEmpty {
                Text("Нет привычек на сегодня")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 4)
            } else {
                VStack(spacing: 12) {
                    ForEach(habits) { habit in
                        HabitCheckboxRow(
                            habit: habit,
                            isDone: isDone(habit),
                            toggle: { toggle(habit) }
                        )
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

struct HabitCheckboxRow: View {
    let habit: Habit
    let isDone: Bool
    let toggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: toggle) {
                Image(isDone ? "checkbox_checked" : "checkbox_unchecked")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(habit.title.isEmpty ? "Без названия" : habit.title)
                    .font(.body)
                    .foregroundColor(isDone ? .secondary : .primary)
                if !habit.description.trimmingCharacters(in: .whitespaces).isEmpty {
                    Text(habit.description)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
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

struct TodayTasksView: View {
    @StateObject private var viewModel = TodayTasksViewModel()
    @EnvironmentObject private var habitsViewModel: HabitViewModel
    @State private var newTaskTitle: String = ""
    @State private var isAddingTask: Bool = false
    @FocusState private var isTaskFieldFocused: Bool
    let myBlue = Color(red: 0.30, green: 0.60, blue: 0.98)
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            NavigationStack {
                ScrollView {
                    
                    VStack(spacing: 20) {
                        HeaderView()
                        WeekStripView(
                            weekDays: habitsViewModel.weekDays,
                            selectedDate: habitsViewModel.selectedDate,
                            onSelectDay: { date in
                                habitsViewModel.selectDate(date)
                                viewModel.selectedDate = habitsViewModel.selectedDate
                            },
                            onShiftWeek: { offset in
                                habitsViewModel.shiftWeek(by: offset)
                                viewModel.selectedDate = habitsViewModel.selectedDate
                            }
                        )
                        ExperienceSectionView()
                        
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

                        HabitsCardView(
                            habits: habitsForToday,
                            isDone: { habitsViewModel.isHabitDone($0, on: todayDate) },
                            toggle: { habit in
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    habitsViewModel.toggleHabit(habit, on: todayDate)
                                }
                            }
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .background(Color(.systemGroupedBackground))
                .onAppear {
                    viewModel.selectedDate = habitsViewModel.selectedDate
                }
                .onChange(of: habitsViewModel.selectedDate) { newDate in
                    viewModel.selectedDate = newDate
                }
            }
            
            if !isAddingTask {
                LiquidGlassCircleButton(systemImage: "plus", tint: myBlue, buttonSize: 72, iconSize: 26) {
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
                                .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 6)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color(myBlue).opacity(0.2), lineWidth: 1)
                        )
                        .font(.system(size: 16))
                        .submitLabel(.done)
                        .focused($isTaskFieldFocused)
                        .onSubmit(addTask)
                    
                    LiquidGlassCircleButton(
                            systemImage: "arrow.up",
                            tint: myBlue,
                            buttonSize: 36,
                            iconSize: 20
                    ) {
                        addTask()
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

        viewModel.addTask(title: trimmed, date: todayDate)
        newTaskTitle = ""

        withAnimation {
            isAddingTask = false
        }
        isTaskFieldFocused = false
    }

    private var habitsForToday: [Habit] {
        habitsViewModel.visibleHabits(on: todayDate)
    }

    private var todayDate: Date {
        viewModel.selectedDate
    }
}
#Preview {
    TodayTasksView()
        .environmentObject(HabitViewModel())
}
