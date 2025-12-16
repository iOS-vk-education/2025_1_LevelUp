import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

/// Минимальный сервис для работы с профилем пользователя в Firestore.
final class UserProfileService {
    static let shared = UserProfileService()

    private let db = Firestore.firestore()
    private let collectionName = "users"

    private init() {}

    private var collection: CollectionReference {
        db.collection(collectionName)
    }

    /// Убеждаемся, что у текущего пользователя есть профиль в Firestore.
    /// Если документа нет — создаём его.
    func ensureCurrentUserProfile(phone: String?) async throws -> UserProfile {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "UserProfileService",
                          code: 401,
                          userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
        }
        return try await ensureUserProfile(uid: user.uid, phone: phone)
    }

    func ensureUserProfile(uid: String, phone: String?) async throws -> UserProfile {
        let ref = collection.document(uid)
        let snapshot = try await ref.getDocument()

        if snapshot.exists, let profile = try? snapshot.data(as: UserProfile.self) {
            return profile
        } else {
            let profile = UserProfile(
                id: uid,
                phone: phone,
                displayName: nil,
                createdAt: Date(),
                xp: 0
            )
            try ref.setData(from: profile, merge: false)
            return profile
        }
    }

    func loadProfile(uid: String) async throws -> UserProfile {
        try await collection.document(uid)
            .getDocument()
            .data(as: UserProfile.self)
    }

    func updateProfile(_ profile: UserProfile) async throws {
        try collection.document(profile.id)
            .setData(from: profile, merge: true)
    }
}

