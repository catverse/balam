import Foundation

public class Property: Codable, Hashable {
    private func equals(_ property: Property) -> Bool {
        type(of: self) == type(of: property)
    }
    
    public func hash(into: inout Hasher) {
//        into.combine(name)
    }
    
    public static func == (lhs: Property, rhs: Property) -> Bool {
        lhs.equals(rhs)
    }
    
    public class Concrete: Property {
        public let name: Swift.String
        
        init(_ name: Swift.String) {
            self.name = name
            super.init()
        }
        
        required init(from: Decoder) throws {
            try name = from.container(keyedBy: Key.self).decode(Swift.String.self, forKey: .name)
            try super.init(from: from)
        }
        
        override func equals(_ property: Property) -> Bool {
            super.equals(property) && name == (property as! Concrete).name
        }
        
        private enum Key: CodingKey {
            case name
        }
    }
    
    public class Wrap: Property {
        public let property: Property
        
        init(_ property: Property) {
            self.property = property
            super.init()
        }
        
        required init(from: Decoder) throws {
            try property = from.container(keyedBy: Key.self).decode(Property.self, forKey: .property)
            try super.init(from: from)
        }
        
        override func equals(_ property: Property) -> Bool {
            super.equals(property) && self.property == (property as! Wrap).property
        }
        
        private enum Key: CodingKey {
            case property
        }
    }
    
    public final class Optional: Wrap { }
    public final class String: Concrete { }
    public final class Int: Concrete { }
}

/*
final class Property: Codable, Hashable {
    var dictionary: Dict?
    var group = Group.one
    var optional = false
    let name: String
    let value: Value
    
    struct Dict: Codable, Hashable {
        let key: Property
        let value: Property
    }
    
    enum Group: String, Codable {
        case
        one,
        array,
        dictionary,
        set
    }
    
    enum Value: String, Codable {
        case
        _struct,
        _class,
        _enum,
        string,
        int,
        double
    }
    
    func hash(into: inout Hasher) {
        into.combine(name)
        into.combine(value)
        into.combine(optional)
        into.combine(group)
        dictionary.map { into.combine($0) }
    }
    
    static func == (lhs: Property, rhs: Property) -> Bool {
        lhs.name == rhs.name
            && lhs.value == rhs.value
            && lhs.optional == rhs.optional
            && lhs.group == rhs.group
            && lhs.dictionary == rhs.dictionary
    }
}
*/
