import Foundation

struct Node: Codable, Hashable {
    var items = Set<Data>()
    let name: String
    let properties: Set<Property>
    
    init<T>(_ type: T) where T : Codable {
        self.name = .init(describing: T.self)
        properties = Mirror(reflecting: type).reflect(type)
    }
    
    init(from: Decoder) throws {
        var container = try from.unkeyedContainer()
        name = try container.decode(String.self)
        items = try container.decode(Set<Data>.self)
        properties = Property.decode(container)
    }
    
    func encode(to: Encoder) throws {
        var container = to.unkeyedContainer()
        try container.encode(name)
        try container.encode(items)
        Property.encode(container, properties: properties)
    }
    
    func hash(into: inout Hasher) {
        into.combine(name)
        into.combine(properties)
    }
    
    private func decoded<T>(_ name: T.Type, data: Data) -> T where T : Property {
        try! JSONDecoder().decode(T.self, from: data)
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.name == rhs.name && lhs.properties == rhs.properties
    }
}
