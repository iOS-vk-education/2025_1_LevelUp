import SwiftUI

struct HabitsView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @StateObject private var viewModel = HabitViewModel()
    @FocusState private var isTitleFieldFocused: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    header
                    WeekStripView(
                        weekDays: viewModel.weekDays,
                        selectedDate: viewModel.selectedDate,
                        onSelectDay: viewModel.selectDate,
                        onShiftWeek: viewModel.shiftWeek
                    )
                    habitCard
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 16)
                .padding(.bottom, 120)
            }

            addButton
                .padding(.bottom, 20)
        }
        .sheet(item: $viewModel.editingHabit) { habit in
            HabitEditSheet(
                viewModel: viewModel,
                habit: habit,
                selectedDate: viewModel.selectedDate,
                isTitleFieldFocused: _isTitleFieldFocused
            )
        }
    }

    private var header: some View {
        HStack {
            Spacer()
            Text("Привычки")
                .font(.title2.bold())
                .foregroundStyle(.primary)
            Spacer()
        }
    }

    private var habitCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(viewModel.visibleHabits()) { habit in
                HabitRowView(
                    habit: habit,
                    isDone: viewModel.isHabitDone(habit, on: viewModel.selectedDate),
                    onToggle: { viewModel.toggleHabit(habit, on: viewModel.selectedDate) },
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
        Button(action: { viewModel.beginCreate(on: viewModel.selectedDate) }) {
            Image(systemName: "plus")
                .font(.system(size: 22, weight: .bold))
                .frame(width: 60, height: 60)
                .foregroundStyle(.white)
                .background(
                    Circle()
                        .fill(Color.blue)
                        .shadow(color: Color.blue.opacity(0.25), radius: 12, x: 0, y: 6)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Add habit")
    }

    private var horizontalPadding: CGFloat {
        horizontalSizeClass == .compact ? 16 : 24
    }
}

#Preview {
    HabitsView()
}
