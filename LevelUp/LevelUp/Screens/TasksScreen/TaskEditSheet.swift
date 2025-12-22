import SwiftUI

struct TaskEditSheet: View {
    let task: Task
    @State private var title: String
    @State private var description: String
    @State private var tag: TaskTag?
    @State private var minutesSpent: Int
    @FocusState private var isTitleFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    private let onFinish: (Task) -> Void
    private let onCancel: () -> Void
    
    @EnvironmentObject var viewModel: TodayTasksViewModel

    init(task: Task, onFinish: @escaping (Task) -> Void, onCancel: @escaping () -> Void = {}) {
        self.task = task
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description)
        _tag = State(initialValue: task.tag)
        _minutesSpent = State(initialValue: max(task.minutesSpent, 0))
        self.onFinish = onFinish
        self.onCancel = onCancel
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Название") {
                    TextField("Название задачи", text: $title)
                        .focused($isTitleFocused)
                }
                Section("Описание") {
                    TextField("Описание задачи", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                        .frame(minHeight: 80, alignment: .topLeading)
                }

                Section("Тег") {
                    tagPicker
                }

                Section("Затраченное время (мин)") {
                    TextField("Например, 25", value: $minutesSpent, format: .number)
                        .keyboardType(.numberPad)

                    Text("1 минута = 1 XP")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Редактировать задачу")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        onCancel()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        save()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTitleFocused = true
            }
        }
    }

    private func save() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        let selectedDate = viewModel.selectedDate
        let task = Task(
            id: task.id,
            title: trimmedTitle,
            description: trimmedDescription,
            isCompleted: task.isCompleted,
            date: selectedDate,
            tag: tag,
            minutesSpent: max(minutesSpent, 0)
        )
        onFinish(task)
        dismiss()
    }

    private var tagPicker: some View {
        HStack(spacing: 8) {
            Button {
                tag = nil
            } label: {
                Text("Без тега")
                    .font(.subheadline.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule(style: .continuous)
                            .fill(tag == nil ? Color(.secondarySystemBackground) : Color.clear)
                    )
                    .foregroundStyle(.primary)
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(tag == nil ? Color.gray.opacity(0.4) : .clear, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)

            ForEach(TaskTag.allCases, id: \.self) { option in
                let isSelected = tag == option
                Button {
                    tag = option
                } label: {
                    Text(option.title)
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule(style: .continuous)
                                .fill(isSelected ? option.color.opacity(0.15) : Color(.secondarySystemBackground))
                        )
                        .foregroundStyle(isSelected ? option.color : .primary)
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(isSelected ? option.color : .clear, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
