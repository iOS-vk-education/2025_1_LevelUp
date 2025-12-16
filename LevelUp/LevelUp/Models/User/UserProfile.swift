import Foundation

struct UserProfile: Identifiable, Codable {
    let id: String               // Firebase Auth UID
    var phone: String?
    var displayName: String?
    var createdAt: Date
    var xp: Int
}

