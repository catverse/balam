import Foundation

struct User: Codable {
    var id = 1
    var name = ""
}

struct UserId: Codable, Identifiable {
    var id = 1
    var name = ""
}

struct UserEqual: Codable, Equatable {
    var id = 1
    var name = ""
    
    static func == (lhs: UserEqual, rhs: UserEqual) -> Bool {
        lhs.id == rhs.id
    }
}

struct UserEqualId: Codable, Equatable, Identifiable {
    var id = 1
    var name = ""
    var last = ""
    
    static func == (lhs: UserEqualId, rhs: UserEqualId) -> Bool {
        lhs.name == rhs.name
    }
}

enum Mode: String, Codable {
    case
    cool,
    uncool,
    meh
}
