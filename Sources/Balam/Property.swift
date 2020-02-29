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
    
    public final class Dictionary: Concrete {
        public let key: Property
        public let value: Property
        
        init(_ name: Swift.String, key: Property, value: Property) {
            self.key = key
            self.value = value
            super.init(name)
        }
        
        required init(from: Decoder) throws {
            try key = from.container(keyedBy: Key.self).decode(Property.self, forKey: .key)
            try value = from.container(keyedBy: Key.self).decode(Property.self, forKey: .value)
            try super.init(from: from)
        }
        
        public override func hash(into: inout Hasher) {
            super.hash(into: &into)
            into.combine(key)
            into.combine(value)
        }
        
        override func equals(_ property: Property) -> Bool {
            super.equals(property) && self.key == (property as! Dictionary).key && self.value == (property as! Dictionary).value
        }
        
        private enum Key: CodingKey {
            case
            key,
            value
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
            try! super.init(from: from)
        }
        
        public override func encode(to: Encoder) throws {
            var container = to.unkeyedContainer()
            try! container.encode(name)
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
            property = try! Serialiser.decode(from.unkeyedContainer()).first!
            try! super.init(from: from)
        }
        
        public override func encode(to: Encoder) throws {
            Serialiser.encode(to.unkeyedContainer(), properties: .init(arrayLiteral: property))
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
}
