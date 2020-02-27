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
        let values = try from.container(keyedBy: Key.self)
        items = try values.decode(Set<Data>.self, forKey: .items)
        name = try values.decode(String.self, forKey: .name)
        properties = try values.decode([Kind].self, forKey: .properties).reduce(into: .init()) {
            $0.insert(decoded(Bundle.main.classNamed($1.type)!, data: $1.property))
        }
        
        let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
        elevation = try additionalInfo.decode(Double.self, forKey: .elevation)
    }
    
    func encode(to: Encoder) throws {
        var container = to.container(keyedBy: Key.self)
        try container.encode(items, forKey: .items)
        try container.encode(name, forKey: .name)
        try container.encode(properties.map { Kind($0) }, forKey: .properties)
    }
    
    func hash(into: inout Hasher) {
        into.combine(name)
        into.combine(properties)
    }
    
    private func decoded<T>(_ name: T, data: Data) -> T where T : Decodable {
        try! JSONDecoder().decode(T.self, from: data)
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.name == rhs.name && lhs.properties == rhs.properties
    }
    
    private enum Key: CodingKey {
        case
        items,
        name,
        properties
    }
    
    private struct Kind: Codable {
        let type: String
        let property: Data
        
        init(_ property: Property) {
            type = .init(describing: property)
            self.property = try! JSONEncoder().encode(property)
        }
    }
}
