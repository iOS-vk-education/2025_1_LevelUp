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
    let progress: Double
    let earnedXP: Int
    let targetXP: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Твой опыт за сегодня")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 18, weight: .medium))
            AppProgressView(progress: progress)
                .frame(height: 14)
            Text("\(earnedXP) / \(targetXP) XP")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

struct TaskRowView: View {
    let task: Task
    let toggle: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: toggle) {
                Image(task.isCompleted ? "checkbox_checked" : "checkbox_unchecked")
                    .resizable()
                    .frame(width: 20, height: 20)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .font(.body)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)

                HStack(spacing: 8) {
                    if task.minutesSpent > 0 {
                        MinutesBadge(minutes: task.minutesSpent)
                    }
                    if let tag = task.tag {
                        TagBadge(tag: tag)
                    }
                }
                .opacity(task.isCompleted ? 0.6 : 1)
            }

            Spacer()
        }
        .padding(.vertical, 10)
        .contentShape(Rectangle())
        .onTapGesture {
            onEdit()
        }
    }
}

private struct TagBadge: View {
    let tag: TaskTag

    var body: some View {
        Text(tag.title)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule(style: .continuous)
                    .fill(tag.color.opacity(0.15))
            )
            .foregroundStyle(tag.color)
    }
}

private struct MinutesBadge: View {
    let minutes: Int

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.blue)
                .frame(width: 8, height: 8)
            Text("\(minutes) мин")
            Text("\(minutes) XP")
        }
        .font(.caption.weight(.semibold))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule(style: .continuous)
                .fill(Color.blue.opacity(0.12))
        )
        .foregroundStyle(Color.blue)
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
                MinutesBadge(minutes: habit.minutesSpent)
                    .opacity(isDone ? 0.6 : 1)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct SwipeActionRow<Content: View>: View {
    private let content: Content
    private let onDelete: () -> Void
    private let onEdit: () -> Void

    private let actionWidth: CGFloat = 120

    @State private var offset: CGFloat = 0
    @State private var isOpen: Bool = false
    @State private var isDragging: Bool = false

    init(
        onDelete: @escaping () -> Void,
        onEdit: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.onDelete = onDelete
        self.onEdit = onEdit
        self.content = content()
    }

    private var showActions: Bool {
        isOpen || isDragging || offset < -1
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            if showActions {
                HStack(spacing: 12) {
                    LiquidGlassCircleButton(
                        systemImage: "trash",
                        tint: .red,
                        buttonSize: 40,
                        iconSize: 18,
                        useMaterial: false,
                        imageShadow: 0,
                        action: onDelete,
                    )
                    LiquidGlassCircleButton(
                        systemImage: "pencil",
                        tint: .orange,
                        buttonSize: 40,
                        iconSize: 18,
                        useMaterial: false,
                        imageShadow: 0,
                        action: onEdit,
                    )
                }
                .padding(.trailing, 6)
                .transition(.opacity)
            }

            content
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .contentShape(Rectangle())
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true

                            let t = value.translation.width
                            if t < 0 {
                                offset = max(t, -actionWidth)
                            } else {
                                offset = isOpen ? min(t - actionWidth, 0) : 0
                            }
                        }
                        .onEnded { value in
                            isDragging = false

                            let shouldOpen = (-value.translation.width) > actionWidth * 0.4
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                offset = shouldOpen ? -actionWidth : 0
                                isOpen = shouldOpen
                            }
                        }
                )
                .onTapGesture {
                    if isOpen {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                            offset = 0
                            isOpen = false
                        }
                    }
                }
        }
        .clipped()
    }
}

struct TasksCardView: View {
    let title: String
    let tasks: [Task]
    let emptyText: String
    let toggleTask: (Task) -> Void
    let deleteTask: (Task) -> Void
    let editTask: (Task) -> Void

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
                        SwipeActionRow(
                            onDelete: { deleteTask(task) },
                            onEdit: { editTask(task) }
                        ) {
                            TaskRowView(
                                task: task,
                                toggle: { toggleTask(task) },
                                onEdit: { editTask(task) }
                            )
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
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .contentShape(RoundedRectangle(cornerRadius: 24))
    }
}

