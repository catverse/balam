import Foundation

struct Node: Codable, Hashable {
    var items = Set<Data>()
    let name: String
    let properties: Set<Property>
    
    init<T>(_ type: T) where T : Codable {
        self.name = .init(describing: T.self)
        properties = Mirror(reflecting: type).reflect(type)
    }
    
    func hash(into: inout Hasher) {
        into.combine(name)
        into.combine(properties)
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        print("is \(lhs.name == rhs.name && lhs.properties == rhs.properties)")
        print(type(of: lhs.properties.first))
        return lhs.name == rhs.name && lhs.properties == rhs.properties
    }
}
