import SwiftUI

struct TaskEditSheet: View {
    let task: Task
    @ObservedObject var viewModel: TodayTasksViewModel
    @State private var title: String
    @State private var description: String
    @State private var tag: TaskTag?
    @FocusState private var isTitleFocused: Bool
    @Environment(\.dismiss) private var dismiss

    init(task: Task, viewModel: TodayTasksViewModel) {
        self.task = task
        self.viewModel = viewModel
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description)
        _tag = State(initialValue: task.tag)
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
            }
            .navigationTitle("Редактировать задачу")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
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
        viewModel.updateTask(task, newTitle: trimmedTitle, newDescription: trimmedDescription, newTag: tag)
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
