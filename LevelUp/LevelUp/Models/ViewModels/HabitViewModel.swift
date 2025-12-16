import SwiftUI
import Combine

private struct HabitCompletionKey: Hashable {
    let habitId: UUID
    let date: Date
}

final class HabitViewModel: ObservableObject {
    @Published var habits: [Habit]
    @Published var weekDays: [WeekDay] = []
    @Published var selectedDate: Date
    @Published var completions: [Date: Set<UUID>] = [:]
    private var xpPointsByCompletion: [HabitCompletionKey: Point] = [:]

    @Published var editingHabit: Habit?
    @Published var draftTitle: String = ""
    @Published var draftDescription: String = ""
    @Published var draftIsDone: Bool = false
    @Published var draftIconName: String = ""
    @Published var draftRepeatDays: Set<Int>
    @Published var draftDifficulty: TaskDifficulty = .medium
    @Published var isCreatingNew: Bool = false
    @Published var showDeleteOptions: Bool = false

    let palette: [Color] = [.blue, .orange, .mint, .pink, .purple, .teal]
    let icons: [String] = ["flame.fill", "brain.head.profile", "bolt.heart.fill", "target", "checkmark.seal.fill", "moon.fill"]

    private let calendar = Calendar.current

    init() {
        let today = calendar.startOfDay(for: Date())
        self.selectedDate = today
        self.draftRepeatDays = [calendar.component(.weekday, from: today)]
        self.habits = Self.seedHabits(createdOn: today)
        refreshWeek(for: today)
    }

    func visibleHabits(on date: Date? = nil) -> [Habit] {
        let day = date ?? selectedDate
        return habits.filter { isHabitVisible($0, on: day) }
    }

    func isHabitDone(_ habit: Habit, on date: Date) -> Bool {
        let key = dayKey(date)
        return completions[key]?.contains(habit.id) ?? false
    }

    func toggleHabit(_ habit: Habit, on date: Date) {
        let done = isHabitDone(habit, on: date)
        setHabit(habit, done: !done, on: date)
        refreshWeek(for: selectedDate)
    }

    func beginCreate(on date: Date) {
        let tint = palette.randomElement() ?? .blue
        let icon = icons.first ?? "plus"
        let weekday = calendar.component(.weekday, from: date)
        let newHabit = Habit(
            title: "",
            description: "",
            isDone: false,
            createdOn: date,
            repeatDays: [weekday],
            iconName: icon,
            tint: tint,
            difficulty: .medium
        )

        editingHabit = newHabit
        draftTitle = ""
        draftDescription = ""
        draftIsDone = false
        draftIconName = icon
        draftRepeatDays = [weekday]
        draftDifficulty = .medium
        isCreatingNew = true
        showDeleteOptions = false
    }

    func startEditing(_ habit: Habit, selectedDay: Date) {
        editingHabit = habit
        draftTitle = habit.title
        draftDescription = habit.description
        draftIsDone = isHabitDone(habit, on: selectedDay)
        draftIconName = habit.iconName
        draftRepeatDays = habit.repeatDays
        draftDifficulty = habit.difficulty
        isCreatingNew = false
        showDeleteOptions = false
    }

    func saveEdits(for selectedDay: Date) {
        guard let currentHabit = editingHabit else { return }
        let index = habits.firstIndex(where: { $0.id == currentHabit.id })

        let trimmedTitle = draftTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = draftDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        let chosenIcon = draftIconName.isEmpty ? currentHabit.iconName : draftIconName
        let repeatDays = draftRepeatDays.isEmpty ? currentHabit.repeatDays : draftRepeatDays
        let chosenDifficulty = draftDifficulty

        let updatedHabit = Habit(
            id: currentHabit.id,
            title: trimmedTitle.isEmpty ? currentHabit.title : trimmedTitle,
            description: trimmedDescription.isEmpty ? currentHabit.description : trimmedDescription,
            isDone: draftIsDone,
            createdOn: currentHabit.createdOn,
            repeatDays: repeatDays,
            skipDates: currentHabit.skipDates,
            endDate: currentHabit.endDate,
            iconName: chosenIcon,
            tint: currentHabit.tint,
            difficulty: chosenDifficulty
        )

        withAnimation(.easeInOut) {
            if let index {
                habits[index] = updatedHabit
            } else {
                habits.append(updatedHabit)
            }
        }

        setHabit(updatedHabit, done: draftIsDone, on: selectedDay)
        if updatedHabit.difficulty != currentHabit.difficulty {
            refreshXPPoints(for: updatedHabit)
        }
        refreshWeek(for: selectedDay)
        resetEditingState()
    }

    func cancelEditing() {
        resetEditingState()
    }

    func toggleRepeatDay(_ weekday: Int) {
        if draftRepeatDays.contains(weekday) {
            if draftRepeatDays.count > 1 {
                draftRepeatDays.remove(weekday)
            }
        } else {
            draftRepeatDays.insert(weekday)
        }
    }

    func deleteHabit(_ habit: Habit, scope: DeleteScope, on selectedDay: Date) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        let key = dayKey(selectedDay)

        switch scope {
        case .onlyToday:
            habits[index].skipDates.insert(key)
            removeCompletion(habit.id, on: key)
        case .fromTodayForward:
            habits[index].endDate = key
            removeCompletions(habit.id, from: key)
        case .everywhere:
            habits.remove(at: index)
            removeCompletions(habit.id)
        }

