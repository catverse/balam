import Foundation

struct Node: Codable, Hashable {
    var items = Set<Data>()
    let name: String
    let description: [String : Value]
    
    init<T>(_ type: T) {
        self.name = String(describing: T.self)
        description = Mirror(reflecting: type).children.reduce(into: [:]) {
            guard let label = $1.label else { return }
            switch $1.value {
            case is String:
                $0[label] = .string
            case is Int:
                $0[label] = .int
            default: break
            }
        }
    }
    
    func hash(into: inout Hasher) {
        into.combine(name)
        into.combine(description)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name && lhs.description == rhs.description
    }
    
    enum Value: String, Codable {
        case
        string,
        int
    }
}
