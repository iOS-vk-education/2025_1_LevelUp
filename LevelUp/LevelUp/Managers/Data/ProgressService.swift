<<<<<<< HEAD
//
//  ProgressService.swift
//  LevelUp
//
//  Created by Андрей Прибавкин on 17.12.25.
//

=======
>>>>>>> fire_storage
import Foundation
import FirebaseAuth
import FirebaseFirestore

final class ProgressService {
    static let shared = ProgressService()

    private let db = Firestore.firestore()
    private init() {}

    private func userProgressRef(uid: String) -> DocumentReference {
        db.collection("users")
            .document(uid)
            .collection("meta")
            .document("progress")
    }

    // Сохранить локальный прогресс текущего пользователя в Firestore
    func saveCurrentUserProgress() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let stats = Statistics.shared

        let pointsArray: [[String: Any]] = stats.xpPoints.map { point in
            [
                "id": point.id.uuidString,
                "date": Timestamp(date: point.date),
                "value": point.value
            ]
        }

        let data: [String: Any] = [
            "extraXpWage": stats.extraXpWage,
            "xpPoints": pointsArray
        ]

        try await userProgressRef(uid: uid).setData(data, merge: true)
    }

    // Загрузить прогресс из Firestore в Statistics.shared
    func loadCurrentUserProgress() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let snapshot = try await userProgressRef(uid: uid).getDocument()
        guard let data = snapshot.data() else { return }

        let extraXpWage = data["extraXpWage"] as? Int ?? 0
        let xpPointsRaw = data["xpPoints"] as? [[String: Any]] ?? []

        let points: [Point] = xpPointsRaw.compactMap { dict in
            guard
                let value = dict["value"] as? Int,
                let timestamp = dict["date"] as? Timestamp
            else { return nil }

            let id: UUID
            if let idString = dict["id"] as? String, let uuid = UUID(uuidString: idString) {
                id = uuid
            } else {
                id = UUID()
            }

            return Point(id: id, date: timestamp.dateValue(), value: value)
        }

        let stats = Statistics.shared
        stats.extraXpWage = extraXpWage
        stats.xpPoints = points
    }
}