struct TodayTasksView: View {
    @EnvironmentObject private var viewModel: TodayTasksViewModel
    @EnvironmentObject private var habitsViewModel: HabitViewModel
    @State private var newTaskTitle: String = ""
    @State private var isAddingTask: Bool = false
    @FocusState private var isTaskFieldFocused: Bool
    @State private var editingTask: Task? = nil
    @State private var isXPInfoPresented: Bool = false
    let myBlue = Color(red: 0.30, green: 0.60, blue: 0.98)
    private let xpProgressTarget = 100
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            NavigationStack {
                ScrollView {
                    
                    VStack(spacing: 20) {
                        HeaderView()
                        ExperienceSectionView(
                            progress: todayXPProgress,
                            earnedXP: earnedXP,
                            targetXP: targetXP
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isXPInfoPresented = true
                        }
                        WeekStripView(
                            weekDays: habitsViewModel.weekDays,
                            selectedDate: habitsViewModel.selectedDate,
                            onSelectDay: { date in
                                withAnimation {
                                    habitsViewModel.selectDate(date)
                                    viewModel.selectedDate = habitsViewModel.selectedDate
                                }
                            },
                            onShiftWeek: { offset in
                                habitsViewModel.shiftWeek(by: offset)
                            }
                        )
                        
                        // Карточка "Сделать"
                        TasksCardView(
                            title: "Сделать",
                            tasks: viewModel.todayTasks,
                            emptyText: "Нет задач",
                            toggleTask: { task in
                                withAnimation {
                                    viewModel.toggleCompletion(for: task)
                                }
                            },
                            deleteTask: { task in
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    viewModel.deleteTask(task)
                                }
                            },
                            editTask: { task in
                                startEdit(task)
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
                            },
                            deleteTask: { task in
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    viewModel.deleteTask(task)
                                }
                            },
                            editTask: { task in
                                startEdit(task)
                            }
                        )

                        HabitsCardView(
                            habits: habitsForToday,
                            isDone: { habitsViewModel.isHabitDone($0, on: todayDate) },
                            toggle: { habit in
                                withAnimation {
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
                .onChange(of: habitsViewModel.selectedDate) { _, newDate in
                    viewModel.selectedDate = newDate
                }
            }
            .sheet(isPresented: $isAddingTask) {
                let newTask = Task(title: "")
                TaskEditSheet(task: newTask) { edited in
                    viewModel.addTask(
                        title: edited.title,
                        date: todayDate,
                        minutesSpent: edited.minutesSpent
                    )
                }
            }
            .sheet(item: $editingTask) { task in
                TaskEditSheet(task: task) { edited in
                    viewModel.updateTask(
                        task,
                        newTitle: edited.title,
                        newDescription: edited.description,
                        newTag: edited.tag,
                        newMinutes: edited.minutesSpent
                    )
                }
            }
            .sheet(isPresented: $isXPInfoPresented) {
                XPInfoView(earnedXP: earnedXP)
            }
            
            
            if !isAddingTask {
                LiquidGlassCircleButton(systemImage: "plus", tint: myBlue, buttonSize: 72, iconSize: 26, imageShadow: 0.25) {
                    withAnimation {
                        isAddingTask = true
                    }
                }
                .shadow(color: Color.black.opacity(0.2), radius: 18, x: 0, y: 10)
                .shadow(color: Color.white.opacity(0.4), radius: 8, x: 0, y: -3)
                .padding(.trailing, 26)
                .padding(.bottom, 40)
            }
        }
    }

    private func addTask() {
        let trimmed = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        _ = viewModel.addTask(title: trimmed, date: todayDate)
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
    
    private func startEdit(_ task: Task) {
        editingTask = task
    }

    private var taskEarnedXP: Int {
        viewModel.doneTasks.reduce(0) { $0 + max($1.minutesSpent, 0) }
    }

    private var habitEarnedXP: Int {
        habitsForToday
            .filter { habitsViewModel.isHabitDone($0, on: todayDate) }
            .reduce(0) { $0 + max($1.minutesSpent, 0) }
    }

    private var earnedXP: Int {
        taskEarnedXP + habitEarnedXP
    }

    private var targetXP: Int {
        xpProgressTarget
    }

    private var todayXPProgress: Double {
        guard targetXP > 0 else { return 0 }
        return min(Double(earnedXP) / Double(targetXP), 1)
    }
}
#Preview {
    TodayTasksView()
        .environmentObject(HabitViewModel())
        .environmentObject(TodayTasksViewModel())
}

struct XPInfoView: View {
    let earnedXP: Int

    var body: some View {
        ZStack {
            Color(red: 0.30, green: 0.60, blue: 0.98)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image("mascott")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 360)

                Text("Копи опыт и получай XP")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)

                Text("Текущее XP за сегодня: \(earnedXP)")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .multilineTextAlignment(.center)
            .padding(24)
        }
    }
}
