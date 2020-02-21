import Foundation

struct Node: Codable, Hashable {
    var items = Set<Data>()
    let name: String
    let properties: Set<Property>
    
    init<T>(_ type: T) {
        self.name = String(describing: T.self)
        properties = Mirror(reflecting: type).children.reduce(into: .init()) {
            var property: Property
            switch $1.value {
            case is String: property = .String($1.label!)
            case is Int: property = .Int($1.label!)
            case is Double: property = .Double($1.label!)
            case is [String?]: property = .Array(.Optional(.String($1.label!)))
            case is [String]: property = .Array(.String($1.label!))
            default: property = .Unknown()
            }
            print($1.value is [String])
            print($1.value is [String?])
            $0.insert(Mirror(reflecting: $1.value).displayStyle == .optional ? .Optional(property) : property)
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
