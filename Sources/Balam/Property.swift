import Foundation

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
