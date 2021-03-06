import Foundation

public struct Node: Codable, Hashable {
    public var items = Set<Data>()
    public let name: String
    public let properties: Set<Property>
    
    init<T>(_ type: T) where T : Codable {
        self.name = .init(describing: T.self)
        properties = Mirror(reflecting: type).reflect(type)
    }
    
    public init(from: Decoder) throws {
        var container = try from.unkeyedContainer()
        name = try container.decode(String.self)
        items = try container.decode(Set<Data>.self)
        properties = Property.decode(container)
    }
    
    public func encode(to: Encoder) throws {
        var container = to.unkeyedContainer()
        try container.encode(name)
        try container.encode(items)
        Property.encode(container, properties: properties)
    }
    
    public func hash(into: inout Hasher) {
        into.combine(name)
        into.combine(properties)
    }
    
    private func decoded<T>(_ name: T.Type, data: Data) -> T where T : Property {
        try! JSONDecoder().decode(T.self, from: data)
    }
    
    public static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.name == rhs.name && lhs.properties == rhs.properties
    }
    
    static func == <T>(lhs: Node, rhs: T.Type) -> Bool where T : Codable {
        lhs.name == .init(describing: rhs)
            && lhs.items.first
                .flatMap { try? JSONDecoder().decode(rhs, from: $0) }
                .map { Node($0) == lhs }
            ?? false
    }
    
    mutating func mutate<T>(mutating: (inout [T]) -> Void) where T : Codable {
        var decoded: [T] = decoding()
        mutating(&decoded)
        items = try! .init(decoded.map(JSONEncoder().encode))
    }
    
    mutating func mutate<T>(mutating: (inout T) -> Void) where T : Codable {
        items = try! .init(decoding().map { (item: T) -> T in
            var item = item
            mutating(&item)
            return item
        }.map(JSONEncoder().encode))
    }
    
    mutating func replace<T>(with: T) where T : Codable {
        items = try! .init([with].map(JSONEncoder().encode))
    }
    
    func decoding<T>() -> [T] where T : Codable {
        items.map { try! JSONDecoder().decode(T.self, from: $0) }
    }
}
