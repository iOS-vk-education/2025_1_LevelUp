import Foundation
import FirebaseAuth
import FirebaseFirestore

final class TasksService {
    static let shared = TasksService()

    private let db = Firestore.firestore()
    private init() {}

    private func tasksCollection(uid: String) -> CollectionReference {
        db.collection("users")
            .document(uid)
            .collection("tasks")
    }

    func loadCurrentUserTasks() async throws -> [Task] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }

        let snapshot = try await tasksCollection(uid: uid).getDocuments()
        let tasks: [Task] = snapshot.documents.compactMap { doc in
            let data = doc.data()

            let title = data["title"] as? String ?? ""
            let description = data["description"] as? String ?? ""
            let isCompleted = data["isCompleted"] as? Bool ?? false

            let date: Date
            if let timestamp = data["date"] as? Timestamp {
                date = timestamp.dateValue()
            } else {
                date = Date()
            }

            var tag: TaskTag? = nil
            if let tagRaw = data["tag"] as? String {
                tag = TaskTag(rawValue: tagRaw)
            }

            let difficulty: TaskDifficulty
            if let difficultyRaw = data["difficulty"] as? String,
               let parsed = TaskDifficulty(rawValue: difficultyRaw) {
                difficulty = parsed
            } else {
                difficulty = .medium
            }

            let id: UUID
            if let idString = data["id"] as? String, let uuid = UUID(uuidString: idString) {
                id = uuid
            } else if let uuid = UUID(uuidString: doc.documentID) {
                id = uuid
            } else {
                id = UUID()
            }

            return Task(
                id: id,
                title: title,
                description: description,
                isCompleted: isCompleted,
                date: date,
                tag: tag,
                difficulty: difficulty
            )
        }

        return tasks
    }

    func saveCurrentUserTasks(_ tasks: [Task]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let collection = tasksCollection(uid: uid)

        let existing = try await collection.getDocuments()
        for doc in existing.documents {
            try await collection.document(doc.documentID).delete()
        }

        for task in tasks {
            let data: [String: Any] = [
                "id": task.id.uuidString,
                "title": task.title,
                "description": task.description,
                "isCompleted": task.isCompleted,
                "date": Timestamp(date: task.date),
                "tag": task.tag?.rawValue as Any,
                "difficulty": task.difficulty.rawValue
            ]

            try await collection.document(task.id.uuidString).setData(data, merge: false)
        }
    }
}
