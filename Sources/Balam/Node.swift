import Foundation

struct Node: Codable, Hashable {
    var items = Set<Data>()
    let name: String
    let description: [String : Value]
    
    init<T>(_ type: T) {
        self.name = String(describing: T.self)
        description = Mirror(reflecting: type).children.reduce(into: [:]) {
            guard let label = $1.label else { return }
            let display = Mirror(reflecting: $1.value).displayStyle
            switch $1.value {
            case is String: $0[label] = display == .optional ? .optionalString : .string
            case is Int: $0[label] = .int
            case is Double: $0[label] = .double
            case let a where (a as? String) == Optional<String>.none: $0[label] = .optionalString
            case let a where (a as? Int) == Optional<Int>.none: $0[label] = .optionalInt
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
    
    
}