        refreshWeek(for: selectedDay)
        resetEditingState()
    }

    func shiftWeek(by offset: Int) {
        guard offset != 0 else { return }
        let step = offset * 7
        let tentative = calendar.date(byAdding: .day, value: step, to: selectedDate) ?? selectedDate
        selectedDate = dayKey(tentative)
        refreshWeek(for: tentative)
    }

    func selectDate(_ date: Date) {
        selectedDate = dayKey(date)
        refreshWeek(for: date)
    }

    func dayStatus(for date: Date) -> CompletionState {
        let key = dayKey(date)
        let activeHabits = visibleHabits(on: date)
        guard !activeHabits.isEmpty else { return .none }

        let completed = completions[key] ?? []
        let completedVisible = completed.filter { id in
            activeHabits.contains(where: { $0.id == id })
        }

        if completedVisible.isEmpty { return .none }
        if completedVisible.count >= activeHabits.count { return .full }
        return .partial
    }

    private func resetEditingState() {
        editingHabit = nil
        isCreatingNew = false
        showDeleteOptions = false
    }

    private func refreshWeek(for anchor: Date? = nil) {
        let base = anchor ?? selectedDate
        weekDays = generateWeekDays(for: base)
    }

    private func generateWeekDays(for anchor: Date) -> [WeekDay] {
        let startOfWeek = self.startOfWeek(for: anchor)
        return (0..<7).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek) else { return nil }
            let status = dayStatus(for: date)
            return WeekDay(date: date, status: status)
        }
    }

    private func isHabitVisible(_ habit: Habit, on date: Date) -> Bool {
        let key = dayKey(date)
        let createdKey = dayKey(habit.createdOn)
        if key < createdKey { return false }
        if let endDate = habit.endDate, key >= dayKey(endDate) { return false }

        let weekday = calendar.component(.weekday, from: key)
        if !habit.repeatDays.contains(weekday) { return false }
        if habit.skipDates.contains(key) { return false }

        return true
    }

    private func setHabit(_ habit: Habit, done: Bool, on date: Date) {
        let key = dayKey(date)
        var set = completions[key] ?? Set<UUID>()
        let completionKey = HabitCompletionKey(habitId: habit.id, date: key)
        let alreadyDone = set.contains(habit.id)

        if done {
            set.insert(habit.id)
            if alreadyDone {
                refreshXPPoint(for: habit, on: key, completionKey: completionKey)
            } else {
                addXPPoint(for: habit, on: key, completionKey: completionKey)
            }
        } else {
            set.remove(habit.id)
            if alreadyDone {
                removeXPPoint(for: completionKey)
            }
        }
        if set.isEmpty {
            completions.removeValue(forKey: key)
        } else {
            completions[key] = set
        }
    }

    private func addXPPoint(for habit: Habit, on date: Date, completionKey: HabitCompletionKey) {
        let point = Point(date: date, value: habit.difficulty.xpReward)
        xpPointsByCompletion[completionKey] = point
        Statistics.shared.addXPPoint(point: point)
    }

    private func removeXPPoint(for completionKey: HabitCompletionKey) {
        guard let point = xpPointsByCompletion.removeValue(forKey: completionKey) else { return }
        Statistics.shared.delXPPoint(point: point)
    }

    private func refreshXPPoint(for habit: Habit, on date: Date, completionKey: HabitCompletionKey) {
        if let previous = xpPointsByCompletion[completionKey] {
            Statistics.shared.delXPPoint(point: previous)
        }
        let updatedPoint = Point(date: date, value: habit.difficulty.xpReward)
        xpPointsByCompletion[completionKey] = updatedPoint
        Statistics.shared.addXPPoint(point: updatedPoint)
    }

    private func refreshXPPoints(for habit: Habit) {
        for (date, set) in completions where set.contains(habit.id) {
            let key = HabitCompletionKey(habitId: habit.id, date: date)
            refreshXPPoint(for: habit, on: date, completionKey: key)
        }
    }

    private func removeCompletion(_ habitID: UUID, on date: Date) {
        let key = dayKey(date)
        guard var set = completions[key] else { return }
        set.remove(habitID)
        removeXPPoint(for: HabitCompletionKey(habitId: habitID, date: key))
        if set.isEmpty {
            completions.removeValue(forKey: key)
        } else {
            completions[key] = set
        }
    }

    private func removeCompletions(_ habitID: UUID, from startDate: Date? = nil) {
        let start = startDate.map { dayKey($0) }
        completions = completions.reduce(into: [:]) { result, pair in
            let (date, set) = pair
            let shouldDrop = set.contains(habitID) && (start == nil || date >= start!)
            if shouldDrop {
                var newSet = set
                newSet.remove(habitID)
                removeXPPoint(for: HabitCompletionKey(habitId: habitID, date: date))
                if !newSet.isEmpty {
                    result[date] = newSet
                }
            } else {
                result[date] = set
            }
        }
    }

    func dayKey(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    private func startOfWeek(for date: Date) -> Date {
        calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? calendar.startOfDay(for: date)
    }

    private static func seedHabits(createdOn: Date) -> [Habit] {
        [
            Habit(
                title: "Learn New Words",
                description: "15 new words daily",
                createdOn: createdOn,
                repeatDays: Set(1...7),
                iconName: "character.book.closed.fill",
                tint: .blue
            ),
            Habit(
                title: "LeetCode Problem",
                description: "Solve 1 medium task",
                createdOn: createdOn,
                repeatDays: Set(1...7),
                iconName: "calendar.badge.clock",
                tint: .orange
            ),
            Habit(
                title: "Go Backend",
                description: "1 hour of Go practice",
                createdOn: createdOn,
                repeatDays: Set(1...7),
                iconName: "person.fill.badge.plus",
                tint: .mint
            ),
            Habit(
                title: "Social Media Detox",
                description: "No socials after 9 pm",
                createdOn: createdOn,
                repeatDays: Set(1...7),
                iconName: "sparkles",
                tint: .pink
            )
        ]
    }
}
