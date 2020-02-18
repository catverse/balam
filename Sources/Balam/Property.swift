import Foundation

final class Property: Codable, Hashable {
    var _keys: Property?
    var _values: Property?
    var group = Group.one
    var optional = false
    let name: String
    let value: Value
    
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
}
