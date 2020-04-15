import Foundation

public class Property: Codable, Hashable {
    public final class Custom: Concrete { }
    public final class Optional: Wrap { }
    public final class Array: Wrap { }
    public final class Set: Wrap { }
    public final class String: Concrete { }
    public final class Int: Concrete { }
    public final class Double: Concrete { }
    public final class Float: Concrete { }
    public final class Boolean: Concrete { }
    public final class Date: Concrete { }
    public final class Data: Concrete { }
    public final class UInt8: Concrete { }
    public final class UInt16: Concrete { }
    public final class UInt32: Concrete { }
    public final class UInt64: Concrete { }
    public final class Int8: Concrete { }
    public final class Int16: Concrete { }
    public final class Int32: Concrete { }
    public final class Int64: Concrete { }
    public final class URL: Concrete { }
    public final class UUID: Concrete { }
    
    public final class Dictionary: Concrete {
        public let key: Property
        public let value: Property
        
        init(_ name: Swift.String, key: Property, value: Property) {
            self.key = key
            self.value = value
            super.init(name)
        }
        
        required init(from: Decoder) throws {
            var container = try! from.unkeyedContainer()
            key = Property.decode(&container)
            value = Property.decode(&container)
            try! super.init(from: container.superDecoder())
        }
        
        public override func encode(to: Encoder) throws {
            var container = to.unkeyedContainer()
            Property.encode(&container, property: key)
            Property.encode(&container, property: value)
            try! super.encode(to: container.superEncoder())
        }
        
        public override func hash(into: inout Hasher) {
            super.hash(into: &into)
            into.combine(key)
            into.combine(value)
        }
        
        override func equals(_ property: Property) -> Bool {
            super.equals(property) && self.key == (property as! Dictionary).key && self.value == (property as! Dictionary).value
        }
    }
    
    public class Concrete: Property {
        public let name: Swift.String
        
        init(_ name: Swift.String) {
            self.name = name
            super.init()
        }
        
        required init(from: Decoder) throws {
            var container = try! from.unkeyedContainer()
            name = try! container.decode(Swift.String.self)
            try! super.init(from: container.superDecoder())
        }
        
        public override func encode(to: Encoder) throws {
            var container = to.unkeyedContainer()
            try! container.encode(name)
            try! super.encode(to: container.superEncoder())
        }
        
        public override func hash(into: inout Hasher) {
            super.hash(into: &into)
            into.combine(name)
        }
        
        override func equals(_ property: Property) -> Bool {
            super.equals(property) && name == (property as! Concrete).name
        }
    }
    
    public class Wrap: Property {
        public let property: Property
        
        init(_ property: Property) {
            self.property = property
            super.init()
        }
        
        required init(from: Decoder) throws {
            var container = try! from.unkeyedContainer()
            property = Property.decode(&container)
            try! super.init(from: container.superDecoder())
        }
        
        public override func encode(to: Encoder) throws {
            var container = to.unkeyedContainer()
            Property.encode(&container, property: property)
            try! super.encode(to: container.superEncoder())
        }
        
        public override func hash(into: inout Hasher) {
            super.hash(into: &into)
            into.combine(property)
        }
        
        override func equals(_ property: Property) -> Bool {
            super.equals(property) && self.property == (property as! Wrap).property
        }
    }
    
    public func hash(into: inout Hasher) {
        into.combine(Swift.String(describing: type(of: self)))
    }
    
    private func equals(_ property: Property) -> Bool {
        type(of: self) == type(of: property)
    }
    
    public static func == (lhs: Property, rhs: Property) -> Bool {
        lhs.equals(rhs)
    }
    
    class func encode(_ container: UnkeyedEncodingContainer, properties: Swift.Set<Property>) {
        var container = container
        properties.forEach { encode(&container, property: $0) }
    }
    
    class func decode(_ container: UnkeyedDecodingContainer) -> Swift.Set<Property> {
        var set = Swift.Set<Property>()
        var container = container
        while !container.isAtEnd {
            set.insert(decode(&container))
        }
        return set
    }
    
    private class func encode(_ container: inout UnkeyedEncodingContainer, property: Property) {
        try! container.encode(Swift.UInt8(list.firstIndex { $0 == type(of: property) }!))
        try! container.encode(property)
    }
    
    private class func decode(_ container: inout UnkeyedDecodingContainer) -> Property {
        return try! container.decode(list[.init(container.decode(Swift.UInt8.self))])
    }
    
    private static let list = [
        Custom.self,
        Optional.self,
        Array.self,
        Set.self,
        String.self,
        Int.self,
        Double.self,
        Float.self,
        Boolean.self,
        Date.self,
        Data.self,
        UInt8.self,
        UInt16.self,
        UInt32.self,
        UInt64.self,
        Int8.self,
        Int16.self,
        Int32.self,
        Int64.self,
        URL.self,
        UUID.self,
        Dictionary.self]
}
