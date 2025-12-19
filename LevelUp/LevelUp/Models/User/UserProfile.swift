import Foundation

struct UserProfile: Identifiable, Codable {
    let id: String
    var phone: String?
    var displayName: String?
    var createdAt: Date
    var xp: Int
}

