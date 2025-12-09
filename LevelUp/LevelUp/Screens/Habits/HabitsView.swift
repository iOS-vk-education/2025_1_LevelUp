import SwiftUI

struct HabitsView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject private var viewModel: HabitViewModel
    @EnvironmentObject private var tasksViewModel: TodayTasksViewModel
    @FocusState private var isTitleFieldFocused: Bool
    private let habitAccent = Color(red: 0.30, green: 0.60, blue: 0.98)
    private let xpPerTask = 100

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    header
                    ExperienceSectionView(
                        progress: todayXPProgress,
                        earnedXP: earnedXP,
                        targetXP: targetXP
                    )
                    WeekStripView(
                        weekDays: viewModel.weekDays,
                        selectedDate: viewModel.selectedDate,
                        onSelectDay: { date in
                            viewModel.selectDate(date)
                            tasksViewModel.selectedDate = viewModel.selectedDate
                        },
                        onShiftWeek: { offset in
                            viewModel.shiftWeek(by: offset)
                            tasksViewModel.selectedDate = viewModel.selectedDate
                        }
                    )
                    habitCard
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 16)
                .padding(.bottom, 120)
            }

            addButton
                .padding(.trailing, 26)
                .padding(.bottom, 40)
        }
        .sheet(item: $viewModel.editingHabit) { habit in
            HabitEditSheet(
                viewModel: viewModel,
                habit: habit,
                selectedDate: viewModel.selectedDate,
                isTitleFieldFocused: _isTitleFieldFocused
            )
        }
        .onAppear {
            tasksViewModel.selectedDate = viewModel.selectedDate
        }
        .onChange(of: viewModel.selectedDate) { newDate in
            tasksViewModel.selectedDate = newDate
        }
    }

    private var header: some View {
        Text("Привычки")
            .font(.system(size: 32, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundStyle(.primary)
    }

    private var habitCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(viewModel.visibleHabits()) { habit in
                HabitRowView(
                    habit: habit,
                    isDone: viewModel.isHabitDone(habit, on: viewModel.selectedDate),
                    onToggle: {
                        viewModel.toggleHabit(habit, on: viewModel.selectedDate)
                        CompletedHabits.shared.add()
                    },
                    onEdit: { viewModel.startEditing(habit, selectedDay: viewModel.selectedDate) },
                    onDelete: { scope in viewModel.deleteHabit(habit, scope: scope, on: viewModel.selectedDate) }
                )
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground))
        )
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
    }

    private var addButton: some View {
        LiquidGlassCircleButton(
            systemImage: "plus",
            tint: habitAccent,
            buttonSize: 72,
            iconSize: 26,
            action: { viewModel.beginCreate(on: viewModel.selectedDate) }
        )
        .accessibilityLabel("Add habit")
    }

    private var horizontalPadding: CGFloat {
        horizontalSizeClass == .compact ? 16 : 24
    }

    private var totalTasksCount: Int {
        tasksViewModel.todayTasks.count + tasksViewModel.doneTasks.count
    }

    private var earnedXP: Int {
        tasksViewModel.doneTasks.count * xpPerTask
    }

    private var targetXP: Int {
        max(totalTasksCount * xpPerTask, xpPerTask)
    }

    private var todayXPProgress: Double {
        guard targetXP > 0 else { return 0 }
        return min(Double(earnedXP) / Double(targetXP), 1)
    }
}

#Preview {
    HabitsView()
        .environmentObject(HabitViewModel())
        .environmentObject(TodayTasksViewModel())
}
