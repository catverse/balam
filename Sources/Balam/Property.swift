import Foundation

struct Property {
    var optional = false
    let name: String
    let value: Value
    
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
