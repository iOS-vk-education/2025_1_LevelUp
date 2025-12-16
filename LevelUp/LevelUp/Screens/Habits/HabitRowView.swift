import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    let isDone: Bool
    let onToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: (DeleteScope) -> Void

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(habit.tint.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: habit.iconName)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(habit.tint)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(habit.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(habit.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: onToggle) {
                Image(systemName: isDone ? "checkmark.circle.fill" : "checkmark.circle")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(isDone ? Color.blue : Color.gray.opacity(0.5))
                    .padding(6)
            }
            .buttonStyle(.plain)
            .contextMenu {
                Button("Изменить") {
                    onEdit()
                }
                Button("Удалить только в этот день", role: .destructive) {
                    onDelete(.onlyToday)
                }
                Button("Удалить с этого дня и дальше", role: .destructive) {
                    onDelete(.fromTodayForward)
                }
                Button("Удалить везде", role: .destructive) {
                    onDelete(.everywhere)
                }
            }
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture {
            onEdit()
        }
    }
}
