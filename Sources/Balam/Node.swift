import Foundation

struct Node: Codable, Hashable {
    var items = Set<Data>()
    let name: String
    let properties: Set<Property>
    
    init<T>(_ type: T) {
        self.name = String(describing: T.self)
        properties = Mirror(reflecting: type).children.reduce(into: .init()) {
            guard let label = $1.label else { return }
            let display = Mirror(reflecting: $1.value).displayStyle
            switch $1.value {
            case is String: $0.insert(display == .optional ? .Optional(.String(label)) : .String(label))
            case is Int: $0.insert(display == .optional ? .Optional(.Int(label)) : .Int(label))
//            case is Int: $0[label] = .int
//            case is Double: $0[label] = .double
//            case let a where (a as? String) == Optional<String>.none: $0[label] = .optionalString
//            case let a where (a as? Int) == Optional<Int>.none: $0[label] = .optionalInt
            default: break
            }
        }
    }
    
    func hash(into: inout Hasher) {
        into.combine(name)
        into.combine(properties)
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.name == rhs.name && lhs.properties == rhs.properties
    }
}
