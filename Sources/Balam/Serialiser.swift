import Foundation

struct Serialiser {
    static func encode(_ container: UnkeyedEncodingContainer, properties: Set<Property>) {
        var container = container
        properties.forEach { property in
            try! container.encode(list.firstIndex { $0 == type(of: property) }!)
            try! container.encode(property)
        }
    }
    
    static func decode(_ container: UnkeyedDecodingContainer) -> Set<Property> {
        var set = Set<Property>()
        var container = container
        while !container.isAtEnd {
            try! set.insert(container.decode(list[container.decode(Int.self)]))
        }
        return set
    }
    
    private static let list = [
        Property.String.self,
        Property.Double.self]
}
