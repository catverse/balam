import Foundation

struct Serialiser {
    static func encode(_ container: UnkeyedEncodingContainer, properties: Set<Property>) {
        var container = container
        properties.forEach { property in
            try! container.encode(UInt8(list.firstIndex { $0 == type(of: property) }!))
            try! container.encode(property)
        }
    }
    
    static func decode(_ container: UnkeyedDecodingContainer) -> Set<Property> {
        var set = Set<Property>()
        var container = container
        while !container.isAtEnd {
            try! set.insert(container.decode(list[.init(container.decode(UInt8.self))]))
        }
        return set
    }
    
    private static let list = [
        Property.Custom.self,
        Property.Optional.self,
        Property.Array.self,
        Property.Set.self,
        Property.String.self,
        Property.Int.self,
        Property.Double.self,
        Property.Float.self,
        Property.Boolean.self,
        Property.Date.self,
        Property.Data.self,
        Property.UInt8.self,
        Property.UInt16.self,
        Property.UInt32.self,
        Property.UInt64.self,
        Property.Int8.self,
        Property.Int16.self,
        Property.Int32.self,
        Property.Int64.self,
        Property.Dictionary.self]
}
