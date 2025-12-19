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

    func loadCurrentUserProgress() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let snapshot = try await userProgressRef(uid: uid).getDocument()
        let stats = Statistics.shared

        guard let data = snapshot.data() else {
            await MainActor.run {
                stats.extraXpWage = 0
                stats.xpPoints = []
            }
            return
        }

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

        await MainActor.run {
            stats.extraXpWage = extraXpWage
            stats.xpPoints = points
        }
    }
}
