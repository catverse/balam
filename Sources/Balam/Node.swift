import Foundation

struct Node: Codable, Hashable {
    var items = Set<Data>()
    let name: String
    let properties: Set<Property>
    
    init<T>(_ type: T) {
        self.name = String(describing: T.self)
        properties = Mirror(reflecting: type).reflect
    }
    
    func hash(into: inout Hasher) {
        into.combine(name)
        into.combine(properties)
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.name == rhs.name && lhs.properties == rhs.properties
    }
}
