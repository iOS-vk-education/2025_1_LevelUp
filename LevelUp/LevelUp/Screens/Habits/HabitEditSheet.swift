import SwiftUI

struct HabitEditSheet: View {
    @ObservedObject var viewModel: HabitViewModel
    let habit: Habit
    let selectedDate: Date
    @FocusState var isTitleFieldFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section("Название") {
                    TextField("Habit title", text: $viewModel.draftTitle)
                        .focused($isTitleFieldFocused)
                }

                Section("Описание") {
                    TextField("Add a short description", text: $viewModel.draftDescription, axis: .vertical)
                        .lineLimit(3...6)
                        .frame(minHeight: 80, alignment: .topLeading)
                }

                Section("Повторение") {
                    repeatPicker
                }

                Section("Иконка") {
                    iconPicker
                }

                Section("Статус") {
                    Toggle(isOn: $viewModel.draftIsDone) {
                        Text("Пометить выполненным")
                    }
                }

                if !viewModel.isCreatingNew {
                    Section {
                        Button("Удалить привычку", role: .destructive) {
                            viewModel.showDeleteOptions = true
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.cancelEditing()
                        isTitleFieldFocused = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.saveEdits(for: selectedDate)
                        isTitleFieldFocused = false
                    }
                }
            }
        }
        .overlay(alignment: .center) {
            if viewModel.showDeleteOptions {
                Color.black.opacity(0.15)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.showDeleteOptions = false
                    }

                VStack(spacing: 12) {
                    deleteOptionButton(title: "Удалить только этот день") {
                        viewModel.deleteHabit(habit, scope: .onlyToday, on: selectedDate)
                    }
                    deleteOptionButton(title: "Удалить с этого дня и дальше") {
                        viewModel.deleteHabit(habit, scope: .fromTodayForward, on: selectedDate)
                    }
                    deleteOptionButton(title: "Удалить везде") {
                        viewModel.deleteHabit(habit, scope: .everywhere, on: selectedDate)
                    }
                    Button("Отмена") {
                        viewModel.showDeleteOptions = false
                    }
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.15), radius: 16, x: 0, y: 8)
                )
                .padding(.horizontal, 24)
            }
        }
        .onAppear {
            if viewModel.isCreatingNew {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTitleFieldFocused = true
                }
            }
        }
    }

    private var repeatPicker: some View {
        let labels = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        let mappedOrder: [Int] = [2, 3, 4, 5, 6, 7, 1] // Monday first

        return HStack(spacing: 8) {
            ForEach(Array(labels.enumerated()), id: \.offset) { index, label in
                let weekdayValue = mappedOrder[index]
                let isSelected = viewModel.draftRepeatDays.contains(weekdayValue)
                Button {
                    viewModel.toggleRepeatDay(weekdayValue)
                } label: {
                    Text(label)
                        .font(.subheadline.weight(.semibold))
                        .frame(width: 40, height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(isSelected ? Color.blue.opacity(0.15) : Color(.secondarySystemBackground))
                        )
                        .foregroundStyle(isSelected ? Color.blue : Color.primary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var iconPicker: some View {
        let columns = [GridItem(.adaptive(minimum: 44), spacing: 12)]

        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(viewModel.icons, id: \.self) { icon in
                Button {
                    viewModel.draftIconName = icon
                } label: {
                    ZStack {
                        Circle()
                            .fill((viewModel.draftIconName == icon ? Color.blue.opacity(0.15) : Color(.secondarySystemBackground)))
                            .frame(width: 52, height: 52)
                            .overlay(
                                Circle()
                                    .stroke(viewModel.draftIconName == icon ? Color.blue : Color.clear, lineWidth: 2)
                            )

                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(viewModel.draftIconName == icon ? Color.blue : Color.primary)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 6)
    }

    private func deleteOptionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.body.weight(.semibold))
                .foregroundStyle(Color.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.white.opacity(0.9))
                )
        }
        .buttonStyle(.plain)
    }
}
